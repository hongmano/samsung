library(stringr)
library(dplyr)
library(data.table)
library(reshape2)

setwd('C:\\Users\\Mano\\Desktop\\samsung-main\\MONYLD')

dat <- list.files()
dat <- dat[str_detect(dat, '.txt')]
dat_list <- list()
result <- list()

for(i in 1:length(dat)){
  
  dat_list[[i]] <- readLines(dat[i])
  
}

MONYLD <- function(dat_list){
  
  result <- list()
  
  extract <- function(cycle){

    # Information of Device

    tPD2 <- cycle$code[cycle$code %>% str_which('TPD2  n/p')] %>% 
      str_remove_all('TPD2  n/p  : ') %>% 
      str_remove_all('[1-8] \t') %>% 
      str_remove_all('\t') %>%  
      str_replace_all('\\s+', ' ') %>% 
      str_trim %>% 
      str_split_fixed(' ', 4) %>%
      unlist %>% 
      as.numeric %>% 
      na.omit
    
    info <- substr(cycle$code[cycle$code %>% str_which('PMAP: ')], 1, 300) %>% 
      str_split_fixed(' ', 8) %>% 
      as.data.frame() %>% 
      select(-V1) %>% 
      `colnames<-`(c('DUT', 'CH', 'SG', 'RUN', 'WF', 'X', 'Y')) %>% 
      mutate(DUT = as.numeric(DUT),
             CH = as.numeric(CH),
             WF = as.numeric(substr(WF, 2, 3)),
             X = as.numeric(X),
             Y = as.numeric(Y),
             tPD = tPD2,
             variable = paste0('D', DUT, '_', CH))
    
    result <- cycle$code[cycle$code %>% str_which('HF[CH] R0  [0-9]+')] %>% 
      str_remove_all('\\[') %>% 
      str_remove_all('\\]') %>% 
      str_split_fixed(' ', 22) %>% 
      as.data.frame() %>% 
      rename(TN = V4,
             power = V6,
             HSDO = V12,
             PATN = V13,
             DUTPASS = V14,
             CHPASS = V20,
             DOE = V22) %>% 
      mutate(TN = as.numeric(TN),
             HSDO = as.numeric(HSDO)) %>% 
      select(!starts_with('V')) %>% 
      filter(HSDO != '' & DOE != '') %>% 
      mutate(
        
        CHPASS_A = ifelse(substr(DUTPASS, 1, 1) == '-', '----', substr(CHPASS, 1, 4)),
        
        CHPASS_B = ifelse(substr(DUTPASS, 2, 2) == '-', '----',
                          ifelse(str_count(substr(DUTPASS, 1, 2), '-') == 1, substr(CHPASS, 1, 4), substr(CHPASS, 5, 8))),
        
        CHPASS_C = ifelse(substr(DUTPASS, 3, 3) == '-', '----',
                          ifelse(str_count(substr(DUTPASS, 1, 3), '-') == 2, substr(CHPASS, 1, 4),
                                 ifelse(str_count(substr(DUTPASS, 1, 3), '-') == 1, substr(CHPASS, 5, 8), substr(CHPASS, 9, 12)))),
        
        CHPASS_D = ifelse(substr(DUTPASS, 4, 4) == '-', '----',
                          ifelse(str_count(substr(DUTPASS, 1, 3), '-') == 3, substr(CHPASS, 1, 4),
                                 ifelse(str_count(substr(DUTPASS, 1, 3), '-') == 2, substr(CHPASS, 5, 8),
                                        ifelse(str_count(substr(DUTPASS, 1, 3), '-') == 1, substr(CHPASS, 9, 12), substr(CHPASS, 13, 16))))),
        
        CHPASS_real = paste0(CHPASS_A, CHPASS_B, CHPASS_C, CHPASS_D)
        
      )

    result <- split(result, result$TN)
    for(i in 1:length(result)){
      
      if(length(result) == 2){
        
        for(j in 1:16){
          
          substr(result[[i]]$CHPASS_real, j, j) <- ifelse(substr(result[[i]]$CHPASS_real[1], j, j) == 'P' &
                                                            substr(result[[i]]$CHPASS_real[2], j, j) == 'P',
                                                          
                                                          'P', '*')
        }
      }
    }
    
    result <- rbindlist(result) %>% 
      select(-c('CHPASS_A', 'CHPASS_B', 'CHPASS_C', 'CHPASS_D', 'CHPASS'))
    
    CHPASS <- result$CHPASS_real %>% 
      str_split_fixed('', 16) %>% 
      as.data.frame() %>% 
      `colnames<-`(paste0('D', rep(1:4, each = 4), '_', rep(1:4, 4)))
    
    result <- result %>% 
      cbind(CHPASS) %>% 
      select(TN, power, HSDO, PATN, DUTPASS, DOE, starts_with('D')) %>% 
      melt(id.vars = c('TN', 'power', 'HSDO', 'PATN', 'DUTPASS', 'DOE')) %>% 
      inner_join(info)
    
    return(result)

      }
  
  split_code <- function(dat){
    
    # Find Start Point of Cycle
    
    log_start <- c(str_which(dat, 'SGH_MSG=RUNLOTID'), length(dat))
    
    # Retest FLG
    
    REGFLG <- substr(regmatches(dat, regexpr('RETFLG = [0-9]+', dat)), 10, 10)
    
    dat <- data.frame(code = dat, REGFLG = '-', cycle = 0)
    
    for(j in 1:length(REGFLG)){
      
      dat$REGFLG[log_start[j]:log_start[j+1]] <- REGFLG[j]
      dat$cycle[log_start[j]:log_start[j+1]] <- j
      
    }
    
    # Filtering The Log with 1000 >= Lines
    
    real <- dat %>% 
      group_by(cycle) %>% 
      tally %>% 
      filter(n > 1000) %>% 
      select(cycle)
    
    dat <- dat %>% 
      filter(REGFLG == '0' & cycle %in% real$cycle)
    
    # Split Log with Cycle
    
    dat_split <- split(dat, dat$cycle)
    
    return(dat_split)
    
  }
  
  for(i in 1:length(dat_list)){
    
    dat <- split_code(dat_list[[i]])
    result[[i]] <- extract(dat[[i]])
    
  }
  
  result <- rbindlist(result)
  return(result)
  
}

# YLD

MONYLD(dat_list) %>%
  mutate(tPD = round(tPD, 0),
         value = ifelse(value == 'P', 0, 1)) %>% 
  filter(HSDO == 1 & value != '-') %>% 
  group_by(TN, power, DOE, tPD) %>% 
  summarise(YLD = round(mean(value) * 100, 2),
            n = n()) %>% 
  dcast(TN + power + DOE ~ tPD, value.var = 'YLD') %>% 
  View

# n

MONYLD(dat_list) %>%
  mutate(tPD = round(tPD, 0)) %>% 
  select(SG, tPD) %>% 
  unique %>% 
  group_by(tPD) %>% 
  tally
  
