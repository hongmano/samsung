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
tPD_location <- as.numeric(cmd[8]) + 8
MSR <- cmd[9]

myfolder <- paste0('C:\\Users\\mano.hong\\Desktop\\AUTOWORK\\', folder)
setwd(myfolder)

file_list <- list.files()
mylist <- list()

header <- file_list[str_detect(file_list, 'HEADER')] %>% read.header()
print('##### Header Loading Done #####')
test <- file_list[str_detect(file_list, '_0|_1|_2')] %>% read.test()
print('##### PKGMAP Loading Done #####')

dat <- test %>% 
  inner_join(header, by = 'lot') %>%
  unique()

fwrite(dat, 'fin.csv', row.names = F)
print('##### Data Save Done #####')


if(lscl == 'n'){
  
  print('##### END #####')
  
}else{
  
  dat_fin <- dat %>% 
    filter(test == 0 & HB %in% c(1:4)|test == 1) %>% 
    filter(HB != 7 & HB != 8) %>% 
    mutate(tPD = as.numeric(tPD),
           NB_L = ifelse(NB == 0, 0, 1),
           tPD_R = round(tPD, 0),
           x = as.numeric(x),
           y = as.numeric(y))
  
  tPD_plot(dat_fin)
  NB_plot(dat_fin)
  byRUN_plot(dat_fin)
  tPDRUN_plot(dat_fin)
  MAPRUN_plot(dat_fin)
  DUTMAP(dat)
  
  print('##### END #####')

}
