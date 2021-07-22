EDGE_ASSY <- function(dat, DP){

  n1 <- nrow(dat) %/% DP
  n2 <- nrow(dat) %% DP
  
  if(n1 == 0){
    
    pkg <- paste('etc', dat$edge, sep = '_')
    dat$pkg <- pkg
    
  }else{
    
    pkg <- c(rep(paste(dat$run, dat$wf, dat$edge, 1:n1, sep = '_') %>% unique, each = DP), rep(paste('etc', dat$edge, sep = '_') %>% unique, n2))
    dat$pkg <- pkg
    
    }
    
  return(dat)

}

ETC_ASSY <- function(dat, DP){
  
  n1 <- nrow(dat) %/% DP
  n2 <- nrow(dat) %% DP
  
  if(n1 == 0){
    
    pkg <- paste('etc', dat$edge, sep = '_')
    dat$pkg <- pkg
    
  }else{
    
    pkg <- c(rep(paste('etc', dat$edge, 1:n1, sep = '_') %>% unique, each = DP), rep(paste('etc', dat$edge, sep = '_') %>% unique, n2))
    dat$pkg <- pkg
    
  }
  
  return(dat)
  
}

get_result <- function(dat, way, DP){
  
  test <- list()
  
  if(way == 'random'){
    
    for(i in 1:length(dat)){
      
      test[[i]] <- lapply(dat[[i]], function(x){EDGE_ASSY(x, DP)}) %>% rbindlist
      
    }
    
  }else if(way == 'edge'){
    
    for(i in 1:length(dat)){
      
      test[[i]] <- lapply(dat[[i]], function(x){EDGE_ASSY(x, DP)}) %>% rbindlist
      
    }
    
  }
  
  test <- rbindlist(test)
  
  # etc <- test %>% filter(substr(pkg, 1, 3) == 'etc')
  # etc <- split(etc, substr(etc$pkg, 5, 100))
  # etc <- lapply(etc, function(x){ETC_ASSY(x, 4)}) %>% rbindlist
  # 
  # fin <- rbind(test %>% filter(substr(pkg, 1, 3) != 'etc'), etc)

  return(test)
   
}
