
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
                                                                                                                                                                                           ifelse(substr(CMDA, 1, 8) == '10000101', 'RDC', '?')))))))))))))))))))))))))) %>%
      mutate(cycle = 1,
             cycle_precharge = 1)

    # Equalize Falling CMD with Rising CMD

    for(i in 1:(nrow(patn)/4)){patn$CMD[(i*4-1):(i*4)] <- patn$CMD[(i*4-3):(i*4-2)]}

    # Cycle Increase

    for(i in 2:nrow(patn)){

      patn$cycle[i] <- ifelse(patn$CMD[i] == patn$CMD[i-1], patn$cycle[i-1], patn$cycle[i-1] + 1)
      patn$cycle_precharge[i] <- ifelse(patn$CMD[i] == 'PRE', patn$cycle_precharge[i-1] + 1, patn$cycle_precharge[i-1])

      }

    # Bind Rising CMDA and Falling CMDA

    test <- patn %>% select(cycle, CMDA) %>% unique
    test <- split(test, test$cycle)
    for(i in 1:length(test)){test[[i]]$CMDA <- ifelse(nrow(test[[i]]) == 1, paste0(test[[i]]$CMDA[1], test[[i]]$CMDA[1]), paste0(test[[i]]$CMDA[1], test[[i]]$CMDA[2]))}
    test <- rbindlist(test) %>% unique
    patn <- patn %>% select(-CMDA) %>% inner_join(test)

    start <- min(str_which(patn$CMD, 'ACT-1'))
    patn <- patn[start:nrow(patn), ]

    return(patn)

  }

  patn_list <- lapply(patn_list, cmd)

}


# 3. Get ADDR -------------------------------------------------------------

get_addr <- function(patn_list){

  addr <- function(patn){

    patn <- patn %>%
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
              WXSB_B3 = ifelse(CMD == 'CAS-DUM', substr(CMDA, 16, 16), 0) %>% as.numeric(),

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
              C = ifelse(CMD %in% c('MWR', 'WR(16)', 'WR32', 'RD(16)', 'RD32'), (C0 + C1*2 + C2*2^2 + C3*2^3 + C4*2^4 + C5*2^5),
                         ifelse(CMD == 'WR32', (C1*2 + C2*2^2 + C3*2^3 + C4*2^4 + C5*2^5), 0)),

              BANK = ifelse(BANK == 0, 'A',
                            ifelse(BANK == 1, 'B',
                                   ifelse(BANK == 2, 'C',
                                          ifelse(BANK == 3, 'D',
                                                 ifelse(BANK == 'ALL', 'ALL', '?'))))),

              # DEC2HEX

              R = paste0('0x', dec2hex(R)),
              C = paste0('0x', dec2hex(C)),
              DATA_e = paste0('0x', dec2hex(DATA_e)),
              DATA_o = paste0('0x', dec2hex(DATA_o)),


              BANK = ifelse(BANK == 'ALL', 'ALL', paste0(BANK, BANKG)))

    return(patn)

  }

  patn_list <- lapply(patn_list, addr)

  return(patn_list)

}


# 4. Arrange ADDR + CAS ---------------------------------------------------------

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
      select(CMD, BANK, C, cycle, cycle_precharge) %>%
      inner_join(act %>% select(BANK, R, cycle_precharge)) %>%
      unique

    # PRE / REF

    pre_ref <- patn %>%
      filter(CMD %in% c('PRE', 'REF')) %>%
      select(CMD, BANK, R, C, cycle, cycle_precharge)

    # Final

    fin <- rbind(act, wr_rd, pre_ref)

    patn <- patn %>%
      select(-c(BANK, R, C)) %>%
      left_join(fin)

    return(patn)

  }

  patn_list <- lapply(patn_list, addr)


}

cas_dummy <- function(patn_list){

  cas <- function(patn){
    
    patn <- patn$epic
    cas <- patn %>% filter(CMD %in% c('CAS-DUM', 'RD(16)', 'RD32', 'WR(16)', 'WR32'))
    
    
  }
  
  
}

# 5. Summary --------------------------------------------------------------

cmd_summary <- function(patn_list){

  cmd <- function(patn){

    patn <- patn %>% group_by(CMD, BANK, R, C, cycle) %>% tally %>% arrange(cycle) %>% select(-c(cycle, n))

    return(patn)

  }

  cmd_addr <- lapply(patn_list, cmd)
  cmd <- length(names(table(cmd_addr$epic$CMD == cmd_addr$advan$CMD)))
  bank <- length(names(table(cmd_addr$epic$BANK == cmd_addr$advan$BANK)))
  r <- length(names(table(cmd_addr$epic$R == cmd_addr$advan$R)))
  c <- length(names(table(cmd_addr$epic$C == cmd_addr$advan$C)))

  if(cmd != 1){print('###### CMD INCORRECT ######')}
  if(bank != 1){print('###### CMD INCORRECT ######')}
  if(r != 1){print('###### CMD INCORRECT ######')}
  if(c != 1){print('###### CMD INCORRECT ######')}


}
