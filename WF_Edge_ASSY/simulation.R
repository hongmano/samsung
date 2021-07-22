# 1. Packages / Option ----------------------------------------------------

options(warn = -1)
if(!suppressMessages(require(dplyr))){install.packages('dplyr')}; require(dplyr)
if(!suppressMessages(require(stringr))){install.packages('stringr')}; require(stringr)
if(!suppressMessages(require(data.table))){install.packages('data.table')}; require(data.table)

# 2. Data Loading ---------------------------------------------------------

setwd('C:\\Users\\mano.hong\\Desktop\\PROJECT\\21. 07. WF 구배별 조립')

dat <- list()
for(i in 1:2){
  
  dat[[i]] <- fread(paste0('fin', i, '.csv'))
  
}

dat <- rbindlist(dat) %>% 
  filter(step == 'T070256' & mask == 'F' & HB %in% c(1:6)) %>% 
  filter(substr(run, 1, 2) == 'BH') %>% 
  mutate(NB_L = ifelse(NB == 0, 0, 1),
         edge = ifelse(x %in% c(1:30), 'E1', 'E2'))

prime <- dat %>% filter(test == 0 & HB %in% c(1:4))
retest <- dat %>% filter(test == 1 & HB %in% c(1:6))

fin <- rbind(prime, retest)
fin <- split(fin, fin$run)

dat_list <- list()
for(i in 1:length(fin)){
  
  dat_list[[i]] <- split(fin[[i]], fin[[i]]$wf)
  
}

# 3. Simulation -----------------------------------------------------------

result <- get_result(dat_list, 'edge', 4)
table(result$pkg)

