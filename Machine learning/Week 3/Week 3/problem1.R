library(MASS)

getCorrelationCoefficient = function(xr, xs) {
  result = cov(xr, xs) / sqrt(cov(xr, xr) * cov(xs, xs))
  
  return(result)
}

#x is an n by p matrix, mu should be 1 by p, szigma is p by p. 
gaussianDensity = function(x,mu,szigma) { 
  p = dim(szigma)[1]; 
  return( diag( 1/( (2*pi)^(p/2) * det(szigma)^(1/2) ) * exp( (-1/2)* (x-mu)%*%solve(szigma)%*%t(x-mu) ) ) ) 
  # constant so far #this gives a huge matrix but we only need the diagonals 
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

#c)
grid = as.matrix(expand.grid(0.25 * (-20:20), 0.25 * (-20:20)))
matrix = c()

groundTruthDensity = gaussianDensity(grid,means,covarianceMatrix)
kernelDensity = matrix(groundTruthDensity,nrow = 41)

contour(kernelDensity)
image(kernelDensity)
persp(kernelDensity)
