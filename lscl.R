
# 1. Packages / Option ----------------------------------------------------

if(!require(ggplot2)){install.packages('ggplot2')}; require(ggplot2)
if(!require(dplyr)){install.packages('dplyr')}; require(dplyr)
if(!require(stringr)){install.packages('stringr')}; require(stringr)
if(!require(data.table)){install.packages('data.table')}; require(data.table)
if(!require(reshape2)){install.packages('reshape2')}; require(reshape2)
if(!require(BMS)){install.packages('BMS')}; require(BMS)
if(!require(readxl)){install.packages('readxl')}; require(readxl)
setwd('C:\\Users\\mano.hong\\Desktop\\lscl')
source('utils.R')

# 2. My LOT ---------------------------------------------------------

mylot <- commandArgs()
mylotname <- mylot[6] # LOT ID
MSR_tPD <- as.integer(mylot[7]) # tPD Location

print(mylotname)
print(MSR_tPD)

setwd(paste0('C:\\Users\\mano.hong\\Desktop\\lscl\\', mylotname))

test_n <- list.files() %>% length()
test_n <- test_n - 1

dat <- data_load(test_n) # Data Loading
cols <- colnames(dat)
cols[MSR_tPD] <- 'tPD'
colnames(dat) <- cols

dat$tPD <- as.numeric(dat$tPD)
dat <- dat %>% filter(tPD != 0)

dat$tPD_R <- round(dat$tPD, 0)
dat$NB_L <- ifelse(dat$NB == 0, 0, 1)
  
write.csv(dat, paste0(mylotname, '_final.csv'), row.names = F)

# 3. Plotting ------------------------------------------------------------


# 3-1. tPDYLD -------------------------------------------------------------


tPD <- dat %>%
  group_by(tPD_R) %>%
  summarise(YLD = 1 - mean(NB_L),
            n = n()) %>% 
  filter(tPD_R >= 50)

param <- max(tPD$n) / max(tPD$YLD)

plot_tPD <- tPD %>% ggplot(aes(x = tPD_R)) +
  geom_bar(aes(y = n),
           stat = 'identity') +
  geom_line(aes(y = YLD*param, group = 1),
            size = 1) +
  geom_point(aes(y = YLD*param)) +
  scale_y_continuous(sec.axis = sec_axis(~./param)) +
  theme_bw()

ggsave(paste0(mylotname, '_tPDYLD.png'))
print('##################### tPD 저장 완료 ######################')


# 3-2. NB -----------------------------------------------------------------

plot_NB <- dat %>%
  mutate(NB = factor(NB)) %>% 
  filter(NB_L != 0) %>% 
  group_by(NB) %>% 
  tally() %>% 
  head(10) %>% 
  ggplot(aes(x = reorder(NB, -n),
             y = n)) + 
  geom_col() +
  xlab('NG BIN') + 
  theme_bw()

ggsave(paste0(mylotname, '_NB.png'))
print('##################### NB 저장 완료 ######################')


# 3-3. by RUN -------------------------------------------------------------

byRUN <- dat %>% 
  group_by(run) %>% 
  summarise(n = n(),
            YLD = (1-mean(NB_L))*100,
            tPD = mean(tPD))

param <- max(byRUN$n) / max(byRUN$YLD)
param2 <- max(byRUN$n) / max(byRUN$tPD)

plot_byRUN <- ggplot(byRUN,
                     aes(x = reorder(run, -n))) + 
  geom_bar(aes(y = n), 
           stat = 'identity') +
  geom_line(aes(y = YLD*param, group = 1),
            size = 1) +
  geom_point(aes(y = YLD*param)) +
  scale_y_continuous(sec.axis = sec_axis(~./param)) +
  geom_line(aes(y = tPD*param, group = 1),
            size = 1,
            col = 'red') +
  scale_y_continuous(sec.axis = sec_axis(~./param2)) +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 90, 
                                   hjust = 1),
        axis.title.x = element_blank())

ggsave(paste0(mylotname, '_RUN.png'))
print('##################### by RUN 저장 완료 ######################')

# 3-4. Wafer Map ----------------------------------------------------------

WFmap <- dat %>% 
  group_by(run) %>% 
  summarise(n = n(),
            YLD = 1 - mean(NB_L)) %>% 
  filter(n > 199) %>% 
  arrange(YLD)

min_RUN <- WFmap$run[1]

WFmap <- dat %>% 
  filter(run == min_RUN) %>% 
  group_by(x, y, wf) %>% 
  summarise(NB = NB_L)

xmax <- max(WFmap$x)
xmin <- min(WFmap$x)
ymax <- max(WFmap$y)
ymin <- min(WFmap$y)

# plot

ggplot(WFmap,
       aes(x, y)) +
  
  coord_cartesian(xlim = c(xmin, xmax), 
                  ylim = c(ymin, ymax)) +
  
  scale_x_continuous(breaks = seq(xmin, xmax)) +
  scale_y_continuous(breaks = seq(ymin, ymax))+
  
  geom_tile(aes(fill = NB))+
  
  theme_bw() +
  theme(
    panel.background = element_rect(fill= 'white', color = 'white'),
    panel.grid.major = element_line(color='#E0E0E0'),
    panel.grid.minor = element_line(color='#E0E0E0'),
    legend.position = 'none',
    axis.text.x = element_blank(),
    axis.text.y = element_blank()
    ) +
  
  facet_wrap(~ wf) +
  ggtitle('Wafer Map') +
  scale_fill_gradientn(colors = c('skyblue', 'red'))

ggsave(paste0(mylotname, '_WFMAP.png'))
print('##################### WFMAP 저장 완료 ######################')


# 3-5. Wafer Map (tPD) ----------------------------------------------------

WFmap_tPD <- dat %>% 
  group_by(x, y) %>% 
  summarise(tPD = min(tPD))

xmax <- max(WFmap$x)
xmin <- min(WFmap$x)
ymax <- max(WFmap$y)
ymin <- min(WFmap$y)

# plot

ggplot(WFmap_tPD,
       aes(x, y)) +
  
  coord_cartesian(xlim = c(xmin, xmax), 
                  ylim = c(ymin, ymax)) +
  
  scale_x_continuous(breaks = seq(xmin, xmax)) +
  scale_y_continuous(breaks = seq(ymin, ymax))+
  
  geom_tile(aes(fill = tPD))+
  
  theme_bw() +
  theme(
    panel.background = element_rect(fill= 'white', color = 'white'),
    panel.grid.major = element_line(color='#E0E0E0'),
    panel.grid.minor = element_line(color='#E0E0E0'),
    axis.text.x = element_blank(),
    axis.text.y = element_blank()
  ) +
  
  ggtitle('Wafer Map') +
  scale_fill_gradientn(colors = c('skyblue', 'red'))

ggsave(paste0(mylotname, '_WFMAP(tPD).png'))
print('##################### WFMAP_tPD 저장 완료 ######################')
