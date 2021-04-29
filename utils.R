
# 1. Data Loading ---------------------------------------------------------

data_load <- function(test_n){
  
  data_list <- list()
  
  if(test_n == 1){
    
    data_list$final <- wrangling(read.csv(paste0(mylotname, '_0.csv'), header = F))
    
  }else if(test_n == 2){
    
    data_list$prime <- wrangling(read.csv(paste0(mylotname, '_0.csv'), header = F))
    data_list$retest1 <- wrangling(read.csv(paste0(mylotname, '_1.csv'), header = F)) %>% 
      filter(!SG %in% data_list$prime$SG)
    
  }else if(test_n == 3){
    
    data_list$prime <- wrangling(read.csv(paste0(mylotname, '_0.csv'), header = F))
    data_list$retest1 <- wrangling(read.csv(paste0(mylotname, '_1.csv'), header = F)) %>% 
      filter(!SG %in% data_list$prime$SG)
    data_list$retest2 <- wrangling(read.csv(paste0(mylotname, '_2.csv'), header = F)) %>% 
      filter(!SG %in% data_list$prime$SG &
               !SG %in% data_list$retest1$SG)
    
  }
  
  dat <- rbindlist(data_list) %>% 
    filter(DO != '<EOF>')
  sig <- sig_converting(dat)
  
  dat <- dat %>% 
    inner_join(sig) %>% 
    filter(x != 0 & y != 0)
  
  return(dat)
  
}

# 1-1. Wrangling ------------------------------------------------------------


wrangling <- function(dat){
  
  dat$V1 <- str_trim(dat$V1)
  dat$V1 <- str_remove_all(dat$V1, 'DO=|FU=|HB=|CB=|NB=|DU=|SG=|HTEMP=|MV=|DCT')
  dat$V1 <- str_replace_all(dat$V1, '\\s+:', ':')
  dat$V1 <- str_replace_all(dat$V1, ':\\s+', ':')
  dat$V1 <- str_replace_all(dat$V1, '\\s+', ' ')
  
  dat <- str_split_fixed(dat$V1, ' ', 300) %>% 
    as.data.frame() %>% 
    `colnames<-`(c('DO', 'FU', 'HB', 'CB', 'NB', 'DU', 'SG', 'HTEMP', 
                   paste0('MSR', 1:292)))
  
  return(dat)
  
}

# 1-2. Signature Converting -----------------------------------------------

sig_converting <- function(dat){
  
  PKGMAP <- read.table('C:\\Users\\mano.hong\\Desktop\\lscl\\PKGMAP.txt', 
                       fill = T,
                       header = T)
  
  bin64 <- data.frame(sapply(dat$SG,
                             FUN = function(x){paste(rev(hex2bin(x)), 
                                                     collapse = "")}) %>%
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
           run = paste0(line, prod, month, lot4, lot5, lot6)) %>% 
    select(SG, run, wf, x, y, mask)
  
  return(result)
  
}
