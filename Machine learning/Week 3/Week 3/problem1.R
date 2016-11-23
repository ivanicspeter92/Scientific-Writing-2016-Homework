library(MASS)

getCorrelationCoefficient = function(xr, xs) {
  result = cov(xr, xs) / sqrt(cov(xr, xr) * cov(xs, xs))
  
  return(result)
}

p = 2
variances = c(2.0, 3.0)
means = c(0, 0)
covarianceMatrix = matrix(c(2, -1.83,-1.83, 3), nrow = 2)
correlation_coefficient = -0.75
n = 400

x = mvrnorm(n = n, mu = means, Sigma = covarianceMatrix)
plot(x)
cor(x[,1], x[,2])
cov(x[,1], x[,2])

#b)
dataDensity = kde2d(x[,1], x[,2])
image(dataDensity)
persp(dataDensity)
contour(dataDensity)
