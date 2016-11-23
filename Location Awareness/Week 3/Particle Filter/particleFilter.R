library(truncnorm)

getNewParticles = function(particles, mean = 0.5, sd = 1.5) {
  newparticles = c()
  for (i in 1:nrow(particles)) {
    weight = getUpdatedWeight(particles[i,], mean = mean, sd = sd)
    newparticles = c(newparticles, weight, particles[i,]$Distance)
  }
  
  newparticles = matrix(newparticles, ncol = 2, byrow = TRUE)
  return(newparticles)
}

getUpdatedWeight = function(particle, mean, sd) {
  probabilty = dnorm(x = particle$Distance, mean = mean, sd = sd)
  return(particle$Weight * probabilty)
}

normalizeWeights = function(weights) {
  sum = sum(weights)
  for (i in 1:length(weights)) {
    weights[i] = weights[i] / sum
  }
  
  return(weights)
}

needsResampling = function(weights, treshold) {
  if(treshold < numberOfEffectiveParticles(weights)) {
    return(FALSE)
  }
  return(TRUE)
}

numberOfEffectiveParticles = function(weights) {
  return(1 / sum(weights ^ 2))
}


particles = read.csv("particles.csv", header = TRUE, sep = ",")

# a)
newparticles = getNewParticles(particles)
newparticles[,1] = normalizeWeights(newparticles[,1])

#b) 
neffTreshold = 2.0
"Needs resampling?"
needsResampling(weights = newparticles[,1], treshold = neffTreshold)

#c)
newparticles = getNewParticles(particles, mean = 0.5, sd = 0.5)
newparticles[,1] = normalizeWeights(newparticles[,1])
"Needs resampling?"
needsResampling(weights = newparticles[,1], treshold = neffTreshold)