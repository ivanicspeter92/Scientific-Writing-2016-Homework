coordinates = read.csv("coordinates.csv", sep = ",", header = T)

distances = dist(rbind(coordinates))
