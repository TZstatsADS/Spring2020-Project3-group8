###########################################################
### Train a classification model with training features ###
###########################################################
svm_train <- function(dat_train, cost = 1, probability = FALSE, ...){

  tm.train = system.time(
    svm_model <- svm(emotion_idx ~ ., data = dat_train,
                     cost = cost, probability=probability, 
                     ...) 
  )
  return(list(model = svm_model, tm.train))
}

