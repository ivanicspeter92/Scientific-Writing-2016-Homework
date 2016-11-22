library(truncnorm)

getNewParticles = function(particles, mean = 0.5, sd = 1.5) {
  newparticles = c()
  for (i in 1:nrow(particles)) {
    distance = abs(rnorm(n = 1, mean = mean, sd = sd))
    weight = getUpdatedWeigth(particles[i,], distance)
    
    newparticles = c(newparticles, weight, distance)
  }
  
  newparticles = matrix(newparticles, ncol = 2, byrow = TRUE)
  return(newparticles)
}

getUpdatedWeigth = function(particle, distance) {
  return((distance * particle$Weight) / particle$Distance)
}

needsResampling = function(weights, treshold) {
  if(treshold > sum(weights ^ 2)) {
    return(FALSE)
  }
  return(TRUE)
}

particles = read.csv("particles.csv", header = TRUE, sep = ",")

# a)
newparticles = getNewParticles(particles)

#b) 
neffTreshold = 2
"Needs resampling?"
needsResampling(weights = newparticles[1,], treshold = neffTreshold)

#c)
newparticles = getNewParticles(particles, mean = 0.5, sd = 0.5)
"Needs resampling?"
needsResampling(weights = newparticles[1,], treshold = neffTreshold)