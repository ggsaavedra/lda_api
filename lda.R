# lda.R
source('config.R')
source('sample.R')
# This will serve as an api for LDA
#* @get /lda
get_topics <- function(text_data = "", tablename = "", fieldname = "", type = "dataframe", k=5, maxterms=10){
  
  # type: database, dataframe
  # text_column: only useful for dataframe
  # tablename: table name in the db
  # fieldname: fieldname of the text data from the selected table and db
  print(text_data)
  print(paste(k, "topics"))
  print(paste(maxterms, "maximum output terms per topic"))  
  ################
  ### Get data ###
  ################
  if (type=="dataframe"){
    text <- as.character(fromJSON(text_data))
    print("Loaded the file successfully")
  }else{
   lis <- dbListTables(sql_con)
   
   print(tablename)
   print(fieldname)
   print(paste("SELECT", fieldname, "FROM", tablename))
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
#	print(colnames(dtm))  
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
  k <- as.numeric(k)
  
  # added code
  raw.sum=apply(dtm,1,FUN=sum)
  dtm <- dtm[raw.sum!=0, ]
  
  print("Running LDA")
  #Run LDA using Gibbs sampling
  ldaOut <-LDA(dtm, k, method='Gibbs', control=list(nstart=nstart, seed = seed, best=best, burnin = burnin, iter = iter, thin=thin))
  
  print("Done LDA Analysis")
  
  # Generate the result
  print('Generating Result')
  
  out_topics <- tidy(ldaOut, matrix = "beta")
  
  top_terms <- out_topics %>%
    group_by(topic) %>%
    top_n(maxterms, beta) %>%
    ungroup() %>%
    arrange(topic, -beta)
  
  as.data.frame(top_terms)
  
}
