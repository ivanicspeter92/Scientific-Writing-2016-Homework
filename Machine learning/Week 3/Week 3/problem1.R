library(MASS)

getCorrelationCoefficient = function(xr, xs) {
  result = cov(xr, xs) / sqrt(cov(xr, xr) * cov(xs, xs))
  
  return(result)
}

p = 2
variances = c(2.0, 3.0)
means = c(0, 0)
correlation_coefficient = -0.75
n = 200

x = mvrnorm(n = n, mu = means, Sigma = variances)