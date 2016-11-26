require(geosphere)

preprocessData = function(data) {
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

estimate_mode <- function(x) {
  d <- density(x)
  d$x[which.max(d$y)]
}

data = read.csv("velocity_pruning.csv", header = TRUE, sep = ",")
data = preprocessData(data)

par(mfrow = c(1,2))
plot(x = data$longitude, y = data$latitude)

velocityTreshold = round(estimate_mode(data$velocity), 1)
plot(x = data$longitude[ which(data$velocity < velocityTreshold)], y = data$latitude[ which(data$velocity < velocityTreshold)])