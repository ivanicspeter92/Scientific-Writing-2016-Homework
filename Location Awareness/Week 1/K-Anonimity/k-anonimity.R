# Peter Ivanics
# 05.11.2016.
# University of Helsinki

# install.packages(plotrix) # execute if plotrix is not installed
require(plotrix)

getUserCoordinatesAsNumber = function(user) {
  return (c(as.numeric(user$x), as.numeric(user$y)))
}

plotPoints = function(points) {
  plot(points$x, points$y, col='red', pch=16, xlab = "X", ylab = "Y", xlim = c(0, 100), ylim = c(0, 100))
  text(x = points$x, y = points$y, labels = points$user, cex = 0.75, pos = 4)
  grid()
}

isInCircle = function(point, middle, radius) {
  dx = abs(point[1] - middle[1])
  dy = abs(point[2] - middle[2])
  
  if (dx * dx + dy * dy <= radius * radius) {
    return(TRUE)
  } else { 
    return(FALSE)
  }
}

drawCircle = function(x, y, radius, col = "black") {
  alpha = seq(0, 2.1 * pi, by = 0.1);
  lines(x + radius * cos(alpha), y + radius * sin(alpha), col = col)
}

# loading data
data = read.csv("user_coordinates.csv", header = TRUE, sep = ";")

# configuration
middleUserIndex = 1
middleUser = data[middleUserIndex,]
middleUserCoordinates = getUserCoordinatesAsNumber(middleUser)
errorRate = 42

# visualization
plotPoints(data)
drawCircle(x = middleUserCoordinates[1], y = middleUserCoordinates[2], r = errorRate, col = "red")
drawCircle(x = middleUserCoordinates[1], y = middleUserCoordinates[2], r = errorRate / 2, col = "green")

# counting users in the given range
counter = 0
for (i in 1:nrow(data)) {
  nextUserCoordinates = getUserCoordinatesAsNumber(user = data[i,])
  
  if(isInCircle(point = nextUserCoordinates, middle = middleUserCoordinates, radius = errorRate)) {
    counter = counter + 1
  }
}

sprintf("There are %d users in the error range (%d) from user %d", counter, errorRate, middleUserIndex)