# 1. Packages / Option ----------------------------------------------------

options(warn = -1)
if(!suppressMessages(require(dplyr))){install.packages('dplyr')}; require(dplyr)
if(!suppressMessages(require(stringr))){install.packages('stringr')}; require(stringr)
if(!suppressMessages(require(data.table))){install.packages('data.table')}; require(data.table)
if(!suppressMessages(require(reshape2))){install.packages('reshape2')}; require(reshape2)
if(!suppressMessages(require(BMS))){install.packages('BMS')}; require(BMS)
if(!suppressMessages(require(lubridate))){install.packages('lubridate')}; require(lubridate)
if(!suppressMessages(require(ggplot2))){install.packages('ggplot2')}; require(ggplot2)
source('C:\\Users\\mano.hong\\Desktop\\AUTOWORK\\autowork_utils.R')
memory.limit(32624)

cmd <- commandArgs()

# lscl, folder, tPD

lscl <- cmd[6]
folder <- cmd[7]
MSR <- cmd[8]

myfolder <- paste0('C:\\Users\\mano.hong\\Desktop\\AUTOWORK\\', folder)
setwd(myfolder)

if(lscl == 'n'){
  
  file_list <- list.files()
  mylist <- list()
  
  header <- file_list[str_detect(file_list, 'HEADER')] %>% read.header()
  test <- file_list[str_detect(file_list, '_0|_1|_2')] %>% read.test()
  
  dat <- test %>% 
    inner_join(header, by = 'lot') %>%
    unique()
  
  fwrite(dat, 'fin.csv', row.names = F)
  print('##### Data Save Done #####')
  print('##### END #####')
  
}else{
  
  folder_list <- list.files()
  for(i in 1:length(folder_list)){

    setwd(paste0(myfolder, '\\', folder_list[i]))
    file_list <- list.files()
    mylist <- list()
    
    header <- file_list[str_detect(file_list, 'HEADER')] %>% read.header()
    test <- file_list[str_detect(file_list, '_00|_01|_02')] %>% read.test()

    dat <- test %>% 
      inner_join(header, by = 'lot') %>%
      unique()
    
    fwrite(dat, 'fin.csv', row.names = F)
    
    dat_f <- dat_fin(dat)
    
    tPD_plot(dat_f)
    NB_plot(dat_f)
    byRUN_plot(dat_f)
    tPDRUN_plot(dat_f)
    MAPRUN_plot(dat_f)
    DUTMAP(dat)

  }

  print('##### Data Save Done #####')
  print('##### END #####')
  
  }
