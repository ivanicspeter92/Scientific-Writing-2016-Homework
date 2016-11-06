fitModel = function(x, y, degree) {
  if(degree == 1) {
    regression = lm(x ~ y)
    coefficients = coef(regression)
    
    return(coefficients[1] + coefficients[2] * x)
  }
}

x = runif(30, -3, 3)
y = 2 + x - 0.5 * x ^ 2
errors = rnorm(n = 30, mean = 0, sd = 0.4)
y = y + errors

plot(x, y)

linearmodel = fitModel(x = x, y = y, degree = 1)
lines(x, linearmodel, col='green', lwd=5)