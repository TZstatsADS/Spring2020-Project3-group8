library(EBImage)
points = data.frame(x = fiducial_pt_list_sub[[1]][1:78,1], y = fiducial_pt_list_sub[[1]][1:78,2])
single = c(35,36,37,38,44,52,56,59,62)
double = data.frame(x1 = c(1,2,3,4,5,6,7,8,9,19,20,21,22,23,24,25,26,39,40,41,42,43,50,51,57,58,63),
                    x2 = c(10,15,14,13,12,11,18,17,16,31,30,29,28,27,34,33,32,49,48,47,46,45,54,53,55,60,61))
emotion_type=info%>%group_by(type,emotion_cat)%>%summarise()
emotion_list_simple=c('Angry','Disgusted','Fearful','Happy','Neutral','Sad','Surprised')
emotion_list_compound=c('Angrily disgusted','Angrily surprised','Appalled','Awed','Disgustedly surprised','Fearfully angry','Fearfully disgusted','Fearfully surprised','Happily disgusted','Happily surprised','Hatred','Sadly angry','Sadly disgusted','Sadly fearful','Sadly surprised')
emotion_list_all=c(emotion_list_simple,emotion_list_compound)

cal_angle = function(pos){
  model = lm(x ~ y, data = pos)
  summary(model)
  angle = atan(model$coefficients[2])
  
  return(angle)
}

cal_rotation = function(points, angle){
  alpha=atan(points[,2]/points[,1])
  d=sqrt((points[,2])^2+(points[,1])^2)
  newx=d*cos(alpha + angle) + 0 + 750*sin(angle)
  newy=d*sin(alpha + angle) + 0
  points_rotation=data.frame(x=newx,y=newy)
  
  return(points_rotation)
}

cal_translate = function(points, center_x = 500, center_y = 375){
  newx=points[,1]+center_x-points[37,1]
  newy=points[,2]+center_y-points[37,2]
  points_translate=data.frame(x = newx, y = newy)
  
  return(points_translate)
}

move_images = function(points, img, center_x = 500, center_y = 375){
  pos_single = data.frame(x = points[single,1], y = points[single,2])
  pos_double=data.frame(x=0.5*points[double[,1],1]+0.5*points[double[,2],1],
                        y=0.5*points[double[,1],2]+0.5*points[double[,2],2])
  pos=rbind(pos_single,pos_double)
  
  angle = cal_angle(pos)
  points_rotation = cal_rotation(points, angle)
  points_translate = cal_translate(points_rotation, center_x, center_y)
  
  img_rotate = rotate(img, angle/2/pi*360)
  img_translate = translate(img_rotate, c(center_x-points_rotation[37,1],
                                          center_y-points_rotation[37,2]))
  
  return(list(points_translate, img_translate))
}

change_image = function(indices = c(1,2)){
  image.path_sub = map(indices, ~paste0(train_image_dir, sprintf("%04d", .x), ".jpg"))
  image.list_sub = map(image.path_sub, ~EBImage::readImage(.x))
  img = map(image.list_sub, ~Image(.x, colormode = 'Color'))
  
  fiducial_pt_list_sub = fiducial_pt_list[indices]
  points = map(fiducial_pt_list_sub, ~data.frame(x = .x[1:78,1], y = .x[1:78,2]))
  result_move = map(1:length(points), ~move_images(points[[.x]], img[[.x]]))
  
  return(result_move)
}




display_emotion=function(emotion){
  indices <- info[info$emotion_cat==emotion, 'Index']
  l=length(indices)
  result_move = change_image(indices)
  Image_list_sub = map(result_move, ~imageData(.x[[2]])[100:900,100:700,])
  
  Image_overlap_data=Image_list_sub[[1]]/l
  for (i in 2:l){
    Image_overlap_data=Image_overlap_data+Image_list_sub[[i]]/l
  }
  
  display(Image(Image_overlap_data,colormode='Color'), method="raster")
  title(emotion)
}