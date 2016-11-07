library(ISLR)
data("Auto")

plot(Auto$horsepower, Auto$acceleration, col='red', pch=16)

regression = lm(Auto$acceleration~ Auto$horsepower)
coefficients = coef(regression)
summary(regression)

range = 0:250
lines(range, coefficients[1] + coefficients[2] * range, col='green', lwd=5)