# 1. Packages / Option ----------------------------------------------------

if(!suppressMessages(require(dplyr))){install.packages('dplyr')}; require(dplyr)
if(!suppressMessages(require(stringr))){install.packages('stringr')}; require(stringr)
if(!suppressMessages(require(data.table))){install.packages('data.table')}; require(data.table)
if(!suppressMessages(require(broman))){install.packages('broman')}; require(broman)

# 2. Data Loading ---------------------------------------------------------


setwd('C:\\Users\\mano.hong\\Desktop\\PROJECT\\21. 07. LP5 Command Converter')

patterns <- list.files()
patterns <- patterns[str_which(patterns, 'txt')]
patterns <- substr(patterns, 1, 15) %>% as.data.frame() %>% `colnames<-`('patn_name')
patterns <- patterns %>% group_by(patn_name) %>% tally %>% filter(n == 2) %>% select(patn_name)

# 1. Patn Loading ---------------------------------------------------------

get_patn <- function(patn_name){
  
  files <- list.files()
  files <- files[str_detect(files, c('.txt'))]
  files <- files[str_detect(files, c(patn_name))]
  
  
  variable_names <- c('IDX', 'LABEL', 'PC', 'UI', 'CLKT', 'CS0', 'CS1', 'CA', 'WCKT', 'RDQST', 'DMI0', 'DMI1', 'DATA_e', 'DATA_o')
  
  patn_list <- list(epic = read.table(files[str_detect(files, c('epic'))], header = T) %>%
                      `colnames<-`(variable_names),
                    advan = read.table(files[str_detect(files, c('t5511'))], header = T) %>%
                      `colnames<-`(variable_names))
  
  return(patn_list)
  
}

# 2. Get Command ----------------------------------------------------------

get_cmd <- function(patn_list){

    cmd <- function(patn){
      
      patn <- patn %>%
        mutate(CMDA = substr(paste0(CS0, CA), 1, 8),
               cycle = 1,
               cycle_precharge = 1)
      
      # Bind Rising CMDA and Falling CMDA
      
      row_odd <- seq_len(nrow(patn)) %% 4
      
      patn_odd <- patn[row_odd %in% c(1, 2), ]$CMDA
      patn_even <- patn[row_odd %in% c(0, 3), ]$CMDA
      CMDA <- paste0(patn_odd, patn_even)
      patn$CMDA <- rep(CMDA, each = 2)
      
      # Make CMD from CMDA
      
      patn <- patn %>% 
        mutate(
          
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
                                                                                                    ifelse(substr(CMDA, 1, 8) == '10011100', 'CAS-WR',
                                                                                                           ifelse(substr(CMDA, 1, 8) == '10011010', 'CAS-RD',
                                                                                                                  ifelse(substr(CMDA, 1, 8) == '10011001', 'CAS-FS',
                                                                                                                         ifelse(substr(CMDA, 1, 8) == '10011000', 'CAS-DUM',
                                                                                                                                ifelse(substr(CMDA, 1, 7) == '1000011', 'MPC',
                                                                                                                                       ifelse(substr(CMDA, 1, 8) == '10001011', 'SRE',
                                                                                                                                              ifelse(substr(CMDA, 1, 8) == '10001010', 'SRX',
                                                                                                                                                     ifelse(substr(CMDA, 1, 8) == '10001101', 'MRW-1',
                                                                                                                                                            ifelse(substr(CMDA, 1, 7) == '1000100', 'MRW-2',
                                                                                                                                                                   ifelse(substr(CMDA, 1, 8) == '10001100', 'MRR',
                                                                                                                                                                          ifelse(substr(CMDA, 1, 8) == '10000011', 'WFF',
                                                                                                                                                                                 ifelse(substr(CMDA, 1, 8) == '10000010', 'RFF',
                                                                                                                                                                                        ifelse(substr(CMDA, 1, 8) == '10000101', 'RDC', '?'))))))))))))))))))))))))))
      
      
      start <- min(str_which(patn$CMD, 'ACT-1'))
      patn <- patn[start:nrow(patn), ]
      
      # Cycle Increase
      
      for(i in 2:nrow(patn)){
        
        patn$cycle[i] <- ifelse(patn$CMD[i] == patn$CMD[i-1], patn$cycle[i-1], patn$cycle[i-1] + 1)
        patn$cycle_precharge[i] <- ifelse(patn$CMD[i] == 'PRE', patn$cycle_precharge[i-1] + 1, patn$cycle_precharge[i-1])
        
      }
      
      return(patn)
    
    }
    
    patn_list <- lapply(patn_list, cmd)
    return(patn_list)

}



# 3. Get ADDR -------------------------------------------------------------


get_addr <- function(patn_list){
  
  addr <- function(patn){
    
    
    patn <- patn %>%
      
      mutate(
        
        # Bank ADDR
        
        BA0 = ifelse(CMD %in% c('ACT-1', 'PRE', 'REF', 'MWR', 'WR(16)', 'WR32', 'RD(16)', 'RD32'), substr(CMDA, 10, 10), NA) %>% as.numeric(),
        BA1 = ifelse(CMD %in% c('ACT-1', 'PRE', 'REF', 'MWR', 'WR(16)', 'WR32', 'RD(16)', 'RD32'), substr(CMDA, 11, 11), NA) %>% as.numeric(),
        BA2 = ifelse(CMD %in% c('ACT-1', 'PRE', 'REF', 'MWR', 'WR(16)', 'WR32', 'RD(16)', 'RD32'), substr(CMDA, 12, 12), NA) %>% as.numeric(),
        BA3 = ifelse(CMD %in% c('ACT-1', 'PRE', 'MWR', 'WR(16)', 'WR32', 'RD(16)', 'RD32'), substr(CMDA, 13, 13), 0) %>% as.numeric(),
        
        # Bank Group
        
        BG0 = ifelse(CMD %in% c('ACT-1', 'PRE', 'REF', 'MWR', 'WR(16)', 'WR32', 'RD(16)', 'RD32'), substr(CMDA, 12, 12), NA) %>% as.numeric(),
        BG1 = ifelse(CMD %in% c('ACT-1', 'PRE', 'MWR', 'WR(16)', 'WR32', 'RD(16)', 'RD32'), substr(CMDA, 13, 13), NA) %>% as.numeric(),
        
        # Precharge All Bank / Auto Precharge
        
        AB = ifelse(CMD %in% c('PRE', 'REF'), substr(CMDA, 16, 16), NA) %>% as.numeric(),
        AP = ifelse(CMD %in% c('MWR', 'WR(16)', 'WR32', 'RD(16)', 'RD32'), substr(CMDA, 16, 16), NA) %>% as.numeric(),
        
        # ACT Row ADDR
        
        R0 = ifelse(substr(CMD, 1, 3) == 'ACT', substr(CMDA, 10, 10), NA) %>% as.numeric(),
        R1 = ifelse(substr(CMD, 1, 3) == 'ACT', substr(CMDA, 11, 11), NA) %>% as.numeric(),
        R2 = ifelse(substr(CMD, 1, 3) == 'ACT', substr(CMDA, 12, 12), NA) %>% as.numeric(),
        R3 = ifelse(substr(CMD, 1, 3) == 'ACT', substr(CMDA, 13, 13), NA) %>% as.numeric(),
        R4 = ifelse(substr(CMD, 1, 3) == 'ACT', substr(CMDA, 14, 14), NA) %>% as.numeric(),
        R5 = ifelse(substr(CMD, 1, 3) == 'ACT', substr(CMDA, 15, 15), NA) %>% as.numeric(),
        R6 = ifelse(substr(CMD, 1, 3) == 'ACT', substr(CMDA, 16, 16), NA) %>% as.numeric(),
        R7 = ifelse(substr(CMD, 1, 3) == 'ACT', substr(CMDA, 5, 5), NA) %>% as.numeric(),
        R8 = ifelse(substr(CMD, 1, 3) == 'ACT', substr(CMDA, 6, 6), NA) %>% as.numeric(),
        R9 = ifelse(substr(CMD, 1, 3) == 'ACT', substr(CMDA, 7, 7), NA) %>% as.numeric(),
        R10 = ifelse(substr(CMD, 1, 3) == 'ACT', substr(CMDA, 8, 8), NA) %>% as.numeric(),
        
        R11 = ifelse(substr(CMD, 1, 3) == 'ACT', substr(CMDA, 14, 14), NA) %>% as.numeric(),
        R12 = ifelse(substr(CMD, 1, 3) == 'ACT', substr(CMDA, 15, 15), NA) %>% as.numeric(),
        R13 = ifelse(substr(CMD, 1, 3) == 'ACT', substr(CMDA, 16, 16), NA) %>% as.numeric(),
        R14 = ifelse(substr(CMD, 1, 3) == 'ACT', substr(CMDA, 5, 5), NA) %>% as.numeric(),
        R15 = ifelse(substr(CMD, 1, 3) == 'ACT', substr(CMDA, 6, 6), NA) %>% as.numeric(),
        R16 = ifelse(substr(CMD, 1, 3) == 'ACT', substr(CMDA, 7, 7), NA) %>% as.numeric(),
        R17 = ifelse(substr(CMD, 1, 3) == 'ACT', substr(CMDA, 8, 8), NA) %>% as.numeric(),
        
        # RD / WR Col ADDR
        
        C0 = ifelse(CMD %in% c('MWR', 'WR(16)', 'RD(16)', 'RD32'), substr(CMDA, 5, 5), NA) %>% as.numeric(),
        C1 = ifelse(CMD %in% c('MWR', 'WR(16)', 'WR32','RD(16)', 'RD32'), substr(CMDA, 14, 14), NA) %>% as.numeric(),
        C2 = ifelse(CMD %in% c('MWR', 'WR(16)', 'WR32','RD(16)', 'RD32'), substr(CMDA, 15, 15), NA) %>% as.numeric(),
        C3 = ifelse(CMD %in% c('MWR', 'WR(16)', 'WR32','RD(16)', 'RD32'), substr(CMDA, 6, 6), NA) %>% as.numeric(),
        C4 = ifelse(CMD %in% c('MWR', 'WR(16)', 'WR32','RD(16)', 'RD32'), substr(CMDA, 7, 7), NA) %>% as.numeric(),
        C5 = ifelse(CMD %in% c('MWR', 'WR(16)', 'WR32','RD(16)', 'RD32'), substr(CMDA, 8, 8), NA) %>% as.numeric(),
        
        # Only 8B RD32 B4
        
        # B4 = ifelse(CMD == 'RD32', substr(CMDA, 13, 13), 0) %>% as.numeric(),
        
        # CAS 
        
        DC0 = ifelse(CMD == 'CAS-DUM', substr(CMDA, 9, 9), NA) %>% as.numeric(),
        DC1 = ifelse(CMD == 'CAS-DUM', substr(CMDA, 10, 10), NA) %>% as.numeric(),
        DC2 = ifelse(CMD == 'CAS-DUM', substr(CMDA, 11, 11), NA) %>% as.numeric(),
        DC3 = ifelse(CMD == 'CAS-DUM', substr(CMDA, 12, 12), NA) %>% as.numeric(),
        
        WS_WR = ifelse(CMD == 'CAS-DUM', substr(CMDA, 6, 6), NA) %>% as.numeric(),
        WS_RD = ifelse(CMD == 'CAS-DUM', substr(CMDA, 7, 7), NA) %>% as.numeric(),
        WS_FS = ifelse(CMD == 'CAS-DUM', substr(CMDA, 8, 8), NA) %>% as.numeric(),
        WRX = ifelse(CMD == 'CAS-DUM', substr(CMDA, 14, 14), NA) %>% as.numeric(),
        WXSA = ifelse(CMD == 'CAS-DUM', substr(CMDA, 15, 15), NA) %>% as.numeric(),
        WXSB_B3 = ifelse(CMD == 'CAS-DUM', substr(CMDA, 16, 16), NA) %>% as.numeric(),
        
        
        # MPC / MRW / MRR
        
        OP0 = ifelse(CMD %in% c('MPC', 'MRW-2'), substr(CMDA, 10, 10), NA) %>% as.numeric(),
        OP1 = ifelse(CMD %in% c('MPC', 'MRW-2'), substr(CMDA, 11, 11), NA) %>% as.numeric(),
        OP2 = ifelse(CMD %in% c('MPC', 'MRW-2'), substr(CMDA, 12, 12), NA) %>% as.numeric(),
        OP3 = ifelse(CMD %in% c('MPC', 'MRW-2'), substr(CMDA, 13, 13), NA) %>% as.numeric(),
        OP4 = ifelse(CMD %in% c('MPC', 'MRW-2'), substr(CMDA, 14, 14), NA) %>% as.numeric(),
        OP5 = ifelse(CMD %in% c('MPC', 'MRW-2'), substr(CMDA, 15, 15), NA) %>% as.numeric(),
        OP6 = ifelse(CMD %in% c('MPC', 'MRW-2'), substr(CMDA, 16, 16), NA) %>% as.numeric(),
        OP7 = ifelse(CMD %in% c('MPC', 'MRW-2'), substr(CMDA, 8, 8), NA) %>% as.numeric(),
        
        MA0 = ifelse(CMD %in% c('MRW-1', 'MRR'), substr(CMDA, 10, 10), NA) %>% as.numeric(),
        MA1 = ifelse(CMD %in% c('MRW-1', 'MRR'), substr(CMDA, 11, 11), NA) %>% as.numeric(),
        MA2 = ifelse(CMD %in% c('MRW-1', 'MRR'), substr(CMDA, 12, 12), NA) %>% as.numeric(),
        MA3 = ifelse(CMD %in% c('MRW-1', 'MRR'), substr(CMDA, 13, 13), NA) %>% as.numeric(),
        MA4 = ifelse(CMD %in% c('MRW-1', 'MRR'), substr(CMDA, 14, 14), NA) %>% as.numeric(),
        MA5 = ifelse(CMD %in% c('MRW-1', 'MRR'), substr(CMDA, 15, 15), NA) %>% as.numeric(),
        MA6 = ifelse(CMD %in% c('MRW-1', 'MRR'), substr(CMDA, 16, 16), NA) %>% as.numeric(),
        
        # Final
        
        BANK = ifelse(CMD %in% c('ACT-1', 'MWR', 'WR(16)', 'WR32', 'RD(16)', 'RD32'), BA0 + BA1*2,
                      ifelse(paste0(CMD, AB) %in% c('PRE1', 'REF1'), 'ALL',
                             ifelse(paste0(CMD, AB) %in% c('PRE0', 'REF0'), BA0 + BA1*2, NA))),
        
        BANKG = ifelse(CMD %in% c('ACT-1', 'MWR', 'WR(16)', 'WR32', 'RD(16)', 'RD32'), BG0 + BG1*2,
                       ifelse(paste0(CMD, AB) %in% c('PRE1', 'REF1'), 'ALL',
                              ifelse(paste0(CMD, AB) == 'PRE0', BG0 + BG1*2,
                                     ifelse(paste0(CMD, AB) == 'REF0', BG0, NA)))),
        
        R = ifelse(CMD == 'ACT-1', (R11*2^11 + R12*2^12 + R13*2^13 + R14*2^14 + R15*2^15 + R16*2^16 + R17*2^17),
                   ifelse(CMD == 'ACT-2', (R0 + R1*2 + R2*2^2 + R3*2^3 + R4*2^4 + R5*2^5 + R6*2^6 + R7*2^7 + R8*2^8 + R9*2^9 + R10*2^10), NA)),
        C = ifelse(CMD %in% c('MWR', 'WR(16)', 'RD(16)', 'RD32'), (C0 + C1*2 + C2*2^2 + C3*2^3 + C4*2^4 + C5*2^5),
                   ifelse(CMD == 'WR32', (C1*2 + C2*2^2 + C3*2^3 + C4*2^4 + C5*2^5), NA)),
        
        BANK = ifelse(BANK == 0, 'A',
                      ifelse(BANK == 1, 'B',
                             ifelse(BANK == 2, 'C',
                                    ifelse(BANK == 3, 'D',
                                           ifelse(BANK == 'ALL', 'ALL', NA))))),
        
        # DEC2HEX
        
        R = ifelse(is.na(R) == F, paste0('0x', dec2hex(R)), NA),
        C = ifelse(is.na(C) == F, paste0('0x', dec2hex(C)), NA),
        DATA_e = ifelse(is.na(DATA_e) == F, paste0('0x', dec2hex(DATA_e), NA), NA)
        DATA_o = ifelse(is.na(DATA_o) == F, paste0('0x', dec2hex(DATA_o), NA), NA)
        
        BANK = ifelse(BANK == 'ALL', 'ALL', paste0(BANK, BANKG)))
    
    return(patn)
    
  }
  
  patn_list <- lapply(patn_list, addr)
  
  return(patn_list)
  
}


# 4. Arrange ADDR ---------------------------------------------------------

arrange_addr <- function(patn_list){
  
  addr <- function(patn){
    
    # ACTIVE
    
    act1 <- patn %>% filter(CMD == 'ACT-1')
    act2 <- patn %>% filter(CMD == 'ACT-2')
    
    act1$R <- act2$R
    act2$BANK <- act1$BANK
    
    act <- rbind(act1, act2) %>% select(CMD, BANK, R, C, cycle, cycle_precharge) %>% unique
    
    # WR / RD
    
    wr_rd <- patn %>%
      filter(CMD %in% c('RD(16)', 'RD32', 'WR(16)', 'WR32', 'MWR')) %>%
      select(CMD, BANK, C, cycle, cycle_precharge) 
    
    wr_rd <- wr_rd %>%
      inner_join(act %>% select(BANK, R, cycle_precharge)) %>%
      unique
    
    # Final
    
    fin <- rbind(act, wr_rd)
    
    patn <- patn %>%
      select(-c(BANK, R, C)) %>%
      left_join(fin)
    
    return(patn)
    
  }
  
  patn_list <- lapply(patn_list, addr)
  
  
}


# 4. Summary --------------------------------------------------------------

cmd_summary <- function(patn_list){
  
  result <- list()
  
  cmd <- function(patn){
    
    fin <- patn %>% group_by(CMD, BANK, R, C, cycle) %>% tally %>% arrange(cycle)
    
    return(fin)
    
  }
  
  result <- lapply(patn_list, cmd)
  
  return(result)
  
}

# 4. ----------------------------------------------------------------------

result <- list()
result <- get_patn(patterns$patn_name) %>% 
  get_cmd %>% 
  get_addr %>% 
  arrange_addr


# IDX LABEL PC UI CLKT WCKT RDQST DMI0 DMI1 CMD CMDA BANK R C DATA_e DATA_o AP

# tRAS : Active Restore Time(ACT ~ PRE)
# tRCD : ACT ~ RD/WR Delay Time
# tRP : PRC ~ Next ACT Time
# tRDL(tWR) : Last Data In ~ PCR Time
# tRC : ACT ~ Next ACT(tRAS + tRP)
# tRFC : REF ~ ACT/REF Time
# tFAW : Four Bank Activation window
# tRRD : ACT ~ Another Bank ACT Time

a <- cmd_summary(result)

a$epic %>% nrow
a$advan %>% nrow

table(a$epic$CMD == a$advan$CMD)
table(a$epic$C == a$advan$C)
table(a$epic$R == a$advan$R)
table(a$epic$BANK == a$advan$BANK)

test <- result$epic %>% select(CMD, DATA_e, DATA_o)
