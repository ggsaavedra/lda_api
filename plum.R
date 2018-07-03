library(plumber)
r <- plumb('lda.R')
r$run(port=8000)
