# 1. Packages / Option ----------------------------------------------------

if(!suppressMessages(require(dplyr))){install.packages('dplyr')}; require(dplyr)
if(!suppressMessages(require(stringr))){install.packages('stringr')}; require(stringr)
if(!suppressMessages(require(data.table))){install.packages('data.table')}; require(data.table)
if(!suppressMessages(require(broman))){install.packages('broman')}; require(broman)

# 2. Data Loading ---------------------------------------------------------

setwd('C:\\Users\\mano.hong\\Desktop\\PROJECT\\21. 07. LP5 Command Converter')

patterns <- c('PDBS4FADC7D5ANN', 'PDBS4FADC7N5ANN', 'PDBS4FIPM7N5ANN', 'PDBS4FPBR7N5ANN')

patn <- get_patn('PDBS4FIPM7N5ANN') %>% 
  get_cmd() %>% 
  get_addr() %>% 
  arrange_addr()

# IDX LABEL PC UI CLKT WCKT RDQST DMI0 DMI1 CMD CMDA BANK R C DATA_e DATA_o AP

epic_fin <- patn$epic %>% group_by(CMD, BANK, R, C, cycle) %>% tally %>% arrange(cycle) %>% select(-c(cycle, n))
advan_fin <- patn$advan %>% group_by(CMD, BANK, R, C, cycle) %>% tally %>% arrange(cycle) %>% select(-c(cycle, n))

table(epic_fin$CMD == advan_fin$CMD)
table(epic_fin$BANK == advan_fin$BANK)
table(epic_fin$C == advan_fin$C)
table(epic_fin$R == advan_fin$R)
