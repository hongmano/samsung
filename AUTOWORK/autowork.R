
#  Wrangling --------------------------------------------------------------

wrangling <- function(files){
  
  w <- function(file){
    
    # Data Load
    
    dat <- readLines(file)
    
    part <- regmatches(dat, regexpr('[A-Z0-9]+[-][A-Z0-9]+[-][A-Z0-9]+', dat))
    part2 <- paste0(substr(part, 1, 10), substr(part, 23, 25))
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
      str_remove_all('DO=|FU=|HB=|CB=|NB=|DU=|SG=|HTEMP=|MV=|DCT|FBIN=|PBIN=|TAG=|ACT|NRT|FPE|ZQ|IDT|TRV|IBIS|FPN|SPIN|OPIN') %>% 
      str_replace_all('\\s+', ' ') %>% 
      str_trim() 
    
    # Split by Space
    
    n_col <- str_count(dat[1], ' ') + 1
    
    dat <- dat %>% 
      str_split_fixed(' ', n_col) %>% 
      as.data.frame() %>% 
      mutate(cycle = rawdata$cycle)
    
    # Set Colnames
    
    if(part2 %in% c('K4F8E3D4HF7UP', 'K4F4E3S4HF7UQ', 'K4F4E3S4HF7WL')){
      
      names(dat)[1:10] <- c('DO', 'FU', 'HB', 'CB', 'NB', 'DU', 'SG', 'HTEMP', 'tPD_F', 'tPD')
      
    }else if(part2 %in% c('K4F4E3S4HF7GN', 'K4F4E6S4HF7TT', 'K4F8E3D4HF7PN')){
      
      names(dat)[1:9] <- c('DO', 'FU', 'HB', 'CB', 'NB', 'DU', 'SG', 'HTEMP', 'tPD')
      
    }else if(part2 %in% c('K4UBE3S4AM95M', 'K4UCE3D4AM99U')){
      
      names(dat)[1:11] <- c('DO', 'FU', 'HB', 'CB', 'NB', 'DU', 'SG', 'HTEMP', 'first_MV', 'tPD', 'tPD_F')
      
    }else if(part2 %in% c('K3LK2K20BM76X', 'K3LK4K40BM93M', 'K3LK4K40BM76P')){
      
      names(dat)[1:11] <- c('DO', 'FU', 'HB', 'CB', 'NB', 'DU', 'SG', 'HTEMP', 'first_MV', 'second_MV', 'tPD')
      
    }else if(part2 %in% c('K3KL3L30CM9AH')){
      
      names(dat)[1:11] <- c('DO', 'FU', 'HB', 'CB', 'NB', 'DU', 'SG', 'HTEMP', 'first_MV', 'second_MV', 'tPD')
      
    }
    
    SG <- dat %>% sig_converting()
    
    dat <- cbind(dat, SG)
    
    dat$part <- part
    dat$step <- step
    dat$test_model <- test_model
    dat$tester <- tester
    
    return(dat)
    
    
  }
  
  dat_list <- c()
  
  for(i in 1:length(files)){
    
    dat_list[[i]] <- w(files[i])
    dat_list[[i]]$test <- i
    file.remove(files[i])
    
  }
  
  for(i in 2:length(files)){
    
    dat_list[[i]]$cycle <- dat_list[[i]]$cycle + max(dat_list[[i-1]]$cycle)
    
  }
  
  dat <- rbindlist(dat_list)
  
  return(dat)
  
  
}


# Signature Decoding ------------------------------------------------------

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

# 3-1. tPD x YLD

tPD_plot <- function(dat){
  
  tPD <- dat %>%
    mutate(tPD = round(tPD, 0),
           NB_L = ifelse(NB == 0, 0, 1)) %>% 
    filter(tPD > 40) %>% 
    group_by(tPD) %>%
    summarise(YLD = 1 - mean(NB_L),
              n = n(),
              .groups = 'drop')
  
  param <- max(tPD$n) / max(tPD$YLD)
  
  plot_tPD <- tPD %>% 
    ggplot(aes(x = tPD)) +
    geom_bar(aes(y = n),
             stat = 'identity') +
    geom_line(aes(y = YLD * param, group = 1),
              size = 1) +
    geom_point(aes(y = YLD * param)) +
    scale_y_continuous(sec.axis = sec_axis(~. / param)) +
    theme_bw()
  
  ggsave('tPDYLD.png', scale = 3)
  
}

# 3-2. NB 

NB_plot <- function(dat){
  
  plot_NB <- dat %>%
    filter(test == max(test)) %>% 
    mutate(NB = factor(NB),
           tPD = round(tPD, 0),
           NB_L = ifelse(NB == 0, 0, 1)) %>% 
    filter(NB_L != 0) %>% 
    group_by(NB) %>% 
    tally() %>% 
    arrange(desc(n)) %>%
    head(20) %>% 
    ggplot(aes(x = reorder(NB, -n),
               y = n)) + 
    geom_col() +
    xlab('NG BIN') + 
    coord_flip() +
    theme_bw()
  
  ggsave('NB.png', scale = 3)
  
}

# 3-3. RUN x YLD

byRUN_plot <- function(dat){
  
  byRUN <- dat %>% 
    mutate(tPD = round(tPD, 0),
           NB_L = ifelse(NB == 0, 0, 1)) %>% 
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
  
  ggsave('RUNYLD.png', scale = 3)
  
}

# 3-4. tPD x RUN MAP

tPDRUN_plot <- function(dat){
  
  run_16 <- dat %>% group_by(run) %>% tally %>% arrange(desc(n)) %>% head(16)
  
  WFmap_tPD <- dat %>% 
    filter(tPD >= 40 & run %in% run_16$run) %>% 
    group_by(x, y, run) %>% 
    summarise(tPD = mean(tPD),
              n = n(),
              .groups = 'drop') %>%
    arrange(desc(n))
  
  xmax <- max(WFmap_tPD$x, na.rm = T)
  xmin <- min(WFmap_tPD$x, na.rm = T)
  ymax <- max(WFmap_tPD$y, na.rm = T)
  ymin <- min(WFmap_tPD$y, na.rm = T)
  
  # plot
  
  ggplot(WFmap_tPD,
         aes(x, y)) +
    
    coord_cartesian(xlim = c(xmin, xmax), 
                    ylim = c(ymin, ymax)) +
    
    scale_x_continuous(breaks = seq(xmin, xmax)) +
    scale_y_continuous(breaks = seq(ymin, ymax))+
    
    geom_tile(aes(fill = tPD),
              color = 'black')+
    
    theme_bw() +
    theme(
      panel.background = element_rect(fill = 'white', color = 'white'),
      panel.grid.major = element_line(color = 'white'),
      panel.grid.minor = element_line(color = 'white'),
      axis.text.x = element_blank(),
      axis.text.y = element_blank()
    ) +
    
    facet_wrap(~run) +
    ggtitle('tPD x RUN') +
    scale_fill_gradient(low = 'green',
                        high = 'red')
  
  ggsave('tPDRUN.png', scale = 3)
  
}

# 3-5. NB x RUN MAP

MAPRUN_plot <- function(dat){
  
  run_16 <- dat %>% group_by(run) %>% tally %>% arrange(desc(n)) %>% head(16)
  
  WFmap <- dat %>% 
    mutate(tPD = round(tPD, 0),
           NB_L = ifelse(NB == 0, 0, 1)) %>% 
    filter(run %in% run_16$run) %>% 
    group_by(x, y, run) %>% 
    summarise(NB = sum(NB_L),
              n = n(),
              .groups = 'drop') %>% 
    mutate(NB = ifelse(NB == 0, 0, 1)) %>%
    arrange(desc(n))
  
  xmax <- max(WFmap$x, na.rm = T)
  xmin <- min(WFmap$x, na.rm = T)
  ymax <- max(WFmap$y, na.rm = T)
  ymin <- min(WFmap$y, na.rm = T)
  
  # plot
  
  ggplot(WFmap,
         aes(x, y)) +
    
    coord_cartesian(xlim = c(xmin, xmax), 
                    ylim = c(ymin, ymax)) +
    
    scale_x_continuous(breaks = seq(xmin, xmax)) +
    scale_y_continuous(breaks = seq(ymin, ymax))+
    
    geom_tile(aes(fill = NB),
              color = 'black')+
    
    theme_bw() +
    theme(
      panel.background = element_rect(fill = 'white', color = 'white'),
      panel.grid.major = element_line(color = 'white'),
      panel.grid.minor = element_line(color = 'white'),
      legend.position = 'none',
      axis.text.x = element_blank(),
      axis.text.y = element_blank()
    ) +
    
    facet_wrap(~ run) +
    ggtitle('Wafer Map') +
    scale_fill_gradientn(colors = c('skyblue', 'red'))
  
  ggsave('NBRUN.png', scale = 3)
  
}

# 3-6. DUTMAP

DUTMAP <- function(dat){
  
  dat <- dat %>% 
    mutate(HB_L = ifelse(HB %in% c(1:4), 'Good',
                         ifelse(HB %in% c(7:8), 'Env', 'Fail')))
  
  HTEMP <- as.numeric(str_split_fixed(dat$HTEMP, ':', 3)[, 1])
  
  dat$HTEMP <- HTEMP
  dat$DU <- factor(dat$DU)
  dat$cycle <- factor(dat$cycle)
  
  
  ggplot(dat, 
         aes(x = DU, 
             y = cycle)) +
    
    geom_tile(aes(fill = HB_L), 
              show.legend = T,
              na.rm = F,
              color = 'black') +
    
    labs(y = "cycle") +
    scale_x_discrete(position = "top") +
    scale_y_discrete(limits = rev(levels(dat$cycle))) + 
    scale_fill_manual(values = c('Env' = 'red', 'Fail' = 'orange', 'Good' = 'blue')) +
    theme_bw()
  
  ggsave('DUTMAP.jpeg', scale = 3)
  
  ggplot(dat, 
         aes(x = DU, 
             y = cycle)) +
    
    geom_tile(aes(fill = HTEMP), 
              show.legend = T,
              na.rm = F,
              color = 'black') +
    
    labs(y = "cycle") +
    scale_x_discrete(position = "top") +
    scale_y_discrete(limits = rev(levels(dat$cycle))) + 
    scale_fill_gradient(high = 'red', low = 'yellow') + 
    theme_bw()
  
  ggsave('TEMPMAP.jpeg', scale = 3)
  
}
