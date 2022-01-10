library(stringr)
library(dplyr)
library(data.table)

setwd('C:/Users/mano.hong/Desktop/AUTOWORK/WH_D_AMP/Cold Log')

dat <- list.files()
dat <- dat[str_detect(dat, '.txt')]
dat_list <- list()
result <- list()

for(i in 1:length(dat)){

  dat_list[[i]] <- readLines(dat[i])
  
  log_start <- c(str_which(dat_list[[i]], 'SGH_MSG=RUNLOTID'), length(dat_list[[i]]))
  REGFLG <- substr(regmatches(dat_list[[i]], regexpr('RETFLG = [0-9]+', dat_list[[i]])), 10, 10)
  
  dat_list[[i]] <- data.frame(code = dat_list[[i]],
                              REGFLG = '?',
                              cycle = 0)
  
  for(j in 1:length(REGFLG)){
    
    dat_list[[i]]$REGFLG[log_start[j]:log_start[j+1]] <- REGFLG[j]
    dat_list[[i]]$cycle[log_start[j]:log_start[j+1]] <- j
    
  }
  
  real <- dat_list[[i]] %>% 
    group_by(cycle) %>% 
    tally %>% 
    filter(n > 1000) %>% 
    select(cycle)
  
  dat_list[[i]] <- dat_list[[i]] %>% 
    filter(REGFLG == '0' & cycle %in% real$cycle)
  
  dat_list[[i]] <- split(dat_list[[i]], dat_list[[i]]$cycle)
  
  for(z in 1:length(dat_list[[i]])){
    
    Sig <- substr(dat_list[[i]][[z]]$code[dat_list[[i]][[z]]$code %>% str_which('PMAP: ')], 14, 31)
    DUT <- substr(dat_list[[i]][[z]]$code[dat_list[[i]][[z]]$code %>% str_which('PMAP: ')], 9, 9)
    Ch <- substr(dat_list[[i]][[z]]$code[dat_list[[i]][[z]]$code %>% str_which('PMAP: ')], 12, 12)
    tPD <- dat_list[[i]][[z]]$code[dat_list[[i]][[z]]$code %>% str_which('TPD2  n/p')] %>% 
      str_remove_all('TPD2  n/p  : ') %>% 
      str_remove_all('[1-8] \t') %>% 
      str_remove_all('\t') %>%  
      str_replace_all('\\s+', ' ') %>% 
      str_trim %>% 
      str_split_fixed(' ', 4) %>% 
      as.data.frame() %>% 
      unlist
    
    test <- dat_list[[i]][[z]]$code[dat_list[[i]][[z]]$code %>% str_which('HF[CH] R0  3[5-7][7-9][1-8]')] %>% 
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
      select(!starts_with('V'))
    
    
    
    test <- test %>% 
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
  
    device <- cbind(DUT, Ch, Sig)
    
    
    result[[i]][[z]] <- data.frame(DUT = rep(1:4, each = 4),
                                 Ch = rep(1:4, 4))
      
  
  
    # result[[i]][[z]] <- data.frame(
    #   
    #   SG = Sig,
    #   DU = DUT,
    #   CH = Ch, 
    #   tPD = tPD,
    #   TN = test$TN,
    #   power = test$power,
    #   HSDO = test$HSDO,
    #   PATN = test$PATN,
    #   DUTPASS = test$DUTPASS,
    #   CHPASS = test$CHPASS,
    #   DOE = test$CHPASS_real
    #   
    #   )
    
  }
  
  
}
  
finfin <- rbindlist(result)
  
