# 1. Packages / Option ----------------------------------------------------

options(warn = -1)
if(!suppressMessages(require(dplyr))){install.packages('dplyr')}; require(dplyr)
if(!suppressMessages(require(stringr))){install.packages('stringr')}; require(stringr)
if(!suppressMessages(require(data.table))){install.packages('data.table')}; require(data.table)
if(!suppressMessages(require(ggplot2))){install.packages('ggplot2')}; require(ggplot2)

setwd('C:\\Users\\geonbo.park\\Desktop\\MBTIDD\\')
cmd <- commandArgs()

setwd(paste0('./', cmd[6]))


# 2. Data Loading ---------------------------------------------------------

files <- list.files()
files <- files[str_detect(files, '.gz')]
dat_list <- list()

for(i in 1:length(files)){
  
  dat_list[[i]] <- readLines(files[i])
  dat_list[[i]] <- str_replace_all(dat_list[[i]], '\\s+', '') %>%
    as.data.frame() %>%
    `colnames<-`('v')
  
}

# 3. Utils ----------------------------------------------------------------


wrangling <- function(dat){
  
  w <- function(dat){
    
    system <- substr(regmatches(dat$v,regexpr('System=[A-Z0-9]+', dat$v)), 8, 100)
    tester <- substr(regmatches(dat$v,regexpr('Tester=[A-Z0-9]+', dat$v)), 8, 100)
    lot <- substr(regmatches(dat$v,regexpr('LotId=[A-Z0-9]+', dat$v)), 7, 100)
    start <- ifelse(sum(str_detect(dat$v, 'SAMSUNG PS LOG START')) == 0, str_which(dat$v, 'SAMSUNGPSLOGSTART') + 2, str_which(dat$v, 'SAMSUNG PS LOG START') + 2)
    
    l <- dat[start,] %>% str_split(';')
    l <- length(l[[1]]) - 1
    
    dat <- dat[start:nrow(dat), ] %>% str_split_fixed(';', l) %>% as.data.frame()
    names(dat) <- dat[1,] %>% str_remove_all(';') %>% str_remove_all('\\s+')
    dat <- dat[-1, ]
    
    dat <- dat %>%
      select(Slot, BIB_ID, t_name, ends_with('_I'), )
    
    dat[, 4:ncol(dat)] <- apply(dat[, 4:ncol(dat)], 2, as.numeric)
    dat$t <- 1:nrow(dat)
    
    if(system == 'DM1400CH'){
      
      dat <- dat %>%
        mutate(VDD2 = PS1_I + PS2_I + PS3_I + PS4_I + PS5_I,
               VDD1 = PS6_I + PS7_I) %>%
        select(Slot, t_name, VDD1, VDD2, t) %>% 
        mutate(system = system,
               tester = tester,
               lot = lot)
    }else{
      
      dat <- dat %>%
        mutate(VDD2 = PS1_I + PS2_I + PS3_I + PS4_I,
               VDD1 = PS5_I) %>%
        select(Slot, t_name, VDD1, VDD2, t) %>% 
        mutate(system = system,
               tester = tester,
               lot = lot)
      
    }
    
    return(dat)
    
  }
  
  dat_list <- lapply(dat_list, w)
  
  return(dat_list)
  
}

dat_fin <- wrangling(dat_list)

for(i in 1:length(dat_fin)){

    lot <- dat_fin[[i]]$lot %>% unique
    system <- dat_fin[[i]]$system %>% unique
    tester <- dat_fin[[i]]$tester %>% unique
    
    dat_fin[[i]] <- dat_fin[[i]] %>% select(-c(lot, system, tester)) %>% melt(id.vars = c('Slot', 't_name', 't'))
    
    a <- dat_fin[[i]] %>%
      ggplot(aes(x = t, y = value, col = variable)) + 
      geom_line(size = 1.5) + 
      facet_wrap( ~ Slot, ncol = 2) + 
      theme_bw() +
      theme(legend.position = '',
            axis.text.y = element_text(size = 40),
            strip.text = element_text(size = 25),
            axis.text.x = element_text(size = 0),
            panel.border = element_rect(size = 2, fill = NA)) +
      scale_color_manual(values = c('VDD1' = 'orange',
                                    'VDD2' = '#00A6D6')) +
      labs(x = '',
           y = '')
    
    print(a)
    ggsave(paste0(paste(system, tester, lot, sep = '_'), '.png'), scale = 5)


    if(i == length(dat_fin)){
      
      print('##### END #####')
    }
    
  }

