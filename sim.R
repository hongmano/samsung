
SRS <- function(dat, NRT, DP){
  
  SRS <- dat %>% 
    filter(HB != 8) %>% 
    mutate(NB = ifelse(HB %in% 5:8 & NB != 0, 1, 0),
           pkg = sample(1:nrow(dat)) %/% DP) %>% 
    group_by(pkg) %>% 
    summarise(NB = max(NB),
              .groups = 'drop') %>% 
    
    ungroup() %>% 
    unique()
  
  SRS <- round((1 - sum(SRS$NB) / nrow(SRS)) * 100, 2)
  
  return(SRS)
  
}

runRS <- function(dat, NRT, DP){
  
  runRS <- split(dat, dat$run)
  
  for(run in 1:length(runRS)){
    
    pkg <- sample(1:nrow(runRS[[run]])) %/% DP
    
    runRS[[run]] <- runRS[[run]] %>%
      mutate(NB = ifelse(HB %in% 5:8 & NB != 0, 1, 0),
             pkg = pkg) %>% 
      group_by(pkg) %>% 
      summarise(NB = max(NB),
                .groups = 'drop') %>% 
      
      ungroup() %>% 
      unique()
    
  }
  
  runRS <- rbindlist(runRS)
  runRS <- round((1 - sum(runRS$NB) / nrow(runRS)) * 100, 2)
  
  return(runRS)
  
}

wfRS <- function(dat, NRT, DP){
  
  wfRS <- split(dat, paste0(dat$run, '_', dat$wf))
  
  for(wf in 1:length(wfRS)){
    
    pkg <- sample(1:nrow(wfRS[[wf]])) %/% DP
    
    wfRS[[wf]] <- wfRS[[wf]] %>% 
      filter(HB != 8) %>% 
      mutate(NB = ifelse(HB %in% 5:8 & NB != 0, 1, 0),
             pkg = pkg) %>% 
      group_by(pkg) %>% 
      summarise(NB = max(NB),
                .groups = 'drop') %>% 
      
      ungroup() %>% 
      unique()
    
  }
  
  wfRS <- rbindlist(wfRS)
  wfRS <- round((1 - sum(wfRS$NB) / nrow(wfRS)) * 100, 2)
  
  return(wfRS)
  
}

simulation <- function(dat, NRT, iter, DP){
  
  dat <- dat %>% filter(HB != 8)
  
  if(max(dat$test) == 1){
    
    prime <- dat %>% filter(test == 0 & HB %in% 1:4)
    retest <- dat %>% filter(test == 1)
    dat <- rbind(prime, retest)
    
    }else if(max(dat$test) == 2){
      
      prime <- dat %>% filter(test == 0 & HB %in% 1:4)
      retest <- dat %>% filter(test == 1 & HB %in% 1:4)
      retest2 <- dat %>% filter(test == 2)
      dat <- rbind(prime, retest, retest2)
      
    }else{
      
      stop('What The Fuck with max(test) ????')
      
    }
  
  

  SRS_YLD <- list()
  runRS_YLD <- list()
  wfRS_YLD <- list()
  
  for(i in 1:iter){
    
    set.seed(i)
    SRS_YLD[[i]] <- SRS(dat, NRT, DP)
    
    set.seed(i)
    runRS_YLD[[i]] <- runRS(dat, NRT, DP)
    
    set.seed(i)
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

setwd('C:\\Users\\mano.hong\\Desktop\\RProject(WH)\\22. 02. WH PRA 물량 조립안 별 Simulation\\LF')
folders <- list.files()
result <- list()

for(folder in 1:length(folders)){
  
  setwd('C:\\Users\\mano.hong\\Desktop\\RProject(WH)\\22. 02. WH PRA 물량 조립안 별 Simulation\\LF')
  setwd(paste0('./', folders[folder]))
  
  step <- str_split_fixed(folders[folder], '_', 3)[1]
  info <- substr(folders[folder], 6, 100)
  
  dat <- fread('fin.csv')
  result[[folder]] <- simulation(dat = dat, iter = 2, DP = 4) %>% 
    mutate(step = step,
           info = info)
  
  print(info)
  
}

result
