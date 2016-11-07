r = rnorm(1e5)
hist(r, breaks = 50, probability = TRUE, col = 'green')

# create a grid
x <- seq(-5, 5, by = .1)
lines(x, dnorm(x), lwd = 2)