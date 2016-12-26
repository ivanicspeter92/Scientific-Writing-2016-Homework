measurements = read.csv("geolife_trace.csv", header = F, sep = ",")
A = H = diag(1, nrow = 2)
R = 0.25 * diag(1, nrow = 2)
Q = 0.00225 * diag(1, nrow = 2)
