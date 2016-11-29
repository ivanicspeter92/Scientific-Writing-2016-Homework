probabilities = c(0.4, 0.3, 0.3)

prob_c0 = c(0.2, 0.1, 0.4, 0.2, 0.0, 0.1)
prob_c1 = c(0.6, 0.1, 0.1, 0.1, 0.1, 0.0)
prob_c2 = c(0.1, 0.4, 0.3, 0.0, 0.2, 0.0)

classProbabilities = matrix(c(prob_c0, prob_c1, prob_c2), nrow = 3, byrow = TRUE)

feature_values = c()
n = 100

for (i in 1:n) {
  class = sample(1:length(probabilities), 1, replace = TRUE, prob = probabilities)
  x = expand.grid(0:1, 0:2)[sample(1:6, 1, replace = TRUE, prob = classProbabilities[class,]),]
  
  feature_values = c(feature_values, class, x)
}
feature_values = matrix(data = feature_values, ncol = 3)
nrow(feature_values[which(feature_values[,1] == 0)])
nrow(feature_values[which(feature_values[,2] == 0 & feature_values[,3] == 0), ])