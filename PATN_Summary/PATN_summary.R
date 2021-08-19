# 1. Packages / Option ----------------------------------------------------

if(!suppressMessages(require(dplyr))){install.packages('dplyr')}; require(dplyr)
if(!suppressMessages(require(stringr))){install.packages('stringr')}; require(stringr)
if(!suppressMessages(require(data.table))){install.packages('data.table')}; require(data.table)
if(!suppressMessages(require(broman))){install.packages('broman')}; require(broman)

# 2. Data Loading ---------------------------------------------------------

setwd('C:\\Users\\mano.hong\\Desktop\\PROJECT\\21. 07. LP5 Command Converter')

patterns <- c('PDBS4FADC7D5ANN', 'PDBS4FADC7N5ANN', 'PDBS4FIPM7N5ANN', 'PDBS4FPBR7N5ANN')

for(i in 1:4){
  
  patn <- get_patn(patterns[i]) %>% 
    get_cmd() %>% 
    get_addr() %>% 
    arrange_addr()
  
  cmd_summary(patn)

}

# IDX LABEL PC UI CLKT WCKT RDQST DMI0 DMI1 CMD CMDA BANK R C DATA_e DATA_o AP

patn <- get_patn('PDBS4FADC7D5ANN') %>% 
  get_cmd() %>% 
  get_addr() %>% 
  arrange_addr()
