dat <- read.csv('C:/Users/Mano/Desktop/z.csv')

SRS <- function(dat, NRT, DP){
  
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

simulation <- function(dat, NRT, DP){

  NRT1 <- dat[, NRT]
  SRS_YLD <- list()
  runRS_YLD <- list()
  wfRS_YLD <- list()
  
  for(i in 1:10){
    
    set.seed(i)
    
    SRS_YLD[[i]] <- SRS(dat, NRT, DP)
    runRS_YLD[[i]] <- runRS(dat, NRT, DP)
    wfRS_YLD[[i]] <- wfRS(dat, NRT, DP)
    
  }

  SRS_YLD <- SRS_YLD %>% unlist
  runRS_YLD <- runRS_YLD %>% unlist
  wfRS_YLD <- wfRS_YLD %>% unlist
  
  fin <- list(SRS = SRS_YLD,
              runRS = runRS_YLD,
              wfRS = wfRS_YLD)
  
  return(fin)  
  
}

result <- simulation(dat, 14, 4)
result
