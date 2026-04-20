#Find ranks from points
rank.from.points<- function(p=1000, pts_rk_mf = pts_rk_m) {
  names(pts_rk_mf)<-c("pts","rk")
  # sorted pts_rk in decreasing order if not done
  pts_rk_mf <- pts_rk_mf[order(pts_rk_mf$pts, decreasing = TRUE), ]
  
  pts_rk_mf$rk<- as.integer(pts_rk_mf$rk)
  
  above_p <- which(pts_rk_mf$pts > p) #select indivduals above p
  # rule out the number 1 case
  if (length(above_p) == 0) {return(min(pts_rk_mf$rk))}
  # nearest higher row
  pos_above <- max(pts_rk_mf$rk[above_p])
  
  return(pos_above + 1)
}

#examples
rank.from.points(5000,pts_rk_mf=pts_rk_m)
rank.from.points(1500,pts_rk)
rank.from.points(830,pts_rk)



