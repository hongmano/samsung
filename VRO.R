library(stringr)
library(dplyr)
library(data.table)
library(xlsx)
library(ggplot2)
library(plotly)

dat1 <- read.csv('C:\\Users\\mano.hong\\Desktop\\hfc_vro-prod_1-Stn1-S0001.txt', header = F)
dat2 <- read.csv('C:\\Users\\mano.hong\\Desktop\\hfc_vro-prod_1-Stn1-S0002.txt', header = F)
dat3 <- read.csv('C:\\Users\\mano.hong\\Desktop\\hfc_vro-prod_1-Stn1-S0003.txt', header = F)
dat4 <- read.csv('C:\\Users\\mano.hong\\Desktop\\hfc_vro-prod_1-Stn1-S0004.txt', header = F)

cut1 <- min(which(str_detect(dat1$V1, 'EUB0609'))) - 1
cut2 <- min(which(str_detect(dat2$V1, 'EUB0609'))) - 1
cut3 <- min(which(str_detect(dat3$V1, 'EUB0609'))) - 1
cut4 <- min(which(str_detect(dat4$V1, 'EUB0609'))) - 1

dat1 <- dat1[1:cut1, ] %>% as.data.frame()
dat2 <- dat2[1:cut2, ] %>% as.data.frame()
dat3 <- dat3[1:cut3, ] %>% as.data.frame()
dat4 <- dat4[1:cut4, ] %>% as.data.frame()

dat1$. <- dat1$. %>% str_replace_all('\\s+', ' ') %>% str_remove_all('mV')
dat2$. <- dat2$. %>% str_replace_all('\\s+', ' ') %>% str_remove_all('mV')
dat3$. <- dat3$. %>% str_replace_all('\\s+', ' ') %>% str_remove_all('mV')
dat4$. <- dat4$. %>% str_replace_all('\\s+', ' ') %>% str_remove_all('mV')


dat1$.[(str_detect(dat1$., 'LOT NO:'))]
dat2$.[(str_detect(dat2$., 'LOT NO:'))]
dat3$.[(str_detect(dat3$., 'LOT NO:'))]
dat4$.[(str_detect(dat4$., 'LOT NO:'))]

which(str_detect(dat1$., 'LOT NO:'))
which(str_detect(dat2$., 'LOT NO:'))
which(str_detect(dat3$., 'LOT NO:'))
which(str_detect(dat4$., 'LOT NO:'))

EUA5128Q62 <- c(dat1[125:104622, ], dat2[132:115598, ], dat3[128:111916, ], dat4[128:123502, ]) %>% as.data.frame()
EUA5128U52 <- c(dat1[104623:nrow(dat1), ], dat2[115599:nrow(dat2), ], dat3[111917:nrow(dat3), ], dat4[123503:nrow(dat4), ]) %>% as.data.frame()

# TN
EUA5128Q62_TN <- substr(regmatches(EUA5128Q62$., regexpr('TEST NAME: 15[2-3][0-9]+', EUA5128Q62$.)), 12, 300)
EUA5128U52_TN <- substr(regmatches(EUA5128U52$., regexpr('TEST NAME: 15[2-3][0-9]+', EUA5128U52$.)), 12, 300)
# TN start + 2
EUA5128Q62_start <- which(str_detect(EUA5128Q62$., 'TEST NAME: 15[2-3][0-9]+')) + 2
EUA5128U52_start <- which(str_detect(EUA5128U52$., 'TEST NAME: 15[2-3][0-9]+')) + 2
# X16 END - 1
EUA5128Q62_end <- which(str_detect(EUA5128Q62$., 'X16')) - 1
EUA5128U52_end <- which(str_detect(EUA5128U52$., 'X16')) - 1

# Fin
EUA5128Q62_fin <- list()
EUA5128U52_fin <- list()

for(i in 1:length(EUA5128Q62_TN)){
  
  EUA5128Q62_fin[[i]] <- EUA5128Q62[EUA5128Q62_start[i]:EUA5128Q62_end[i], ] %>% 
    str_split_fixed(' ', 6) %>% 
    as.data.frame() %>% 
    mutate(TN = EUA5128Q62_TN[i])
  
}

for(i in 1:length(EUA5128U52_TN)){
  
  EUA5128U52_fin[[i]] <- EUA5128U52[EUA5128U52_start[i]:EUA5128U52_end[i], ] %>% 
    str_split_fixed(' ', 6) %>% 
    as.data.frame() %>% 
    mutate(TN = EUA5128U52_TN[i])
  
}

EUA5128Q62_fin <- rbindlist(EUA5128Q62_fin) %>% 
  `colnames<-`(c('GO/TO', 'DATA', 'UPPER', 'LOWER', 'PIN', 'DUT', 'TN')) %>% 
  mutate(LOT = 'EUA5128Q62')
EUA5128U52_fin <- rbindlist(EUA5128U52_fin) %>% 
  `colnames<-`(c('GO/TO', 'DATA', 'UPPER', 'LOWER', 'PIN', 'DUT', 'TN')) %>% 
  mutate(LOT = 'EUA5128U52')

dat_fin <- rbind(EUA5128Q62_fin, EUA5128U52_fin) %>% 
  mutate(DATA = str_remove_all(DATA, 'mV') %>% as.numeric(),
         UPPER = str_remove_all(DATA, 'mV') %>% as.numeric(),
         LOWER = str_remove_all(DATA, 'mV') %>% as.numeric(),
         TN = factor(TN))

write.csv(dat_fin, 'T090_HFC_VRO.csv', row.names = F)
str_remove_all(dat_fin, 'mV')
