library(dplyr)
library(data.table)
library(stringr)


# function -----------------------------------------------------------------

patn_compare <- function(speed){
    
  # 1. get PATN list 
  
  setwd(paste0('C:\\Users\\mano.hong\\Desktop\\WH_PATN\\', speed))
  
  # get PATN list in MAIN PGM
  
  patn_list <- fread('patn_list.txt', header = F)
  
  # get PATN list in WHP
  
  setwd('./new')
  
  new_patn <- data.frame(patn = list.files()) %>% 
    filter(patn %in% paste0(patn_list$V1, 'NN.asc'))
  
  patn_list %>% filter(!paste0(V1, 'NN.asc') %in% new_patn$patn) ## 
  
  # get PATN list in NNP
  
  setwd('../old')
  
  old_patn <- data.frame(patn = list.files())
  substr(old_patn$patn, 3, 3) <- 'C'
  
  old_patn <- old_patn %>% 
    filter(patn %in% paste0(patn_list$V1, 'NN.asc'))
  
  patn_list %>% filter(!paste0(V1, 'NN.asc') %in% old_patn$patn) ## 4 patterns are not in old PATN
  
  # get PATN list which jonjae in 2 Folder
  
  fin <- old_patn %>% 
    filter(patn %in% new_patn$patn) %>% 
    arrange(patn) %>% 
    unlist
  
  fin_old <- fin
  substr(fin_old, 3, 3) <- 'B'
  
  # 2. PATN loading 
  
  # new PATNs
  
  setwd('../new')
  
  new_patn <- list()
  old_patn <- list()
  
  for(i in 1:length(fin)){
    
    new_patn[[i]] <- readLines(fin[i]) %>% 
      str_replace_all('\\s+', '') %>% 
      str_trim('both') %>% 
      as.data.frame() %>% 
      `colnames<-`('V1') %>% 
      filter(substr(V1, 1, 1) != ';' & substr(V1, 2, 2) != ';' & V1 != '' & V1 != ' ')
    
  }
  names(new_patn) <- fin
  
  # old PATNs
  
  setwd('../old')
  
  for(i in 1:length(fin)){
    
    old_patn[[i]] <- readLines(fin_old[i]) %>% 
      str_replace_all('\\s+', '') %>%
      str_trim('both') %>% 
      as.data.frame() %>% 
      `colnames<-`('V1') %>% 
      filter(substr(V1, 1, 1) != ';' & substr(V1, 2, 2) != ';' & V1 != '' & V1 != ' ')
    
  }
  names(old_patn) <- fin
  
  # 3. Compare PATNs 
  
  # Check Arrangement of PATN names
  
  table(names(old_patn) == names(new_patn))
  length_compare <- list()
  diff <- list()
  
  for(i in 1:length(fin)){
    
    length_compare[[i]] <- length(old_patn[[i]]$V1) == length(new_patn[[i]]$V1)
    d <- which(old_patn[[i]]$V1 != new_patn[[i]]$V1)
    
    if(length_compare[[i]] == T){
      
      diff[[i]] <- list()
      diff[[i]]$old <- old_patn[[i]]$V1[d] %>% unlist
      diff[[i]]$new <- new_patn[[i]]$V1[d] %>% unlist
      diff[[i]] <- as.data.frame(diff[[i]]) %>% mutate(PATN = fin[i])
      
    }
    
  }
  names(diff) <- fin
  
  for(i in 1:length(fin)){
    
    all.equal(new_patn[[i]], old_patn[[i]]) %>% print
    
  }
  
  
  diff_fin <- rbindlist(diff)
  a <- F
  
  for(i in 2:nrow(diff_fin)){
    
    a[i] <- diff_fin$PATN[i] == diff_fin$PATN[i-1]
    
  }
  
  diff_fin$PATN[a] <- NA
  
  a <- c()
  for(i in 1:length(fin)){
    
    a[i] <- ifelse(is.null(diff[[i]]) == T, 'Length Diff', nrow(diff[[i]]))
    
  }
  
  return(list(diff = diff,
              a = a))
  
}


# result ------------------------------------------------------------------

# 1. patn_compare

T7500 <- patn_compare('7500')
T6400 <- patn_compare('6400')
T3200_R41 <- patn_compare('3200_R41')
T3200_R21 <- patn_compare('3200_R21')
T1600_R41 <- patn_compare('1600_R41')
T1600_R21 <- patn_compare('1600_R21')


T3200_R21$diff[[1]] %>% select(-PATN)

# 2. Refresh Type

