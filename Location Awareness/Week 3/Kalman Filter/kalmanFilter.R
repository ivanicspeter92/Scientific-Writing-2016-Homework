measurements = read.csv("noisyCompass.csv", header = FALSE)

#configuration
sigma = 1.25 * 10 ^ -4
Q = sigma * diag(x = 1, ncol = 3, nrow = 3)
A = diag(x = 1, ncol = 3, nrow = 3)
R = 0.15 * diag(x = 1, ncol = 3, nrow = 3)

# predict
predict = function(measurements, A, Q) {
  covarianceMatrix = cov(measurements) # P
  means = colMeans(measurements) # m

  mPredict = A %*% means
  pPredict = A %*% (covarianceMatrix %*% t(A)) + Q
  return(c(mPredict, pPredict))
}
#update
update = function(mPredict, pPredict) {
  covarianceResidual = solve(A %*% pPredict %*% t(A))
  kalmanGain = pPredict %*% t(A) %*% covarianceResidual
  trueM = mPredict + (kalmanGain %*% (measurements - (A %*% mPredict)))
  trueP = pPredict - (kalmanGain %*% pPredict %*% t(A))
  
  return(c(trueM, trueP))
}