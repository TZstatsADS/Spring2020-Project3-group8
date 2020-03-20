ac_byclass <- function(conf_table){
  table <- as.matrix(conf_table)
  n <- dim(table)[2]
  rate <- rep(NA, n)
  for (i in 1:n){
    rate[i] <- table[i,i]/colSums(table)[i]
  }
  return(rate)
}