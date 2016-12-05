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

totalDistance = sum(data$Distance)

hcr = pc / (totalDistance / unitDistance)
sr = ps / (totalDistance / unitDistance)
vcr = pv / (totalDistance / unitDistance)

#b)
mode1 = read.csv("mode1.csv", header = FALSE)
mode2 = read.csv("mode2.csv", header = FALSE)

means1 = colMeans(mode1)
means2 = colMeans(mode2)

strongestAccessPoint1 = as.numeric(which.max(means1))
strongestAccessPoint2 = as.numeric(which.max(means2))

sigma1 = var(mode1[, strongestAccessPoint1])
sigma2 = var(mode2[, strongestAccessPoint2])

intensities1 = colSums(mode1)
variances1 = apply(mode1, 2, var)
mean(intensities1)
mean(variances1)

intensities2 = colSums(mode2)
variances2 = apply(mode2, 2, var)
mean(intensities2)
mean(variances2)
