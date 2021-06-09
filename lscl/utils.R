# 0. HEADER ---------------------------------------------------------------

header <- function(){
  
  
  dat <- read.csv('HEADER.csv')
  
  # PART
  
  part <- regmatches(dat$DOC_VER.5.0,regexpr('[A-Z0-9]+[-][A-Z0-9]+[-][A-Z0-9]+', dat$DOC_VER.5.0))
  
  # STEP
  
  step <- regmatches(dat$DOC_VER.5.0,regexpr('T0[0-9][0-9][A-Z0-9]+', dat$DOC_VER.5.0))
  
  # TEST MODEL
  
  test_model <- substr(regmatches(dat$DOC_VER.5.0,regexpr('TESTER_MODEL=[A-Z0-9]+', dat$DOC_VER.5.0)), 14 , 100)
  
  # TESTER
  
  tester <- substr(regmatches(dat$DOC_VER.5.0,regexpr('TESTER=[a-z0-9]+', dat$DOC_VER.5.0)), 8 , 100)
  
  # BOARD
  
  board <- substr(regmatches(dat$DOC_VER.5.0,regexpr('BOARD_ID=[A-Z0-9]+', dat$DOC_VER.5.0)), 10, 100)
  
  # END TIME
  
  date <- substr(regmatches(dat$DOC_VER.5.0,regexpr('BLOCK_END_DATE=[0-9/0-9/0-9]+', dat$DOC_VER.5.0)), 16, 100)
  time <- substr(regmatches(dat$DOC_VER.5.0,regexpr('BLOCK_END_TIME=[0-9:0-9:0-9]+', dat$DOC_VER.5.0)), 16, 100)
  date_time <- ymd_hms(paste0(date,time))
  
  header_list <- list(part = part,
                      step = step,
                      test_model = test_model,
                      tester = tester,
                      board = board,
                      end_time = date_time)
  
  return(header_list)
  
}


# 1. Data Loading ---------------------------------------------------------

data_load <- function(files){
  
  dat_list <- list()
  for(i in 1:length(files)){
    
    dat_list[[i]] <- wrangling(read.csv(files[i], header = F)) %>% mutate(test = i-1)
    
    }
  
  dat <- rbindlist(dat_list) %>% filter(DO != '<EOF>')
  sig <- sig_converting(dat)

  dat <- dat %>% inner_join(sig, by = 'SG') %>% 
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
  
  PKGMAP <- read.table('C:\\Users\\mano.hong\\Desktop\\AUTO\\lscl\\PKGMAP.txt', 
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


# 2. Plotting -------------------------------------------------------------


# 2-1. tPD -----------------------------------------------------------------

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
  
  ggsave(paste0('C:\\Users\\mano.hong\\Desktop\\AUTO\\lscl\\', mylotname, '\\', mylotname, '_tPDYLD.png'))
  
}

# 2-2. NB -----------------------------------------------------------------

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
  
  ggsave(paste0('C:\\Users\\mano.hong\\Desktop\\AUTO\\lscl\\', mylotname, '\\', mylotname, '_NB.png'))
  
}


# 2-3. by RUN -------------------------------------------------------------

byRUN_plot <- function(dat){
  
  byRUN <- dat %>% 
    group_by(run) %>% 
    summarise(n = n(),
              YLD = (1-mean(NB_L))*100,
              tPD = mean(tPD),
              .groups = 'drop')
  
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
  
  ggsave(paste0('C:\\Users\\mano.hong\\Desktop\\AUTO\\lscl\\', mylotname, '\\', mylotname, '_RUN.png'))
  
}


# 2-4. Wafer Map ----------------------------------------------------------

MAP_plot <- function(dat){
  
  WFmap <- dat %>% 
    group_by(x, y, wf) %>% 
    summarise(NB = sum(NB_L),
              .groups = 'drop') %>% 
    mutate(NB = ifelse(NB == 0, 0, 1))
  
  xmax <- max(WFmap$x)
  xmin <- min(WFmap$x)
  ymax <- max(WFmap$y)
  ymin <- min(WFmap$y)
  
  # plot
  
  ggplot(WFmap,
         aes(x, y)) +
    
    coord_cartesian(xlim = c(xmin, xmax), 
                    ylim = c(ymin, ymax)) +
    
    scale_x_continuous(breaks = seq(xmin, xmax)) +
    scale_y_continuous(breaks = seq(ymin, ymax))+
    
    geom_tile(aes(fill = NB))+
    
    theme_bw() +
    theme(
      panel.background = element_rect(fill = 'white', color = 'white'),
      panel.grid.major = element_line(color = 'white'),
      panel.grid.minor = element_line(color = 'white'),
      legend.position = 'none',
      axis.text.x = element_blank(),
      axis.text.y = element_blank()
    ) +
    
    facet_wrap(~ wf) +
    ggtitle('Wafer Map') +
    scale_fill_gradientn(colors = c('skyblue', 'red'))
  
  ggsave(paste0('C:\\Users\\mano.hong\\Desktop\\AUTO\\lscl\\', mylotname, '\\', mylotname, '_WFMAP.png'))
  
}


# 2-4-2. WF MAP RUN -------------------------------------------------------

MAPRUN_plot <- function(dat){
  
  WFmap <- dat %>% 
    group_by(x, y, run) %>% 
    summarise(NB = sum(NB_L),
              .groups = 'drop') %>% 
    mutate(NB = ifelse(NB == 0, 0, 1))
  
  xmax <- max(WFmap$x)
  xmin <- min(WFmap$x)
  ymax <- max(WFmap$y)
  ymin <- min(WFmap$y)
  
  # plot
  
  ggplot(WFmap,
         aes(x, y)) +
    
    coord_cartesian(xlim = c(xmin, xmax), 
                    ylim = c(ymin, ymax)) +
    
    scale_x_continuous(breaks = seq(xmin, xmax)) +
    scale_y_continuous(breaks = seq(ymin, ymax))+
    
    geom_tile(aes(fill = NB))+
    
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
  
  ggsave(paste0('C:\\Users\\mano.hong\\Desktop\\AUTO\\lscl\\', mylotname, '\\', mylotname, '_WFMAPRUN.png'))
  
}

# 2-5. WF MAP tPD ---------------------------------------------------------

MAPtPD_plot <- function(dat){
  
  
  WFmap_tPD <- dat %>% 
    group_by(x, y) %>% 
    summarise(tPD = mean(tPD),
              .groups = 'drop')
  
  xmax <- max(WFmap_tPD$x)
  xmin <- min(WFmap_tPD$x)
  ymax <- max(WFmap_tPD$y)
  ymin <- min(WFmap_tPD$y)
  
  # plot
  
  ggplot(WFmap_tPD,
         aes(x, y)) +
    
    coord_cartesian(xlim = c(xmin, xmax), 
                    ylim = c(ymin, ymax)) +
    
    scale_x_continuous(breaks = seq(xmin, xmax)) +
    scale_y_continuous(breaks = seq(ymin, ymax))+
    
    geom_tile(aes(fill = tPD))+
    
    theme_bw() +
    theme(
      panel.background = element_rect(fill = 'white', color = 'white'),
      panel.grid.major = element_line(color = '#E0E0E0'),
      panel.grid.minor = element_line(color = '#E0E0E0'),
      axis.text.x = element_blank(),
      axis.text.y = element_blank()
    ) +
    
    ggtitle('Wafer Map') +
    scale_fill_gradient(low = "green",
                        high = "red")
  
  ggsave(paste0('C:\\Users\\mano.hong\\Desktop\\AUTO\\lscl\\', mylotname, '\\', mylotname, '_WFMAP(tPD).png'))
  
}


# 2-6. WF MAP tPD RUN -----------------------------------------------------


MAPtPDRUN_plot <- function(dat){
  
  
  WFmap_tPD <- dat %>% 
    filter(tPD >= 40) %>% 
    group_by(x, y, run) %>% 
    summarise(tPD = mean(tPD),
              .groups = 'drop')
  
  xmax <- max(WFmap_tPD$x)
  xmin <- min(WFmap_tPD$x)
  ymax <- max(WFmap_tPD$y)
  ymin <- min(WFmap_tPD$y)
  
  # plot
  
  ggplot(WFmap_tPD,
         aes(x, y)) +
    
    coord_cartesian(xlim = c(xmin, xmax), 
                    ylim = c(ymin, ymax)) +
    
    scale_x_continuous(breaks = seq(xmin, xmax)) +
    scale_y_continuous(breaks = seq(ymin, ymax))+
    
    geom_tile(aes(fill = tPD))+
    
    theme_bw() +
    theme(
      panel.background = element_rect(fill = 'white', color = 'white'),
      panel.grid.major = element_line(color = 'white'),
      panel.grid.minor = element_line(color = 'white'),
      axis.text.x = element_blank(),
      axis.text.y = element_blank()
    ) +
    
    facet_wrap(~run) +
    ggtitle('Wafer Map') +
    scale_fill_gradient(low = "green",
                        high = "red")
  
  ggsave(paste0('C:\\Users\\mano.hong\\Desktop\\AUTO\\lscl\\', mylotname, '\\', mylotname, '_WFMAPRUN(tPD).png'))
  
}
