
# 1. Options / Packages ---------------------------------------------------

if(!suppressMessages(require(dplyr))){install.packages('dplyr')}; require(dplyr)
if(!suppressMessages(require(data.table))){install.packages('data.table')}; require(data.table)
if(!suppressMessages(require(stringr))){install.packages('stringr')}; require(stringr)
setwd('C:\\Users\\mano.hong\\Desktop\\PROJECT\\21. 06. SORTING')

mylot <- commandArgs()
filename <- mylot[6]

# 2. Data Loading ---------------------------------------------------------

dat <- read.csv(paste0(filename, '.txt'))

dat <- dat %>% 
  mutate(W = ifelse(nchar(W) == 1, paste0('W0', W), paste0('W', W)),
         XY = 100 * X + Y) %>% 
  arrange(XY)

# 3. Wrangling -------------------------------------------------------------

test <- split(dat, dat$R)
cnt_R <- dat %>% group_by(R) %>% tally %>% arrange(R) %>% select(n) %>% unlist()

for(i in 1:length(test)){
  
  test[[i]] <- split(test[[i]], test[[i]]$W)
  
}

for(i in 1:length(test)){
  for(j in 1:length(test[[i]])){
    
    test[[i]][[j]] <- test[[i]][[j]] %>% select(XY) %>% as.data.frame()
    
  }
}

# 4. Function -------------------------------------------------------------

code <- list()

for(i in 1:length(test)){
  
  if(i == 1){
    
    code[[i]] <- paste0('IF RWSRT0(1,6)="', names(test)[i] ,'" THEN ENTRY ; CNT:', cnt_R[i]) %>% as.data.frame()
    
    }
  else{
    
    exit <- 'EXIT'
    code[[i]] <- rbind('EXIT', paste0('IF RWSRT0(1,6)="', names(test)[i] ,'" THEN ENTRY ; CNT:', cnt_R[i]) %>% as.data.frame())
    
    }
  
  for(j in 1:length(test[[i]])){
    
    msg <- paste0('   IF RWSRT0(8,3)="', names(test[[i]][j]), '" THEN GOSUB RWYSRT(')
    XY <- nrow(test[[i]][[j]])
    
    
    
    if(XY %% 36 == 0){
      
      for(k in 1:(XY %/% 36)){
        
        XYs <- toString(test[[i]][[j]][(1 + 36*(k-1)):(36*k), ]) %>% str_replace_all('\\s+', '')
        cnt <- 36 - str_count(XYs, 'NA')
        XYs <- XYs %>% str_replace_all('NA', '0')
        
        msg_fin <- paste0(msg, XYs, ') ; ', 'CNT:', 36 * (k-1) + cnt, ' / ', XY) %>% as.data.frame()
        
        code[[i]] <- rbind(code[[i]], msg_fin)
      
      }
    }
    else{
      
      for(k in 1:(XY %/% 36 + 1)){
        
        XYs <- toString(test[[i]][[j]][(1 + 36*(k-1)):(36*k), ]) %>% str_replace_all('\\s+', '')
        cnt <- 36 - str_count(XYs, 'NA')
        XYs <- XYs %>% str_replace_all('NA', '0')
        
        msg_fin <- paste0(msg, XYs, ') ; ', 'CNT:', 36 * (k-1) + cnt, ' / ', XY) %>% as.data.frame()
        
        code[[i]] <- rbind(code[[i]], msg_fin)
       
      }
    }
    
    }
    
    
}

code <- rbindlist(code)
fwrite(code, paste0(filename, '_code.csv'), row.names = F, col.names = F)
print('############ PGM SETTING DONE ############')
