data = read.csv("ex_1_data.csv", header = F)

sprintf("D=%d, N=%d", nrow(data), ncol(data))

L = 2
X = cov(data)
eigen = eigen(X)

eigen$values
eigen$vectors

W = t(eigen$vectors[1:L,])
reduced_data =  as.matrix(data) %*% W

# plot(data)
# title(main = "The original dataset", xlab="", ylab="", line = 3)
plot(reduced_data, xlab="X", ylab="Y")
title(main = "The dataset projected to the first L=2 eigenvectors", line = 3)
