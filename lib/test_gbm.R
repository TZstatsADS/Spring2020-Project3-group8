########################################
### Classification with testing data ###
########################################

gbm_test = function(model, dat_test){
	
	best_iter = gbm.perf(model,method ="cv")
	
	###Testing
	tm.test = system.time(
	  pred_gbm <- predict(
	    object = model,
	    newdata = dat_test,
      n.trees = best_iter, missing = NA,
      type = "response"
	    )
	  )
	
	return(list(pred_gbm,tm.test))
}
