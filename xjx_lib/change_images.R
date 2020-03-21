cal_angle = function(pos){
  model = lm(x ~ y, data = pos)
  summary(model)
  angle = atan(model$coefficients[2])
  
  return(angle)
}

cal_rotation = function(points, angle, center_x = 0, center_y = 0, move_x = 750*sin(angle), move_y = 0){
  alpha = atan((points[,2]-center_y)/(points[,1]-center_x))
  d = sqrt((points[,2]-center_y)^2+(points[,1]-center_x)^2)
  newx = d*cos(alpha + angle) + center_x + move_x
  newy = d*sin(alpha + angle) + center_y + move_y
  points_rotation = data.frame(x=newx,y=newy)
  
  return(points_rotation)
}

cal_translate = function(points, center_x = 500, center_y = 375, from_x = points[37,1], from_y = points[37,2]){
  newx = points[,1] + center_x - from_x
  newy = points[,2] + center_y - from_y
  points_translate=data.frame(x = newx, y = newy)
  
  return(points_translate)
}

cal_fixdist = function(points){
  apply(points[c(1,10),],2,mean)[2] - points[44,][2]
}

cal_zoom = function(points, rate){
  points*unlist(rate)
}

move_images = function(points, img, center_x = 500, center_y = 375, fixdist = -170){
  pos_single = data.frame(x = points[single,1], y = points[single,2])
  pos_double=data.frame(x = 0.5*points[double[,1],1]+0.5*points[double[,2],1],
                        y = 0.5*points[double[,1],2]+0.5*points[double[,2],2])
  pos=rbind(pos_single,pos_double)
  
  angle = cal_angle(pos)
  points_rotation = cal_rotation(points, angle)
  
  my_fixdist = cal_fixdist(points_rotation)
  rate = fixdist/my_fixdist
  points_zoom = cal_zoom(points_rotation, rate)
  
  points_translate = cal_translate(points_zoom, center_x, center_y)
  
  img_rotate = rotate(img, angle/2/pi*360)
  img_zoom = resize(img_rotate, nrow(img_rotate)*unlist(rate))
  img_translate = translate(img_zoom, c(center_x-points_zoom[37,1],
                                        center_y-points_zoom[37,2]))
  
  return(list(points_translate, img_translate))
}

change_image = function(indices = c(1,2), train_dir = "../data/train_set/", fiducial_pt_list = fiducial_pt_list, single = c(35,36,37,38,44,52,56,59,62), double = data.frame(x1 = c(1,2,3,4,5,6,7,8,9,19,20,21,22,23,24,25,26,39,40,41,42,43,50,51,57,58,63), x2 = c(10,15,14,13,12,11,18,17,16,31,30,29,28,27,34,33,32,49,48,47,46,45,54,53,55,60,61))){
  
  train_image_dir <- paste(train_dir, "images/", sep="")
  train_pt_dir <- paste(train_dir,  "points/", sep="")
  train_label_path <- paste(train_dir, "label.csv", sep="") 
  
  image.path_sub = map(indices, ~paste0(train_image_dir, sprintf("%04d", .x), ".jpg"))
  image.list_sub = map(image.path_sub, ~EBImage::readImage(.x))
  img = map(image.list_sub, ~Image(.x, colormode = 'Color'))
  
  fiducial_pt_list_sub = fiducial_pt_list[indices]
  points = map(fiducial_pt_list_sub, ~data.frame(x = .x[1:78,1], y = .x[1:78,2]))
  result_move = map(1:length(points), ~move_images(points[[.x]], img[[.x]]))
  
  return(result_move)
}

# Only points no images
move_points = function(points, center_x = 500, center_y = 375, fixdist = -170){
  pos_single = data.frame(x = points[single,1], y = points[single,2])
  pos_double=data.frame(x = 0.5*points[double[,1],1]+0.5*points[double[,2],1],
                        y = 0.5*points[double[,1],2]+0.5*points[double[,2],2])
  pos=rbind(pos_single,pos_double)
  
  angle = cal_angle(pos)
  points_rotation = cal_rotation(points, angle)
  
  my_fixdist = cal_fixdist(points_rotation)
  rate = fixdist/my_fixdist
  points_zoom = cal_zoom(points_rotation, rate)
  
  points_translate = cal_translate(points_zoom, center_x, center_y)
  
  return(points_translate)
}

change_points = function(indices = c(1,2), train_dir = "../data/train_set/", fiducial_pt_list = fiducial_pt_list, single = c(35,36,37,38,44,52,56,59,62), double = data.frame(x1 = c(1,2,3,4,5,6,7,8,9,19,20,21,22,23,24,25,26,39,40,41,42,43,50,51,57,58,63), x2 = c(10,15,14,13,12,11,18,17,16,31,30,29,28,27,34,33,32,49,48,47,46,45,54,53,55,60,61))){
  train_image_dir <- paste(train_dir, "images/", sep="")
  train_pt_dir <- paste(train_dir,  "points/", sep="")
  train_label_path <- paste(train_dir, "label.csv", sep="") 
  
  fiducial_pt_list_sub = fiducial_pt_list[indices]
  points = map(fiducial_pt_list_sub, ~data.frame(x = .x[1:78,1], y = .x[1:78,2]))
  result_move = map(1:length(points), ~move_points(points[[.x]]))
  
  return(result_move)
}