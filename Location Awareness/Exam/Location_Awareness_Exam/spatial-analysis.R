library(geosphere)
library(ggmap)

preprocessData = function(data, minimumSatellites = 3, maximumHDOP = 6, rangeTreshold = 50) {
  data = data[which(data$satellites >= minimumSatellites),]
  data = data[which(data$HDOP <= maximumHDOP),]
  data = removeOutliers(data, rangeTreshold)
  
  return(data)
}

removeOutliers = function(data, rangeTreshold) {
  booleanIndicators = rep(FALSE, nrow(data)) # for each index contains TRUE if the point has a neighbour in the given treshold, FALSE otherwise
  
  for(i in 1:nrow(data)) {
    p1 = c(data[i,]$longitude, data[i,]$latitude)
    
    for(j in i:nrow(data)) {
      if(booleanIndicators[j] == FALSE && i != j) { # skip already processed lines
        p2 = c(data[j,]$longitude, data[j,]$latitude)
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

kmeans = function(data, k) {
  clusterAssignments = round(runif(n = nrow(data), min = 1, max = k)) # initially random clusters for datapoints
  previousCenters = rep(-1, k)
  clusterMiddlePoints = getClusterMiddlePoints(data, clusterAssignments)
  
  while (previousCenters != clusterMiddlePoints) { # while no change in middle points
    previousCenters = clusterMiddlePoints
    
    plot(x = data$X, y = data$Y, col = clusterAssignments, pch = 16)
    points(x = clusterMiddlePoints$X, y = clusterMiddlePoints$Y, col = (order(clusterAssignments) - 1), pch = 3, lwd = 5)
    
    clusterAssignments = getClosestClusterIndexes(data, clusterMiddlePoints)
    clusterMiddlePoints = getClusterMiddlePoints(data, clusterAssignments)
  }
  return(clusterMiddlePoints)
}

getClusterMiddlePoints = function(data, clusterAssignments) {
  numberOfUniqueClusters = length(unique(clusterAssignments))
  
  clusterMiddlePoints = matrix(data = NA, ncol = 2, nrow = numberOfUniqueClusters)
  
  for (i in 1:numberOfUniqueClusters) {
    clusterPoints = data[which(clusterAssignments == i),]
    clusterMiddlePoints[i,] = getMiddlePoint(clusterPoints)
  }
  
  colnames(clusterMiddlePoints) = c("X", "Y")
  return(data.frame(clusterMiddlePoints))
}

getMiddlePoint = function(points) {
  middlePoint = matrix(colMeans(points), ncol = 2)
  return(middlePoint)
}

addVelocityBetweenPoints = function(data) {
  data$distance = 0
  data$velocity = 0
  
  for (i in 2:nrow(data)) {
    p1 = c(data[i - 1,]$latitude, data[i - 1,]$longitude)
    p2 = c(data[i,]$latitude, data[i,]$longitude)
    elapsedTime = data[i,]$time - data[i - 1,]$time
    
    data[i,]$distance = distCosine(p1 = p1, p2 = p2) # meters
    data[i,]$velocity = data[i,]$distance / elapsedTime # meters/sec
  }
  
  return(data)
}

getClosestClusterIndexes = function(data, clusterMiddlePoints) {
  clusterAssignments = rep(-1, nrow(data))
  
  for (i in 1:nrow(data)) {
    distances = eucledianDistance(clusterMiddlePoints, data[i,])
    clusterAssignments[i] = which.min(distances)
  }
  
  return(clusterAssignments)
}

eucledianDistance = function(p1, p2) {
  return(sqrt((p1$X - p2$X) ^ 2 + (p1$Y - p2$Y) ^ 2))
}

estimate_mode <- function(x) {
  d <- density(x)
  d$x[which.max(d$y)]
}

measurements = read.csv("buenosaires.csv", header = F)
names(measurements) = c("longitude", "latitude", "timestamp", "satellites", "HDOP")

# a)
plot(x = measurements$longitude, y = measurements$latitude)
measurements = preprocessData(measurements)
plot(x = measurements$longitude, y = measurements$latitude)
#write.csv(as.vector(measurements), file = "buenosaires_pruned.csv", row.names = FALSE)

# b)
temp = measurements[,1:2]
names(temp) = c("X", "Y")
kmeans(temp, 3)
rm(temp)

# c)
measurements = addVelocityBetweenPoints(measurements) # meters/sec

velocityTreshold = 1  # meters/sec
#velocityTreshold = round(estimate_mode(measurements$velocity), 1) # mode of observations, meters/sec

prunedPoints = data.frame(matrix(data = c(measurements$longitude[ which(measurements$velocity < velocityTreshold)], measurements$latitude[ which(measurements$velocity < velocityTreshold)]),ncol = 2))
names(prunedPoints) = c("longitude", "latitude")
plot(x = prunedPoints$longitude, y = prunedPoints$latitude)
