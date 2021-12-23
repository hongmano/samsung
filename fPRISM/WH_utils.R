
# 1. Wrangling --------------------------------------------------------------

wrangling <- function(files){
  
  w <- function(file){
    
    # Data Load
    
    dat <- readLines(file)
    
    part <- regmatches(dat, regexpr('[A-Z0-9]+[-][A-Z0-9]+[-][A-Z0-9]+', dat))
    part2 <- paste0(substr(part, 1, 10), substr(part, 23, 25))
    lot <- substr(regmatches(dat, regexpr('LOT_ID=[A-Z0-9]+', dat)), 8, 100)
    step <- regmatches(dat, regexpr('T0[0-9][0-9][A-Z0-9]+', dat))
    test_model <- substr(regmatches(dat, regexpr('TESTER_MODEL=[A-Z0-9]+', dat)), 14 , 100)
    tester <- substr(regmatches(dat, regexpr('TESTER=[a-z0-9]+', dat)), 8 , 100)
    
    # Cycle
    
    rawdata <- as.data.frame(dat) %>% 
      mutate(cycle = 1)
    
    cycle <- c(str_which(dat, 'LOADERSIDE'), nrow(rawdata))
    
    for(i in 1:(length(cycle)-1)){
      
      rawdata$cycle[cycle[i]:cycle[i+1]] <- i
      
    }
    
    rawdata <- rawdata[str_detect(rawdata$dat, 'DO='), ]
    
    rm(cycle)
    
    # Wrangling
    
    dat <- dat[str_detect(dat, 'DO=')] %>% 
      str_replace_all('\\s+', ' ') %>% 
      str_replace_all('= ', '=') %>% 
      str_replace_all(' =', '=') %>% 
      str_replace_all(': ', ':') %>% 
      str_replace_all(' :', ':') %>% 
      str_remove_all('DO=|FU=|HB=|CB=|SB=|NB=|DU=|SG=|HTEMP=|MV=|DCT|FBIN=|PBIN=|TAG=|ACT|FPE|ZQ|IDT|TRV|IBIS|FPN|SPIN|OPIN') %>% 
      str_replace_all('\\s+', ' ') %>% 
      str_trim() 
    
    # Split by Space
    
    n_col <- str_count(dat[1], ' ') + 1
    
    dat <- dat %>% 
      str_split_fixed(' ', n_col) %>% 
      as.data.frame() %>% 
      mutate(cycle = rawdata$cycle)
    
    
    # Set Colnames(WH LF /  HF)
    
    
    # WH LF
    if(part2 %in% c('K3KL3L30CM9AH') & substr(step, 1, 3) == 'T07'){
      
      names(dat)[1:12] <- c('DO', 'FU', 'HB', 'CB', 'NB', 'SB', 'DU', 'SG', 'HTEMP', 'FBIN', 'PBIN', 'TAG')
      
      # NU AUTO(G2) T070 T5375 / T5377
      
    }else if(part2 %in% c('K4F4E3S4HF7WL') & substr(step, 1, 4) == 'T070' & test_model != 'T5833'){
      
      names(dat)[1:12] <- c('DO', 'FU', 'HB', 'CB', 'NB', 'SB', 'DU', 'SG', 'HTEMP', 'FBIN', 'PBIN', 'TAG')
      
      # NU AUTO(G2) T070 T5388
      
    }else if(part2 %in% c('K4F4E3S4HF7WL') & substr(step, 1, 4) == 'T070' & test_model == 'T5833'){
      
      names(dat)[1:8] <- c('DO', 'FU', 'HB', 'CB', 'NB', 'DU', 'SG', 'HTEMP')
      
      # NU AUTO(G2) T071 T5388
      
    }else if(part2 %in% c('K4F4E3S4HF7WL') & substr(step, 1, 4) == 'T071'){
      
      names(dat)[1:8] <- c('DO', 'FU', 'HB', 'CB', 'NB', 'DU', 'SG', 'HTEMP')
      
      ###### HF.
      
    }else if(part2 %in% c('K4F8E3D4HF7UP', 'K4F4E3S4HF7UQ', 'K4F4E3S4HF7WL')){
      
      names(dat)[1:10] <- c('DO', 'FU', 'HB', 'CB', 'NB', 'DU', 'SG', 'HTEMP', 'tPD_F', 'tPD')
      
    }else if(part2 %in% c('K4F4E3S4HF7GN', 'K4F4E6S4HF7TT', 'K4F8E3D4HF7PN')){
      
      names(dat)[1:9] <- c('DO', 'FU', 'HB', 'CB', 'NB', 'DU', 'SG', 'HTEMP', 'tPD')
      
    }else if(part2 %in% c('K4UBE3S4AM95M', 'K4UCE3D4AM99U')){
      
      names(dat)[1:11] <- c('DO', 'FU', 'HB', 'CB', 'NB', 'DU', 'SG', 'HTEMP', 'first_MV', 'tPD', 'tPD_F')
      
    }else if(part2 %in% c('K3LK2K20BM76X', 'K3LK4K40BM93M', 'K3LK4K40BM76P')){
      
      names(dat)[1:11] <- c('DO', 'FU', 'HB', 'CB', 'NB', 'DU', 'SG', 'HTEMP', 'tPD_Short', 'tPD_Long', 'tPD')
      
    }else if(part2 %in% c('K3KL3L30CM9AH') |
             substr(part2, 1, 10) %in% c('K3LK7K70BM', 'K3LK6K60BM')){
      
      names(dat)[1:11] <- c('DO', 'FU', 'HB', 'CB', 'NB', 'DU', 'SG', 'HTEMP', 'tPD_Short', 'tPD_Long', 'tPD')
      
    }
    
    SG <- dat %>% sig_converting()
    
    dat <- cbind(dat, SG)
    
    dat$part <- part
    dat$lot <- lot
    dat$step <- step
    dat$test_model <- test_model
    dat$tester <- tester
    
    ### SG change to numeric when it has ONLY NUMBERS!!!
    
    dat$SG <- paste0('x', dat$SG)
    
    return(dat)
    
    
  }
  
  dat_list <- c()
  
  for(i in 1:length(files)){
    
    ### No data Break
    
    if(length(str_which(readLines(files[i]), 'LOADERSIDE')) == 0) next
    
    dat_list[[i]] <- w(files[i])
    dat_list[[i]]$test <- as.numeric(substr(str_split(files[i], '_')[[1]][5], 1, 2))
    
    # file.remove(files[i])
    
  }
  
  for(i in 2:length(files)){
    
    dat_list[[i]]$cycle <- dat_list[[i]]$cycle + max(dat_list[[i-1]]$cycle)
    
  }
  
  dat <- rbindlist(dat_list, fill = T)
  
  return(dat)
  
  
}


# 2. Signature Decoding ------------------------------------------------------

sig_converting <- function(dat){
  
  PKGMAP <- read.table('C:\\Users\\mano.hong\\Desktop\\AUTOWORK\\PKGMAP.txt', 
                       fill = T,
                       header = T)
  
  bin64 <- data.frame(sapply(dat$SG,
                             FUN = function(x){paste(rev(hex2bin(x)), 
                                                     collapse = '')}) %>%
                        str_split_fixed('', 64))
  bin64 <- data.frame(apply(bin64, 2, as.numeric))
  
  multiple <- c(2^(0:4), 2^(0:5), 2^(0:3), rep(2^(0:5), 2), 2^(0:3), 2^(0:5), 2^(0:4), rep(2^(0:7), 2), 2^(0:4), 1)
  
  for(i in 1:64){bin64[i] <- bin64[i] * multiple[i]}
  
  result <- data.frame(SG = dat$SG,
                       line = rowSums(bin64[1:5]),
                       prod = rowSums(bin64[6:11]),
                       month = rowSums(bin64[12:15]),
                       lot4 = rowSums(bin64[16:21]),
                       lot5 = rowSums(bin64[22:27]),
                       lot6 = rowSums(bin64[28:31]),
                       split = rowSums(bin64[32:37]),
                       wf = rowSums(bin64[38:42]),
                       x = rowSums(bin64[43:50]),
                       y = rowSums(bin64[51:58]),
                       mask = rowSums(bin64[59:63])) %>% 
    
    mutate(month = ifelse(split == 1, month + 16, month),
           lot4 = PKGMAP$lot_code[match(lot4, PKGMAP$lot_value)],
           lot5 = PKGMAP$lot_code[match(lot5, PKGMAP$lot_value)],
           lot6 = PKGMAP$lot_code[match(lot6, PKGMAP$lot_value)],
           line = PKGMAP$line_code[match(line, PKGMAP$line_value)],
           prod = PKGMAP$prod_code[match(prod, PKGMAP$prod_value)],
           month = PKGMAP$month_code[match(month, PKGMAP$month_value)],
           mask = PKGMAP$mask_code[match(mask, PKGMAP$mask_value)],
           run = paste0(line, prod, month, lot4, lot5, lot6)) %>% 
    
    select(run, wf, x, y, mask, line)
  
  return(result)
  
}


# 3. Plotting -------------------------------------------------------------

health_index <- function(dat){
  
  dat %>% 
    select(SG, paste0('V', 105:120)) %>% 
    `colnames<-`(c('SG', rep(paste0(rep(c('A', 'B', 'C', 'D'), 4), rep(0:3, each = 4))))) %>% 
    melt(id.vars = 'SG') %>% 
    mutate(value = as.numeric(value)) %>% 
    ggplot(aes(x = variable,
               y = value,
               col = variable)) +
    geom_boxplot(outlier.shape = NA) +
    geom_jitter(alpha = .03) +
    theme_bw()+
    labs(x = 'Bank',
         y = 'Health Index',
         title = 'Health Index(가안)') +
    theme(legend.position = 'none')
  
  ggsave('Health_Index.png')
  
}


