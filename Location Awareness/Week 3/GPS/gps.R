require(proxy)
require(MASS)

getDOPMatrix = function(receiver_coordinates, satellite_coordinates) {
  A = c()
  
  for (i in 1:nrow(satellite_coordinates)) {
    r = as.numeric(dist(receiver_coordinates, satellite_coordinates[i,]))
    
    A = c(A,(satellite_coordinates[i,1] - receiver_coordinates[1]) / r)
    A = c(A,(satellite_coordinates[i,2] - receiver_coordinates[2]) / r)
    A = c(A,(satellite_coordinates[i,3] - receiver_coordinates[3]) / r)
    A = c(A, -1)
    
    # the first line converts the matrix into a list for some reason which breaks the later indexing :( 
    #dop[i, 1] = (satellite_coordinates[i,1] - receiver_coordinates[1]) / r
    #dop[i, 2] = (satellite_coordinates[i,2] - receiver_coordinates[2]) / r
    #dop[i, 3] = (satellite_coordinates[i,3] - receiver_coordinates[3]) / r
    #dop[i, 4] = -1
  }
  
  A = matrix(unlist(A), ncol = 4, byrow = TRUE)
  return(A)
}

ecef_coordinates = read.csv("ecef_coordinates.csv", header = FALSE, sep = ",")
receiver_coordinates = ecef_coordinates[1, ]
satellite_coordinates = ecef_coordinates[2:6, ]

# a) 
A = getDOPMatrix(receiver_coordinates, satellite_coordinates[2:5,])

# b) 
dopMatrix = solve(t(A) * A) # inverse matrix Q incorrect

#gdop = sqrt(trace(dopMatrix))
tdop = sqrt(dopMatrix[4,4])
pdop = sqrt(dopMatrix[1,1] + dopMatrix[2, 2] + dopMatrix[3, 3])
hdop = sqrt(dopMatrix[1,1] + dopMatrix[2, 2])
vdop = sqrt(dopMatrix[3,3]) 