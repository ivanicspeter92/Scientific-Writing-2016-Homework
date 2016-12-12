loadPrunedMeasurements = function(range) {
  measurements = matrix(ncol = 4)
  
  for (i in 1:length(range)) {
    dataset = as.matrix(read.csv(paste("paths/", as.character(range[i]), ".csv", sep = ""), header = F))
    measurements = rbind(measurements, dataset[1,])
    
    for(j in 2:nrow(dataset)) {
      if(dataset[j, 4] != measurements[nrow(measurements), 4])
        measurements = rbind(measurements, dataset[j, ])
    } 
  }
  
  return(measurements[2:nrow(measurements), ])
}

measurements = loadPrunedMeasurements(1:50)
plot(x = measurements[,2], y = measurements[,3], xlab = "x", ylab = "y")