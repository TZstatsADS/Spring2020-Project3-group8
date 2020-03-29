########################################
### Classification with testing data ###
########################################

svm_test <- function(model, dat_test, probability=FALSE){
  
  tm.test = system.time(
    pred_svm <- predict(model, dat_test, probability=probability)
  )
  return(list(pred_svm,tm.test))
}
