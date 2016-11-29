extendedTanimoto = function(A, B) {
  nominator = sum(A * B)
  return(nominator / (sum(A ^ 2) + sum(B ^ 2) - nominator))
}

getLikelihoods = function(data) {
  likelihoods = matrix(data = 0, nrow = ncol(data), ncol = ncol(data))
  
  for (i in 1:ncol(data)) {
    for (j in 1:i) {
      likelihoods[j,i] = extendedTanimoto(data[,i], data[,j])
    }
  }
  
  likelihoods = round(likelihoods, 2)
  return(likelihoods)
}

getResponseRateVector = function(data) {
  result = c()
  j = 1
  for(i in seq(from = 1, to = nrow(data), by = 2)) {
    for (j in 1:ncol(data)) {
      n = length(data[i,j]) + length(data[i + 1,j])
      ni = length(data[i,j][which(data[i,j] != 0)]) + length(data[i + 1,j][which(data[i + 1,j] != 0)])
      
      result = c(result, ni / n) 
    }
  }
  return(matrix(result, ncol = ncol(data)))
}

# a)
data = read.csv("rssVals.csv", header = FALSE, sep = ",")
likelihoods = getLikelihoods(data)

# b) 
responseRateVector = getResponseRateVector(data)
