
# 1. Options / Packages ---------------------------------------------------

library(dplyr)
library(stringr)
library(BMS)

### 8 IPMC ALERT !!!!!!!!!!

# 2. Data Loading ---------------------------------------------------------

setwd('C:/Users/mano.hong/Desktop/even/220124/even')

files <- list.files()
files <- files[str_detect(files, '.pat')]

for(index in 1:length(files)){
  
  # Set Working Directory
  
  setwd('C:/Users/mano.hong/Desktop/even/220124/even')
  
  # Even -> Odd
  
  dat <- readLines(files[index]) %>% 
    str_replace_all('#define E_', '#define O_') %>% 
    str_replace_all('-IFE A E', '-IFE A O')
  
  # Check DATA_MASK_PS_ram_set Index
  
  DM <- regmatches(dat, regexpr('DATA_MASK_PS_ram_set[0-9a-zA-Z,()/* ]+', dat)) %>% tolower()
  DM <- data.frame(DM_index = substr(DM, 31, 31),
                   DM_data = substr(DM, 38, 39))
  
  # Check RD CMD Index
  
  RD <- str_which(dat, ' d[1_][1_][a-zA-Z0-9_\\s+]+RD')
  dat_list <- list()
  
  # Start Convert -----------------------------------------------------------
  
  for(i in 1:length(RD)){
    
    # MRR Case We use 'f0' STRB
    
    MRR <- substr(regmatches(dat[RD[i]], regexpr('RD\\([0-9a-z,]+\\)', dat[RD[i]])), 9, 10)
    
    # DM index
    
    DM_bool <- str_detect(dat[RD[i]], 'DM\\([0-9a-z,]+\\)')
    
    if(MRR != 'f0' & DM_bool == F){


# MRR DATA ----------------------------------------------------------------

      bit_list <- list()
      
      for(bit in 1:4){
        
        bit <- bit - 1
        if(length(bit_list) > 0){
          
          bit <- bit_list[[length(bit_list)]] + 1
          
        }
        
        repeat{
          
          bit_judge <- dat[RD[i]+bit] %>% str_detect('R[0-1]+')
          
          if(sum(bit_judge, na.rm = T) == 1){
            bit_list <- append(bit_list, bit)
            break
          }
          bit <- bit + 1
          msg <- paste0('PATN : ', files[index],
                        ' RD : ', RD[i],
                        ' DATA : ', bit, 'th')
          print(msg)
        }
      }
      
      dat_list[[i]] <- data.frame(code = dat[c(RD[i] + bit_list[[1]],
                                               RD[i] + bit_list[[2]],
                                               RD[i] + bit_list[[3]],
                                               RD[i] + bit_list[[4]])]) %>% 
        mutate(line = 1:4,
               data = regmatches(code, regexpr('R[0-1]+', code)))
      
      
      even <- c(1,3,5,7,9,11,13,15)
      odd <- even + 1
      
      data <- paste0(dat_list[[i]]$data[1],
                     dat_list[[i]]$data[2],
                     dat_list[[i]]$data[3],
                     dat_list[[i]]$data[4]) %>% 
        str_remove_all('R') %>% 
        str_split_fixed('', 16)
      
      
      first <- rev(data[odd][5:8]) %>% as.numeric()
      second <- rev(data[odd][1:4]) %>% as.numeric()
      
      data <- paste0(bin2hex(first), bin2hex(second))
      
      data_location <- str_locate_all(dat_list[[i]]$code[1], 'RD\\([0-9,a-z]+\\)') %>% unlist %>% min
      substr(dat_list[[i]]$code[1], data_location+5, data_location+6) <- data
      
      dat[c(RD[i] + bit_list[[1]],
            RD[i] + bit_list[[2]],
            RD[i] + bit_list[[3]],
            RD[i] + bit_list[[4]])] <- dat_list[[i]]$code
      
    }else if(MRR != 'f0' & DM_bool == T){
      

# DBI DATA ----------------------------------------------------------------
      
      bit_list <- list()
      
      for(bit in 1:4){
        
        bit <- bit - 1
        if(length(bit_list) > 0){
          
          bit <- bit_list[[length(bit_list)]] + 1
          
        }
        
        repeat{
          
          bit_judge <- dat[RD[i]+bit] %>% str_detect('DBI[0-1][0-1][0-1][0-1]')
          
          if(sum(bit_judge, na.rm = T) == 1){
            bit_list <- append(bit_list, bit)
            break
          }
          bit <- bit + 1
          msg <- paste0('PATN : ', files[index],
                        ' RD : ', RD[i],
                        ' DATA : ', bit, 'th')
          print(msg)
        }
      }
      
      dat_list[[i]] <- data.frame(code = dat[c(RD[i] + bit_list[[1]],
                                               RD[i] + bit_list[[2]],
                                               RD[i] + bit_list[[3]],
                                               RD[i] + bit_list[[4]])]) %>% 
        mutate(line = 1:4,
               data = regmatches(code, regexpr('DBI[0-1][0-1][0-1][0-1]', code)))
      
      
      even <- c(1,3,5,7,9,11,13,15)
      odd <- even + 1
      
      data_DBI <- paste0(dat_list[[i]]$data[1],
                     dat_list[[i]]$data[2],
                     dat_list[[i]]$data[3],
                     dat_list[[i]]$data[4]) %>% 
        str_remove_all('DBI') %>% 
        str_split_fixed('', 16)
  
      
      first <- rev(data_DBI[odd][5:8]) %>% as.numeric()
      second <- rev(data_DBI[odd][1:4]) %>% as.numeric()
      
      data_DMI <- paste0(bin2hex(first), bin2hex(second))
      

# RD DATA -----------------------------------------------------------------

      
      bit_list <- list()
      
      for(bit in 1:4){
        
        bit <- bit - 1
        if(length(bit_list) > 0){
          
          bit <- bit_list[[length(bit_list)]] + 1
          
        }
        
        repeat{
          
          bit_judge <- dat[RD[i]+bit] %>% str_detect('R[0-1][0-1][0-1][0-1]')
          
          if(sum(bit_judge, na.rm = T) == 1){
            bit_list <- append(bit_list, bit)
            break
          }
          bit <- bit + 1
          msg <- paste0('PATN : ', files[index],
                        ' RD : ', RD[i],
                        ' DATA : ', bit, 'th')
          print(msg)
        }
      }
      
      dat_list[[i]] <- data.frame(code = dat[c(RD[i] + bit_list[[1]],
                                               RD[i] + bit_list[[2]],
                                               RD[i] + bit_list[[3]],
                                               RD[i] + bit_list[[4]])]) %>% 
        mutate(line = 1:4,
               data = regmatches(code, regexpr('R[0-1][0-1][0-1][0-1]', code)))
      
      
      even <- c(1,3,5,7,9,11,13,15)
      odd <- even + 1
      
      data_RD <- paste0(dat_list[[i]]$data[1],
                     dat_list[[i]]$data[2],
                     dat_list[[i]]$data[3],
                     dat_list[[i]]$data[4]) %>% 
        str_remove_all('R') %>% 
        str_split_fixed('', 16)
      
      first <- rev(data_RD[odd][5:8]) %>% as.numeric()
      second <- rev(data_RD[odd][1:4]) %>% as.numeric()
      
      data_RD <- paste0(bin2hex(first), bin2hex(second))
      
      # Change DM Index
      
      data_location <- str_locate_all(dat_list[[i]]$code[1], 'DM\\([0-9,a-z]+\\)') %>% unlist %>% min
      DM_index <- DM %>% filter(DM_data == data_DMI) %>% select(DM_index) %>% unlist
      substr(dat_list[[i]]$code[1], data_location+5, data_location+5) <- DM_index
      
      # Change RD Data
      
      data_location <- str_locate_all(dat_list[[i]]$code[1], 'RD\\([0-9,a-z]+\\)') %>% unlist %>% min
      substr(dat_list[[i]]$code[1], data_location+5, data_location+6) <- data_RD
      

      # Change PATN Code
      
      dat[c(RD[i] + bit_list[[1]],
            RD[i] + bit_list[[2]],
            RD[i] + bit_list[[3]],
            RD[i] + bit_list[[4]])] <- dat_list[[i]]$code
      
    }
    
    name <- files[index]
    substr(name, nchar(name)-4, nchar(name)-4) <- 'O'
    
  }
  
  
  # End Convert -------------------------------------------------------------
  
  dat <- dat %>% 
    str_replace_all('#define _PDCS[0-9A-Z]+',
                    paste0('#define _', substr(name, 1, nchar(name)-4))) %>% 
    str_replace_all('defined\\(E_\\)',
                    'defined\\(O_\\)') %>%
    str_replace_all('A.AND.E',
                    'A.AND.O') %>% 
    str_replace_all('//      -IFE "A E"  ',
                    '//      -IFE "A O"  ') %>% 
    str_replace_all('PATTERN\\([A-Z0-9]+,memory\\)',
                    paste0('PATTERN\\(', substr(name, 1, nchar(name)-4), ',memory\\)'))
  
  
  setwd('../odd')
  
  writeLines(dat, name)
  
}


# CHK ---------------------------------------------------------------------


