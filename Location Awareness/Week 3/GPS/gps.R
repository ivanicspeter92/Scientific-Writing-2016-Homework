require(proxy)

getDOPMatrix = function(receiver_coordinates, satellite_coordinates) {
  dop = c()
  
  for (i in 1:nrow(satellite_coordinates)) {
    r = as.numeric(dist(receiver_coordinates, satellite_coordinates[i,]))
    
    dop = c(dop,(satellite_coordinates[i,1] - receiver_coordinates[1]) / r)
    dop = c(dop,(satellite_coordinates[i,2] - receiver_coordinates[2]) / r)
    dop = c(dop,(satellite_coordinates[i,3] - receiver_coordinates[3]) / r)
    dop = c(dop, -1)
  }
  
  dop = matrix(unlist(dop), ncol = 4, byrow = TRUE)
  return(dop)
}

ecef_coordinates = read.csv("ecef_coordinates.csv", header = FALSE, sep = ",")
receiver_coordinates = ecef_coordinates[1, ]
satellite_coordinates = ecef_coordinates[2:6, ]

# a) 
dopMatrix = getDOPMatrix(receiver_coordinates, satellite_coordinates)

particles = read.csv("particles.csv", header = TRUE, sep = ",")

