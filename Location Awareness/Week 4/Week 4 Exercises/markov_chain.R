getProbabilityMatrix = function(sequence, symbols, q = 1) {
  matrix = countOccurrances(sequence, symbols, q)
  matrix = normalizeByRow(matrix)
  
  return(matrix)
}

countOccurrances = function(sequence, symbols, q = 1) {
  matrix = matrix(data = 0, nrow = length(symbols) ^ q, ncol = length(symbols))
  previousStrings = symbols
  currentStrings = c()
  if(q > 1) { 
    for(i in 1:(q - 1)) {
      for(j in 1:length(previousStrings)) {
        for(k in 1:length(symbols)) {
          currentStrings = c(currentStrings, paste(previousStrings[j], symbols[k], sep = ""))
        }
      }
    }
    previousStrings = currentStrings
  }
  
  for (i in (1 + q):nchar(sequence)) {
    previousState = substr(sequence, i - q, i - 1)
    currentState = substr(sequence, i, i)
    
    matrix[indexOf(previousState, previousStrings), indexOf(currentState, symbols)] = matrix[indexOf(previousState, previousStrings), indexOf(currentState, symbols)] + 1
  }
  
  return(matrix)
}

normalizeByRow = function(matrix) {
  for (i in 1:nrow(matrix)) {
    sum = sum(matrix[i, ])
    if(sum != 0) {
      matrix[i, ] = matrix[i, ] / sum
    }
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
