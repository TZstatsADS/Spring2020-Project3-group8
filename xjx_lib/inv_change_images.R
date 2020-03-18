single = c(35,36,37,38,44,52,56,59,62)
double = data.frame(x1 = c(1,2,3,4,5,6,7,8,9,19,20,21,22,23,24,25,26,39,40,41,42,43,50,51,57,58,63),
                    x2 = c(10,15,14,13,12,11,18,17,16,31,30,29,28,27,34,33,32,49,48,47,46,45,54,53,55,60,61))

inv_change_points = function(points, endpoints, center_x = 500, center_y = 375, fixdist = -170){
  pos_single = data.frame(x = points[single,1], y = points[single,2])
  pos_double=data.frame(x = 0.5*points[double[,1],1]+0.5*points[double[,2],1],
                        y = 0.5*points[double[,1],2]+0.5*points[double[,2],2])
  pos=rbind(pos_single,pos_double)
  angle = cal_angle(pos)
  points_rotation = cal_rotation(points, angle)
  
  my_fixdist = cal_fixdist(points_rotation)
  rate = fixdist/my_fixdist
  
  endpoints_zoom = cal_translate(endpoints, points_zoom[37,1], points_zoom[37,2])
  endpoints_rotation = cal_zoom(endpoints_zoom, 1/rate)
  endpoints_end = cal_rotation(endpoints_rotation, -angle, center_x = 750*sin(angle), center_y = 0, move_x = -750*sin(angle), move_y = 0)
  
  return(endpoints_end)
}