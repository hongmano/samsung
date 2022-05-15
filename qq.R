library(dplyr)
library(stringr)
library(KoNLP)
library(reshape2)
library(tm)
library(wordcloud2)
library(rJava)
library(network)
library(sna)
library(plotly)
library(ggplot2)
library(GGally)
library(gridExtra)
library(RColorBrewer)



# 1. Data Loading ---------------------------------------------------------

dat <- read.csv('C:/Users/Mano/Desktop/q.csv')

dat <- dat[, -c(1:2)]
dat <- dat %>% 
  `colnames<-`(c('name', 'cl', 'test', paste0('Q', 1:8))) %>% 
  melt(id.vars = c('name', 'cl', 'test')) %>% 
  mutate(value = value %>% 
           tolower() %>% 
           str_replace_all('[^[0-9가-힣a-z.\\s+]]', ' ') %>% 
           removePunctuation() %>% 
           str_replace_all('\\s+', ' ') %>% 
           str_trim() %>% 
           str_replace_all('ATL', 'ATE') %>% 
           str_replace_all('phython', 'python') %>% 
           str_replace_all('32dp', '고단칩') %>% 
           str_replace_all('16dp', '고단칩') %>% 
           str_replace_all('파이썬', 'python') %>% 
           str_replace_all('python[12]', 'python') %>% 
           str_replace_all('시시점', '시사점') %>% 
           str_replace_all('업무에대한', '업무') %>% 
           str_replace_all('다단칩', '고단칩') %>% 
           str_replace_all('16', '고단칩') %>% 
           str_replace_all('32', '고단칩') %>% 
           str_replace_all('sytem', 'system') %>% 
           str_replace_all('python', '파이썬') %>% 
           str_remove_all('정연홍|박건보'))


# 2. Extract Nouns --------------------------------------------------------


nouns <- sapply(dat$value, function(x){x <- extractNoun(x)
x <- x[nchar(x) > 1 & nchar(x) < 10]}, USE.NAMES = F)

# 3. Delete ---------------------------------------------------------------

nouns <- lapply(
  
  nouns, function(x) 
  
  {x <- x %>% str_replace_all('합니|같습니|좋겠습니|하겠습니|것같습니|느껴집니|로운|만큼|의견없|하게|3l|90|들이', '')}
  
  )

# 4. Replace --------------------------------------------------------------

nouns <- lapply(
  
  nouns, function(x) 
  
  {x <- x %>% 
    str_replace_all('고단칩단', '고단칩') %>% 
    str_replace_all('one', '일대일') %>% 
    str_replace_all('목표입니', '목표') %>% 
    str_replace_all('atl', 'ate') %>% 
    str_replace_all('생각합니', '생각') %>% 
    str_replace_all('생각됩니', '생각') %>% 
    str_replace_all('문제입니', '문제') %>% 
    str_replace_all('cl2멤버', 'cl2') %>% 
    str_replace_all('cl2인력들', 'cl2') %>% 
    str_replace_all('cl2인력에게', 'cl2') %>% 
    str_replace_all('cl2인력확', 'cl2') %>% 
    str_replace_all('2년차', 'cl2') %>% 
    str_replace_all('program이해', 'program') %>% 
    str_replace_all('xq', '신제품') %>% 
    str_replace_all('wh', '신제품') %>% 
    str_replace_all('wg', '신제품') %>% 
    str_replace_all('임파워먼트', '동기부여') %>% 
    str_replace_all('advanced', 'adv') %>% 
    str_replace_all('adv', 'advanced') %>% 
    str_replace_all('sq', 'SQL') %>% 
    toupper()
  
  x <- x[x != '']
  
  }
)

# 5. Wordcloud ------------------------------------------------------------

wordcloud <- function(dat, CL){
  
  CL2 <- nouns[which(dat$cl == 2)] %>% 
    unlist %>% 
    table %>% 
    as.data.frame() %>% 
    mutate(Freq = ifelse(Freq > 15, 15, Freq)) %>% 
    arrange(desc(Freq))
  CL3 <- nouns[which(dat$cl == 3)] %>% 
    unlist %>% 
    table %>% 
    as.data.frame()%>% 
    mutate(Freq = ifelse(Freq > 15, 15, Freq)) %>% 
    arrange(desc(Freq))
  CL4 <- nouns[which(dat$cl == 4)] %>% 
    unlist %>% 
    table %>% 
    as.data.frame()%>% 
    mutate(Freq = ifelse(Freq > 15, 15, Freq)) %>% 
    arrange(desc(Freq))

  nouns <- nouns %>% 
    unlist %>% 
    table %>% 
    as.data.frame()%>% 
    mutate(Freq = ifelse(Freq > 30, 30, Freq)) %>% 
    arrange(desc(Freq))
  
  if(CL == 2){
    
    wordcloud2(CL2, minSize = 5, fontFamily = 'NanumGothic', shape = 'circle', color = brewer.pal(n = 8, name = 'Set2'))
    
  }else if(CL == 4){
    
    wordcloud2(CL4, minSize = 5, fontFamily = 'NanumGothic', shape = 'circle', color = brewer.pal(n = 8, name = 'Set2'))
    
  }else if(CL == 'all'){
    
    wordcloud2(nouns, minSize = 5, fontFamily = 'NanumGothic', shape = 'circle', color = brewer.pal(n = 8, name = 'Set2'))
    
  }else{
    stop('Check your CL')
  }
  
}

wordcloud(dat, 2)
wordcloud(dat, 4)
wordcloud(dat, 'all')


# 6. Network --------------------------------------------------------------

SNA <- function(dat, CL, q, cor){
  
  question <- c(
    
    '(개인성장)올해 본인의 성장 목표는?',
    '(개인성장)올해 동료의 성장에 어떻게 기여할것인가?',
    '(개인성장)올해 본인의 도전 과제/목표는?',
    '(개인성장)올해 본인의 연구 주제는?',
    '(발전방향)조직 문화에 도움이 될수 있는 조언이 있다면?',
    '(발전방향)업무 환경 개선에 우선 필요한 것이 있다면?',
    '(발전방향)지금 리더(TL)가 고민하고 준비해야 것은?',
    '(발전방향)지금 리더(PL)가 고민하고 준비해야 것은?'
    
  )
  
  q <- q - 1

  nouns <- nouns[(1+(q*20)):(1+(q*20)+19)]
  
  CL2 <- nouns[which(dat$cl == 2)]
  CL3 <- nouns[which(dat$cl == 3)]
  CL4 <- nouns[which(dat$cl == 4)]
  
  sna_plot <- function(nouns){
    
    cps <- VCorpus(VectorSource(nouns))
    
    dtmTfIdf <- DocumentTermMatrix(x = cps,
                                   control = list(wordLengths = c(2, Inf),
                                                  weighting = function(x) weightTfIdf(x, normalize = T)))
    
    dtmTfIdf <- removeSparseTerms(x =  dtmTfIdf,
                                  sparse = as.numeric(x = 0.99))
    
    dtmTfIdf$dimnames$Terms <- toupper(dtmTfIdf$dimnames$Terms)
    
    corTerms <- dtmTfIdf %>% as.matrix() %>% cor()
    corTerms[corTerms <= cor] <- 0
    
    netTerms <- network(x = corTerms, directed = T)
    btnTerms <- betweenness(netTerms)
    
    netTerms %v% 'mode' <-
      ifelse(test = btnTerms >= quantile(x = btnTerms, probs = 0.9, na.rm = T), 'Top5%', 'Other')
    
    nodeColors <- c('Top5%' = 'yellow',
                    'Other' = 'white')
    
    set.edge.value(netTerms, attrname = 'edgeSize', value = corTerms / 5)
    
    ggnet2(
      net = netTerms,
      layout.par = list(cell.jitter = 0.001),
      size.min = 5,
      label = TRUE,
      label.size = 3,
      node.color = 'mode',
      palette = nodeColors,
      node.size = sna::degree(dat = netTerms),
      edge.size = 'edgeSize') +
      theme_bw() +
      theme(legend.position = 'none',
            axis.text.x = element_blank(),
            axis.text.y = element_blank()) +
      labs(x = '', y = '',
           title = paste0(question[q + 1], ' : CL', CL))
    
  }
  

  if(CL == 2){
    ggplotly(sna_plot(CL2))
  }else if(CL == 4){
    ggplotly(sna_plot(CL4))
  }else{
    ggplotly(sna_plot(nouns))
  }
}


SNA(dat, CL = 2, q = 3, 0)
