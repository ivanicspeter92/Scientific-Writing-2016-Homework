estimatePosition = function(signalStrength, points, k = 1, weighted = FALSE, highlightNeighboursOnPlot = FALSE) {
  differences = matrix(c(points$SS1 - signalStrength[1], points$SS2 - signalStrength[2]), ncol = 2)
  
  averageDifferences = matrix(data = c(1:10, rowMeans(differences)), ncol = 2)
  averageDifferences = averageDifferences[order(averageDifferences[,2]),] # sorting measurements by differences
  
  indexOfClosestKmeasurements = head(averageDifferences[,1], k)
  kNearestNeighbours = points[indexOfClosestKmeasurements[1:k],]
  
  if (highlightNeighboursOnPlot) {
    points(x = kNearestNeighbours$X, y = kNearestNeighbours$Y, col = "green", pch = 16)
  }
  return(c(mean(kNearestNeighbours$X), mean(kNearestNeighbours$Y)))
} 

measurements = read.csv("radio_map.csv", header = TRUE, sep = ";")
plot(x = measurements$X, y = measurements$Y)

k = 5
mySinglalStrength = c(-74, -80)

myPosition = estimatePosition(signalStrength = mySinglalStrength, points = measurements, k = 3)
points(x = myPosition[1], y = myPosition[2], col = "red", pch = 4)
