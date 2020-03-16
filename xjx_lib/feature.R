#############################################################
### Construct features and responses for training images  ###
#############################################################

feature <- function(input_list = fiducial_pt_list, index){
  # 
  # ### Construct process features for training images 
  # 
  # ### Input: a list of images or fiducial points; index: train index or test index
  # 
  # ### Output: a data frame containing: features and a column of label
  # 
  # ### here is an example of extracting pairwise distances between fiducial points
  # ### Step 1: Write a function pairwise_dist to calculate pairwise distance of items in a vector
  # pairwise_dist <- function(vec){
  #   ### input: a vector(length n), output: a vector containing pairwise distances(length n(n-1)/2)
  #   return(as.vector(dist(vec)))
  # }
  # 
  # ### Step 2: Write a function pairwise_dist_result to apply function in Step 1 to column of a matrix 
  # pairwise_dist_result <-function(mat){
  #   ### input: a n*2 matrix(e.g. fiducial_pt_list[[1]]), output: a vector(length n(n-1))
  #   ### by column
  #   return(as.vector(apply(mat, 2, pairwise_dist))) 
  # }
  # 
  # ### Step 3: Apply function in Step 2 to selected index of input list, output: a feature matrix with ncol = n(n-1) = 78*77 = 6006
  # pairwise_dist_feature <- t(sapply(input_list[index], pairwise_dist_result))
  # dim(pairwise_dist_feature) 
  # 
  # ### Step 4: construct a dataframe containing features and label with nrow = length of index
  # ### column bind feature matrix in Step 3 and corresponding features
  # pairwise_data <- cbind(pairwise_dist_feature, info$emotion_idx[index])
  # ### add column names
  # colnames(pairwise_data) <- c(paste("feature", 1:(ncol(pairwise_data)-1), sep = ""), "emotion_idx")
  # ### convert matrix to data frame
  # pairwise_data <- as.data.frame(pairwise_data)
  # ### convert label column to factor
  # pairwise_data$emotion_idx <- as.factor(pairwise_data$emotion_idx)
  # 
  # return(feature_df = pairwise_data)
  
  get_distance <- function(mat){
    colnames(mat) <- c("x", "y")
    dif <- as.data.frame(diff(mat))
    dif$dist <- sqrt(dif$x^2+dif$y^2)
    return (dif$dist)
  }
  
  get_distance_center <- function(mat, pt){
    colnames(mat) <- c("x", "y")
    n = nrow(mat)
    a = pt[1]
    b = pt[2]
    center <- matrix(c(rep(a, n), rep(b,n)), ncol = 2)
    dif <- as.data.frame(mat- center)
    dif$dist <- sqrt(dif$x^2+dif$y^2)
    return (dif$dist)
  }
  
  get_angle <- function(mat){
    colnames(mat) <- c("x", "y")
    dif <- as.data.frame(diff(mat))
    dif$angle <- atan(dif$y/dif$x)
    return (dif$angle)
  }
  
  get_a <- function(mat){
    x <- mat[,1]
    y <- mat[,2]
    model <- lm(y~x+I(x^2))
    return (model$coefficients[3])
  }
  
  get_result <- function(mat){
    ## face dist
    facepoints <- mat[64:78,]
    face_dist <- get_distance(facepoints)#
    
    ## face angle
    face_angle <- get_angle(facepoints)#
    
    ## face a left
    left_facepoints <- mat[64:71,]
    leftface_a <- get_a(left_facepoints)#
    
    ## face a right
    right_facepoints <- mat[71:78,]
    rightface_a <- get_a(right_facepoints)#
    
    ## left eye
    left_pt <- mat[1,]
    left_eyes <- mat[2:9,]
    left_eye_dist <- get_distance_center(left_eyes, left_pt)#
    left_eye_angle1 <- get_angle(mat[c(4,2),]) - get_angle(mat[c(2,8),])#
    left_eye_angle2 <- get_angle(mat[c(2,4),]) - get_angle(mat[c(4,6),])#
    
    ## right eye
    right_pt <- mat[10,]
    right_eyes <- mat[11:18,]
    right_eye_dist <- get_distance_center(right_eyes, right_pt)#
    right_eye_angle1 <- get_angle(mat[c(13,11),]) - get_angle(mat[c(11,17),])#
    right_eye_angle2 <- get_angle(mat[c(11, 17),]) - get_angle(mat[c(17,15),])#
    ##may add some extra angle on eyes
    
    ## left brow
    left_brow <- mat[19:23,]
    left_brow_dist <- get_distance(left_brow)#
    left_brow_angle <- get_angle(left_brow)#
    
    ## right brow
    right_brow <- mat[27:31,]
    right_brow_dist <- get_distance(right_brow)#
    right_brow_angle <- get_angle(right_brow)#
    
    ## nose
    nose_points <- mat[40:48,]
    nose_dist <- get_distance(nose_points)#
    nose_angle <- get_angle(nose_points)#
    
    ## nose area
    pt1<-mat[40,]
    pt2<-mat[42,]
    pt3<-mat[46,]
    pt4<-mat[48,]
    a1 <- (pt1[2]-pt2[2])/(pt1[1]-pt2[1])
    b1 <- pt1[2]-(pt1[2]-pt2[2])/(pt1[1]-pt2[1])*pt1[1]
    a2 <- (pt3[2]-pt4[2])/(pt3[1]-pt4[1])
    b2 <- pt3[2]-(pt3[2]-pt4[2])/(pt3[1]-pt4[1])*pt3[1]
    x <- (b2-b1)/(a1-a2)
    y <- a1*x+b1
    pt5 <- c(x,y)
    mat_nose <- rbind(pt2, pt3, pt5, pt2)
    len <- get_distance(mat_nose)
    a <- len[1]
    b <- len[2]
    c <- len[3]
    p=(a+b+c)/2
    nose_area <- sqrt(p*(p-a)*(p-b)*(p-c))#
    
    ## area of mouth
    outer_area <- polyarea(x = c(mat[50,1], mat[51,1], mat[52,1], mat[53,1], mat[54,1], mat[55,1], mat[56,1], mat[57,1]),
                           y = c(mat[50,2], mat[51,2], mat[52,2], mat[53,2], mat[54,2], mat[55,2], mat[56,2], mat[57,2]))#
    inner_area <- polyarea(x = c(mat[58,1], mat[59,1], mat[60,1], mat[61,1], mat[62,1], mat[63,1]),
                           y = c(mat[58,2], mat[59,2], mat[60,2], mat[61,2], mat[62,2], mat[63,2]))#
    out_mouth_up_points <- mat[50:54,]
    out_mouth_down_points <- mat[c(54:57,50),]
    out_mouth_up_dist <- get_distance(out_mouth_up_points)#
    out_mouth_up_angle <- get_angle(out_mouth_up_points)#
    out_mouth_down_dist <- get_distance(out_mouth_down_points)#
    out_mouth_down_angle <- get_angle(out_mouth_down_points)#
    
    inner_mouth_up_points <- mat[58:60,]
    inner_mouth_down_points <- mat[61:63,]
    inner_mouth_up_dist <- get_distance(inner_mouth_up_points)#
    inner_mouth_up_angle <- get_angle(inner_mouth_up_points)#
    inner_mouth_down_dist <- get_distance(inner_mouth_down_points)#
    inner_mouth_down_angle <- get_angle(inner_mouth_down_points)#
    
    result <- t(matrix(c(face_dist, face_angle, leftface_a, rightface_a, left_eye_dist, left_eye_angle1, left_eye_angle2, right_eye_dist, right_eye_angle1, right_eye_angle2, left_brow_dist, left_brow_angle, right_brow_dist, right_brow_angle, nose_dist, nose_angle, nose_area, outer_area, inner_area, out_mouth_up_dist, out_mouth_up_angle, out_mouth_down_dist, out_mouth_down_angle, inner_mouth_up_dist, inner_mouth_up_angle, inner_mouth_down_dist, inner_mouth_down_angle, mat[-37,1], mat[-37,2])))
    
    return (result)
  }
  dist_feature <- t(sapply(input_list[index], get_result))
  feature_withemo_data <- cbind(dist_feature, info$emotion_idx[index])
  colnames(feature_withemo_data) <- c(paste("feature", 1:(ncol(feature_withemo_data)-1), sep = ""), "emotion_idx")
  feature_withemo_data <- as.data.frame(feature_withemo_data)
  feature_withemo_data$emotion_idx <- as.factor(feature_withemo_data$emotion_idx)
  return(feature_df = feature_withemo_data)
}
