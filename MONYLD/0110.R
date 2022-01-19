library(stringr)
library(dplyr)
library(data.table)

setwd('C:/Users/mano.hong/Desktop/AUTOWORK/WH_D_AMP/Cold Log')

files <- list.files()
files <- files[str_detect(files, '.txt')]


dat <- readLines(files[12])

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
    mutate(tPD = tPD)
  
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
  
  HSDO <- even %>% select(TN, HB, VDD2H, VDD2L, tCK, PATN, DOE, CH) %>% 
    rename(CH_even = CH) %>% 
    inner_join(odd %>% select(TN, HB, VDD2H, VDD2L, tCK, PATN, DOE, CH) %>% 
                 rename(CH_odd = CH))
  
  # Merge HSDO Result
  
  even <- HSDO$CH_even %>% 
    str_split_fixed('', 16) %>% 
    as.data.frame() %>% 
    mutate(TN = HSDO$TN) %>%
    melt(id.vars = c('TN'))
  
  odd <- HSDO$CH_odd %>% 
    str_split_fixed('', 16) %>% 
    as.data.frame() %>% 
    mutate(TN = HSDO$TN) %>%
    melt(id.vars = c('TN'))
  
  even_odd <- rbind(even, odd) %>% 
    mutate(value = ifelse(value == 'P', 1,
                          ifelse(value == '*', 0, NA))) %>% 
    group_by(TN, variable) %>% 
    
  
  

  }
