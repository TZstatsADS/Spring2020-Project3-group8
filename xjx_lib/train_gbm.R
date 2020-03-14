###########################################################
### Train a classification model with training features ###
###########################################################

gbm_train = function(dat_train, n.trees = 200, bag.fraction = 0.65, shrinkage = 0.1, cv.folds = 3){
	
	tm.train = system.time(
	  gbm.fit = gbm(
	    emotion_idx ~ .,
      distribution = "multinomial",
      data = dat_train,
      n.trees = n.trees,
      bag.fraction = bag.fraction,
      shrinkage = shrinkage,
      cv.folds = cv.folds
	    )
	  )
         
    return(list(gbm.fit,tm.train))
}
