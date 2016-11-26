getProbabilityMatrix = function(sequence, symbols, q = 1) {
  matrix = countOccurrances(sequence, symbols, q)
  matrix = normalizeByRow(matrix)
  
  return(matrix)
}

countOccurrances = function(sequence, symbols, q = 1) {
  matrix = matrix(data = 0, nrow = length(symbols), ncol = length(symbols))
  
  for (i in 2:nchar(sequence)) {
    previousState = substr(sequence, i - q, i - q)
    currentState = substr(sequence, i, i)
    
    matrix[indexOf(previousState, symbols), indexOf(currentState, symbols)] = matrix[indexOf(previousState, symbols), indexOf(currentState, symbols)] + 1
  }
  
  return(matrix)
}

normalizeByRow = function(matrix) {
  for (i in 1:nrow(matrix)) {
    matrix[i, ] = matrix[i, ] / sum(matrix[i, ])
  }
  
  return(matrix)
}

indexOf = function(value, inArray) {
  indices = which(inArray == value)
  
  return(indices)
}

lastCharacter = function(string) {
  return(substr(string, nchar(string), nchar(string)))
}

sequence = "HWSWSHWHSHSWHWHWSWSHSWHSWSSHWHWHWS"
symbols = c("H", "W", "S")

orderOneMatrix = round(getProbabilityMatrix(sequence, symbols, q = 1), 2)
orderTwoMatrix = round(getProbabilityMatrix(sequence, symbols, q = 2), 2)

currentPosition = "S"

orderOneMatrix[indexOf(lastCharacter(sequence), symbols), indexOf(currentPosition, symbols)]
orderTwoMatrix[indexOf(lastCharacter(sequence), symbols), indexOf(currentPosition, symbols)]

sequence = paste(sequence, "W", sep = "") # modifying last item in the sequence to be Work
orderOneMatrix = round(getProbabilityMatrix(sequence, symbols, q = 1), 2)
orderTwoMatrix = round(getProbabilityMatrix(sequence, symbols, q = 2), 2)


orderOneMatrix[indexOf(lastCharacter(sequence), symbols), indexOf(currentPosition, symbols)]
orderTwoMatrix[indexOf(lastCharacter(sequence), symbols), indexOf(currentPosition, symbols)]
