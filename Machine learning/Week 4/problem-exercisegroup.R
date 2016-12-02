# a)
Y <- rbind(c(0.2, 0.1, 0.4, 0.2, 0.0, 0.1), c(0.6, 0.1, 0.1, 0.1, 0.1, 0.0), c(0.1, 0.4, 0.3, 0.0, 0.2, 0.0))

sample2 <- function(n) {
	X <- matrix(0, n, 2)
	y <- sample(0:2, n, replace=TRUE, prob=c(0.4, 0.3, 0.3))

	for (i in 1:n) {
		x <- expand.grid(0:1, 0:2)[sample(1:6, 1, replace=TRUE, prob=Y[y[i] + 1, ]), ]
		X[i, ] <- c(unlist(x))
	}
	list("x" = X, "y" = y)
}

# b)
nbx <- function(x, y, class, smoothing) {
	out <- table(apply(expand.grid(0:1, 0:2), 1, paste, collapse='')) - 1
	freqs <- table(apply(x[y == class, ], 1, paste, collapse=''))
	estimates <- (freqs + smoothing)/(sum(freqs) + smoothing*6)
	for (i in names(out)) {
		out[i] <- out[i] + estimates[i]
	}
	out <- matrix(out, 3, 2, byrow=FALSE)
	out[is.na(out)] <- 0
	out
}

nby <- function(y, alpha) {
	freqs <- table(y)
	estimates <- (freqs + alpha)/(sum(freqs) + 3*alpha)
	estimates
}

# c)
classify <- function(x1, x2, train, smoothing) {
	probs <- numeric(3)
	dy <- nby(train$y, smoothing)
	for (i in 0:2) {
		dx <- nbx(train$x, train$y, i, smoothing)
		probs[i + 1] <- dx[x2 + 1, x1 + 1]
	}
	pclass <- numeric(3)
	for (i in 1:3) {
		pclass[i] <- (probs[i]*dy[i])/(sum(probs*dy))
	}
	pclass
}

calcError <- function(test, train, smoothing) {
	real <- test$y
	assigned <- numeric(nrow(test$x))
	for (i in 1:nrow(test$x)) {
		assigned[i] <- which.max(classify(test$x[i, 1], test$x[i, 2], train, smoothing)) - 1
	}
	sum(assigned == real)/length(assigned)
}

test <- sample2(10000)

# errors <- matrix(0, 3, 9)
 ns <- c(25, 50, 100, 200, 400, 800, 1600, 3200, 6400)
# smoots <- c(0, 0.5, 1)
# for (i in 1:length(ns)) {
# 	print(ns[i])
# 	train <- sample2(ns[i])
# 	for (j in 1:length(smoots)) {
# 		errors[j, i] <- calcError(test, train, smoots[j])
# 	}
# }
load("~/Dropbox/kurssit/itml/ex4/problem2_c.Rda")
plot(results[1, ], type='l', ylim=c(0, 1), xlab = "Training set size", ylab = "Absolute error")
lines(results[2, ], col='red')
lines(results[3, ], col='green')

# d)
D <- data.frame("Y" = train$y, "X1" = factor(train$x[, 1]), "X2" = factor(train$x[, 2]))
model <- multinom(Y ~ X1*X2, data=D)
y.predicted <- predict(model, data.frame("X1" = factor(test$x[, 1]), "X2" = factor(test$x[, 2])), type="class")
sum(y.predicted == test$y)/length(test$y)

results.glm <- numeric(length(ns))
for (i in 1:length(ns)) {
	train <- sample2(ns[i])
	D <- data.frame("Y" = train$y, "X1" = factor(train$x[, 1]), "X2" = factor(train$x[, 2]))
	model <- multinom(Y ~ X1*X2, data=D)
	y.predicted <- predict(model, data.frame("X1" = factor(test$x[, 1]), "X2" = factor(test$x[, 2])), type="class")
	results.glm[i] <- 1 - sum(y.predicted == test$y)/length(test$y)
}