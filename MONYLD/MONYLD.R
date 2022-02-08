library(stringr)
library(dplyr)
library(data.table)

setwd('C:/Users/mano.hong/Desktop/마도요/m805A_PCJ0239W82_K3KL3L30CM-BGCT000-PPB9AH_T091PRA_220204222652')

files <- list.files()
files <- files[str_detect(files, '.txt')]

log_summary <- function(file, DP, result){
  
  dat <- readLines(file)
  
  # Start Point of Cycle
  
  log_start <- c(str_which(dat, 'SGH_MSG=RUNLOTID'), length(dat))
  
  # ?th Retest
  
  REGFLG <- substr(regmatches(dat, regexpr('RETFLG = [0-9]+', dat)), 10, 10)
  
  # Wrangling
  
  dat <- data.frame(code = dat,
                    REGFLG = '?',
                    cycle = 0)
  
  for(j in 1:length(REGFLG)){
    
    dat$REGFLG[log_start[j]:log_start[j+1]] <- REGFLG[j]
    dat$cycle[log_start[j]:log_start[j+1]] <- j
    
  }
  
  dat <- dat %>% 
    filter(REGFLG == 0)
  
  # Filter < 1000 row cycle
  
  real <- dat %>% 
    group_by(cycle) %>% 
    tally %>% 
    filter(n > 1000) %>% 
    select(cycle)
  
  dat <- dat %>% 
    filter(REGFLG == '0' & cycle %in% real$cycle)
  
  # Split
  
  dat <- split(dat, dat$cycle)
  
  DUTYLD <- list()
  CHYLD <- list()
  tPDYLD <- list()
  
  for(i in 1:length(dat)){
    
    ### PKGMAP (SG, DU, DO, tPD)
    
    PKGMAP <- dat[[i]]$code[dat[[i]]$code %>% str_which('PMAP: ')]
    
    SG <- substr(PKGMAP, 14, 31)
    DU <- substr(PKGMAP, 9, 9) %>% as.numeric()
    DO <- substr(PKGMAP, 12, 12) %>% as.numeric()
    
    PKGMAP <- data.frame(SG, DU, DO)
    
    tPD <- dat[[i]]$code[dat[[i]]$code %>% str_which('TPD2  n/p')] %>% 
      str_remove_all('TPD2  n/p  : ') %>% 
      str_remove_all('[1-8] \t') %>% 
      str_remove_all('\t') %>%  
      str_replace_all('\\s+', ' ') %>% 
      str_trim %>% 
      str_split_fixed(' ', 4) %>% 
      as.data.frame() %>% 
      unlist
    
    plate <- data.frame(DU = rep(1:4, each = 4),
                        DO = rep(1:4, 4)) %>% 
      left_join(PKGMAP) %>% 
      mutate(tPD = round(as.numeric(tPD), 0),
             variable = paste0('CH', 1:16))
    
    ### Function 
    
    func <- dat[[i]]$code[dat[[i]]$code %>% str_which('HF[CH] R0  [0-9]+ [0-9]+')] %>% 
      str_remove_all('\\[') %>% 
      str_remove_all('\\]') %>% 
      str_split_fixed(' ', 22) %>% 
      as.data.frame() %>% 
      filter(V12 %in% c(1,2) & V4 != 4996) %>% 
      select(V4, V5, V6, V7, V9, V12, V13, V14, V20, V22) %>% 
      `colnames<-`(c('TN', 'HB', 'VDD2H', 'VDD2L', 'tCK', 'HSDO', 'PATN', 'DUT', 'CH', 'DOE')) %>% 
      mutate(
        
        CH_A = ifelse(substr(DUT, 1, 1) == '-', '----', substr(CH, 1, 4)),
        
        CH_B = ifelse(substr(DUT, 2, 2) == '-', '----',
                      ifelse(str_count(substr(DUT, 1, 2), '-') == 1, substr(CH, 1, 4), substr(CH, 5, 8))),
        
        CH_C = ifelse(substr(DUT, 3, 3) == '-', '----',
                      ifelse(str_count(substr(DUT, 1, 3), '-') == 2, substr(CH, 1, 4),
                             ifelse(str_count(substr(DUT, 1, 3), '-') == 1, substr(CH, 5, 8), substr(CH, 9, 12)))),
        
        CH_D = ifelse(substr(DUT, 4, 4) == '-', '----',
                      ifelse(str_count(substr(DUT, 1, 3), '-') == 3, substr(CH, 1, 4),
                             ifelse(str_count(substr(DUT, 1, 3), '-') == 2, substr(CH, 5, 8),
                                    ifelse(str_count(substr(DUT, 1, 3), '-') == 1, substr(CH, 9, 12), substr(CH, 13, 16))))),
        
        CH = paste0(CH_A, CH_B, CH_C, CH_D)
        
      ) %>% 
      select(-starts_with('CH_'))
    
    # HSDO & non-HSDO
    
    even <- func %>% filter(HSDO == 1)
    odd <- func %>% filter(HSDO == 2)
    other <- even %>% filter(!PATN %in% odd$PATN)
    even <- even %>% filter(!PATN %in% other$PATN)
    
    HSDO <- even %>% select(TN, HB, VDD2H, VDD2L, tCK, PATN, DOE, DUT, CH) %>% 
      rename(DUT_even = DUT,
             CH_even = CH) %>% 
      inner_join(odd %>% select(TN, HB, VDD2H, VDD2L, tCK, PATN, DOE, DUT, CH) %>% 
                   rename(DUT_odd = DUT,
                          CH_odd = CH))
    
    other <- other %>% select(TN, HB, VDD2H, VDD2L, tCK, PATN, DOE, DUT, CH)
    
    # Merge HSDO Result
    
    for(j in 1:16){
      
      substr(HSDO$CH_even, j, j) <- ifelse(substr(HSDO$CH_even, j, j) == 'P' & substr(HSDO$CH_odd, j, j) == 'P',
                                           'P',
                                           ifelse(substr(HSDO$CH_even, j, j) == '-' | substr(HSDO$CH_even, j, j) == '-',
                                                  '-', '*'))
    }
    for(j in 1:4){
      
      substr(HSDO$DUT_even, j, j) <- ifelse(substr(HSDO$DUT_even, j, j) == 'P' & substr(HSDO$DUT_odd, j, j) == 'P',
                                            'P',
                                            ifelse(substr(HSDO$DUT_even, j, j) == '-' | substr(HSDO$DUT_even, j, j) == '-',
                                                   '-', '*'))
    }
    
    HSDO <- HSDO %>% 
      rename(DUT = DUT_even,
             CH = CH_even) %>% 
      select(-c(CH_odd, DUT_odd))
    
    # MERGE ALL!!!
    
    fin <- rbind(HSDO, other)
    fin_CH <- str_split_fixed(fin$CH, '', 16) %>% 
      as.data.frame() %>% 
      `colnames<-`(paste0('CH', rep(1:16)))
    
    fin <- fin %>% 
      select(-c(CH, DUT)) %>% 
      cbind(fin_CH) %>% 
      melt(id.vars = c('TN', 'HB', 'VDD2H', 'VDD2L', 'tCK', 'PATN', 'DOE')) %>% 
      mutate(value = ifelse(value == 'P', 1,
                            ifelse(value == '*', 0, NA))) %>% 
      inner_join(plate)
    
    # DUTYLD
    
    DUT_NUM <- fin %>% 
      na.omit %>% 
      select(DU) %>% 
      unique %>% 
      nrow
    
    DUTYLD[[i]] <- fin %>% 
      group_by(TN, DU) %>% 
      summarise(value = sum(value)) %>% 
      mutate(value = ifelse(value == DP, 1, 0)) %>% 
      na.omit %>% 
      group_by(TN) %>% 
      summarise(value = sum(value)) %>% 
      mutate(DUT_NUM)
    
    
    # Chip YLD
    
    CH_NUM <- fin %>% 
      na.omit %>% 
      select(variable) %>% 
      unique %>% 
      nrow
    
    CHYLD[[i]] <- fin %>% 
      group_by(TN, variable) %>% 
      summarise(value = sum(value)) %>% 
      na.omit %>% 
      group_by(TN) %>% 
      summarise(value = sum(value)) %>% 
      mutate(CH_NUM)
    
    # tPD YLD
    
    tPD_NUM <- fin %>% 
      select(DU, DO, tPD) %>% 
      unique %>% 
      na.omit %>% 
      group_by(tPD) %>% 
      tally
    
    tPDYLD[[i]] <- fin %>% 
      group_by(TN, tPD) %>% 
      summarise(value = sum(value)) %>% 
      na.omit %>% 
      inner_join(tPD_NUM) %>% 
      rename(tPD_NUM = n)
    
    
  }
  
  DUTYLD <- rbindlist(DUTYLD) %>% 
    group_by(TN) %>% 
    summarise(value = sum(value),
              DUT_NUM = sum(DUT_NUM))
  
  CHYLD <- rbindlist(CHYLD) %>% 
    group_by(TN) %>% 
    summarise(value = sum(value),
              CH_NUM = sum(CH_NUM))
  
  tPDYLD <- rbindlist(tPDYLD) %>% 
    group_by(TN, tPD) %>% 
    summarise(value = sum(value),
              tPD_NUM = sum(tPD_NUM))
  
  if(result == 'DUT'){
    return(DUTYLD)
  }else if(result == 'CH'){
    return(CHYLD)
  }else if(result == 'tPD'){
    return(tPDYLD)
  }else{
    stop('Write "DUT" or "CH" or "tPD" in result argument.')
  }
  
}


# Start -------------------------------------------------------------------

DP <- 4

DUT <- list()
CH <- list()
tPD <- list()
for(i in 1:length(files)){
  
  DUT[[i]] <- log_summary(files[i], DP, 'DUT')
  CH[[i]] <- log_summary(files[i], DP, 'CH')
  tPD[[i]] <- log_summary(files[i], DP, 'tPD')
  
}

DUT <- rbindlist(DUT)
CH <- rbindlist(CH)
tPD <- rbindlist(tPD)

DUT <- DUT %>% 
  group_by(TN) %>% 
  summarise(value = sum(value),
            DUT_NUM = sum(DUT_NUM))

CH <- CH %>% 
  group_by(TN) %>% 
  summarise(value = sum(value),
            CH_NUM = sum(CH_NUM))

tPD <- tPD %>% 
  group_by(TN, tPD) %>% 
  summarise(value = sum(value),
            tPD_NUM = sum(tPD_NUM))

DUT$YLD <- round(DUT$value / DUT$DUT_NUM * 100 ,2)
CH$YLD <- round(CH$value / CH$CH_NUM * 100 ,2)
tPD$YLD <- round(tPD$value / tPD$tPD_NUM * 100 ,2)

# Summary -----------------------------------------------------------------

tPD %>% 
  filter(TN %in% c(3580:3589,
                   3680:3689,
                   3780:3789,
                   3880:3889,
                   3980:3989)) %>% 
  mutate(YLD = (100 - YLD) / 100) %>% 
  select(TN, tPD, YLD) %>% 
  dcast(TN ~ tPD) %>% 
  write.csv(row.names = F)

tPD %>% 
  ungroup %>% 
  select(tPD, tPD_NUM) %>% 
  unique

