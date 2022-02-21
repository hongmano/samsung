
SRS <- function(dat, NRT, DP){
  
  dat <- dat %>% filter(HB != 8)
  
  NRT1 <- dat[, NRT]
  
  SRS <- dat %>% 
    filter(HB != 8) %>% 
    select(run, wf, x, y) %>% 
    mutate(NRT_L = ifelse(NRT1 == 0, 0, 1),
           pkg = sample(1:nrow(dat)) %/% DP) %>% 
    group_by(pkg) %>% 
    summarise(NRT_L = max(NRT_L),
              .groups = 'drop') %>% 
    
    ungroup() %>% 
    unique()
  
  SRS <- round((1 - sum(SRS$NRT_L) / nrow(SRS)) * 100, 2)
  
  return(SRS)
  
}

runRS <- function(dat, NRT, DP){
  
  runRS <- split(dat, dat$run)
  
  for(run in 1:length(runRS)){
    
    runRS[[run]] <- runRS[[run]] %>% filter(HB != 8)
    
    NRT1 <- runRS[[run]][, NRT]
    pkg <- sample(1:nrow(runRS[[run]])) %/% DP
    
    runRS[[run]] <- runRS[[run]] %>% 
      filter(HB != 8) %>% 
      select(run, wf, x, y) %>% 
      mutate(NRT_L = ifelse(NRT1 == 0, 0, 1),
             pkg = pkg) %>% 
      group_by(pkg) %>% 
      summarise(NRT_L = max(NRT_L),
                .groups = 'drop') %>% 
      
      ungroup() %>% 
      unique()
    
  }
  
  runRS <- rbindlist(runRS)
  runRS <- round((1 - sum(runRS$NRT_L) / nrow(runRS)) * 100, 2)
  
  return(runRS)
  
}

wfRS <- function(dat, NRT, DP){
  
  wfRS <- split(dat, dat$wf)
  
  for(wf in 1:length(wfRS)){
    
    wfRS[[wf]] <- wfRS[[wf]] %>% filter(HB != 8)
    NRT1 <- wfRS[[wf]][, NRT]
    pkg <- sample(1:nrow(wfRS[[wf]])) %/% DP
    
    wfRS[[wf]] <- wfRS[[wf]] %>% 
      filter(HB != 8) %>% 
      select(run, wf, x, y) %>% 
      mutate(NRT_L = ifelse(NRT1 == 0, 0, 1),
             pkg = pkg) %>% 
      group_by(pkg) %>% 
      summarise(NRT_L = max(NRT_L),
                .groups = 'drop') %>% 
      
      ungroup() %>% 
      unique()
    
  }
  
  wfRS <- rbindlist(wfRS)
  wfRS <- round((1 - sum(wfRS$NRT_L) / nrow(wfRS)) * 100, 2)
  
  return(wfRS)
  
}

simulation <- function(dat, NRT, iter, DP){
  
  dat <- dat %>% filter(HB != 8)
  
  prime <- dat %>% filter(test == 0 & HB == 2)
  retest <- dat %>% filter(test == 1)
  dat <- rbind(prime, retest)
  
  NRT1 <- dat[, NRT]
  SRS_YLD <- list()
  runRS_YLD <- list()
  wfRS_YLD <- list()
  
  for(i in 1:iter){
    
    set.seed(i)
    
    SRS_YLD[[i]] <- SRS(dat, NRT, DP)
    runRS_YLD[[i]] <- runRS(dat, NRT, DP)
    wfRS_YLD[[i]] <- wfRS(dat, NRT, DP)
    
  }
  
  SRS_YLD <- SRS_YLD %>% unlist
  runRS_YLD <- runRS_YLD %>% unlist
  wfRS_YLD <- wfRS_YLD %>% unlist
  
  SRS_mean <- SRS_YLD %>% mean
  runRS_mean <- runRS_YLD %>% mean
  wfRS_mean <- wfRS_YLD %>% mean
  
  SRS_std <- SRS_YLD %>% var %>% sqrt / sqrt(iter) * 1.96
  runRS_std <- runRS_YLD %>% var %>% sqrt / sqrt(iter) * 1.96
  wfRS_std <- wfRS_YLD %>% var %>% sqrt / sqrt(iter) * 1.96
  
  fin <- data.frame(type = c('SRS', 'runRS', 'wfRS'),
                    lower = c(round(SRS_mean - SRS_std, 2),
                              round(runRS_mean - runRS_std, 2),
                              round(wfRS_mean - wfRS_std, 2)),
                    upper = c(round(SRS_mean + SRS_std, 2),
                              round(runRS_mean + runRS_std, 2),
                              round(wfRS_mean + wfRS_std, 2)),
                    n_pkg = nrow(dat) / DP)
  
  return(fin)  
  
}


# -------------------------------------------------------------------------

setwd('C:/Users/mano.hong/Desktop/RProject(WH)/22. 02. WH PRA 물량 조립안 별 Simulation')
folders <- list.files()
result <- list()

for(folder in 1:length(folders)){
  
  setwd('C:/Users/mano.hong/Desktop/RProject(WH)/22. 02. WH PRA 물량 조립안 별 Simulation')
  setwd(paste0('./', folders[folder]))
  
  step <- str_split_fixed(folders[folder], '_', 3)[1]
  info <- substr(folders[folder], 6, 100)
  
  dat <- read.csv('fin.csv')
  result[[folder]] <- simulation(dat = dat, NRT = 5, iter = 10000, DP = 4) %>% 
    mutate(step = step,
           info = info)
  
  print(info)
  
  
}
