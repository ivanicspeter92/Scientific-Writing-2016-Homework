library(geosphere)

preprocessData = function(data) {
  minimumSatellites = 3
  maximumHDOP = 6
  
  par(mfrow=c(2, 2))
  plot(x = data[1:2])
  data = data[which(data[,4] >= minimumSatellites),]
  plot(x = data[1:2])
  data = data[which(data[,5] <= maximumHDOP),]
  plot(x = data[1:2])
  data = removeOutliers(data)
  plot(x = data[1:2])
  
  return(data)
}

removeOutliers = function(data) {
  rangeTreshold = 500 #meters
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