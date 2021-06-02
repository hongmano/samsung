
# 1. Packages / Option ----------------------------------------------------

if(!require(ggplot2)){install.packages('ggplot2')}; require(ggplot2)
if(!require(gridExtra)){install.packages('gridExtra')}; require(gridExtra)
if(!require(dplyr)){install.packages('dplyr')}; require(dplyr)
if(!require(data.table)){install.packages('data.table')}; require(data.table)

# 2. Data Loading ---------------------------------------------------------

### G1

G1_AU2 <- fread('C:\\Users\\mano.hong\\Desktop\\trend\\G1_T091AU2\\fin.csv') %>% filter(HB != 8)
G1_128 <- fread('C:\\Users\\mano.hong\\Desktop\\trend\\G1_T091128\\fin.csv') %>% filter(HB == 3) %>% 
  filter(SG %in% G1_AU2$SG) %>% unique

G1_AU2 <- G1_AU2 %>% filter(SG %in% G1_128$SG)

G1_fin <- G1_128 %>% inner_join(G1_AU2, by = 'SG')


### G2

G2_AU2 <- fread('C:\\Users\\mano.hong\\Desktop\\trend\\G2_T091AU2\\fin.csv') %>% filter(HB != 8) %>% unique

G2_128 <- list()
G2_128[[1]] <- fread('C:\\Users\\mano.hong\\Desktop\\trend\\G2_T091128_1\\fin.csv') %>% filter(HB == 3)
G2_128[[3]] <- fread('C:\\Users\\mano.hong\\Desktop\\trend\\G2_T091128_3\\fin.csv') %>% filter(HB == 3)
G2_128[[4]] <- fread('C:\\Users\\mano.hong\\Desktop\\trend\\G2_T091128_4\\fin.csv') %>% filter(HB == 3)
G2_128 <- rbindlist(G2_128) %>% filter(SG %in% G2_AU2$SG) %>% unique

G2_AU2 <- G2_AU2 %>% filter(SG %in% G2_128$SG)

# 3. Visualization --------------------------------------------------------

G1_fin <- G1_128 %>% inner_join(G1_AU2, by = 'SG')
G2_fin <- G2_128 %>% inner_join(G2_AU2, by = 'SG')

### G2 ----

grid.arrange(
  
  # # IDD0
  # 
  # ggplot(G2_fin) +
  #   geom_point(aes(x = MSR21.y,
  #                  y = MSR21.x),
  #              col = 'blue',
  #              size = 1.5.5) +
  #   labs(x = "85'C Rework",
  #        y = "105'C",
  #        title = 'IDD0') + 
  #   geom_hline(yintercept = 53,
  #              linetype = 'dotted',
  #              size = 1.5) +
  #   geom_hline(yintercept = 50,
  #              linetype = 'dotted',
  #              size = 1.5,
  #              col = 'red') +
  #   geom_vline(xintercept = 50.5,
  #              linetype = 'dotted',
  #              size = 1.5,
  #              col = 'red') +
  #   theme_bw() +
  #   theme(axis.text.x = element_text(size = 10),
  #         axis.text.y = element_text(size = 10)),
  
  # IDD2P
  
  ggplot(G2_fin) +
    geom_point(aes(x = MSR22.y,
                   y = MSR22.x),
               col = 'blue',
               size = 1.5) +
    labs(x = "85'C Rework",
         y = "105'C",
         title = 'IDD2P') + 
    geom_hline(yintercept = 5,
               size = 1.5,
               col = 'red') +
    geom_hline(yintercept = 3.4,
               size = 1.5,
               col = 'black') +
    geom_hline(yintercept = 3.2,
               size = 1.5,
               col = 'green') +
    geom_vline(xintercept = 2.5,
               size = 1.5,
               col = 'red') +
    theme_bw() +
    theme(axis.text.x = element_text(size = 10),
          axis.text.y = element_text(size = 10)),

  # IDD2PS

   ggplot(G2_fin) +
     geom_point(aes(x = MSR23.y,
                    y = MSR23.x),
                col = 'blue',
                size = 1.5) +
     labs(x = "85'C Rework",
          y = "105'C",
          title = 'IDD2PS') +
     geom_hline(yintercept = 5,
                size = 1.5,
                col = 'red') +
     geom_hline(yintercept = 3.4,
                size = 1.5,
                col = 'black') +
    geom_hline(yintercept = 3.2,
               size = 1.5,
               col = 'green') +
     geom_vline(xintercept = 2.5,
                size = 1.5,
                col = 'red') +
     theme_bw() +
     theme(axis.text.x = element_text(size = 10),
           axis.text.y = element_text(size = 10)),
  
  # IDD2N
  
  ggplot(G2_fin) +
    geom_point(aes(x = MSR24.y,
                   y = MSR24.x),
               col = 'blue',
               size = 1.5) +
    labs(x = "85'C Rework",
         y = "105'C",
         title = 'IDD2N') + 
    geom_hline(yintercept = 23,
               size = 1.5,
               col = 'red') +
    geom_hline(yintercept = 21,
               size = 1.5,
               col = 'black') +
    geom_hline(yintercept = 19.5,
               size = 1.5,
               col = 'green') +
    geom_vline(xintercept = 18.5,
               size = 1.5,
               col = 'red') +
    theme_bw() +
    theme(axis.text.x = element_text(size = 10),
          axis.text.y = element_text(size = 10)),
  
  # IDD2NS
  
  ggplot(G2_fin) +
    geom_point(aes(x = MSR25.y,
                   y = MSR25.x),
               col = 'blue',
               size = 1.5) +
    labs(x = "85'C Rework",
         y = "105'C",
         title = 'IDD2NS') + 
    geom_hline(yintercept = 18,
               size = 1.5,
               col = 'red') +
    geom_hline(yintercept = 15.5,
               size = 1.5,
               col = 'black') +
    geom_vline(xintercept = 13.5,
               size = 1.5,
               col = 'red') +
    theme_bw() +
    theme(axis.text.x = element_text(size = 10),
          axis.text.y = element_text(size = 10)),
  
  # IDD3P
  
  ggplot(G2_fin) +
    geom_point(aes(x = MSR26.y,
                   y = MSR26.x),
               col = 'blue',
               size = 1.5) +
    labs(x = "85'C Rework",
         y = "105'C",
         title = 'IDD3P') + 
    geom_hline(yintercept = 13.5,
               size = 1.5,
               col = 'red') +
    geom_hline(yintercept = 10.5,
               size = 1.5,
               col = 'black') +
    geom_hline(yintercept = 9.5,
               size = 1.5,
               col = 'green') +
    geom_vline(xintercept = 7.5,
               size = 1.5,
               col = 'red') +
    theme_bw() +
    theme(axis.text.x = element_text(size = 10),
          axis.text.y = element_text(size = 10)),
  
  # IDD3PS
  
  ggplot(G2_fin) +
    geom_point(aes(x = MSR27.y,
                   y = MSR27.x),
               col = 'blue',
               size = 1.5) +
    labs(x = "85'C Rework",
         y = "105'C",
         title = 'IDD3PS') + 
    geom_hline(yintercept = 13.5,
               size = 1.5,
               col = 'red') +
    geom_hline(yintercept = 10.5,
               size = 1.5,
               col = 'black') +
      geom_hline(yintercept = 9.5,
                 size = 1.5,
                 col = 'green') + 
    geom_vline(xintercept = 7.5,
               size = 1.5,
               col = 'red') +
    theme_bw() +
    theme(axis.text.x = element_text(size = 10),
          axis.text.y = element_text(size = 10)),
  
  # IDD3N
  
  ggplot(G2_fin) +
    geom_point(aes(x = MSR28.y,
                   y = MSR28.x),
               col = 'blue',
               size = 1.5) +
    labs(x = "85'C Rework",
         y = "105'C",
         title = 'IDD3N') + 
    geom_hline(yintercept = 26,
               size = 1.5,
               col = 'red') +
    geom_hline(yintercept = 23.2,
               size = 1.5,
               col = 'black') +
      geom_hline(yintercept = 22.5,
                 size = 1.5,
                 col = 'green') +
    geom_vline(xintercept = 20.5,
               size = 1.5,
               col = 'red') +
    theme_bw() +
    theme(axis.text.x = element_text(size = 10),
          axis.text.y = element_text(size = 10)),
  
  # IDD3NS
  
  ggplot(G2_fin) +
    geom_point(aes(x = MSR29.y,
                   y = MSR29.x),
               col = 'blue',
               size = 1.5) +
    labs(x = "85'C Rework",
         y = "105'C",
         title = 'IDD3NS') + 
    geom_hline(yintercept = 21,
               size = 1.5,
               col = 'red') +
    geom_hline(yintercept = 18.7,
               size = 1.5,
               col = 'black') +
    geom_vline(xintercept = 15.5,
               size = 1.5,
               col = 'red') +
    theme_bw() +
    theme(axis.text.x = element_text(size = 10),
          axis.text.y = element_text(size = 10)),
  
  nrow =  2
  
  
  
)



### G1 ----

G1_fin <- G1_fin %>% filter(PART.x == 'K4F8E3D4HF-GUCJ000-EYF7UP')
grid.arrange(
  
  # IDD0
  
  # ggplot(G1_fin) +
  #   geom_point(aes(x = MSR21.y,
  #                  y = MSR21.x),
  #              col = 'blue',
  #              size = 3) +
  #   labs(x = "85'C Rework",
  #        y = "125'C",
  #        title = 'IDD0') + 
  #   geom_hline(yintercept = 56,
  #              linetype = 'dotted',
  #              size = 1.5) +
  #   geom_hline(yintercept = 50,
  #              linetype = 'dotted',
  #              size = 1.5,
  #              col = 'red') +
  #   geom_vline(xintercept = 53,
  #              linetype = 'dotted',
  #              size = 1.5,
  #              col = 'red') +
  #   theme_bw() +
  #   theme(axis.text.x = element_text(size = 10),
  #         axis.text.y = element_text(size = 10)),
  
  # IDD2P
  
  ggplot(G1_fin) +
    geom_point(aes(x = MSR22.y,
                   y = MSR22.x),
               col = 'blue',
               size = 3) +
    labs(x = "85'C Rework",
         y = "125'C",
         title = 'IDD2P') + 
    geom_hline(yintercept = 12,
               size = 1.5,
               col = 'red') +
    geom_hline(yintercept = 9.6,
               size = 1.5,
               col = 'black') +
    # geom_hline(yintercept = 6.4,
    #            size = 1.5,
    #            col = 'green') +
    geom_vline(xintercept = 5,
               size = 1.5,
               col = 'red') +
    theme_bw() +
    theme(axis.text.x = element_text(size = 10),
          axis.text.y = element_text(size = 10)),
  
  # IDD2PS
  
   ggplot(G1_fin) +
     geom_point(aes(x = MSR23.y,
                    y = MSR23.x),
                col = 'blue',
                size = 3) +
     labs(x = "85'C Rework",
          y = "125'C",
          title = 'IDD2PS') + 
     geom_hline(yintercept = 12,
                size = 1.5,
                col = 'red') +
     geom_hline(yintercept = 9.6,
                size = 1.5,
                col = 'black') +
    # geom_hline(yintercept = 6.4,
    #            size = 1.5,
    #            col = 'green') +
     geom_vline(xintercept = 5,
                size = 1.5,
                col = 'red') +
     theme_bw() +
     theme(axis.text.x = element_text(size = 10),
           axis.text.y = element_text(size = 10)),
  
  # IDD2N
  
  ggplot(G1_fin) +
    geom_point(aes(x = MSR24.y,
                   y = MSR24.x),
               col = 'blue',
               size = 3) +
    labs(x = "85'C Rework",
         y = "125'C",
         title = 'IDD2N') + 
    geom_hline(yintercept = 30,
               size = 1.5,
               col = 'red') +
    geom_hline(yintercept = 30,
               size = 1.5,
               col = 'red') +
    geom_hline(yintercept = 40,
               size = 1.5,
               col = 'green') +
    geom_vline(xintercept = 21,
               size = 1.5,
               col = 'red') +
    theme_bw() +
    theme(axis.text.x = element_text(size = 10),
          axis.text.y = element_text(size = 10)),
  
  # IDD2NS
  
  ggplot(G1_fin) +
    geom_point(aes(x = MSR25.y,
                   y = MSR25.x),
               col = 'blue',
               size = 3) +
    labs(x = "85'C Rework",
         y = "125'C",
         title = 'IDD2NS') + 
    geom_hline(yintercept = 24.5,
               size = 1.5,
               col = 'red') +
    geom_hline(yintercept = 24.5,
               size = 1.5,
               col = 'red') +
    geom_hline(yintercept = 30,
               size = 1.5,
               col = 'green') +
    geom_vline(xintercept = 16,
               size = 1.5,
               col = 'red') +
    theme_bw() +
    theme(axis.text.x = element_text(size = 10),
          axis.text.y = element_text(size = 10)),
  
  # IDD3P
  
  ggplot(G1_fin) +
    geom_point(aes(x = MSR26.y,
                   y = MSR26.x),
               col = 'blue',
               size = 3) +
    labs(x = "85'C Rework",
         y = "125'C",
         title = 'IDD3P') + 
    geom_hline(yintercept = 23,
               size = 1.5,
               col = 'red') +
    geom_hline(yintercept = 23,
               size = 1.5,
               col = 'red') +
    geom_hline(yintercept = 20,
               size = 1.5,
               col = 'green') +
    geom_vline(xintercept = 10,
               size = 1.5,
               col = 'red') +
    theme_bw() +
    theme(axis.text.x = element_text(size = 10),
          axis.text.y = element_text(size = 10)),
  
  # IDD3PS
  
  ggplot(G1_fin) +
    geom_point(aes(x = MSR27.y,
                   y = MSR27.x),
               col = 'blue',
               size = 3) +
    labs(x = "85'C Rework",
         y = "125'C",
         title = 'IDD3PS') + 
    geom_hline(yintercept = 23,
               size = 1.5,
               col = 'red') +
    geom_hline(yintercept = 23,
               size = 1.5,
               col = 'red') +
    geom_hline(yintercept = 20,
               size = 1.5,
               col = 'green') +
    geom_vline(xintercept = 10,
               size = 1.5,
               col = 'red') +
    theme_bw() +
    theme(axis.text.x = element_text(size = 10),
          axis.text.y = element_text(size = 10)),
  
  # IDD3N
  
  ggplot(G1_fin) +
    geom_point(aes(x = MSR28.y,
                   y = MSR28.x),
               col = 'blue',
               size = 3) +
    labs(x = "85'C Rework",
         y = "125'C",
         title = 'IDD3N') + 
    geom_hline(yintercept = 34,
               size = 1.5,
               col = 'red') +
    geom_hline(yintercept = 34,
               size = 1.5,
               col = 'red') +
    geom_hline(yintercept = 40,
               size = 1.5,
               col = 'green') +
    geom_vline(xintercept = 23,
               size = 1.5,
               col = 'red') +
    theme_bw() +
    theme(axis.text.x = element_text(size = 10),
          axis.text.y = element_text(size = 10)),
  
  # IDD3NS
  
  ggplot(G1_fin) +
    geom_point(aes(x = MSR29.y,
                   y = MSR29.x),
               col = 'blue',
               size = 3) +
    labs(x = "85'C Rework",
         y = "125'C",
         title = 'IDD3NS') + 
    geom_hline(yintercept = 28.5,
               size = 1.5,
               col = 'red') +
    geom_hline(yintercept = 28.5,
               size = 1.5,
               col = 'red') +
    geom_hline(yintercept = 40,
               size = 1.5,
               col = 'green') +
    geom_vline(xintercept = 18,
               size = 1.5,
               col = 'red') +
    theme_bw() +
    theme(axis.text.x = element_text(size = 10),
          axis.text.y = element_text(size = 10)),
  
  nrow =  2
  
  
  
)


# 4. EDS Join -------------------------------------------------------------

if(!require(dplyr)){install.packages('dplyr')}; require(dplyr)
if(!require(data.table)){install.packages('data.table')}; require(data.table)

dat1 <- fread('C:\\Users\\mano.hong\\Desktop\\21. 06. NU AUTO CURRENT\\G1_EDS.csv') %>% na.omit
dat2 <- fread('C:\\Users\\mano.hong\\Desktop\\21. 06. NU AUTO CURRENT\\G2_EDS.csv') %>% na.omit
EDS_fin <- rbind(dat1, dat2)

G1_fin <- G1_fin %>% 
  mutate(PK = paste(run.x, wf.x, x.x, y.x, sep = ','))

G2_fin <- G2_fin %>% 
  mutate(PK = paste(run.x, wf.x, x.x, y.x, sep = ','))

EDS_fin <- inner_join(dat1, dat2) %>% 
  mutate(PK = paste(run, wf, x, y, sep = ',')) %>% 
  filter(PK %in% G1_fin$PK |
           PK %in% G2_fin$PK) %>% 
  unique()

rm(dat1, dat2, fin)

G1_EDS <- G1_fin %>% inner_join(EDS_fin)
G2_EDS <- G2_fin %>% inner_join(EDS_fin)

