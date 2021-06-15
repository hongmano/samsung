df <- data.frame(
  
  DU = rep(c(1:128, 2:128, 1:128, 3:128), 100),
  NB = 1
  
)

df$NB[1:700] <- 6
df$cycle <- 1
df$site <- ifelse(df$DU %in% 1:32, 1,
                  ifelse(df$DU %in% 33:64, 2,
                         ifelse(df$DU %in% 65:96, 3, 4)))

for(i in 2:nrow(df)){
  
  df$cycle[i] <- ifelse(df$DU[i] < df$DU[i-1], df$cycle[i-1] + 1, df$cycle[i-1])
  
}

df$DU <- factor(df$DU)
df$cycle <- factor(df$cycle)
  
ggplot(df %>% filter(site == 1), aes(x = DU, y = cycle)) +
  geom_tile(aes(fill = NB), 
            show.legend = T,
            na.rm = F) +
  labs(title = 'DUTMAP',
       y = "cycle") +
  scale_x_discrete(position = "top") +
  scale_y_discrete(limits = (levels(df$cycle))) + 
  scale_fill_gradient(low = 'skyblue', high = 'red') +
  theme_bw()
