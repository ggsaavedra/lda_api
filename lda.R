# lda.R
source('config.R')
source('sample.R')
# This will serve as an api for LDA
#* @get /lda
get_topics <- function(text_data = "", tablename = "", fieldname = "", type = "dataframe", k=5, maxout_terms=10){
  
  # type: database, dataframe
  # text_column: only useful for dataframe
  # tablename: table name in the db
  # fieldname: fieldname of the text data from the selected table and db
	print(text_data)  
  ################
  ### Get data ###
  ################
  if (type=="dataframe"){
    text <- as.character(fromJSON(text_data))
    print("Loaded the file successfully")
  }else{
   lis <- dbListTables(sql_con)

   query <- dbSendQuery(sql_con, paste("SELECT", fieldname, "FROM", tablename))
   text <- dbFetch(query)
   
  }
  
  ####################################
  ### Create a DocumentTermMatrix ###
  ###################################
  
  # myCorp <- as.Corpus(dat$state, dat$docs)
  
  # myDF <- as.data.frame(myCorp)
  f <- sub_holder(ngrams, text)
  dtm <- as.DocumentTermMatrix(f$output)
  colnames(dtm) <- f$unhold(colnames(dtm))
	print(colnames(dtm))  
  print('Done creating DocumentTermMatrix')
  
  #convert rownames to filenames
  # rownames(dtm) <- df$full_text
  #collapse matrix by summing over columns
  freq <- colSums(as.matrix(dtm))
  #length should be total number of terms
  # length(freq)
  #create sort order (descending)
  ord <- order(freq,decreasing=TRUE)
  #List all terms in decreasing order of freq and write to disk
  # freq[ord]
  # write.csv(freq[ord],'word_freq.csv')
  
  #####
  ##### TOPIC MODELING
  
  #load topic models library
  #Set parameters for Gibbs sampling
  burnin <- burnin
  iter <- iter
  thin <- thin
  seed <- seed
  nstart <- nstart
  best <- best
  
  #Number of topics
  k <- k
  
  # added code
  raw.sum=apply(dtm,1,FUN=sum)
  dtm <- dtm[raw.sum!=0, ]
  
  #Run LDA using Gibbs sampling
  ldaOut <-LDA(dtm, k, method='Gibbs', control=list(nstart=nstart, seed = seed, best=best, burnin = burnin, iter = iter, thin=thin))
  
  #write out results
  #docs to topics
  # ldaOut.topics <- as.matrix(topics(ldaOut))
  # write.csv(ldaOut.topics,file=paste(“LDAGibbs”,k,”DocsToTopics.csv”))
  
  #top 6 terms in each topic
  ldaOut.terms <- as.matrix(terms(ldaOut,maxout_terms))
  ldaOut.terms
  #probabilities associated with each topic assignment
  # topicProbabilities <- as.data.frame(ldaOut@gamma)
  # write.csv(topicProbabilities,file=paste(“LDAGibbs”,k,”TopicProbabilities.csv”))
  # write.csv(ldaOut.terms,file=paste(“LDAGibbs”,k,”TopicsToTerms.csv”))
  
  # #Find relative importance of top 2 topics
  # topic1ToTopic2 <- lapply(1:nrow(dtm),function(x)
  #   sort(topicProbabilities[x,])[k]/sort(topicProbabilities[x,])[k-1])
  # 
  # #Find relative importance of second and third most important topics
  # topic2ToTopic3 <- lapply(1:nrow(dtm),function(x)
  #   sort(topicProbabilities[x,])[k-1]/sort(topicProbabilities[x,])[k-2])
  
}
