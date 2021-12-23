# 1. Packages / Option ----------------------------------------------------

options(warn = -1)
if(!suppressMessages(require(dplyr))){install.packages('dplyr')}; require(dplyr)
if(!suppressMessages(require(stringr))){install.packages('stringr')}; require(stringr)
if(!suppressMessages(require(data.table))){install.packages('data.table')}; require(data.table)
if(!suppressMessages(require(reshape2))){install.packages('reshape2')}; require(reshape2)
if(!suppressMessages(require(BMS))){install.packages('BMS')}; require(BMS)
if(!suppressMessages(require(lubridate))){install.packages('lubridate')}; require(lubridate)
if(!suppressMessages(require(ggplot2))){install.packages('ggplot2')}; require(ggplot2)
if(!suppressMessages(require(xlsx))){install.packages('xlsx')}; require(xlsx)
source('C:\\Users\\mano.hong\\Desktop\\AUTOWORK\\WH_utils.R')

cmd <- commandArgs()

# lscl, folder, tPD

folder <- cmd[6]
myfolder <- paste0('C:\\Users\\mano.hong\\Desktop\\AUTOWORK\\', folder)
setwd(myfolder)


file_list <- list.files() %>% sort()
dat <- wrangling(file_list)
fwrite(dat, 'fin.csv', row.names = F)

# Health Index

health_index(dat)




print('##### Data Save Done #####')
print('##### END #####')
