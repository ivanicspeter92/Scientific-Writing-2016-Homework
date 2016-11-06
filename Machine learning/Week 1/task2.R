set.seed(20)

degree = 10
numbers = 30
interval = c(-3, 3)

x = runif(numbers, interval[1], interval[2])
y = 2 + x - 0.5 * x ^ 2
errors = rnorm(n = numbers, mean = 0, sd = 0.4)
ywitherrors = y + errors

plot(x, ywitherrors)

regression = lm(ywitherrors ~ poly(x, degree))
values = seq(interval[1], interval[2], by = 0.1)
model = predict(regression, data.frame(x = values), interval = "confidence", level = 0.95)

lines(values, model[,1], col='green', lwd=5)

mse = mean(regression$residuals^2)
sprintf("MSE: %f", mse)