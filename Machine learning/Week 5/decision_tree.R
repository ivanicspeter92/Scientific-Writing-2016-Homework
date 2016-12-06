data = read.csv("decision_tree.csv", header = TRUE)

impurity = function(D, type = "classificationerror") {
  Pk = D / sum(D)
  if(type == "classificationerror") {
    return(1 - max(Pk))
  } else if(type == "gini") {
    return(sum(Pk * (1 - Pk)))
  } else if(type == "entropy") {
    return(- 1 * sum(Pk * log(Pk)))
  }
}

gains = function(D1, D2, type = "classificationerror") {
  D = D1 + D2
  
  return(impurity(D, type) - 
           ((sum(D1) / sum(D)) * impurity(D1, type) + 
            (sum(D2) / sum(D)) * impurity(D2, type))
           )
}

gain = c()
gini = c()
entropy = c()
for (i in 1:nrow(data)) {
  D1 = c(data[i,]$D1Total - data[i,]$D1Correct, data[i,]$D1Correct)
  D2 = c(data[i,]$D2Total - data[i,]$D2Correct, data[i,]$D2Correct)
  gain = c(gain, gains(D1, D2))
  gini = c(gini, gains(D1, D2, type = "gini"))
  entropy = c(entropy, gains(D1, D2, type = "entropy"))
}