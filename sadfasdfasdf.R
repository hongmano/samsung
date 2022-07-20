
# 1. Options / Library ----------------------------------------------------

if (!require(dplyr)) {install.packages('dplyr')}; require(dplyr)
if (!require(ggplot2)) {install.packages('ggplot2')}; require(ggplot2)
if (!require(reshape2)) {install.packages('reshape2')}; require(reshape2)
if (!require(readxl)) {install.packages('readxl')}; require(readxl)
if (!require(KoNLP)) {install.packages('KoNLP')}; require(KoNLP)
if (!require(stringr)) {install.packages('stringr')}; require(stringr)
if (!require(wordcloud2)) {install.packages('wordcloud2')}; require(wordcloud2)
if (!require(RColorBrewer)) {install.packages('RColorBrewer')}; require(RColorBrewer)

useSejongDic()
useNIADic()
useSystemDic()

buildDictionary(ext_dic = "woorimalsam", user_dic=data.frame("워라밸","ncn"),replace_usr_dic = T)

# 2. Data Loading ---------------------------------------------------------

year <- read.csv('C:/Users/mano.hong/Desktop/year.csv') %>% 
  group_by(site, CL) %>% 
  summarise(people = n()) %>% 
  filter(CL %in% paste0('CL', 1:4))

survey <- read_xlsx('C:/Users/mano.hong/Desktop/survey.xlsx') %>% 
  rename(site = Q5,
         CL = Q6)

survey_melt <- survey %>% 
  melt(id.vars = c('date', 'team', 'site', 'CL')) %>% 
  filter(value != '<NA>') %>% 
  select(site, CL, variable, value) %>% 
  `colnames<-`(c('site', 'CL', 'Q', 'A')) %>% 
  mutate(Q = substr(Q, 1, 3))


# 3. Freq. Analysis -------------------------------------------------------

# 3.1 설문 참여율 --------------------------------------------------------------

survey %>% 
  group_by(site, CL) %>% 
  tally() %>% 
  inner_join(year) %>% 
  mutate(portion = round(n / people * 100, 1)) %>% 
  ggplot(aes(x = portion,
             y = CL,
             fill = site)) +
  geom_bar(stat = 'identity', 
           width = .7,
           position = position_dodge(width = .8)) +
  geom_text(aes(label = paste0(portion, '%'),
                fill = site),
            position = position_dodge(width = 1), 
            hjust = -.1) +
  theme_bw() +
  scale_x_continuous(limits = c(0, 40)) +
  scale_fill_manual(values = c('blue', 'red')) +
  labs(x = 'Portion (%)',
       y = '') +
  ggtitle(label = 'Site/CL 별 설문 참여율 (%)') +
  theme(axis.text.y = element_text(size = 15))


# 3-2. Freq ---------------------------------------------------------------

survey_melt %>% 
  filter(Q == 'Q1') %>% 
  group_by(site, A) %>% 
  tally %>% 
  ungroup %>%  
  inner_join(survey_melt %>% 
               filter(Q == 'Q1') %>% 
               group_by(site) %>% 
               summarise(people = n())) %>% 
  mutate(portion = round(n / people * 100, 1),
         A = factor(A, levels = c('매우 만족하고 있고, 타 부서 사람들에게도 자기 부서를 추천할 의향이 있다.',
                                  '현재 만족하고 있고, 이동할 계획도 없다.',
                                  '회사 내 평균 수준이라고 생각한다.',
                                  '부서 이동 계획은 없지만, 큰 매력을 느끼지 못하고 있다.',
                                  '잡포스팅, 이직 등 구체적인 부서 이동 계획이 있다.'))) %>% 
  ggplot(aes(x = portion,
             y = A,
             fill = site)) +
  geom_bar(stat = 'identity',
           position = position_dodge(width = 1),
           width = .7) +
  geom_text(aes(label = paste0(portion, '%'),),
            position = position_dodge(1),
            hjust = -.1) +
  theme_bw() +
  scale_x_continuous(limits = c(0, 50)) +
  scale_fill_manual(values = c('blue', 'red')) +
  labs(y = '',
       x = 'Portion (%)') +
  theme(axis.text.y = element_text(size = 10))


survey_melt %>% 
  filter(Q == 'Q2.') %>% 
  mutate(A = str_split_fixed(A, ':', 2)[, 1],
         A = ifelse(substr(A, 1, 3) == '직무별', '업무 강도 차이', A)) %>% 
  group_by(site, A) %>% 
  tally %>% 
  ungroup %>%  
  inner_join(survey_melt %>% 
               filter(Q == 'Q2.') %>% 
               group_by(site) %>% 
               summarise(people = n())) %>% 
  mutate(portion = round(n / people * 100, 1)) %>% 
  ggplot(aes(x = portion,
             y = A,
             fill = site)) +
  geom_bar(stat = 'identity',
           position = position_dodge(width = 1),
           width = .7) +
  geom_text(aes(label = paste0(portion, '%'),),
            position = position_dodge(1),
            hjust = -.1) +
  theme_bw() +
  scale_x_continuous(limits = c(0, 30)) +
  scale_fill_manual(values = c('blue', 'red')) +
  labs(y = '',
       x = 'Portion (%)') +
  theme(axis.text.y = element_text(size = 20))

survey_melt$A <- survey_melt$A %>% 
  str_remove_all('[^가-힣\\s+]') %>% 
  str_replace_all('\\s+', ' ') %>% 
  str_trim()

# 3-3. Wordcloud ----------------------------------------------------------

wordcloud <- function(dat, Q, site){
  
  Q3_wordcloud <- dat %>% 
    filter(Q == 'Q4')
  
  Q3_wordcloud$A <- Q3_wordcloud$A %>% 
    str_remove_all('[^가-힣\\s+]') %>% 
    str_replace_all('\\s+', ' ') %>% 
    str_trim()
  
  Q3_word <- extractNoun(Q3_wordcloud$A)
  Q3_word <- sapply(Q3_word, function(x) { Filter(function(x){nchar(x) > 1 & nchar(x) < 5 }, x)})
  
  Q3_word_OY <- Q3_word[Q3_wordcloud$site == '온양'] %>% 
    unlist %>% 
    table %>% 
    as.data.frame() %>% 
    arrange(desc(Freq)) %>% 
    mutate(Freq = ifelse(Freq > 200, 200, Freq)) %>% 
    filter(. != '업무' & . != '업무량')
  
  Q3_word_H1 <- Q3_word[Q3_wordcloud$site != '온양'] %>% 
    unlist %>% 
    table %>% 
    as.data.frame() %>% 
    arrange(desc(Freq)) %>% 
    mutate(Freq = ifelse(Freq > 200, 200, Freq)) %>% 
    filter(. != '업무' & . != '업무량')
  
  pal <- brewer.pal(8, 'Dark2')
  
  if(site == 'OY'){
    
    wordcloud2(Q3_word_OY, minSize = 10, color = pal, shape = 'circle')
    
  }else{
    
    wordcloud2(Q3_word_H1, minSize = 10, color = pal, shape = 'circle')
    
  }
  
}

wordcloud(survey_melt, 'Q3', 'OY')
wordcloud(survey_melt, 'Q3', 'H1')

wordcloud(survey_melt, 'Q4', 'OY')
wordcloud(survey_melt, 'Q4', 'H1')

survey_melt$site <- enc2utf8(survey_melt$site)
survey_melt$CL <- enc2utf8(survey_melt$CL)
survey_melt$Q <- enc2utf8(survey_melt$Q)
survey_melt$A <- enc2utf8(survey_melt$A)
write.csv(survey_melt, 'C:/Users/mano.hong/Desktop/ss.csv', row.names = F)
