# 1. Packages / Option ----------------------------------------------------

options(warn = -1)
if(!suppressMessages(require(dplyr))){install.packages('dplyr')}; require(dplyr)
if(!suppressMessages(require(stringr))){install.packages('stringr')}; require(stringr)
if(!suppressMessages(require(data.table))){install.packages('data.table')}; require(data.table)
if(!suppressMessages(require(reshape2))){install.packages('reshape2')}; require(reshape2)
if(!suppressMessages(require(BMS))){install.packages('BMS')}; require(BMS)
if(!suppressMessages(require(lubridate))){install.packages('lubridate')}; require(lubridate)

source('C:\\Users\\mano.hong\\Desktop\\AUTO\\lscl\\utils.R')

cmd <- commandArgs()
folder <- cmd[6]


myfolder <- paste0('C:\\Users\\mano.hong\\Desktop\\AUTO\\trend\\', folder)
setwd(myfolder)
file_list <- list.files()
mylist <- list()


for(i in 1:length(file_list)){
  
  mylotname <- substr(file_list[i], 1 ,10)
  setwd(paste0('C:\\Users\\mano.hong\\Desktop\\AUTO\\trend\\', folder, '\\', file_list[i]))
  header_list <- header()
  file.remove('HEADER.csv')
  test_n <- list.files()

  mylist[[i]] <- data_load(test_n) %>% 
    mutate(PART = header_list$part,
           STEP = header_list$step,
           TEST_MODEL = header_list$test_model,
           TESTER = header_list$tester,
           BOARD = header_list$board,
           end_time = header_list$end_time)

}

dat <- rbindlist(mylist)

fwrite(dat, paste0('C:\\Users\\mano.hong\\Desktop\\AUTO\\trend\\', folder, '\\fin.csv'), row.names = F)
print('### END ###')
