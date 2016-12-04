data = read.csv("gps.csv", header = FALSE, sep = ",")
names(data) = c("Latitude", "Longitude", "Distance", "Heading", "Velocity")

headingThreshold = 40
stoppingThreshold = 0.015
velocityThreshold = 0.004
unitDistance = 1000

pc = 0
ps = 0
pv = 0

for (i in 1:(nrow(data) - 1)) {
  if((data[i,]$Heading - data[i + 1,]$Heading) >= headingThreshold) {
    pc = pc + 1
  }
  if((data[i,]$Velocity) <= stoppingThreshold) {
    ps = ps + 1
  }
  
  velocityRate = (abs(data[i + 1,]$Velocity - (data[i,]$Velocity)) / (data[i,]$Velocity))
  if(velocityRate >= velocityThreshold) {
    pv = pv + 1
  }
}

pc
ps
pv

totalDistance = sum(data$Distance)

hcr = pc / (totalDistance / unitDistance)
sr = ps / (totalDistance / unitDistance)
vcr = pv / (totalDistance / unitDistance)

hcr
sr
vcr