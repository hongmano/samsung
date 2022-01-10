
# 1. Options / Packages ---------------------------------------------------

library(dplyr)
library(data.table)
library(stringr)

# 2. Data Loading ---------------------------------------------------------

answer <- read.csv('C:/Users/Mano/Desktop/answer.csv') %>% 
  filter(fusing %in% c('EDS', 'PKG')) %>% 
  mutate(code = paste0('0x', substr(code, 4, 200) %>% toupper()))


patt1 <- readLines('C:/Users/Mano/Desktop/fullrccm1.txt')
patt2 <- readLines('C:/Users/Mano/Desktop/fullrccm2.txt')

patt1 <- patt1 %>% 
  str_replace_all('\\s+', ' ') %>% 
  str_trim
patt1 <- patt1[str_which(patt1, 'SetJamram\\(XXXX')]

patt2 <- patt2 %>% 
  str_replace_all('\\s+', ' ') %>% 
  str_trim
patt2 <- patt2[str_which(patt2, 'SetJamram\\(XXXX')]


patt1 <- data.frame(pgm = patt1,
                    code = regmatches(patt1, regexpr('0x[A-Z0-9]+', patt1)),
                    patn = 1,
                    logic = ifelse(substr(patt1, 1, 1) == '/', 0, 1))

patt2 <- data.frame(pgm = patt2,
                    code = regmatches(patt2, regexpr('0x[A-Z0-9]+', patt2)),
                    patn = 1,
                    logic = ifelse(substr(patt2, 1, 1) == '/', 0, 1))

fin <- rbind(patt1, patt2)

rm(patt1, patt2)

# 3. Test -----------------------------------------------------------------

# Duplicate

fin %>% 
  group_by(code) %>% 
  tally %>% 
  filter(n != 1)

fin %>% filter(code == '0x643011')
fin %>% filter(code == '0x649011')
fin %>% filter(code == '0x64B011')
fin %>% filter(code == '0x64B031')
fin %>% filter(code == '0x64D011')
fin %>% filter(code == '0x64D031')

# in answer but not in patn

answer %>% 
  filter(!code %in% fin$code)

# cross table

fin %>% 
  left_join(answer) %>% 
  filter(fusing %in% c('EDS', 'PKG')) %>% 
  filter(logic == 1)

fin %>% 
  left_join(answer) %>% 
  filter(!fusing %in% c('EDS', 'PKG')) %>% 
  filter(logic == 0)
