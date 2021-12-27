# 1. Packages / Option ----------------------------------------------------

options(warn = -1)
if(!suppressMessages(require(dplyr))){install.packages('dplyr')}; require(dplyr)
if(!suppressMessages(require(stringr))){install.packages('stringr')}; require(stringr)
if(!suppressMessages(require(data.table))){install.packages('data.table')}; require(data.table)
if(!suppressMessages(require(reshape2))){install.packages('reshape2')}; require(reshape2)
if(!suppressMessages(require(BMS))){install.packages('BMS')}; require(BMS)
if(!suppressMessages(require(lubridate))){install.packages('lubridate')}; require(lubridate)
if(!suppressMessages(require(ggplot2))){install.packages('ggplot2')}; require(ggplot2)
if(!suppressMessages(require(gridExtra))){install.packages('gridExtra')}; require(gridExtra)
source('C:\\Users\\mano.hong\\Desktop\\AUTOWORK\\WH_utils.R')

cmd <- commandArgs()

# lscl, folder, tPD

folder <- cmd[6]
myfolder <- paste0('C:\\Users\\mano.hong\\Desktop\\AUTOWORK\\', folder)
setwd(myfolder)

folder_list <- list.files()

for(i in 1:length(folder_list)){
  
  setwd(paste0(myfolder, '\\', folder_list[i]))
  file_list <- list.files() %>% sort()
  
  dat <- wrangling(file_list)
  fprism <- prism(dat)
  
  fwrite(dat, 'fin.csv', row.names = F)

  # Plotting
    
  health_index(dat)
  FBCbyITEM(dat)
  NB_plot(dat)
  DUTMAP(dat)
  MAPRUN_plot(dat)
  byBANK(fprism)
  byPRISM(fprism)
  

}

print('##### Data Save Done #####')
print('##### END #####')
