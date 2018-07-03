## the ngrams
ngrams <- c("turn signal", "back seat", "buckle up")

## fake data (MWE)
dat <- data.frame(docs=paste0("doc", 1:5), 
                  state=c("use your turn signal",
                          "please buckle up in the back seat",
                          "buckle up for safety",
                          "Sit in the back seat",
                          "here it is"
                  )
)