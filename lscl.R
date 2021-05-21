
# 1. Packages / Option ----------------------------------------------------

if(!require(ggplot2)){install.packages('ggplot2')}; require(ggplot2)
if(!require(dplyr)){install.packages('dplyr')}; require(dplyr)
if(!require(stringr)){install.packages('stringr')}; require(stringr)
if(!require(data.table)){install.packages('data.table')}; require(data.table)
if(!require(reshape2)){install.packages('reshape2')}; require(reshape2)
if(!require(BMS)){install.packages('BMS')}; require(BMS)
if(!require(lubridate)){install.packages('lubridate')}; require(lubridate)
setwd('C:\\Users\\mano.hong\\Desktop\\lscl')
source('utils.R')

# 2. My LOT ---------------------------------------------------------

mylot <- commandArgs()
mylotname <- mylot[6] # LOT ID
MSR_tPD <- as.integer(mylot[7]) # tPD Location

setwd(paste0('C:\\Users\\mano.hong\\Desktop\\lscl\\', mylotname))
header_list <- header()

test_n <- list.files() %>% length()
test_n <- test_n - 1

dat <- data_load(test_n) # Data Loading
cols <- colnames(dat)
cols[MSR_tPD] <- 'tPD'
colnames(dat) <- cols

dat$tPD <- as.numeric(dat$tPD)

dat <- dat %>% 
  filter(tPD != 0) %>% 
  mutate(tPD_R = round(tPD, 0),
         NB_L = ifelse(NB == 0, 0, 1),
         HB_L = ifelse(HB == 2, 0, 1),
         PART = header_list$part,
         STEP = header_list$step,
         TEST_MODEL = header_list$test_model,
         TESTER = header_list$tester,
         BOARD = header_list$board,
         end_time = header_list$end_time)
  
write.csv(dat, paste0(mylotname, '_final.csv'), row.names = F)

# 3. Plotting ------------------------------------------------------------


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

