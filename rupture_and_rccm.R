
# 1. Options / Packages ---------------------------------------------------

library(dplyr)
library(data.table)

# 2. Data Loading ---------------------------------------------------------


dat <- read.csv('C:/Users/Mano/Desktop/answer.csv') %>% 
  mutate(code = substr(code, 2, 200))

eds <- dat %>% filter(type == 'EDS_FUSE')
pkg <- dat %>% filter(type == 'PKG_FUSE')

ex <- 'FAMAPRCCM =         ; IFS =     ;  FUSE_RUP = "   "; FUSE_DESC = "                               "; RCCMRD(1);'


# 3. EDS ------------------------------------------------------------------


eds_list <- list()
eds_list[[1]] <- data.frame(code = '//EDS')

for(i in 1:nrow(eds)){
  
  c <- ex
  
  substr(c, 13, 20) <- eds$code[i]
  substr(c, 29, 32) <- as.character(eds$ifs[i])
  substr(c, 48, 50) <- ifelse(eds$fusing[i] == 'EDS', 'OOO', 'XXX')
  substr(c, 67, 66+nchar(eds$name[i])) <- eds$name[i]
  
  eds_list[[i+1]] <- data.frame(code = c)
  
}

eds_fin <- rbindlist(eds_list)

# write.csv(rbindlist(eds_list), row.names = F, quote = F)

# 4. PKG ------------------------------------------------------------------

pkg_list <- list()
pkg_list[[1]] <- data.frame(code = '//PKG')

for(i in 1:nrow(pkg)){
  
  c <- ex
  
  substr(c, 13, 20) <- pkg$code[i]
  substr(c, 29, 32) <- as.character(pkg$ifs[i])
  substr(c, 48, 50) <- ifelse(pkg$fusing[i] == 'PKG', 'OOO', 'XXX')
  substr(c, 67, 66+nchar(pkg$name[i])) <- pkg$name[i]
  
  pkg_list[[i+1]] <- data.frame(code = c)
  
}

pkg_fin <- rbindlist(pkg_list)

# write.csv(rbindlist(pkg_list), row.names = F, quote = F)


# 5. fin ------------------------------------------------------------------

fin <- rbind(eds_fin, pkg_fin)
write.csv(fin, 'RCCM_RUPTURE_CODE.csv', 
          row.names = F, 
          quote = F)
