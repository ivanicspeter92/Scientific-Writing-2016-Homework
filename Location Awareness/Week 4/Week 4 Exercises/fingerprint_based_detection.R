extendedTanimoto = function(A, B) {
  nominator = sum(A * B)
  return(nominator / (sum(A ^ 2) + sum(B ^ 2) - nominator))
}

data = read.csv("rssVals.csv", header = FALSE, sep = ",")
likelihoods = matrix(data = 0, nrow = ncol(data), ncol = ncol(data))

for (i in 1:ncol(data)) {
  for (j in 1:i) {
    likelihoods[j,i] = extendedTanimoto(data[,i], data[,j])
  }
}
likelihoods = round(likelihoods, 2)