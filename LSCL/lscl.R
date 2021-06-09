
# 1. Packages / Option ----------------------------------------------------

options(warn = -1)
if(!suppressMessages(require(ggplot2))){install.packages('ggplot2')}; require(ggplot2)
if(!suppressMessages(require(dplyr))){install.packages('dplyr')}; require(dplyr)
if(!suppressMessages(require(stringr))){install.packages('stringr')}; require(stringr)
if(!suppressMessages(require(data.table))){install.packages('data.table')}; require(data.table)
if(!suppressMessages(require(reshape2))){install.packages('reshape2')}; require(reshape2)
if(!suppressMessages(require(BMS))){install.packages('BMS')}; require(BMS)
if(!suppressMessages(require(lubridate))){install.packages('lubridate')}; require(lubridate)

source('C:\\Users\\mano.hong\\Desktop\\AUTO\\lscl\\utils.R')

# 2. My LOT ---------------------------------------------------------

# Commands from SHELL

mylot <- commandArgs()

# LOT ID, tPD Location

mylotname <- mylot[6]
MSR_tPD <- as.integer(mylot[7])

# Read HEADER

setwd(paste0('C:\\Users\\mano.hong\\Desktop\\AUTO\\lscl\\', mylotname))
header_list <- header()
file.remove('HEADER.csv')

# Read Test Files

files <- list.files() %>% sort()
dat <- data_load(files) # Data Loading
file.remove(files)

cols <- colnames(dat)
cols[MSR_tPD] <- 'tPD'
colnames(dat) <- cols

dat$tPD <- as.numeric(dat$tPD)

dat <- dat %>% 
  mutate(tPD_R = round(tPD, 0),
         NB_L = ifelse(NB == 0, 0, 1),
         HB_L = ifelse(HB == 2, 0, 1),
         PART = header_list$part,
         STEP = header_list$step,
         TEST_MODEL = header_list$test_model,
         TESTER = header_list$tester,
         BOARD = header_list$board,
         end_time = header_list$end_time)

write.csv(dat, paste0(mylotname, '_data.csv'), row.names = F)

# 3. Plotting ------------------------------------------------------------

prime_good <- dat %>% filter(test == 0 & HB %in% c(1,2,3,4))
retest <- dat %>% filter(test == 1)

dat <- rbind(prime_good, retest) %>% filter(HB != 8 & HB != 7 & tPD != 0)

# 3-1. tPDYLD -------------------------------------------------------------

tPD_plot(dat)
print('##################### tPD 저장 완료 ######################')


# 3-2. NB -----------------------------------------------------------------

NB_plot(dat)
print('##################### NB 저장 완료 ######################')

# 3-3. by RUN -------------------------------------------------------------

byRUN_plot(dat)
print('##################### by RUN 저장 완료 ######################')

# 3-4. Wafer Map ----------------------------------------------------------

MAP_plot(dat)
MAPRUN_plot(dat)
print('##################### WFMAP 저장 완료 ######################')

# 3-5. Wafer Map (tPD) ----------------------------------------------------

MAPtPD_plot(dat)
MAPtPDRUN_plot(dat)
print('##################### WFMAP_tPD 저장 완료 ######################')

# 3-6. Line Compare -------------------------------------------------------
