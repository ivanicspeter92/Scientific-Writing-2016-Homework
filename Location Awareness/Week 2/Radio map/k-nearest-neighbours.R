measurements = read.csv("radio_map.csv", header =TRUE, sep = ";")
plot(x = measurements$X, y = measurements$Y)

k = 5
mySinglalStrength = c(-74, -80)

differences = matrix(c(measurements$SS1 - mySinglalStrength[1], measurements$SS2 - mySinglalStrength[2]), ncol = 2)

averageDifferences = matrix(data = c(1:10, rowMeans(differences)), ncol = 2)
averageDifferences = averageDifferences[order(averageDifferences[,2]),] # sorting measurements by differences

indexOfClosestKmeasurements = head(averageDifferences[,1], k)
kNearestNeighbours = measurements[indexOfClosestKmeasurements[1:k],]

points(x = kNearestNeighbours$X, y = kNearestNeighbours$Y, col = "green", pch = 16)

myPosition = c(mean(kNearestNeighbours$X), mean(kNearestNeighbours$Y))
points(x = myPosition[1], y = myPosition[2], col = "red", pch = 4)
