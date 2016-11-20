measurements = read.csv("noisyCompass.csv", header = FALSE)
S = diag(x = 0.15, ncol = 3, nrow = 3)
sigma = 1.25 * 10 ^ -4
Q = sigma * diag(x = 1, ncol = 3, nrow = 3)
A = diag(x = 1, ncol = 3, nrow = 3)
R = 0.15 * diag(x = 1, ncol = 3, nrow = 3)