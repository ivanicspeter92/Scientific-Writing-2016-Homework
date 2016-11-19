require(proxy)
require(MASS)

getDOPMatrix = function(receiver_coordinates, satellite_coordinates) {
  dop = c()
  
  for (i in 1:nrow(satellite_coordinates)) {
    r = as.numeric(dist(receiver_coordinates, satellite_coordinates[i,]))
    
    dop = c(dop,(satellite_coordinates[i,1] - receiver_coordinates[1]) / r)
    dop = c(dop,(satellite_coordinates[i,2] - receiver_coordinates[2]) / r)
    dop = c(dop,(satellite_coordinates[i,3] - receiver_coordinates[3]) / r)
    dop = c(dop, -1)
    
    # the first line converts the matrix into a list for some reason which breaks the later indexing :( 
    #dop[i, 1] = (satellite_coordinates[i,1] - receiver_coordinates[1]) / r
    #dop[i, 2] = (satellite_coordinates[i,2] - receiver_coordinates[2]) / r
    #dop[i, 3] = (satellite_coordinates[i,3] - receiver_coordinates[3]) / r
    #dop[i, 4] = -1
  }
  
  dop = matrix(unlist(dop), ncol = 4, byrow = TRUE)
  dop = ((t(dop) * dop) ^ -1) # inverse matrix Q incorrect
  return(dop)
}

ecef_coordinates = read.csv("ecef_coordinates.csv", header = FALSE, sep = ",")
receiver_coordinates = ecef_coordinates[1, ]
satellite_coordinates = ecef_coordinates[3:6, ]

# a) 
dopMatrix = getDOPMatrix(receiver_coordinates, satellite_coordinates)

# b) 
#gdop = sqrt(trace(dopMatrix))
tdop = sqrt(dopMatrix[4,4])
pdop = sqrt(dopMatrix[1,1] + dopMatrix[2, 2] + dopMatrix[3, 3])
hdop = sqrt(dopMatrix[1,1] + dopMatrix[2, 2])
vdop = sqrt(dopMatrix[3,3]) 


particles = read.csv("particles.csv", header = TRUE, sep = ",")

