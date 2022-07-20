
# 1. Options / Library ----------------------------------------------------

if (!require(dplyr)) {install.packages('dplyr')}; require(dplyr)
if (!require(ggplot2)) {install.packages('ggplot2')}; require(ggplot2)
if (!require(reshape2)) {install.packages('reshape2')}; require(reshape2)

if (!require(KoNLP)) {install.packages('KoNLP')}; require(KoNLP)
if (!require(tm)) {install.packages('tm')}; require(tm)
if (!require(ldatuning)) {install.packages('ldatuning')}; require(ldatuning)
if (!require(network)) {install.packages('network')}; require(network)
if (!require(sna)){install.packages('sna')}; library(sna)
if (!require(plotly)){install.packages('plotly')}; library(plotly)
if (!require(GGally)){install.packages('GGally')}; library(GGally)

if (!require(stringr)) {install.packages('stringr')}; require(stringr)
if (!require(wordcloud2)) {install.packages('wordcloud2')}; require(wordcloud2)
if (!require(RColorBrewer)) {install.packages('RColorBrewer')}; require(RColorBrewer)

useSejongDic()
useNIADic()
useSystemDic()

# 2. Data Loading ---------------------------------------------------------

survey <- read.csv('C:/Users/Mano/Desktop/survey.csv') 

# 3. Q2_ ------------------------------------------------------------------

Q2_ <- survey %>% 
  filter(Q == 'Q2_')



# 4. Wordcloud ------------------------------------------------------------


# 4-1. Q3 -----------------------------------------------------------------

Q3_stopwords <- c('같습니', '하나', '뭐라', '에서', '일하', '프로젝트별', '하다', 
                  '다들', '등등', '많습니', '못받고', '있습니', '하거', '한데',
                  '한보', '가술', '같긴한데', '그걸', '끌어주냐에', '넓다보니',
                  '나아지긴', '년간', '될꺼라고', '뒷처리는', '들었습니', '때문에',
                  '많다보니', '모르겠', '모럴', '못받는', '뭘까요', '받기', '본다는거',
                  '선두안', '이주훈', '아무것', '안나', '안씁니다', '않는부서는', 
                  '않습니', '없습니', '업의', '와닿지가', '이기', '이닝', '응신',
                  '은근', '이걸', '줌꿀', '힘듦', '하게', '때문', '하기', '하려', '해도',
                  '해서', '공은', '들이', '만큼', '때문에', '로운', '보면', '해주', '많은',
                  '안해', '좋겠', '아니길', '여러', '누구냐에', '하시시', '하지', '하면')

Q3 <- survey %>% 
  filter(Q == 'Q3')

Q3_nouns <- sapply(Q3$A, 
                   function(x){
                     x <- extractNoun(x)
                     x <- x[nchar(x) > 1 & nchar(x) < 6]
                     x <- x %>% 
                       str_replace_all('사람들', '사람') %>% 
                       str_replace_all('교육가', '교육') %>% 
                       str_replace_all('문화때문에', '문화') %>% 
                       str_replace_all('존재하는거', '존재') %>% 
                       str_replace_all('차이나', '차이') %>% 
                       str_replace_all('발생핢', '발생') %>% 
                       str_replace_all('워라', '워라밸') %>% 
                       str_replace_all('주도하', '주도') %>% 
                       str_replace_all('발생핢', '발생') %>% 
                       str_replace_all('스트래스도', '스트레스') %>% 
                       str_remove_all(paste(Q3_stopwords, collapse = '|')) %>% 
                       str_replace_all('\\s+', ' ') %>% 
                       str_trim()
                   }, 
                   USE.NAMES = F)

Q3_nouns <- sapply(Q3_nouns, function(x){x <- x[x != '']})
Q3_nouns[[7]] <- '업무'

wordcloud <- function(dat, nouns, site, CL){
  
  site <- dat$site == site
  CL <- dat$CL == CL
  
  nouns <- nouns[site & CL] %>% 
    unlist %>% 
    table %>% 
    as.data.frame() %>% 
    arrange(desc(Freq)) %>% 
    filter(. != '' & . != ' ' & . != '업무') %>% 
    mutate(Freq = ifelse(Freq > 50, 50, Freq))
  
  pal <- brewer.pal(8, 'Dark2')
  
  wordcloud2(nouns, minSize = 3, color = pal, shape = 'circle')
  
}

wordcloud(Q3, Q3_nouns, '온양', 'CL2')
wordcloud(Q3, Q3_nouns, '온양', 'CL3')
wordcloud(Q3, Q3_nouns, '온양', 'CL4')

wordcloud(Q3, Q3_nouns, '화성', 'CL2')
wordcloud(Q3, Q3_nouns, '화성', 'CL3')
wordcloud(Q3, Q3_nouns, '화성', 'CL4')


# 4-2. Q4 -----------------------------------------------------------------

Q4 <- survey %>% 
  filter(Q == 'Q4')

Q4_nouns <- sapply(Q4$A, 
                   function(x){
                     x <- extractNoun(x)
                     x <- x[nchar(x) > 1 & nchar(x) < 6]
                     x <- x %>% 
                       str_replace_all('사람들', '사람') %>% 
                       str_replace_all('교육가', '교육') %>% 
                       str_replace_all('문화때문에', '문화') %>% 
                       str_replace_all('존재하는거', '존재') %>% 
                       str_replace_all('차이나', '차이') %>% 
                       str_replace_all('발생핢', '발생') %>% 
                       str_replace_all('워라', '워라밸') %>% 
                       str_replace_all('주도하', '주도') %>% 
                       str_replace_all('발생핢', '발생') %>% 
                       str_replace_all('스트래스도', '스트레스') %>% 
                       str_remove_all(paste(Q3_stopwords, collapse = '|')) %>% 
                       str_replace_all('\\s+', ' ') %>% 
                       str_trim()
                   }, 
                   USE.NAMES = F)


wordcloud(Q4, Q4_nouns, 'OY', 'CL2')
wordcloud(Q4, Q4_nouns, 'OY', 'CL3')
wordcloud(Q4, Q4_nouns, 'OY', 'CL4')

wordcloud(Q4, Q4_nouns, 'H1', 'CL2')
wordcloud(Q4, Q4_nouns, 'H1', 'CL3')
wordcloud(Q4, Q4_nouns, 'H1', 'CL4')


# 5. SNA ------------------------------------------------------------------

SNA <- function(dat, nouns, site, CL, cor, sparse){
  
  site <- dat$site == site
  CL <- dat$CL == CL
  
  nouns <- nouns[site & CL]
  nouns <- sapply(nouns, function(x) {x <- x[x != '']})
  
  
  for(i in 1:length(nouns)){
    
    if(length(nouns[[i]]) == 0){
      
      nouns[[i]] <- NULL
      
    }
  }
  
  cps <- VCorpus(VectorSource(nouns))
  
  dtmTfIdf <- DocumentTermMatrix(x = cps,
                                 control = list(wordLengths = c(2, Inf),
                                                weighting = function(x) weightTfIdf(x, normalize = T)))

  dtmTfIdf <- removeSparseTerms(x =  dtmTfIdf,
                                sparse = as.numeric(x = sparse))
  
  
  dtmTfIdf$dimnames$Terms <- toupper(dtmTfIdf$dimnames$Terms)
  
  corTerms <- dtmTfIdf %>% as.matrix() %>% cor()
  corTerms[corTerms <= cor] <- 0
  
  netTerms <- network(x = corTerms, directed = T)
  btnTerms <- betweenness(netTerms)
  
  netTerms %v% 'mode' <-
    ifelse(test = btnTerms >= quantile(x = btnTerms, probs = 0.9, na.rm = T), 'Top10%', 'Other')
  
  nodeColors <- c('Top10%' = 'yellow',
                  'Other' = 'white')

  
  set.edge.value(netTerms, attrname = 'edgeSize', value = 0.05)
  
  ggplotly(
    
    ggnet2(
      net = netTerms,
      layout.par = list(cell.jitter = 0.001),
      size.min = 5,
      label = TRUE,
      label.size = 3,
      node.color = 'mode',
      palette = nodeColors,
      node.size = sna::degree(dat = netTerms),
      edge.size = 'edgeSize'),
    
    tooltip = 'color'
    
  )
  
}


SNA(Q3, Q3_nouns, '화성', 'CL2', 0.3, 0.98)
SNA(Q3, Q3_nouns, '온양', 'CL2', 0, 0.98)

SNA(Q3, Q3_nouns, '화성', 'CL3', 0.1, 0.91)
SNA(Q3, Q3_nouns, '온양', 'CL3', 0.3, 0.98)


SNA(Q3, Q3_nouns, '화성', 'CL4', 0.1, 0.99)
SNA(Q3, Q3_nouns, '온양', 'CL4', 0.05, 0.98)
