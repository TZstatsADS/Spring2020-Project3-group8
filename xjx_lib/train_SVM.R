###########################################################
### Train a classification model with training features ###
###########################################################
svm_train <- function(feature_df = pairwise_data, cost = 1, probability = FALSE, kernel = 'linear', degree = 3, gamma = 1/ncol(feature_df)){

  tm.train = system.time(
    svm_model <- svm(emotion_idx ~ ., data = feature_df,
                     kernel = kernel, cost = cost, probability=probability, 
                     degree = degree, gamma = gamma) 
  )
  return(list(model = svm_model, tm.train))
}

