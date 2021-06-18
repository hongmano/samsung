
# 1. READ HEADER ----------------------------------------------------------


read.header <- function(files){
  
  header_list <- list()
  
  for(i in 1:length(files)){
    
    dat <- read.csv(files[i])
    
    header_list[[i]] <- data.frame(
      
      part = regmatches(dat$DOC_VER.5.0,regexpr('[A-Z0-9]+[-][A-Z0-9]+[-][A-Z0-9]+', dat$DOC_VER.5.0)),
      step = regmatches(dat$DOC_VER.5.0,regexpr('T0[0-9][0-9][A-Z0-9]+', dat$DOC_VER.5.0)),
      test_model = substr(regmatches(dat$DOC_VER.5.0,regexpr('TESTER_MODEL=[A-Z0-9]+', dat$DOC_VER.5.0)), 14 , 100),
      tester = substr(regmatches(dat$DOC_VER.5.0,regexpr('TESTER=[a-z0-9]+', dat$DOC_VER.5.0)), 8 , 100),
      board = substr(regmatches(dat$DOC_VER.5.0,regexpr('BOARD_ID=[A-Z0-9]+', dat$DOC_VER.5.0)), 10, 100),
      lot = substr(files[i], 1, 10)
      
    )
    
    file.remove(files[i])
      
  }
  
  header_fin <- rbindlist(header_list)
  
  return(header_fin)
  
}


# 2. READ TEST ------------------------------------------------------------


read.test <- function(files){
  
  dat_list <- list()
  
  for(i in 1:length(files)){
    
    dat_list[[i]] <- fread(files[i], sep = '', header = T) %>% 
      `colnames<-`('V1') %>% 
      wrangling() %>% 
      mutate(test = substr(files[i], 12, 12),
             lot = substr(files[i], 1, 10))
    file.remove(files[i])
  }
  
  dat <- rbindlist(dat_list) %>% filter(DO != '<EOF>')
  sig <- sig_converting(dat)
  
  dat <- dat %>% inner_join(sig, by = 'SG')
  
  return(dat)
  
}

wrangling <- function(dat){
  
  dat$V1 <- str_trim(dat$V1)
  dat$V1 <- str_remove_all(dat$V1, 'DO=|FU=|HB=|CB=|NB=|DU=|SG=|HTEMP=|MV=|DCT|SB= [0-9]+|SB=[0-9]+|FBIN=|PBIN=|TAG=|PS|ACT')
  dat$V1 <- str_replace_all(dat$V1, '\\s+:', ':')
  dat$V1 <- str_replace_all(dat$V1, ':\\s+', ':')
  dat$V1 <- str_replace_all(dat$V1, '\\s+', ' ')
  
  ns <- str_count(dat$V1[1], ' ')
  
  dat <- str_split_fixed(dat$V1, ' ', ns+1) %>% 
    as.data.frame() %>% 
    `colnames<-`(c('DO', 'FU', 'HB', 'CB', 'NB', 'DU', 'SG', 'HTEMP', 
                   paste0('MSR', 1:(ns-7))))
  
  return(dat)
  
}

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
    
    select(SG, run, wf, x, y, mask, line)
  
  return(result)
  
}

# 3. Plotting -------------------------------------------------------------

# 3-1. tPD x YLD

tPD_plot <- function(dat){
  
  tPD <- dat %>%
    group_by(tPD_R) %>%
    summarise(YLD = 1 - mean(NB_L),
              n = n(),
              .groups = 'drop')
  
  param <- max(tPD$n) / max(tPD$YLD)
  
  plot_tPD <- tPD %>% 
    ggplot(aes(x = tPD_R)) +
    geom_bar(aes(y = n),
             stat = 'identity') +
    geom_line(aes(y = YLD * param, group = 1),
              size = 1) +
    geom_point(aes(y = YLD * param)) +
    scale_y_continuous(sec.axis = sec_axis(~. / param)) +
    theme_bw()
  
  ggsave(paste0('C:\\Users\\mano.hong\\Desktop\\AUTOWORK\\', folder, '\\', 'tPDYLD.png'))
  
}

# 3-2. NB 

NB_plot <- function(dat){
  
  plot_NB <- dat %>%
    mutate(NB = factor(NB)) %>% 
    filter(NB_L != 0) %>% 
    group_by(NB) %>% 
    tally() %>% 
    arrange(desc(n)) %>% 
    head(10) %>% 
    ggplot(aes(x = reorder(NB, -n),
               y = n)) + 
    geom_col() +
    xlab('NG BIN') + 
    coord_flip() +
    theme_bw()
  
  ggsave(paste0('C:\\Users\\mano.hong\\Desktop\\AUTOWORK\\', folder, '\\', 'NB.png'))
  
}

# 3-3. RUN x YLD

byRUN_plot <- function(dat){
  
  byRUN <- dat %>% 
    group_by(run) %>% 
    summarise(n = n(),
              YLD = (1-mean(NB_L))*100,
              tPD = mean(tPD),
              .groups = 'drop') %>% 
    filter(n >= 100)
  
  param <- max(byRUN$n) / max(byRUN$YLD)
  
  plot_byRUN <- ggplot(byRUN,
                       aes(x = reorder(run, -n))) + 
    geom_bar(aes(y = n), 
             stat = 'identity') +
    geom_line(aes(y = YLD*param, group = 1),
              size = 1) +
    geom_point(aes(y = YLD*param),
               size = 2,
               fill = 'white') +
    geom_line(aes(y = tPD*param, group = 1),
              size = 1,
              col = 'red') +
    scale_y_continuous(sec.axis = sec_axis(~./param)) +
    theme_bw() +
    theme(axis.text.x = element_text(angle = 90, 
                                     hjust = 1),
          axis.title.x = element_blank())
  
  ggsave(paste0('C:\\Users\\mano.hong\\Desktop\\AUTOWORK\\', folder, '\\', 'RUNYLD.png'))
  
}
