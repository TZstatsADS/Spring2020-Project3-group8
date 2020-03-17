###########################################################
### Train a classification model with training features ###
###########################################################
svm_train <- function(dat_train, cost = 1, probability = FALSE, kernel = 'linear', degree = 3, gamma = 1/ncol(dat_train)){

  tm.train = system.time(
    svm_model <- svm(emotion_idx ~ ., data = dat_train,
                     kernel = kernel, cost = cost, probability=probability, 
                     degree = degree, gamma = gamma) 
  )
  return(list(model = svm_model, tm.train))
}

