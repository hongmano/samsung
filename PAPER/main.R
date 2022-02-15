
# 1. Options / Packages ---------------------------------------------------

options(scipen = 100)

library(dplyr)
library(stringr)
library(stringi)

library(ggplot2)
library(GGally)
library(gridExtra)
library(plotly)

library(tm)
library(ldatuning)
library(topicmodels)
library(LDAvis)
library(tidytext)

library(network)
library(sna)

# 2. Data Loading ---------------------------------------------------------

setwd('C:/Users/mano.hong/Desktop/논문/22.02 LDA SNA(가제)')

dat <- read.csv('fin2.csv')
item <- read.csv('item.csv') %>% 
  mutate(Item = str_remove_all(Item, '\\s+'))

# 3. Wrangling ------------------------------------------------------------

# 3-1. Filter Only Fail Chip and Final Test ----------------------------------------------

dat <- dat %>% 
  filter(HB == 6 & test == 0) %>% 
  mutate(D_amp = ifelse(lot %in% c('PCH0079X52', 'PCH0079X62'), '1st', '2nd'))



# 3-2. Split PKGMAP to list -----------------------------------------------

dat_list <- list(HFC_before = dat %>% filter(step == 'T090PR0' & D_amp == '1st'),
                 HFC_after = dat %>% filter(step == 'T090PR0' & D_amp == '2nd'),
                 
                 HFH_before = dat %>% filter(step == 'T091PR0' & D_amp == '1st'),
                 HFH_after = dat %>% filter(step == 'T091PR0' & D_amp == '2nd'))


# 3-3. Filtering Function -------------------------------------------------


filtering <- function(dat){

  if(substr(dat$step[1], 1, 4) == 'T090'){
    
    dat <- dat %>% 
      select(DO, HB, NB, DU, SG, HTEMP, tPD, paste0('V', 186:201), run, wf, x, y, step, D_amp, test)
    dat[8:23][dat[8:23] == 0] <- ''
    
    NRT <- do.call(paste, c(dat[8:23])) %>%
      str_replace_all('\\s+', ' ') %>% 
      str_trim()

# 3-4. Remove Duplicated TN by HSDO ---------------------------------------
    
    for(i in 1:length(NRT)){
      
      NRT[i] <- NRT[i] %>% str_split(' ') %>% unlist %>% unique %>% str_flatten(' ')
      
      }
    
    dat$NRT <- NRT
    dat$NRT_n <- str_count(dat$NRT, ' ')
    
    dat <- dat %>% 
      select(-c(paste0('V', 186:201)))
    
  }else{
    
    dat <- dat %>% 
      select(DO, HB, NB, DU, SG, HTEMP, tPD, paste0('V', 201:210), run, wf, x, y, step, D_amp, test)
    dat[8:17][dat[8:17] == 0] <- ''
    
    NRT <- do.call(paste, c(dat[8:17])) %>%
      str_replace_all('\\s+', ' ') %>% 
      str_trim()
    

# 3-5. Remove Duplicated TN by HSDO ---------------------------------------
    
    for(i in 1:length(NRT)){
      
      NRT[i] <- NRT[i] %>% str_split(' ') %>% unlist %>% unique %>% str_flatten(' ')
      
    }
    
    dat$NRT <- NRT
    dat$NRT_n <- str_count(dat$NRT, ' ')
    
    dat <- dat %>% 
      select(-c(paste0('V', 201:210)))
    
  }
  
  return(dat)
  
}

dat_list <- lapply(dat_list, filtering)
dat_list$HFC_before$NRT[str_count(dat_list$HFC_before$NRT, ' ') == 0] <- ''
dat_list$HFC_before$NRT[str_detect(dat_list$HFC_before$NRT, '4001')] <- ''
dat_list$HFC_before$NRT[str_detect(dat_list$HFC_before$NRT, '2301')] <- ''

dat_list$HFC_before$NRT[dat_list$HFC_before$NRT_n == 0] <- ''

# 4. LDA ------------------------------------------------------------------

# 4-1. Check_LDA ----------------------------------------------------------

check_LDA <- function(dat){
  
  dat <- dat %>% 
    filter(NRT != '' & NRT_n > 0)
  
  cps <- VCorpus(VectorSource(dat$NRT))
  tdm <- TermDocumentMatrix(cps, control = list(wordLengths = c(2, 10)))
  dtm <- as.DocumentTermMatrix(tdm)
  
  result <- FindTopicsNumber(
    
    dtm,
    topics = c(2:20),
    metrics = c("Griffiths2004", "CaoJuan2009", "Arun2010", "Deveaud2014"),
    method = "Gibbs",
    control = list(seed = 1965,
                   iter = 100),
    mc.cores = 2,
    verbose = TRUE
    
  )
  
  FindTopicsNumber_plot(result)
  
}



# 4-2. Fit_LDA ------------------------------------------------------------

fit_LDA <- function(dat, topic){
  
  dat <- dat %>% 
    filter(NRT != '')
  
  cps <- VCorpus(VectorSource(dat$NRT))
  tdm <- TermDocumentMatrix(cps, control = list(wordLengths = c(2, 10)))
  dtm <- as.DocumentTermMatrix(tdm)
  
  result <- LDA(dtm,
                k = topic,
                control = list(seed = 1965,
                               iter = 100),
                method = 'Gibbs')
  
  post <- posterior(result)
  mat <- result@wordassignments
  
  json <- createJSON(phi = post[['terms']],
                     theta = post[['topics']],
                     vocab = colnames(post[['terms']]),
                     doc.length = slam::row_sums(mat),
                     term.frequency = slam::col_sums(mat))
  
  serVis(json)
  return(result)
  
}


# 4-2. Fitting -------------------------------------------------------------

check_LDA(dat_list$HFC_before)
result <- fit_LDA(dat_list$HFC_before, 8)

# 4-3. Beta Visualize -----------------------------------------------------

Beta_visualize <- function(result, n_words){
  
  beta <- tidy(result, matrix = 'beta') %>% 
    group_by(topic) %>% 
    top_n(n_words) %>% 
    arrange(topic, desc(beta))
  
  beta_list <- split(beta, beta$topic)
  p <- list()
  
  for(i in 1:length(beta_list)){
    
    p[[i]] <- beta_list[[i]] %>% 
      ggplot(aes(x = reorder(term, beta),
                 y = beta)) +
      geom_bar(stat = 'identity') +
      coord_flip() +
      labs(x = '',
           y = '',
           title = paste0('Topic = ', i)) +
      theme_bw()
    
    
  }
  
  p <- do.call('grid.arrange', c(p, ncol = length(beta_list)))
  
}

Beta_visualize(result, 15)


# 4-4. Gamma Visualize ----------------------------------------------------

Gamma_visualize <- function(result, n_docs){
  
  gamma <- tidy(result, matrix = "gamma") %>% 
    group_by(topic) %>% 
    top_n(n_docs) %>% 
    arrange(topic, desc(gamma))
  
  gamma_list <- split(gamma, gamma$topic)
  p <- list()
  
  for(i in 1:length(gamma_list)){
    
    p[[i]] <- gamma_list[[i]] %>% 
      ggplot(aes(x = reorder(document, gamma),
                 y = gamma)) +
      geom_bar(stat = 'identity') +
      coord_flip() +
      labs(x = '',
           y = '',
           title = paste('Topic = ', i)) +
      theme_bw()
    
    
  }
  
  p <- do.call('grid.arrange', c(p, ncol = length(gamma_list)))
  
}

Gamma_visualize(result, 10)

# 5. Network Analysis -----------------------------------------------------

# 5-1. SNA ----------------------------------------------------------------

SNA <- function(dat, cor, size.min = 30, topic_n){

  dat <- dat %>% 
    filter(NRT != '' & test == 0) %>% 
    mutate(topic = apply(result@gamma, 1, which.max)) %>% 
    filter(topic == topic_n)
  
  # gamma <- tidy(result, matrix = "gamma") %>% 
  #   group_by(topic) %>% 
  #   top_n(2000) %>% 
  #   arrange(topic, desc(gamma)) %>% 
  #   filter(topic == topic_n)
  # 
  # dat <- dat[gamma$document, ]
  
  if(topic_n == 1){
    
    dat$NRT <- dat$NRT %>% 
      str_remove_all('[0-9][0-9][0-9][0-9]') %>% 
      str_replace_all('\\s+', ' ')
    
  }else if(topic_n == 3){
    
    dat$NRT <- dat$NRT %>% 
      str_remove_all('4217|4219|4230') %>% 
      str_replace_all('\\s+', ' ')
    
  }else if(topic_n == 4){
    
    dat$NRT <- dat$NRT %>% 
      str_remove_all('[0-9][0-9][0-9][0-9]') %>% 
      str_replace_all('\\s+', ' ')
    
  }else if(topic_n == 5){
    
    dat$NRT <- dat$NRT %>% 
      str_remove_all('4219|4230|4359') %>% 
      str_replace_all('\\s+', ' ')
    
  }else if(topic_n == 7){
    
    dat$NRT <- dat$NRT %>% 
      str_remove_all('3229|3243|3213|3326|272 |304 ') %>% 
      str_replace_all('\\s+', ' ')
    
    dat$NRT[str_detect(dat$NRT, '3001')] <- ''
    
  }else if(topic_n == 8){
    
    dat$NRT <- dat$NRT %>% 
      str_remove_all('1037|139|1007|1008|1099') %>% 
      str_replace_all('\\s+', ' ')
    
  }
  
  cps <- VCorpus(VectorSource(dat$NRT))
  tdm <- TermDocumentMatrix(cps, control = list(wordLengths = c(2, 10)))
  dtm <- as.DocumentTermMatrix(tdm)

  dtmTfIdf <- DocumentTermMatrix(x = cps,
                                 control = list(wordLengths = c(2, Inf),
                                                weighting = function(x) weightTfIdf(x, normalize = T)))

  dtmTfIdf <- removeSparseTerms(x =  dtmTfIdf,
                                sparse = as.numeric(x = 0.95))

  corTerms <- dtmTfIdf %>% as.matrix() %>% cor()
  corTerms[corTerms <= cor] <- 0
  
  netTerms <- network(x = corTerms, directed = F)
  btnTerms <- betweenness(netTerms)
  
  netTerms %v% 'mode' <-
    ifelse(test = btnTerms >= quantile(x = btnTerms, probs = 0.95, na.rm = T), 'Top5%', 
           ifelse(test = btnTerms >= quantile(x = btnTerms, probs = 0.85, na.rm = T), 'Top15%', 'Other'))
  
  nodeColors <- c('Top5%' = 'orange',
                  'Top15%' = 'yellow',
                  'Other' = 'white')
  
  set.edge.value(netTerms, attrname = 'edgeSize', value = corTerms)


  ggnet2(netTerms, 
         node.color = 'mode',
         palette = nodeColors,
         layout.par = list(cell.jitter = 0.001),
         label = TRUE, 
         size = degree(dat = netTerms),
         size.min = size.min,
         label.size = 5) +
    labs(title = paste0('TOPIC = ', topic_n)) +
    theme_bw() +
    theme(legend.position = 'none')

}

# 5-2. Fitting ------------------------------------------------------------

SNA(dat_list$HFC_before, cor = 0, size.min = 1, topic_n = 1)
SNA(dat_list$HFC_before, cor = 0, size.min = 1, topic_n = 2)
SNA(dat_list$HFC_before, cor = 0, size.min = 1, topic_n = 3)
SNA(dat_list$HFC_before, cor = 0, size.min = 1, topic_n = 4)
SNA(dat_list$HFC_before, cor = 0, size.min = 1, topic_n = 5)
SNA(dat_list$HFC_before, cor = 0, size.min = 1, topic_n = 6)
SNA(dat_list$HFC_before, cor = 0, size.min = 1, topic_n = 7)
SNA(dat_list$HFC_before, cor = 0, size.min = 1, topic_n = 8)
