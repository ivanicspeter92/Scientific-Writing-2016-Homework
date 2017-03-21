sigmoid = function(x) {
  return(1 / (1 + exp(-1 * x)))
}

sigmoidFirstDerivate = function(x) {
  return(exp(-x) / (exp(-x) + 1)^2)
}

sigmoidSecondDerivate = function(x) {
  return(exp(x) * (exp(x) - 1) / (exp(x) + 1)^3)  
}

logloss = function(data) {
  return(- data$y * log(sigmoid(t(data$theta) * data$x) - (1 - data$y) * log(1 - sigmoid(t(data$theta) * data$x))))
}

theta = c(1, 1)
x = c(-1, 2)
y = 1

gradient = x * (sigmoid(t(theta) %*% x) - y)
hessian = (x %*% t(x)) * as.vector(sigmoidFirstDerivate(t(theta) %*% x))