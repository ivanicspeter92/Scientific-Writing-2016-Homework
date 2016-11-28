require(plotly)

grid = as.matrix(expand.grid((-5:5), (-5:5)))
x1 = grid[,1]
x2 = grid[,2]

y = dnorm(x1, 0, 16) * dnorm(x2, 0, 16) * 0.5 / (dnorm(x1, 0, 16) * dnorm(x2, 0, 16) * 0.5 + dnorm(x1, 0, 1) * dnorm(x2, 0, 1) * 0.5)
y = matrix(y, nrow = sqrt(nrow(grid)))

contour(y)
image(y)
persp(y)
plot_ly(z = y, type = "surface")
