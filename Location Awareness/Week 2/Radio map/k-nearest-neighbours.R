kNearestNeighbours = function(signalStrength, points, k = 1, weighted = FALSE) {
  differences = matrix(c(points$SS1 - signalStrength[1], points$SS2 - signalStrength[2]), ncol = 2)
  
  averageDifferences = matrix(data = c(1:nrow(differences), rowMeans(differences)), ncol = 2)
  averageDifferences = averageDifferences[order(averageDifferences[,2]),] # sorting measurements by differences
  
  indexOfClosestKmeasurements = head(averageDifferences[,1], k)
  result = points[indexOfClosestKmeasurements[1:k],]
  
  return(result)
}

estimatePosition = function(signalStrength, points, k = 1, weighted = FALSE, highlightNeighboursOnPlot = FALSE, neighbourColor = "green") {
  kNearestNeighbours = kNearestNeighbours(signalStrength = signalStrength, points = points, k = k, weighted = weigthed)
  
  if (highlightNeighboursOnPlot) {
    points(x = kNearestNeighbours$X, y = kNearestNeighbours$Y, col = neighbourColor, pch = 16)
  }
  return(c(mean(kNearestNeighbours$X), mean(kNearestNeighbours$Y)))
} 

measurements = read.csv("radio_map.csv", header = TRUE, sep = ";")
plot(x = measurements$X, y = measurements$Y)

k = 3
mySinglalStrength = c(-74, -80)

myPosition = estimatePosition(signalStrength = mySinglalStrength, points = measurements, k = k, highlightNeighboursOnPlot = TRUE)
points(x = myPosition[1], y = myPosition[2], col = "red", pch = 4)

k = 4

myPosition = estimatePosition(signalStrength = mySinglalStrength, points = measurements, k = k, weighted = TRUE)
points(x = myPosition[1], y = myPosition[2], col = "blue", pch = 4)
