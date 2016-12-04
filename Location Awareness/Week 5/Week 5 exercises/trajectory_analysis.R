douglasPeucker = function(trajectory, errorBound) {
  index = identifyFurthestPoint(trajectory, errorBound)
  
  if(is.na(index) == FALSE) {
    douglasPeucker(trajectory[1:index,], errorBound)
    douglasPeucker(trajectory[index:nrow(trajectory),], errorBound)
  }
}

indexOfFurthestPoint = function(p1, p2, trajectory, errorBound) {
  m = (p2$V2 - p1$V2) / (p2$V1 - p1$V1)
  b = p1$V2 - m * p1$V1
  
  diff = c()
  for (i in 1:nrow(trajectory)) {
    diff = c(diff, abs(trajectory[i,]$V2 - m * trajectory[i,]$V1 - b))
  }
  
  if(max(diff) > errorBound) {
    return(which.max(diff))
  } else {
    return(NA)
  }
}

identifyFurthestPoint = function(trajectory, errorBound) {
  p1 = trajectory[1,]
  p2 = trajectory[nrow(trajectory),]
  
  index = indexOfFurthestPoint(p1, p2, trajectory, errorBound)
  furthestPoint = trajectory[index,]
  
  # segments(x0 = p1$V1, y0 = p1$V2, x1 = p2$V1 , y1 = p2$V2, col = "red", lwd = 5)
  points(x = furthestPoint$V1, y = furthestPoint$V2, col = "green", pch = 16)
  
  return(index)
}

trajectory = read.csv("trajectory.csv", header = FALSE, sep = ",")

#for(i in 1:nrow(trajectory) - 1) {
#  
#}

# b)
errorBound = 0.005
plot(trajectory$V1, trajectory$V2)
douglasPeucker(trajectory, errorBound)