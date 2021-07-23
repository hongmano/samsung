# 1. Packages / Option ----------------------------------------------------

options(warn = -1)
if(!suppressMessages(require(dplyr))){install.packages('dplyr')}; require(dplyr)
if(!suppressMessages(require(stringr))){install.packages('stringr')}; require(stringr)
if(!suppressMessages(require(data.table))){install.packages('data.table')}; require(data.table)

# 2. Data Loading ---------------------------------------------------------

setwd('C:\\Users\\mano.hong\\Desktop\\PROJECT\\21. 07. WF 구배별 조립')

dat <- fread('fin.csv') %>% 
  mutate(NB_L = ifelse(NB == 0, 0, 1))

prime <- dat %>% filter(test == 0 & HB %in% c(1:4))
retest <- dat %>% filter(test == 1 & HB %in% c(1:6))

fin_ <- rbind(prime, retest) %>% inner_join(read.table('edge.txt', header = T))
fin <- split(fin_, fin_$run)

dat_list <- list()
for(i in 1:length(fin)){
  
  dat_list[[i]] <- split(fin[[i]], fin[[i]]$wf)
  
}

### Simulation ----

result <- get_result(dat_list, 'edge', 4)
result_ <- result %>% 
  group_by(pkg) %>% 
  summarise(NB_L = ifelse(sum(NB_L) == 0, 0, 1)) %>%
  filter(!pkg %in% c(paste0('etc_E', 1:9), 'etc_center')) %>% 
  mutate(edge = str_split_fixed(pkg, '_', 3)[, 2]) %>% 
  group_by(edge) %>% 
  summarise(n = n(),
            n_fail = sum(NB_L),
            YLD = round(1 - mean(NB_L), 4) * 100)

fin_$HB_L <- ifelse(fin_$HB %in% c(1:4), 1, 0)
round(table(fin_$HB_L)/nrow(fin_) * 100, 2)
round((sum(result_$n) - sum(result_$n_fail)) / sum(result_$n) * 100, 5)

