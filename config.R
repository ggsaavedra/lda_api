## Load required library

library(RMySQL)
library(data.table)
library(tm)
library(SnowballC)
library(topicmodels)
library(mongolite)
library(qdap)
library(ngram)

# mysql config

DB_HOST = '10.196.239.218'
DB_USER = 'devuser'
DB_PW = 'devp@ss'
DB = 'censei'

sql_con <- dbConnect(MySQL(),
                 dbname = DB,
                 username = DB_USER,
                 password = DB_PW,
                 host = DB_HOST)
  
  
  
# mongo config
MONGO_COLLEC = "abscbn"
MONGO_DB = "nlp_ner"
MONGO_URL = "mongodb://10.196.239.218:27017/test"
# Initialize mongo connection
mongo_con <- mongo(collection = MONGO_COLLEC, 
                   db = MONGO_DB, 
                   url = MONGO_URL
)

mong_out <- mongo_con$find()
ngrams <- tolower(mong_out$text)
ngrams <- ngrams[which(mapply(wordcount, ngrams)>1)]

#Set parameters for Gibbs sampling
burnin <- 4000
iter <- 2000
thin <- 500
seed <-list(2003,5,63,100001,765)
nstart <- 5
best <- TRUE

#Number of topics
k <- 20
maxout_terms <- 20
