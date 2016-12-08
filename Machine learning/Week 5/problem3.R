require(e1071)
library(ISLR)
data("OJ")

generateCoordinates = function(n) {
  x = rnorm(n = n, mean = 0, sd = 1)
  y = rnorm(n = n, mean = 0, sd = sqrt(16))
  
  return(matrix(c(x, y), ncol = 2))
}

applySVM = function(x, y, kernel = "linear", cost = 10, plot = TRUE) {
  dat = data.frame(x = x, y = as.factor(y))
  svmfit = svm(y ~ ., data = dat, kernel = kernel, cost = cost, scale = FALSE)
  
  if(plot)
    plot(svmfit, data = dat)
  return(svmfit)
}

applyPolynomialSVM = function(x, y, cost = 10, degree = 2, plot = TRUE) {
  dat = data.frame(x = x, y = as.factor(y))
  svmfit = svm(y ~ ., data = dat, kernel = "polynomial", degree = degree, cost = cost, scale = F)
  
  if(plot)
    plot(svmfit, data=dat)
  return(svmfit)
}

evaluate = function(predictionVector, realVector) {
  count = 0
  
  for (i in 1:length(predictionVector)) {
    if(predictionVector[i] == realVector[i]) {
      count = count + 1
    }
  }
  
  return(count / length(predictionVector))
}

n = 200

x = generateCoordinates(n)
classes = c(rep(-1, n / 2), rep(1, n / 2))

plot(x = x, col= (3 - classes))

model = applySVM(x, classes)
prediction = predict(model)
evaluate(prediction, classes)

model = applyPolynomialSVM(x, classes, degree = 2)
prediction = predict(model)
evaluate(prediction, classes)

n = 10
x = generateCoordinates(n)
x[(n / 2 + 1):n,] = x[(n / 2 + 1):n,] * x[( n / 2 + 1):n,] # raising every point in the second half to the power of 2

model = applySVM(x, classes)
prediction = predict(model)
evaluate(prediction, classes)

model = applyPolynomialSVM(x, classes, degree = 2)
prediction = predict(model)
evaluate(prediction, classes)

# task 8
# a)
samples = OJ[runif(800, min = 1, max = nrow(OJ)),]

# b)
x = samples[1, (names(samples) != "Purchase")]
y = samples$Purchase

model = applySVM(x = x, y = y, cost = 0.01, kernel = "linear", plot = FALSE) 
#summary(model)
prediction = predict(model)
evaluate(predictionVector = prediction, realVector = y)

model = applySVM(x = x, y = y, cost = 0.01, kernel = "radial", plot = FALSE) 
#summary(model)
prediction = predict(model)
evaluate(predictionVector = prediction, realVector = y)

model = applyPolynomialSVM(x = x, y = y, cost = 0.01, plot = FALSE, degree = 2) 
#summary(model)
prediction = predict(model)
evaluate(predictionVector = prediction, realVector = y)
