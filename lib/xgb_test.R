########################################
### Classification with testing data ###
########################################

xgb_test = function(model, dat_test) {
  
  test_mat_dat = as.matrix(dat_test)
  tm.test = system.time(
    pred <- predict(
      model, 
      newdata = test_mat_dat, 
      missing=NA, 
      n.trees = 500, 
      reshape=T
    )
  )
  
  return(list(pred, tm.test))
  
}