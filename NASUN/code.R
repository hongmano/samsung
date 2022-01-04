
# 1. Options / Packages ---------------------------------------------------

library(dplyr)
library(xlsx)
library(ggplot2)
library(data.table)
setwd('C:/Users/mano.hong/Desktop/RProject(WH)/21. 11. WH-ver Full ³ª¼±Çü Pick-up °ËÁõ')

# 2. Data Loading ---------------------------------------------------------

#### WH GUBAE

coord <- read.csv('WH_coord.csv') %>% 
  select(x, y, zone, edge) %>% 
  unique


#### WH PVR

PVR <- read.csv('all.csv') %>% 
  rename(wf = WAFER_ID,
         x = WAFER_LOC_XPOS,
         y = WAFER_LOC_YPOS) %>% 
  left_join(coord)


# 3. Wrangling ------------------------------------------------------------

PVR_list <- split(PVR, paste(PVR$RUN_ID, PVR$wf))
for(i in 1:length(PVR_list)){
  
  pkg <- PVR_list[[i]] %>% 
    group_by(FRAME_ID, FRAME_LOC_XPOS, FRAME_LOC_YPOS) %>% 
    tally %>% 
    select(-n)
  pkg$pkg <- 1:nrow(pkg)
  
  PVR_list[[i]] <- PVR_list[[i]] %>% 
    left_join(pkg)
  
}

fin <- rbindlist(PVR_list) %>%  
  select(LOT_ID, RUN_ID, wf, x, y, EQP_HEADER, pkg, zone, edge) %>% 
  filter(EQP_HEADER != "0")


min_max <- fin %>% 
  group_by(pkg) %>% 
  summarise(max = max(edge),
            min = min(edge))

# 4. Plotting -------------------------------------------------------------

xmax <- max(fin$x, na.rm = T)
xmin <- min(fin$x, na.rm = T)
ymax <- max(fin$y, na.rm = T)
ymin <- min(fin$y, na.rm = T)

# plot

setwd('./Plots')
fin_list <- split(fin, paste(fin$RUN_ID, fin$wf, sep = '_'))

for(i in 1:length(fin_list)){
  
  ggplot(fin_list[[i]],
         aes(x, y)) +
    
    coord_cartesian(xlim = c(xmin, xmax), 
                    ylim = c(ymin, ymax)) +
    
    scale_x_continuous(breaks = seq(xmin, xmax)) +
    scale_y_continuous(breaks = seq(ymin, ymax))+
    
    geom_tile(aes(fill = factor(pkg),
                  size = 40),
              color = 'black') +
    geom_text(aes(label = pkg,
                  size = 60,
                  angle = 90),
              col = 'black') +
    facet_wrap(~ paste(RUN_ID, wf, sep = '_')) +
    
    
    theme_bw() +
    theme(
      panel.background = element_rect(fill = 'white', color = 'white'),
      panel.grid.major = element_line(color = 'white'),
      panel.grid.minor = element_line(color = 'white'),
      legend.position = 'none',
      axis.text.x = element_blank(),
      axis.text.y = element_blank(),
      strip.text.x = element_text(size = 30)
    ) 
  
  ggsave(paste0(names(fin_list)[i], '.jpg'), scale = 3)
  
}

