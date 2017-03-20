reconstructionError = function(data, L, plot = FALSE) {
  X = cov(data)
  eigen = eigen(X)
  
  W = eigen$vectors[1:L,]
  reduced_data = as.matrix(data) %*% t(W)
  
  if(plot) {
    plot(reduced_data, xlab="X", ylab="Y", pch = 4)
    title(main = "The dataset projected to the first L=2 eigenvectors", line = 3)
  }
  
  backwardProjection = reduced_data %*% W 
  error = sum((data - backwardProjection)^2)
  
  return(error)
}

data = read.csv("ex_1_data.csv", header = F)
sprintf("D=%d, N=%d", nrow(data), ncol(data))

L = 2
reconstructionError(data = data, L = L, plot = TRUE)

reconstructionErrors = c()

for (i in L:ncol(data)) {
  reconstructionErrors = c(reconstructionErrors, reconstructionError(data = data, L = i))
}

plot(x = L:ncol(data), y = reconstructionErrors, type = "line", xlab="L", ylab="Reconstruction error", xaxt = "n")
points(x = L:ncol(data), y = reconstructionErrors)
axis(side = 1, at = c(1:5))
title(main = "The reconstruction error in terms of reduced dimensions", line = 3)
