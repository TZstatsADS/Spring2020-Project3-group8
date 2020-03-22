#############################################################
### Construct features and responses for training images  ###
#############################################################

source("../xjx_lib/change_images.R")
source("../xjx_lib/inv_change_images.R")
feature <- function(input_list = fiducial_pt_list, index, image_file = "../data/train_set/images/", all_points){

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
  
  get_eyebrow=function(index, file, img){

    points=input_list[[index]]
    pointpair=all_points[[index]][c(23,27),]
    center=apply(pointpair,2,mean)
    
    length=pointpair[2,1]-pointpair[1,1]
    
    if(length >= 0){
      a=seq((center[1]-length*0.4),(center[1]+length*0.4),3)
      b=seq(center[2],(center[2]+0.8*length),3)
    }
    else{
      a=seq((center[1]-length*0.4),(center[1]+length*0.4),-3)
      b=seq(center[2],(center[2]+0.8*length),-3)
    }

    final_points=merge(a,b)
    return_points=inv_change_points(points, final_points)%>%round()%>%unique()
    
    image_final=img
    
    color_list=map2(return_points[,1],return_points[,2],~image_final[.x,.y,])
    color_list_sum=map(color_list,sum)%>%unlist
    
    #skin color
    indices_skin=c(35,38)
    points_select=all_points[[index]][indices_skin,]
    points_skin_all=merge(min(points_select[,1]):max(points_select[,1]),points_select[,2])
    skin_color_points=inv_change_points(points, points_skin_all)%>%round()%>%unique()
    skin_color_list_3=map2(skin_color_points[,1],skin_color_points[,2],~image_final[.x,.y,])
    skin_color_list_sum=map(skin_color_list_3,sum)%>%unlist%>%mean()
    rate=sum(color_list_sum<skin_color_list_sum)/length(color_list_sum)
    return(rate)
  }
  
  #get face folds
  get_color_line <- function(idx1, idx2, img, points){
    pt1 <- points[idx1,]
    pt2 <- points[idx2,]
    slope <- as.numeric((pt2[2]-pt1[2])/(pt2[1]-pt1[1]))
    intercept <- as.numeric(pt1[2] - slope*pt1[1])
    x <- as.numeric(pt1[1]):as.numeric(pt2[1])
    y <- round(x*slope+intercept)
    return (mean(img[x,y,1:3]))
  }
  
  get_skin_color <- function(img, points){
    c1 <- get_color_line(59, 69, img, points)
    c2 <- get_color_line(57, 70, img, points)
    c3 <- get_color_line(56, 71, img, points)
    c4 <- get_color_line(55, 72, img, points)
    c5 <- get_color_line(54, 73, img, points)
    return (mean(c(c1, c2, c3, c4, c5), na.rm = T))
  }
  
  get_color <- function(index, file, img, thre_value = 0.2){
    
    points <- fiducial_pt_list[[index]]
    y1 <- as.numeric(round(0.4*points[53,2] + 0.6*points[46,2]))
    y2 <- as.numeric(round(0.1*points[46,2] + 0.9*points[53,2]))
    x1 <- as.numeric(round((points[45,1] + points[46,1])/2))
    x2 <- as.numeric(round((points[46,1] + points[76,1])/2))
    x <- c(x1:x2)
    y <- c(y1:y2)
    diff <- max(img[x,y,1] + img[x,y,2] + img[x,y,3]) - min(img[x,y,1] + img[x,y,2] + img[x,y,3])
    mat <- img[x,y,1]+img[x,y,2]+img[x,y,2]
    skin_color <- get_skin_color(img, points)*3
    threshold <- skin_color - thre_value
    mean(mat < threshold)
    return(c(diff, mean(mat < threshold)))
  }
  
  get_symmetric <- function(mat1, mat2){
    colnames(mat1) <- c("x", "y")
    colnames(mat2) <- c("x", "y")
    mat1[,1] <- 1000-mat1[,1]
    mat <- mat2-mat1
    return (sqrt(mat[,1]^2 + mat[,2]^2))
  }
  
  get_result <- function(mat,index){
    ## face dist
    facepoints <- mat[64:78,]
    # face_dist <- get_distance(facepoints)#
    
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
    
    
    ##### WX #####
    ## eyebrow head middle
    eyebrow_mid_points <- mat[c(23,27),]
    eyebrow_head_dist <- get_distance(eyebrow_mid_points)
    
    ## eyebrow - eye
    inner_eye_corner <- mat[6,]
    eyebrow_eye_dist1 <- get_distance(mat[c(2,19),])
    eyebrow_eye_dist2 <- get_distance(mat[c(3,20),])
    eyebrow_eye_dist3 <- get_distance(mat[c(4,21),])
    eyebrow_eye_dist4 <- get_distance(mat[c(9,19),])
    eyebrow_eye_dist5 <- get_distance(mat[c(6,23),])
    
    ## eyebrow_left - nose bridge
    eyebrow_cornor_nose_bridge_dist <- get_distance(mat[c(23,35),])
    
    ## eye width
    inner_eye_corner_dist <- get_distance(mat[c(6,11),])
    outer_eye_corner_dist <- get_distance(mat[c(2,15),])
    one_eye_width_dist <- get_distance(mat[c(2,6),])
    
    ## eye height
    eye_height_dist1 <- get_distance(mat[c(4,8),])
    eye_height_dist2 <- get_distance(mat[c(3,9),])
    
    ## pupil dist
    pupil_dist <- get_distance(rbind(left_pt, right_pt))
    
    ## eye_corner_nose_dist
    eye_corner_nose_dist <- get_distance(mat[c(6,42),])
    
    ## eye angle
    eye_angle_points <- mat[c(2:3,9),]
    eye_angle <- get_angle(eye_angle_points)
    
    ## nose_bridge_dist
    nose_bridge_points <- mat[c(39,49),]
    nose_bridge_dist <- get_distance(nose_bridge_points)
    
    ## nose dist
    nose_dist1 <- get_distance(mat[c(38,44),])
    nose_dist2 <- get_distance(mat[c(38,50),])
    nose_dist3 <- get_distance(mat[c(38,52),])
    nose_dist4 <- get_distance(mat[c(38,56),])
    
    ## nose width
    nose_width <- get_distance(mat[c(42,46),])
    
    ## down nose angle
    nose_down_angle <- get_angle(mat[43:45,])
    
    ## symmetric
    single = c(35,36,37,38,44,52,56,59,62)
    double = data.frame(x1 = c(1,2,3,4,5,6,7,8,9,19,20,21,22,23,24,25,26,39,40,41,42,43,50,51,57,58,63), 
                        x2 = c(10,15,14,13,12,11,18,17,16,31,30,29,28,27,34,33,32,49,48,47,46,45,54,53,55,60,61))
    mat1 <- mat[double$x1,]
    mat2 <- mat[double$x2,]
    symmetricity <- get_symmetric(mat1, mat2)
    
    face_to_mouth1 <- get_distance(mat[c(71,56),])
    face_to_mouth2 <- get_distance(mat[c(71,52),])
    face_to_mouth3 <- get_distance(mat[c(68,50),])
    face_to_mouth4 <- get_distance(mat[c(64,50),])
    face_to_mouth5 <- get_distance(mat[c(69,60),])
    
    face_dist1 <- get_distance(mat[c(65,77),])
    face_dist2 <- get_distance(mat[c(67,75),])
    face_dist3 <- get_distance(mat[c(69,73),])
    face_dist4 <- get_distance(mat[c(65,68),])
    face_dist5 <- get_distance(mat[c(65,70),])

    
    result <- t(matrix(c(face_angle, leftface_a, 
                         rightface_a, left_eye_dist, left_eye_angle1, 
                         left_eye_angle2, right_eye_dist, right_eye_angle1, 
                         right_eye_angle2, left_brow_dist, left_brow_angle, 
                         right_brow_dist, right_brow_angle, nose_dist, 
                         nose_angle, nose_area, outer_area, inner_area, 
                         out_mouth_up_dist, out_mouth_up_angle, out_mouth_down_dist, 
                         out_mouth_down_angle, inner_mouth_up_dist, inner_mouth_up_angle, 
                         inner_mouth_down_dist, inner_mouth_down_angle, mat[-37,1]-500, mat[-37,2]-375,
                         eyebrow_head_dist,eyebrow_eye_dist1, eyebrow_eye_dist2,eyebrow_eye_dist3,eyebrow_eye_dist4, 
                         eyebrow_eye_dist5,eyebrow_cornor_nose_bridge_dist,inner_eye_corner_dist,outer_eye_corner_dist,
                         one_eye_width_dist,eye_height_dist1,eye_height_dist2,pupil_dist,eye_corner_nose_dist,eye_angle,
                         nose_bridge_dist, nose_dist1,nose_dist2,nose_dist3,nose_dist4,nose_width,nose_down_angle, 
                         symmetricity,
                         face_to_mouth1, face_to_mouth2, face_to_mouth3, face_to_mouth4, face_to_mouth5, 
                         face_dist1, face_dist2, face_dist3, face_dist4, face_dist5)))
    
    return (result)
  }
  
  get_used_color = function(index, file = image_file){
    
    image.path_sub = paste0(file, sprintf("%04d", index), ".jpg")
    image.list_sub = EBImage::readImage(image.path_sub)
    img = Image(image.list_sub, colormode = 'Color')
    
    eyebrow_feature<-get_eyebrow(index, file, img)
    face_folds<-get_color(index, file, img)
    
    return(c(eyebrow_feature, face_folds))
    
  }
  
  
  dist_feature <- t(sapply(all_points[index], get_result))
  #used_color <- t(sapply(index, get_used_color, file = image_file))
  feature_withemo_data <- cbind(dist_feature,
                                #used_color,
                                info$emotion_idx[index])
  colnames(feature_withemo_data) <- c(paste("feature", 1:(ncol(feature_withemo_data)-1), sep = ""), "emotion_idx")
  feature_withemo_data <- as.data.frame(feature_withemo_data)
  feature_withemo_data$emotion_idx <- as.factor(feature_withemo_data$emotion_idx)
  return(feature_df = feature_withemo_data)
}
