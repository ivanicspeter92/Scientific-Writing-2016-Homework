loss = function(x, y, theta) {
  return(sum((t(theta) * x - y) ^ 2) / nrow(x))
}

lossGradient = function(x, y, theta) {
  return(2 / nrow(x) * sum((t(theta) * x - y) * x))
}

gradientDescent = function(x, y, theta, method, stepsize = 0.5) {
  switch(method, 
         "erm" = return(gradientDescentERM(x, y, theta, stepsize)),
         "earlystopping" = return(gradientDescentEarlyStopping(x, y, theta, stepsize))
       )
}

isGradientUnderThreshold = function(gradient){
  return(sum(gradient^2) > 10^-6)
}

gradientDescentERM = function(x, y, theta, stepsize = 0.5, condition) {
  stepCount = 1
  gradient = lossGradient(x, y, theta)
  gradientValues = c(gradient)
  
  while(condition(gradient)) {
    theta = theta - stepsize * gradient
    stepCount = stepCount + 1
    gradient = lossGradient(x, y, theta)
    gradientValues = c(gradientValues, gradient)
  }

  return(list(minimum = theta, "stepCount" = stepCount, "gradientValues" = gradientValues))
}

gradientDescentEarlyStopping = function(x, y, theta, stepsize = 0.5) {
  portion = 1 / 10 * nrow(x) # the optimization is found on this portion, the rest of the data is used for validation loss calculation
  
  indexes = 1:portion
  validationIndexes = portion:nrow(x) 
  
  stepCount = 1
  gradient = lossGradient(x, y, theta)
  gradientValues = c(gradient)
  validationLoss = c(loss(x[validationIndexes,], y[validationIndexes], theta))
  
  while(loss(x[validationIndexes,], y[validationIndexes], theta) >= validationLoss) {
    newLoss = loss(x[validationIndexes,], y[validationIndexes], theta)
    theta = theta - stepsize * gradient
    stepCount = stepCount + 1
    gradient = lossGradient(x[indexes,], y[indexes], theta)
    gradientValues = c(gradientValues, gradient)
    validationLoss = c(validationLoss, loss(x[validationIndexes,], y[validationIndexes], theta))
  }
  
  return(list(minimum = theta, "stepCount" = stepCount, "gradientValues" = gradientValues))
}

data = read.csv(file = "exercise_2_2_train.csv", header = FALSE)

x = data[,1:10]
y = data[,11]
theta = rep(0, ncol(x))

resultERM = gradientDescent(x[1:50,],y[1:50],theta, method = "erm")
resultEarlyStop = gradientDescent(x, y, theta, method = "earlystopping")
