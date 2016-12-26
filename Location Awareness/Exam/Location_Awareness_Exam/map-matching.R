calculateIntervals = function(measurements) {
  for (i in 2:nrow(measurements)) {
    measurements[i,]$interval = measurements[i,]$time_stamp - measurements[i - 1,]$time_stamp
  }
  
  return(measurements)
}

areTheSamePosition = function(p1, p2) {
  if(p1$latitude == p2$latitude || p1$longitude == p2$longitude) {
    return(TRUE)
  }
    
  return(FALSE)
}

interpolate = function(measurements) {
  new_measurements = data.frame(matrix(data = NA, ncol = 4))
  colnames(new_measurements) = colnames(measurements)
  
  for (i in 2:(nrow(measurements) - 1)) {
    if(areTheSamePosition(measurements[i - 1, ], measurements[i, ]) == FALSE) {
      newpointsneeded = floor(measurements[i,]$interval / 10)
      
      if(newpointsneeded > 1) {
        range = (i - 1):i
        
        newpoints = approx(x = measurements[range,]$longitude, y = measurements[range, ]$latitude, n = newpointsneeded + 2)
        # dropping first and last prediction (they are already in dataset)
        newpoints$x = newpoints$x[2:(length(newpoints$x) - 1)]
        newpoints$y = newpoints$y[2:(length(newpoints$y) - 1)]
        
        for (i in 1:length(newpoints$x)) {
          new_measurements = rbind(new_measurements, c(longitude = newpoints$x[i], latitude = newpoints$y[i], time_stamp = min(measurements[range,]$time_stamp) + i * 10, interval = 0))
        }
      }
    }
  }
  new_measurements = new_measurements[-c(1), ] # removing the first line of NA values
  return(new_measurements)
}

measurements = read.csv("cabspotting_trace.csv", header = T, sep = ",")
measurements = cbind(measurements, interval = 0)
measurements = calculateIntervals(measurements)

plot(measurements$longitude, measurements$latitude, pch = 16)

new_measurements = interpolate(measurements)
points(x = new_measurements$longitude, y = new_measurements$latitude, col = "red", pch = 16)

measurements = rbind(measurements, new_measurements) # concatenating measurements
measurements = measurements[order(measurements$time_stamp),] # ordering data by time_stamp
measurements = calculateIntervals(measurements)