
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

prism <- function(dat){
  
  fprism <- list()
  for(i in 1:30){
    
    fprism[[i]] <- dat %>% 
      select(SG, paste0('V', (252+(8*(i-1))+1):(252+(8*(i-1))+8))) %>% 
      `colnames<-`(c('SG', 'TN', 'prism', 'BANK', 'X_1', 'X_2', 'X_3', 'X-4', 'FBC')) %>% 
      filter(TN != '____') %>% 
      mutate(TN = as.numeric(TN)) %>% 
      inner_join(read.table('C:/Users/mano.hong/Desktop/AUTOWORK/condition.txt',
                            header = T,
                            fill = T),
                 by = 'TN')
  }
  
  fprism <- rbindlist(fprism) %>% 
    mutate(BANK = substr(BANK, 1, 2))
  fprism <- split(fprism, fprism$ITEM)
  
  return(fprism)
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
         title = 'Health Index(°¡¾È)') +
    theme(legend.position = 'none')
  
  ggsave('Health_Index.png')
  
}

##### 2.

FBCbyITEM <- function(dat){
  
  table_join <- data.frame(ITEM = rep(rep(c('C2','GF', 'MB', 'SBD', 'ST0', 'ST1'), each = 3), 9),
                           condition = rep(c('40', '48', '56', '16', '18', '20', '40', '48', '56', '160', '200', '240', '40', '48', '56', '40', '48', '56'), 9),
                           FBC = rep(c(paste0(1:5, 'bit'), '~ 10bit', '~ 100bit', '~ 1000bit', '1000bit ~'), each = 18))
  
  test2 <- dat %>%
    select(SG, paste0('V', 123:140)) %>%
    `colnames<-`(c('SG',
                   'GF_16', 'GF_18', 'GF_20',
                   'ST1_40', 'ST1_48', 'ST1_56',
                   'ST0_40', 'ST0_48', 'ST0_56',
                   'SBD_160', 'SBD_200', 'SBD_240',
                   'MB_40', 'MB_48', 'MB_56',
                   'C2_40', 'C2_48', 'C2_56')) %>%
    melt(id.vars = 'SG') %>%
    mutate(value = as.numeric(value),
           ITEM = str_split_fixed(variable, '_', 2)[, 1],
           condition = str_split_fixed(variable, '_', 2)[, 2],
           FBC = ifelse(value <= 5, paste0(value, 'bit'),
                        ifelse(value <= 10, '~ 10bit',
                               ifelse(value <= 100, '~ 100bit',
                                      ifelse(value <= 1000, '~ 1000bit', '1000bit ~'))))) %>%
    group_by(ITEM, condition, FBC) %>%
    tally %>%
    right_join(table_join,
               by = c('ITEM', 'condition', 'FBC')) %>%
    mutate(n = ifelse(is.na(n) == T, 0, n),
           FBC = factor(FBC, levels = c(paste0(1:5, 'bit'), '~ 10bit', '~ 100bit', '~ 1000bit', '1000bit ~'))) %>%
    arrange(ITEM, condition, FBC) %>%
    group_by(ITEM, condition) %>%
    mutate(cumsum = cumsum(n))
  
  test2 <- test2 %>%
    inner_join(test2 %>%
                 group_by(ITEM, condition) %>%
                 summarise(n_sum = sum(n),
                           .groups = 'drop'),
               by = c('ITEM', 'condition')) %>%
    mutate(ratio = round(cumsum / n_sum * 100, 1)) %>%
    select(ITEM, condition, FBC, n, ratio)
  
  
  test2 <- split(test2, test2$ITEM)
  p <- list()
  
  for(i in 1:length(test2)){
    
    p[[i]] <- test2[[i]] %>%
      ggplot(aes(x = FBC,
                 y = n,
                 fill = condition)) +
      geom_bar(stat = 'identity',
               width = .5,
               position = position_dodge(width = .7,
                                         preserve = 'single')) +
      geom_line(aes(y = ratio * max(n) / 100,
                    col = condition,
                    group = condition),
                size = 1.5) +
      geom_point(aes(y = ratio * max(n) / 100,
                     fill = condition,
                     col = condition),
                 size = 2) +
      geom_text(aes(y = ratio * max(n) / 100,
                    label = paste0(ratio, '%')),
                position = 'dodge',
                vjust = -.5,
                check_overlap = T) +
      scale_fill_manual(values = c('skyblue', 'grey', 'blue')) +
      scale_color_manual(values = c('skyblue', 'grey', 'blue')) +
      theme_bw() +
      theme(legend.position = c(0.9, 0.5)) +
      labs(x = '',
           y = '',
           title = names(test2)[i])
    
  }
  
  p <- do.call('grid.arrange', c(p, ncol = 3))
  grid.arrange(p)
  
  ggsave(p , filename =  'FBCbyITEM.png',  width = 18, height = 10, dpi = 300, units = "in", device='png')
  
  
}

byBANK <- function(dat){

  p <- list()
  
  for(i in 1:length(fprism)){

    p[[i]] <- fprism[[i]] %>%
      group_by(condition2, BANK) %>% 
      tally %>% 
      ggplot(aes(x = BANK,
                 y = n,
                 col = condition2,
                 fill = condition2)) +
      geom_point() +
      geom_line(aes(group = condition2)) +
      geom_text(aes(label = n), 
                check_overlap = T, vjust = -.5) +
      theme_bw() +
      theme(legend.position = c(0.95, 0.95),
            legend.justification = c("right", "top"),
            legend.box.background = element_rect(),
            legend.box.margin = margin(1, 1, 1, 1)) +
      labs(x = '',
           y = '',
           title = names(fprism)[i])
    
  }
  
  coln <- ifelse(substr(dat$step[1], 1, 4) == 'T070', 4, 3)

  p <- do.call('grid.arrange', c(p, ncol = coln))
    

  
  grid.arrange(p)
  ggsave(p , filename =  'PRISMbyBANK.png',  width = 18, height = 10, dpi = 300, units = "in", device='png')
  
}

byPRISM <- function(dat){
  
  p <- list()
  
  for(i in 1:length(fprism)){

    p[[i]] <- fprism[[i]] %>%
      mutate(prism = factor(prism, levels = c('SBIT', paste0(1:8, 'ROW'), '1CMA', '2CMA', paste0(1:4, 'BLK')) )) %>% 
      group_by(condition2, prism) %>% 
      tally %>% 
      ggplot(aes(x = prism,
                 y = n,
                 col = condition2)) +
      geom_point() +
      geom_line(aes(group = condition2)) +
      geom_text(aes(label = n), 
                check_overlap = T, vjust = -.4) +
      theme_bw() +
      theme(legend.position = c(0.95, 0.95),
            legend.justification = c("right", "top"),
            legend.box.background = element_rect(),
            legend.box.margin = margin(1, 1, 1, 1),
      ) +
      labs(x = '',
           y = '',
           title = names(fprism)[i])
    
  }
  
  coln <- ifelse(substr(dat$step[1], 1, 4) == 'T070', 4, 3)
  p <- do.call('grid.arrange', c(p, ncol = coln))
    
  
  grid.arrange(p)
  
  ggsave(p , filename =  'PRISM.png',  width = 18, height = 10, dpi = 300, units = "in", device='png')
  
}
