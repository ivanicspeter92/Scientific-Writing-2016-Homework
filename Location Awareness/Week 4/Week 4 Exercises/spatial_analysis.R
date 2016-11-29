library(geosphere)
library(ggmap)

preprocessData = function(data) {
  minimumSatellites = 3
  maximumHDOP = 6
  rangeTreshold = 500 #meters
  
  par(mfrow=c(2, 2))
  plot(x = data[1:2])
  write.csv(as.vector(data[,1:2]), file = "output/points1.csv", row.names = FALSE)
  
  data = data[which(data[,4] >= minimumSatellites),]
  plot(x = data[1:2])
  write.csv(as.vector(data[,1:2]), file = "output/points2.csv", row.names = FALSE)
  
  data = data[which(data[,5] <= maximumHDOP),]
  plot(x = data[1:2])
  write.csv(as.vector(data[,1:2]), file = "output/points3.csv", row.names = FALSE)
  
  data = removeOutliers(data, rangeTreshold)
  plot(x = data[1:2])
  write.csv(as.vector(data[,1:2]), file = "output/points4.csv", row.names = FALSE)
  
  return(data)
}

removeOutliers = function(data, rangeTreshold) {
  booleanIndicators = rep(FALSE, nrow(data)) # for each index contains TRUE if the point has a neighbour in the given treshold, FALSE otherwise
  
  for(i in 1:nrow(data)) {
    p1 = c(data[i,1], data[i,2])
    
    for(j in i:nrow(data)) {
      if(booleanIndicators[j] == FALSE && i != j) { # skip already processed lines
        p2 = c(data[j,1], data[j,2])
        distance = distm(p1, p2, fun = distHaversine)
        
        if(distance <= rangeTreshold) {
          booleanIndicators[i] = TRUE
          booleanIndicators[j] = TRUE
          break
        }
      }
    }
  }
  
  return(data[booleanIndicators,])
}

data = read.csv("tokyo.csv", header = FALSE, sep = ",")
data = preprocessData(data)

points <- data.frame(lat=data[, 2], lon = data[, 1])

map = ggmap(get_map(location = c(lon = points[1,]$lon, lat = points[1,]$lat), zoom = 12))
map = map + geom_point(data = points, aes(x = lon, y = lat), size = 1)
map
