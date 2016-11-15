preprocessTrainingSet = function(trainingSet) {
  # replace observations with 0 values with the average of the observations for the same sensor
  # for (i in 1:ncol(trainingSet) - 1) {
  #  for (j in nrow(trainingSet)) {
  #    if(trainingSet[j, i] == 0) {
  #      trainingSet[j, i] = mean(trainingSet[, i])
  #    }
  #  }
  #}
  
  return(trainingSet)
} 

preprocessTestingSet = function(testingSet, trainingSet) {
  # replace observations with 0 values with the average of the observations in the training data
  # average = mean(trainingSet)
  # testingSet[testingSet == 0] = average
  
  return(testingSet)
} 

calculateAverageDistances = function(trainingSet) {
  for (i in min(trainingSet[, 40]):max(trainingSet[, 40])) {
    observationsForCurrentGrid = trainingSet[ which(trainingSet[,40] == i), ]
    
    if(i == 1) { # create container
      averageDistances = abs(colMeans(observationsForCurrentGrid))
    } else { # append to container
      averageDistances = rbind(averageDistances, abs(colMeans(observationsForCurrentGrid)))
    }
  }
  
  return(averageDistances)
}

calculateClosestDistance = function(averageDistances) {
  closestDistance = c() # will contain three columns: the minimum index of the antenna that is closest; the minimum distance to the antenna; and the grid index id
  for (i in 1:nrow(averageDistances)) {
    min = averageDistances[i, 1]
    minIndex = 1
    
    for(j in 2:ncol(averageDistances) - 1) {
      if(min > averageDistances[i, j]) {
        min = averageDistances[i, j]
        minIndex = j
      }
    }
    
    closestDistance = c(closestDistance, minIndex, min, i)
  }
  closestDistance = matrix(data = closestDistance, ncol = 3, byrow = TRUE)
  colnames(closestDistance) <- c("ClosestAntenna","MinimumDistanceToAntenna", "GridIndex")
  
  return(closestDistance)
}

trainingSet = read.csv("training_set.csv", header = FALSE, sep = ",")
trainingSet = preprocessTrainingSet(trainingSet)

#averageDistances = calculateAverageDistances(trainingSet)
#closestDistance = calculateClosestDistance(averageDistances)


testingSet = read.csv("testing_set.csv", header = FALSE, sep = ",")
testingSet = preprocessTestingSet(testingSet, trainingSet)