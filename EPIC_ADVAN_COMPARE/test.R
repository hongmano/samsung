# 1. Packages / Option ----------------------------------------------------


if(!suppressMessages(require(dplyr))){install.packages('dplyr')}; require(dplyr)
if(!suppressMessages(require(stringr))){install.packages('stringr')}; require(stringr)
if(!suppressMessages(require(data.table))){install.packages('data.table')}; require(data.table)
if(!suppressMessages(require(broman))){install.packages('broman')}; require(broman)

# 2. Data Loading ---------------------------------------------------------

setwd('C:\\Users\\mano.hong\\Desktop\\PROJECT\\21. 07. LP5 Command Converter')
files <- list.files()
files <- files[str_detect(files, c('.txt'))]
files <- files[str_detect(files, c('ADC'))]

dat <- read.table(files, header = T) 

dat[dat == '0x'] <- 0
dat[dat == '1x'] <- 1



# 3. Epic Setting ---------------------------------------------------------

# 3-1. Command

dat <- dat %>% 
  mutate(CMDA = paste0(CS0A, CA0A, CA1A, CA2A, CA3A, CA4A, CA5A, CA6A),
         CMD = ifelse(substr(CMDA, 1, 1) == '0', 'DES',
                      ifelse(substr(CMDA, 1, 8) == '10000000', 'NOP',
                             ifelse(substr(CMDA, 1, 8) == '10000001', 'PDE',
                                    ifelse(substr(CMDA, 1, 4) == '1111', 'ACT-1',
                                           ifelse(substr(CMDA, 1, 4) == '1110', 'ACT-2',
                                                  ifelse(substr(CMDA, 1, 8) == '10001111', 'PRE',
                                                         ifelse(substr(CMDA, 1, 8) == '10001110', 'REF',
                                                                ifelse(substr(CMDA, 1, 4) == '1010', 'MWR',
                                                                       ifelse(substr(CMDA, 1, 4) == '1011', 'WR(16)',
                                                                              ifelse(substr(CMDA, 1, 5) == '10010', 'WR32',
                                                                                     ifelse(substr(CMDA, 1, 4) == '1100', 'RD(16)',
                                                                                            ifelse(substr(CMDA, 1, 4) == '1101', 'RD32',
                                                                                                   ifelse(substr(CMDA, 1, 5) == '10011', 'CAS-DUM',
                                                                                                          ifelse(substr(CMDA, 1, 7) == '1000011', 'MPC',
                                                                                                                 ifelse(substr(CMDA, 1, 8) == '10001011', 'SRE',
                                                                                                                        ifelse(substr(CMDA, 1, 8) == '10001010', 'SRX',
                                                                                                                               ifelse(substr(CMDA, 1, 8) == '10001101', 'MRW-1',
                                                                                                                                      ifelse(substr(CMDA, 1, 7) == '1000100', 'MRW-2',
                                                                                                                                             ifelse(substr(CMDA, 1, 8) == '10001100', 'MRR',
                                                                                                                                                    ifelse(substr(CMDA, 1, 8) == '10000011', 'WFF',
                                                                                                                                                           ifelse(substr(CMDA, 1, 8) == '10000010', 'RFF',
                                                                                                                                                                  ifelse(substr(CMDA, 1, 8) == '10000101', 'RDC', '?'))))))))))))))))))))))) %>% 
  mutate(cycle = 1)

# CMD 
for(i in 1:(nrow(dat)/4)){dat$CMD[(i*4-1):(i*4)] <- dat$CMD[(i*4-3):(i*4-2)]}
# Cycle Increase
for(i in 2:nrow(dat)){dat$cycle[i] <- ifelse(dat$CMD[i] == dat$CMD[i-1], dat$cycle[i-1], dat$cycle[i-1] + 1)}

# 3-2. 
# test : CMDA by Cycle
# CS~CA6 by cycle, if cycle has only one unique CMDA, repeat it, else just join it

test <- dat %>% select(cycle, CMDA) %>% unique
test <- split(test, test$cycle)
for(i in 1:length(test)){test[[i]]$CMDA <- ifelse(nrow(test[[i]]) == 1, paste0(test[[i]]$CMDA[1], test[[i]]$CMDA[1]), paste0(test[[i]]$CMDA[1], test[[i]]$CMDA[2]))}
test <- rbindlist(test) %>% unique
dat <- dat %>% select(-CMDA) %>% inner_join(test)
rm(test)

# 3-3. ADDR

dat <- dat %>% 
  mutate( BA0 = ifelse(CMD %in% c('ACT-1', 'PRE', 'REF', 'MWR', 'WR(16)', 'WR32', 'RD(16)', 'RD32'), substr(CMDA, 10, 10), 0) %>% as.numeric(),
          BA1 = ifelse(CMD %in% c('ACT-1', 'PRE', 'REF', 'MWR', 'WR(16)', 'WR32', 'RD(16)', 'RD32'), substr(CMDA, 11, 11), 0) %>% as.numeric(),
          BA2 = ifelse(CMD %in% c('ACT-1', 'PRE', 'REF', 'MWR', 'WR(16)', 'WR32', 'RD(16)', 'RD32'), substr(CMDA, 12, 12), 0) %>% as.numeric(),
          BA3 = ifelse(CMD %in% c('ACT-1', 'PRE', 'MWR', 'WR(16)', 'WR32', 'RD(16)', 'RD32'), substr(CMDA, 13, 13), 0) %>% as.numeric(),
          
          BG0 = ifelse(CMD %in% c('ACT-1', 'PRE', 'REF', 'MWR', 'WR(16)', 'WR32', 'RD(16)', 'RD32'), substr(CMDA, 12, 12), 0) %>% as.numeric(),
          BG1 = ifelse(CMD %in% c('ACT-1', 'PRE', 'MWR', 'WR(16)', 'WR32', 'RD(16)', 'RD32'), substr(CMDA, 13, 13), 0) %>% as.numeric(),
          
          B4 = ifelse(CMD == 'RD32', substr(CMDA, 13, 13), 0) %>% as.numeric(),
          
          AB = ifelse(CMD %in% c('PRE', 'REF'), substr(CMDA, 16, 16), 0) %>% as.numeric(),
          AP = ifelse(CMD %in% c('MWR', 'WR(16)', 'WR32', 'RD(16)', 'RD32'), substr(CMDA, 16, 16), 0) %>% as.numeric(),
          
          R0 = ifelse(CMD == 'ACT-2', substr(CMDA, 10, 10), 0) %>% as.numeric(),
          R1 = ifelse(CMD == 'ACT-2', substr(CMDA, 11, 11), 0) %>% as.numeric(),
          R2 = ifelse(CMD == 'ACT-2', substr(CMDA, 12, 12), 0) %>% as.numeric(),
          R3 = ifelse(CMD == 'ACT-2', substr(CMDA, 13, 13), 0) %>% as.numeric(),
          R4 = ifelse(CMD == 'ACT-2', substr(CMDA, 14, 14), 0) %>% as.numeric(),
          R5 = ifelse(CMD == 'ACT-2', substr(CMDA, 15, 15), 0) %>% as.numeric(),
          R6 = ifelse(CMD == 'ACT-2', substr(CMDA, 16, 16), 0) %>% as.numeric(),
          R7 = ifelse(CMD == 'ACT-2', substr(CMDA, 5, 5), 0) %>% as.numeric(),
          R8 = ifelse(CMD == 'ACT-2', substr(CMDA, 6, 6), 0) %>% as.numeric(),
          R9 = ifelse(CMD == 'ACT-2', substr(CMDA, 7, 7), 0) %>% as.numeric(),
          R10 = ifelse(CMD == 'ACT-2', substr(CMDA, 8, 8), 0) %>% as.numeric(),
          
          R11 = ifelse(CMD == 'ACT-1', substr(CMDA, 14, 14), 0) %>% as.numeric(),
          R12 = ifelse(CMD == 'ACT-1', substr(CMDA, 15, 15), 0) %>% as.numeric(),
          R13 = ifelse(CMD == 'ACT-1', substr(CMDA, 16, 16), 0) %>% as.numeric(),
          R14 = ifelse(CMD == 'ACT-1', substr(CMDA, 5, 5), 0) %>% as.numeric(),
          R15 = ifelse(CMD == 'ACT-1', substr(CMDA, 6, 6), 0) %>% as.numeric(),
          R16 = ifelse(CMD == 'ACT-1', substr(CMDA, 7, 7), 0) %>% as.numeric(),
          R17 = ifelse(CMD == 'ACT-1', substr(CMDA, 8, 8), 0) %>% as.numeric(),
          
          C0 = ifelse(CMD %in% c('MWR', 'WR(16)', 'RD(16)', 'RD32'), substr(CMDA, 5, 5), 0) %>% as.numeric(),
          C1 = ifelse(CMD %in% c('MWR', 'WR(16)', 'WR32','RD(16)', 'RD32'), substr(CMDA, 14, 14), 0) %>% as.numeric(),
          C2 = ifelse(CMD %in% c('MWR', 'WR(16)', 'WR32','RD(16)', 'RD32'), substr(CMDA, 15, 15), 0) %>% as.numeric(),
          C3 = ifelse(CMD %in% c('MWR', 'WR(16)', 'WR32','RD(16)', 'RD32'), substr(CMDA, 6, 6), 0) %>% as.numeric(),
          C4 = ifelse(CMD %in% c('MWR', 'WR(16)', 'WR32','RD(16)', 'RD32'), substr(CMDA, 7, 7), 0) %>% as.numeric(),
          C5 = ifelse(CMD %in% c('MWR', 'WR(16)', 'WR32','RD(16)', 'RD32'), substr(CMDA, 8, 8), 0) %>% as.numeric(),
          
          DC0 = ifelse(CMD == 'CAS-DUM', substr(CMDA, 9, 9), 0) %>% as.numeric(),
          DC1 = ifelse(CMD == 'CAS-DUM', substr(CMDA, 10, 10), 0) %>% as.numeric(),
          DC2 = ifelse(CMD == 'CAS-DUM', substr(CMDA, 11, 11), 0) %>% as.numeric(),
          DC3 = ifelse(CMD == 'CAS-DUM', substr(CMDA, 12, 12), 0) %>% as.numeric(),
          
          WS_WR = ifelse(CMD == 'CAS-DUM', substr(CMDA, 6, 6), 0) %>% as.numeric(),
          WS_RD = ifelse(CMD == 'CAS-DUM', substr(CMDA, 7, 7), 0) %>% as.numeric(),
          WS_FS = ifelse(CMD == 'CAS-DUM', substr(CMDA, 8, 8), 0) %>% as.numeric(),
          WRX = ifelse(CMD == 'CAS-DUM', substr(CMDA, 14, 14), 0) %>% as.numeric(),
          WXSA = ifelse(CMD == 'CAS-DUM', substr(CMDA, 15, 15), 0) %>% as.numeric(),
          WXSB = ifelse(CMD == 'CAS-DUM', substr(CMDA, 16, 16), 0) %>% as.numeric(),
          
          OP0 = ifelse(CMD %in% c('MPC', 'MRW-2'), substr(CMDA, 10, 10), 0) %>% as.numeric(),
          OP1 = ifelse(CMD %in% c('MPC', 'MRW-2'), substr(CMDA, 11, 11), 0) %>% as.numeric(),
          OP2 = ifelse(CMD %in% c('MPC', 'MRW-2'), substr(CMDA, 12, 12), 0) %>% as.numeric(),
          OP3 = ifelse(CMD %in% c('MPC', 'MRW-2'), substr(CMDA, 13, 13), 0) %>% as.numeric(),
          OP4 = ifelse(CMD %in% c('MPC', 'MRW-2'), substr(CMDA, 14, 14), 0) %>% as.numeric(),
          OP5 = ifelse(CMD %in% c('MPC', 'MRW-2'), substr(CMDA, 15, 15), 0) %>% as.numeric(),
          OP6 = ifelse(CMD %in% c('MPC', 'MRW-2'), substr(CMDA, 16, 16), 0) %>% as.numeric(),
          OP7 = ifelse(CMD %in% c('MPC', 'MRW-2'), substr(CMDA, 8, 8), 0) %>% as.numeric(),
          
          MA0 = ifelse(CMD %in% c('MRW-1', 'MRR'), substr(CMDA, 10, 10), 0) %>% as.numeric(),
          MA1 = ifelse(CMD %in% c('MRW-1', 'MRR'), substr(CMDA, 11, 11), 0) %>% as.numeric(),
          MA2 = ifelse(CMD %in% c('MRW-1', 'MRR'), substr(CMDA, 12, 12), 0) %>% as.numeric(),
          MA3 = ifelse(CMD %in% c('MRW-1', 'MRR'), substr(CMDA, 13, 13), 0) %>% as.numeric(),
          MA4 = ifelse(CMD %in% c('MRW-1', 'MRR'), substr(CMDA, 14, 14), 0) %>% as.numeric(),
          MA5 = ifelse(CMD %in% c('MRW-1', 'MRR'), substr(CMDA, 15, 15), 0) %>% as.numeric(),
          MA6 = ifelse(CMD %in% c('MRW-1', 'MRR'), substr(CMDA, 16, 16), 0) %>% as.numeric(),
          
          # Final
          
          BANK = ifelse(CMD %in% c('ACT-1', 'MWR', 'WR(16)', 'WR32', 'RD(16)', 'RD32'), BA0 + BA1*2,
                        ifelse(paste0(CMD, AB) %in% c('PRE1', 'REF1'), 'ALL',
                               ifelse(paste0(CMD, AB) %in% c('PRE0', 'REF0'), BA0 + BA1*2, 0))),
          
          BANKG = ifelse(CMD %in% c('ACT-1', 'MWR', 'WR(16)', 'WR32', 'RD(16)', 'RD32'), BG0 + BG1*2,
                         ifelse(paste0(CMD, AB) %in% c('PRE1', 'REF1'), 'ALL',
                                ifelse(paste0(CMD, AB) == 'PRE0', BG0 + BG1*2,
                                       ifelse(paste0(CMD, AB) == 'REF0', BG0, 0)))),
          
          R = ifelse(CMD == 'ACT-1', (R11*2^11 + R12*2^12 + R13*2^13 + R14*2^14 + R15*2^15 + R16*2^16 + R17*2^17),
                     ifelse(CMD == 'ACT-2', (R0 + R1*2 + R2*2^2 + R3*2^3 + R4*2^4 + R5*2^5 + R6*2^6 + R7*2^7 + R8*2^8 + R9*2^9 + R10*2^10), 0)),
          C = ifelse(CMD %in% c('MWR', 'WR(16)', 'RD(16)', 'RD32'), (C0 + C1*2 + C2*2^2 + C3*2^3 + C4*2^4 + C5*2^5),
                     ifelse(CMD == 'WR32', (C1*2 + C2*2^2 + C3*2^3 + C4*2^4 + C5*2^5), 0)),
          
          BANK = ifelse(BANK == 0, 'A',
                        ifelse(BANK == 1, 'B',
                               ifelse(BANK == 2, 'C',
                                      ifelse(BANK == 3, 'D', 
                                             ifelse(BANK == 'ALL', 'ALL', '?'))))),
          
          BANK = ifelse(BANK == 'ALL', 'ALL', paste0(BANK, BANKG))
          
  )

# Statrs with First ACTIVE

dat <- dat[which(dat$CMD == 'ACT-1')[1]:nrow(dat), ]

# if cycle has only one unique CMDA, repeat it, else just join it

epic_fin <- dat %>% 
  group_by(CMD, cycle) %>% 
  tally %>% 
  arrange(cycle)

epic_addr <- dat %>% select(cycle, CMD, CMDA, BANK, R, C, AB, AP)
epic_fin <- epic_fin %>% inner_join(epic_addr, by = c('cycle', 'CMD'))
epic_fin$cycle <- epic_fin$cycle - min(epic_fin$cycle) + 1

rm(epic_addr)

# ADDR sum

epic_fin$cycle_a <- 1
for(i in 2:nrow(epic_fin)){epic_fin$cycle_a[i] <- ifelse(substr(epic_fin$CMD[i], 1, 3) == substr(epic_fin$CMD[i-1], 1, 3), epic_fin$cycle_a[i-1], epic_fin$cycle_a[i-1] + 1)}

epic_fin <- epic_fin %>% 
  select(-c(R, C, AB, AP)) %>% 
  inner_join(epic_fin %>%
               group_by(cycle_a) %>% 
               summarise(R = paste0('0x', dec2hex(sum(R / 4))),
                         C = ifelse(sum(C) == 0, '0x0', paste0('0x', dec2hex(sum(C / 4)), '0')),
                         AB = unique(AB),
                         AP = unique(AP)), by = 'cycle_a') %>% 

  mutate(R = ifelse(substr(CMD, 1, 2) %in% c('AC', 'WR', 'RD', 'MW'), R, NA),
         C = ifelse(substr(CMD, 1, 2) %in% c('AC', 'WR', 'RD', 'MW'), C, NA),
         BANK = ifelse(substr(CMD, 1, 2) %in% c('AC', 'WR', 'RD', 'MW', 'PR', 'RE'), BANK, NA))

act_1 <- epic_fin %>% filter(CMD == 'ACT-1') %>% select(CMD, R, C, BANK, AB, AP, cycle_a) %>% unique
act_2 <- epic_fin %>% filter(CMD == 'ACT-2') %>% select(CMD, R, C, BANK, AB, AP, cycle_a) %>% unique
wr_rd <- epic_fin %>% filter(substr(CMD, 1, 2) %in% c('WR', 'RD')) %>% select(CMD, R, C, BANK, AB, AP, cycle_a) %>% unique
pr_re <- epic_fin %>% filter(substr(CMD, 1, 2) %in% c('PR', 'RE')) %>% select(CMD, R, C, BANK, AB, AP, cycle_a) %>% unique

wr_rd$R <- act_1$R
act_2$BANK <- act_1$BANK

epic_fin <- epic_fin %>% 
  select(-c(BANK, R, C, AB, AP)) %>% 
  left_join(rbind(act_1, act_2, wr_rd, pr_re), by = c('CMD', 'cycle_a'))

epic_fin$DQ_E <- paste0('0x', substr(dat$DQ_E, 2, 6))
epic_fin$DQ_O <- paste0('0x', substr(dat$DQ_O, 2, 6))

rm(act_1, act_2, wr_rd, pr_re)


# 4. Advan Setting --------------------------------------------------------

advan <- fread('C:\\Users\\mano.hong\\Desktop\\T5511\\ADC.csv')
advan[advan == '-'] <- NA

advan <- advan %>% 
  mutate(C = ifelse(substr(CMD, 1, 2) == 'AC', '0x0', C))

advan$cycle <- 1
advan$cycle_a <- 1
for(i in 2:nrow(advan)){advan$cycle[i] <- ifelse(advan$CMD[i] == advan$CMD[i-1], advan$cycle[i-1], advan$cycle[i-1] + 1)}
for(i in 2:nrow(advan)){advan$cycle_a[i] <- ifelse(substr(advan$CMD[i], 1, 3) == substr(advan$CMD[i-1], 1, 3), advan$cycle_a[i-1], advan$cycle_a[i-1] + 1)}

advan <- advan %>% 
  select(-c(R, C, BANK)) %>% 
  left_join(advan %>%
              group_by(cycle_a) %>% 
              summarise(R = unique(R),
                        C = unique(C),
                        BANK = unique(BANK)) %>%
  filter(is.na(BANK) != T), by = 'cycle_a')

# Done --------------------------------------------------------------------

aa <- advan %>% group_by(cycle, CMD, R, C, BANK) %>% tally
ee <- epic_fin %>% group_by(cycle, CMD, R, C, BANK, CMDA) %>% tally

table(aa$CMD == ee$CMD)
table(aa$R == ee$R)
table(aa$C == ee$C)
table(aa$BANK == ee$BANK)
