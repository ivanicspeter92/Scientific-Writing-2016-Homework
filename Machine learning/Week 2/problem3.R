#install.packages("proxy") 
require(proxy)

reduceData = function(data, toNumberOfItems) {
  data$n = toNumberOfItems
  data$x = data$x[1:data$n, 1:784]
  data$y= data$y[1:data$n]
  
  return(data)
}

# a 
show_digit(train$x[5,]) # display the 5th instance (letter a or number 9)
train$y[5] # printing the correct value

# b
train = reduceData(train, 5000)
test = reduceData(test, 1000)

#eucledianDistances = dist(train$x, test$x)
#eucledianDistances[1,1]

# c
accuracies = c()
correctClassifications = c()
for (k in 1:50) { # looping through finding the kNNs
  correctClassifications = c(correctClassifications, 0)
  totalClassifications = ncol(eucledianDistances)
  
  for(j in 1:totalClassifications) { # looping through the test results
    indexVector = order(eucledianDistances[,j])
    indexOfKNearestNeighbours = indexVector[1:k]
    classesOfNearNeighbours = train$y[indexOfKNearestNeighbours]
    
    majorityClass = names(sort(table(classesOfNearNeighbours), decreasing=TRUE))[1]
    if (majorityClass == test$y[j]) {
      correctClassifications[k] = correctClassifications[k] + 1
    }
  }
  
  accuracies = c(accuracies, correctClassifications[k] / totalClassifications)
}
plot(x = 1:length(accuracies), y = accuracies)
