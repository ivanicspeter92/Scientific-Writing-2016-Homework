library(truncnorm)

particles = read.csv("particles.csv", header = TRUE, sep = ",")
movements = rtruncnorm(n = nrow(particles), a = 0.5, b = 1.5)
