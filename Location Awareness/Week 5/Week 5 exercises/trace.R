calculateDifferences =  function(shortestPaths) {
  diff = c()
  for(i in 1:(nrow(shortestPaths) - 1)) {
    
    diffX = shortestPaths[i,]$V1 - shortestPaths[i + 1,]$V1
    diffY = shortestPaths[i,]$V2 - shortestPaths[i + 1,]$V2
    
    value = atan(diffX / diffY)
    if (!is.na(value))
      diff = c(diff, value)
  }
  
  return(round(diff,2))
}

countSegments = function(differences) {
  count = 0
  
  for (i in 1:(length(differences) - 1)) {
    if(differences[i] == differences[i + 1]) {
      count = count + 1
    }
  }
  return(count)
}

shortestPaths = read.csv("trace.csv", header = FALSE, sep = ",")
diff = calculateDifferences(shortestPaths)
segments = countSegments(diff)