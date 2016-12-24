measurements = read.csv("location_measurements.csv", header = F, sep = ",")
# c) 
distances = dist(measurements)

k = 4
#sort(distances)
sort(distances)[k]

# d)
library(dbscan)
results = dbscan(measurements, eps = 0.15, minPts = 4)