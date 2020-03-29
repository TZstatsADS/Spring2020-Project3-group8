###########################################################
### Train a classification model with training features ###
###########################################################

gbm_train = function(dat_train, ...){
	
	tm.train = system.time(
	  gbm.fit <- gbm(
	    emotion_idx ~ .,
      distribution = "multinomial",
      data = dat_train,
      ...
	    )
	  )
         
    return(list(gbm.fit,tm.train))
}
