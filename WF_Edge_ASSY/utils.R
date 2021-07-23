EDGE_ASSY <- function(dat, DP){
  
  n1 <- nrow(dat) %/% DP
  n2 <- nrow(dat) %% DP
  
  if(n1 == 0){
    
    pkg <- paste('etc', dat$edge, sep = '_')
    dat$pkg <- pkg
    
  }else{
    
    pkg <- c(rep(paste(paste0(dat$run, '-', dat$wf), dat$edge, 1:n1, sep = '_') %>% unique, each = DP), rep(paste('etc', dat$edge, sep = '_') %>% unique, n2))
    dat$pkg <- pkg
    
  }
  
  return(dat)
  
}

ETC_ASSY1 <- function(dat, DP){
  
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

ETC_ASSY2 <- function(dat, DP){
  
  n1 <- nrow(dat) %/% DP
  n2 <- nrow(dat) %% DP
  
  if(n1 == 0){
    
    pkg <- paste('etc', dat$edge, sep = '_')
    dat$pkg <- pkg
    
  }else{
    
    pkg <- c(rep(paste('etc2', dat$edge, 1:n1, sep = '_') %>% unique, each = DP), rep(paste('etc', dat$edge, sep = '_') %>% unique, n2))
    dat$pkg <- pkg
    
  }
  
  return(dat)
  
}

result1 <- function(dat, way, DP){
  
  dat <- split(dat, dat$edge)
  
  if(way == 'edge'){
    
    dat <- lapply(dat, function(x){EDGE_ASSY(x, DP)}) %>% rbindlist()
  
  }
  
  return(dat)
  
}

result2 <- function(dat, way, DP){

  fin <- lapply(dat, function(x){result1(x, way, DP)}) %>% rbindlist()
  
  etc <- fin %>% filter(substr(pkg, 1, 3) == 'etc')
  etc <- split(etc, etc$edge)
  etc <- lapply(etc, function(x){ETC_ASSY1(x, DP)}) %>% rbindlist()
  
  fin <- fin %>% filter(substr(pkg, 1, 3) != 'etc') %>% rbind(etc)

  return(fin)
}
  
get_result <- function(dat, way, DP){
  
  fin <- lapply(dat, function(x){result2(x, way, DP)}) %>% rbindlist()
  
  etc <- fin %>% filter(substr(pkg, 1, 3) == 'etc')
  etc <- split(etc, etc$edge)
  etc <- lapply(etc, function(x){ETC_ASSY2(x, DP)}) %>% rbindlist()
  
  fin <- fin %>% filter(substr(pkg, 1, 3) != 'etc') %>% rbind(etc)
  
  return(fin)
  
}
