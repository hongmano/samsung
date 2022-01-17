
# 1. Options / Packages ---------------------------------------------------

library(dplyr)
library(stringr)
library(BMS)

# 2. Data Loading ---------------------------------------------------------

setwd('C:/Users/mano.hong/Desktop/RProject(WH)/22. 01. EPIC Even PATN ODD로 만들기 - 작성중')

dat <- readLines('PDBS4FADC8N5PEE.pat') %>% 
  str_replace_all('#define E_', '#define O_') %>% 
  str_replace_all('-IFE A E', '-IFE A O')

option <- 'odd'

# 3. Extract RD -----------------------------------------------------------

# EPIC PATN START

RD <- str_which(dat, ' RR ')

dat_list <- list()
for(i in 1:length(RD)){
  
  dat_list[[i]] <- data.frame(code = dat[(RD[i]+1):(RD[i]+16)]) %>% 
    mutate(line = 1:16,
           data = regmatches(code, regexpr('R[0-1]+', code)))
  
  even <- c(1,3,5,7,9,11,13,15)
  odd <- even+1
  
  data <- list()
  
  for(j in 1:4){
    
    data[[j]] <- dat_list[[i]]$data[(4*j-3):(4*j)]
    data[[j]] <- paste0(data[[j]][1], data[[j]][2], data[[j]][3], data[[j]][4]) %>% 
      str_remove_all('R') %>% 
      str_split_fixed('', 16)
    
    if(option == 'even'){
      
      first <- rev(data[[j]][even][5:8]) %>% as.numeric()
      second <- rev(data[[j]][even][1:4]) %>% as.numeric()
      
      data[[j]] <- paste0(bin2hex(first), bin2hex(second))
      
    }else if(option == 'odd'){
      
      first <- rev(data[[j]][odd][5:8]) %>% as.numeric()
      second <- rev(data[[j]][odd][1:4]) %>% as.numeric()
      
      data[[j]] <- paste0(bin2hex(first), bin2hex(second))
      
    }else{
      
      stop('Set option within "even" or "odd"')
      
    }
  }
  
  
  data_location <- str_locate_all(dat_list[[i]]$code[1], 'RD\\([0-9,a-z]+\\)') %>% unlist %>% min
  substr(dat_list[[i]]$code[1], data_location+5, data_location+6) <- data[[1]]
  
  data_location <- str_locate_all(dat_list[[i]]$code[5], 'RD\\([0-9,a-z]+\\)') %>% unlist %>% min
  substr(dat_list[[i]]$code[5], data_location+5, data_location+6) <- data[[2]]
  
  data_location <- str_locate_all(dat_list[[i]]$code[9], 'RD\\([0-9,a-z]+\\)') %>% unlist %>% min
  substr(dat_list[[i]]$code[9], data_location+5, data_location+6) <- data[[3]]
  
  data_location <- str_locate_all(dat_list[[i]]$code[13], 'RD\\([0-9,a-z]+\\)') %>% unlist %>% min
  substr(dat_list[[i]]$code[13], data_location+5, data_location+6) <- data[[4]]
  
  
  dat[(RD[i]+1):(RD[i]+16)] <- dat_list[[i]]$code
  
}

write.csv(dat, 'PDBS4FADC8N5PEO.pat', quote = F, row.names = F)
