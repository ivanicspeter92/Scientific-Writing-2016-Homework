loss = function(x, y, theta) {
  return(sum((t(theta) * x - y) ^ 2) / nrow(x))
}

lossGradient = function(x, y, theta) {
  return(2 / nrow(x) * sum((t(theta) * x - y) * x))
}

data = read.csv(file = "exercise_2_2_train.csv", header = FALSE)

x = data[,1:10]
y = data[,11]
theta = rep(0, length(x))

gradientDescent = function(x, y, theta, stepsize = 0.5) {
  stepCount = 0

  while(stepCount < 500) {
    theta = theta - stepsize * lossGradient(x, y, theta)
    stepCount = stepCount + 1
    minimum = theta
  }
  
  return(list(minimum = minimum, "stepCount" = stepCount))
}

