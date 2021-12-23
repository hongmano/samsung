dat <- read.csv('C:/Users/mano.hong/Desktop/AUTOWORK/WHHH/fin.csv')

#### 1.

dat %>% 
  select(SG, paste0('V', 105:120)) %>% 
  `colnames<-`(c('SG', rep(paste0(rep(c('A', 'B', 'C', 'D'), 4), rep(0:3, each = 4))))) %>% 
  melt(id.vars = 'SG') %>% 
  ggplot(aes(x = variable,
             y = value,
             col = variable)) +
  geom_boxplot(outlier.shape = NA) +
  geom_jitter(alpha = .03) +
  theme_bw()+
  labs(x = 'Bank',
       y = 'Health Index',
       title = 'Health Index(가안)') +
  theme(legend.position = 'none')


##### 2.

test2 <- dat %>% 
  select(SG, paste0('V', 123:140)) %>% 
  `colnames<-`(c('SG', 
                 'GF_16', 'GF_18', 'GF_20',
                 'ST1_40', 'ST1_48', 'ST1_56',
                 'ST0_40', 'ST0_48', 'ST0_56',
                 'SBD_160', 'SBD_200', 'SBD_240',
                 'MB_40', 'MB_48', 'MB_56',
                 'C2_40', 'C2_48', 'C2_56')) %>% 
  melt(id.vars = 'SG') %>% 
  mutate(value = as.numeric(value),
         ITEM = str_split_fixed(variable, '_', 2)[, 1],
         condition = str_split_fixed(variable, '_', 2)[, 2],
         FBC = ifelse(value <= 5, paste0(value, 'bit'),
                        ifelse(value <= 10, '~ 10bit',
                               ifelse(value <= 100, '~ 100bit',
                                      ifelse(value <= 1000, '~ 1000bit', '1000bit ~'))))) %>%
  group_by(ITEM, condition, FBC) %>% 
  tally %>% 
  filter(FBC != '0bit') %>% 
  mutate(FBC = factor(FBC, levels = c(paste0(1:5, 'bit'), '~ 10bit', '~ 100bit', '~ 1000bit', '1000bit ~')))


table_join <- data.frame(ITEM = rep(rep(c('C2','GF', 'MB', 'SBD', 'ST0', 'ST1'), each = 3), 9),
                         condition = rep(c('40', '48', '56', '16', '18', '20', '40', '48', '56', '160', '200', '240', '40', '48', '56', '40', '48', '56'), 9),
                         FBC = rep(c(paste0(1:5, 'bit'), '~ 10bit', '~ 100bit', '~ 1000bit', '1000bit ~'), each = 18))
  
test2 <- table_join %>% 
  left_join(test2) %>% 
  mutate(n = ifelse(is.na(n) == T, 0, n))

test2 <- test2 %>% 
  inner_join(test2 %>% 
               group_by(ITEM, condition) %>% 
               summarise(sum = sum(n))) %>% 
  mutate(ratio = round(n / sum * 100, 2))

a <- split(test2, paste(test2$ITEM, test2$condition))

for(i in 1:length(a)){

  a[[i]] <- a[[i]] %>%
    mutate(FBC = factor(FBC, levels = c(paste0(1:5, 'bit'), '~ 10bit', '~ 100bit', '~ 1000bit', '1000bit ~'))) %>% 
    arrange(FBC) %>% 
    mutate(cumsum = cumsum(ratio))
  
}

test2 <- test2 %>% 
  inner_join(rbindlist(a))

test2 <- split(test2, test2$ITEM)

plot <- list()

for(i in 1:length(test2)){

  param <- max(test2[[i]]$n) / max(test2[[i]]$ratio)
  
  plot[[i]] <- test2[[i]] %>% 
    mutate(FBC = factor(FBC, levels = c(paste0(1:5, 'bit'), '~ 10bit', '~ 100bit', '~ 1000bit', '1000bit ~'))) %>% 
    ggplot(aes(x = FBC,
               y = n,
               fill = condition)) +
    geom_bar(stat = 'identity',
             width = .5,
             position = position_dodge(width = .7,
                                       preserve = 'single')) +
    geom_line(aes(y = cumsum * param, 
                  fill = condition,
                  col = condition,
                  group = condition),
              size = 1) +
    geom_point(aes(y = cumsum * param,
                   fill = condition,
                   col = condition)) +
    geom_text(aes(y = cumsum * param,
                  label = round(cumsum, 1)),
              position = 'dodge',
              vjust = -.5,
              check_overlap = T) +
    scale_y_continuous(sec.axis = sec_axis(~. / param)) +
    scale_fill_manual(values = c('skyblue', 'grey', 'blue')) +
    scale_color_manual(values = c('skyblue', 'grey', 'blue')) +
    labs(x = '',
         y = '',
         title = names(test2)[i]) +
    theme_bw()
  
  }


##### 3.

fprism <- list()
for(i in 1:30){

    fprism[[i]] <- dat %>% 
      select(SG, paste0('V', (252+(8*(i-1))+1):(252+(8*(i-1))+8))) %>% 
      `colnames<-`(c('SG', 'TN', 'prism', 'BANK', 'X_1', 'X_2', 'X_3', 'X-4', 'FBC')) %>% 
      filter(TN != '____') %>% 
      mutate(TN = as.numeric(TN)) %>% 
      inner_join(read.csv('C:/Users/mano.hong/Desktop/AUTOWORK/condition.csv'))
}

fprism <- rbindlist(fprism) 

fprism %>% 
  group_by(ITEM, condition2, prism) %>% 
  tally

zz <- fprism %>% 
  mutate(BANK = substr(BANK, 1, 2)) %>% 
  group_by(ITEM, condition2, prism) %>% 
  tally

zz <- split(zz, zz$ITEM)


