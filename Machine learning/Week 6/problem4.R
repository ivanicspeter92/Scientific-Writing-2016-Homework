library(MASS)

# a)
getBivariateDistributedDataPoints = function(n) {
  sigma = matrix(c(1, 0, 0, 1), ncol = 2)
  mu = c(0, 0)
  
  points = mvrnorm(n = n, mu, sigma)
  colnames(points) = c("X", "Y")
  
  return(data.frame(points))
}

kmeans = function(data, k) {
  clusterAssignments = round(runif(n = nrow(data), min = 1, max = k)) # initially random clusters for datapoints
  previousCenters = rep(-1, k)
  clusterMiddlePoints = getClusterMiddlePoints(data, clusterAssignments)
  
  while (previousCenters != clusterMiddlePoints) { # while no change in middle points
    previousCenters = clusterMiddlePoints
    
    plot(x = data$X, y = data$Y, col = clusterAssignments, pch = 16)
    points(x = clusterMiddlePoints$X, y = clusterMiddlePoints$Y, col = "blue", pch = 3, lwd = 5)
    
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

n = 200
k = 3

datapoints = getBivariateDistributedDataPoints(n = n)

middlePoints = kmeans(datapoints, k)
