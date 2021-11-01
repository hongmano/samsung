
# 1. Options / Packages ---------------------------------------------------

suppressMessages(library(dplyr))
suppressMessages(library(reshape2))
suppressMessages(library(readxl))
suppressMessages(library(dplyr))
suppressMessages(library(stringr))
suppressMessages(library(xlsx))

library(gdata)

TL1 <- c('K4F8E3D4HF', 'K4F4E3S4HF', 'K4F4E6S4HF', #NU
         'K4EBE304ED', 'K4E8E324ED', 'K4E6E304ED', #LC
         'K4UBE3S4AM', 'K4UCE3D4AM', #KR
         'K3LK2K20BM', 'K3LK4K40BM', #KL
         'K3KL3L30CM') #WH


# 2. V-Process -------------------------------------------------------------------


setwd('C:\\Users\\mano.hong\\Desktop\\RProject(WH)\\WH_status\\VP')

### V_P STATUS from DATAEXTRACTOR

vp_status <- read.csv('WH_VP_STATUS.csv')
vp_status <- vp_status[-1, ]
vp_status <- vp_status %>% 
  rename(V_PROCESS = VP_ID,
         STEP_NO_STATUS = VP_STEP) %>% 
  mutate(STEP_NO_STATUS = as.numeric(substr(STEP_NO_STATUS, 5, 6)))

### VP LIST FROM GPM(TP)

vp_up <- read_xlsx('VP.xlsx', sheet = 'VP_UP')
vp_up <- vp_up[, c(3, 4, 7, 17)] %>% 
  `colnames<-`(c('VP_COMMENT', 'V_PROCESS', 'NCP', 'NAME'))

vp_down <- read_xlsx('VP.xlsx', sheet = 'VP_DOWN')
vp_down <- vp_down[, c(3, 4, 8, 9)] %>% 
  `colnames<-`(c('V_PROCESS', 'STEP', 'STEP_NO', 'PGM_CODE')) %>% 
  mutate(PGM_CODE = ifelse(PGM_CODE == '-', '(-)', PGM_CODE),
         STEP = paste0(STEP, PGM_CODE)) %>% 
  select(-PGM_CODE)

### Join VP_STATUS With VP LIST

vp_fin <- vp_status %>% 
  left_join(vp_up %>% inner_join(vp_down)) %>% 
  filter(substr(PART_ID, 1, 10) %in% TL1) %>%
  filter(!substr(STEP, 1, 4) %in% c('T030', 'T045', 'T047')) %>%
  mutate(STATUS = ifelse(STEP_NO_STATUS > STEP_NO, '完',
                         ifelse(STEP_NO_STATUS < STEP_NO, '', STATUS))) %>% 
  unique()


vp_fin <- split(vp_fin, vp_fin$V_PROCESS)

for(i in 1:length(vp_fin)){
  
  name_order <- c('PJ_CODE', 'NAME', 'ERREQNO', 'VP_COMMENT', 'V_PROCESS', 'NCP', 'PART_ID', 'LOT_ID', 'QTY', 'HODECODE', vp_fin[[i]]$STEP)
  seolma <- vp_fin[[i]] %>% group_by(LOT_ID, STEP) %>% tally %>% ungroup() %>% select(n) %>% unique() %>% nrow()
  
  if(seolma > 1){
    
    vp_fin[[i]]$STEP <- paste0(vp_fin[[i]]$STEP, '_', vp_fin[[i]]$STEP_NO)
    name_order <- c('PJ_CODE', 'NAME', 'ERREQNO', 'VP_COMMENT', 'V_PROCESS', 'NCP', 'PART_ID', 'LOT_ID', 'QTY', 'HODECODE', vp_fin[[i]]$STEP)
    
  }
  
  vp_fin[[i]] <- dcast(vp_fin[[i]], PJ_CODE + NAME + ERREQNO + V_PROCESS + VP_COMMENT + NCP + PART_ID + LOT_ID + PART_ID + LOT_ID + QTY + HODECODE ~ STEP, value.var = 'STATUS') %>% 
    select(name_order) %>% 
    rename(HODECODE = HODECODE)
  
  if(sum(is.na(vp_fin[[i]]$ERREQNO)) == 1){
    
    name_order <- c('PJ_CODE', 'NAME', 'ERREQNO', 'PURPOSE', 'VP_COMMENT', 'V_PROCESS', 'NCP', 'PART_ID', 'LOT_ID', 'QTY', 'HODECODE', vp_fin[[i]]$STEP)
    
    vp_fin[[i]] <- vp_fin[[i]] %>% 
      left_join(NO) %>% 
      select(name_order)
    
    
  }
  
  names(vp_fin[[i]]) <- str_remove_all(names(vp_fin[[i]]), '_[0-9]+')
  
}


# 3. Write ----------------------------------------------------------------

today <- substr(Sys.time(), 1, 11)
wb <- createWorkbook()
sheet <- createSheet(wb, today)

currRow <- 1
for(i in 1:length(vp_fin)){
  
  cs <- CellStyle(wb) + 
    Font(wb, isBold = TRUE) + 
    Border(position = c("BOTTOM", "LEFT", "TOP", "RIGHT"))
  
  addDataFrame(vp_fin[[i]],
               sheet = sheet,
               startRow = currRow,
               row.names = FALSE,
               colnamesStyle = cs)
  
  currRow <- currRow + nrow(vp_fin[[i]]) + 2 
}

saveWorkbook(wb, file = "status.xlsx")
