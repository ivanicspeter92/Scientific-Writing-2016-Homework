# IML 2016
# Exercise session IV
# Model solutions
# Ville H.
# ville.o.hyvonen@helsinki.fi

###########################################################
# Exercise 2

# a
# generate n_sim data points from the model given in the exercise sheet
generate_data <- function(n_sim) {
  X_combinations <- as.matrix(expand.grid(0:1,0:2))
  Y <- sample(0:2, size = n_sim, replace = TRUE, prob = c(0.4,0.3,0.3)) # generate class labels 
  X <- matrix(0, nrow = n_sim, ncol = 2)
  
  for(i in 1:n_sim) {
    prob <- switch (Y[i]+1,
                    c(0.2,0.1,0.4,0.2,0.0,0.1),
                    c(0.6,0.1,0.1,0.1,0.1,0.0),
                    c(0.1,0.4,0.3,0.0,0.2,0.0))
    X[i, ] <- X_combinations[sample(1:6, size = 1, replace = TRUE, prob = prob),]
  }
  list(X = X, Y = Y)
}

n_train <- 100
train <- generate_data(n_train)

# compute the proportion of X = (0,0)
table(rowSums(train$X == 0)) / n_train

# We get the probability of X=(0,0) from the law of total probability:
# P(X=(0,0)) = P(X=(0,0), Y=0) = P(X=(0,0), Y=1) = P(X=(0,0), Y=2)
0.4 * 0.2 + 0.3 * 0.6 + 0.3 * 0.1


######################################################
# b

# train a Naive Bayes classifier
# Y = vector of class labels
# X = data matrix containing predictors, row = data point, col = variable
# n_class = number of different classes in Y
# n_class_x = vector with numbers of different values for each predictor (cols of X)
# m = smoothing parameter
# returns an object of class 'nb' with components
#   prior = vector containing estimated probabilities for the classes
#   likelihood = list containing estimated conditional probabilities
#     for the features given class p(X_i| Y) (each component of this list 
#     contains probabilities for one variable).
#   n_class = number of different classes in Y
#   n_class_x = vector with numbers of different values for each predictor (cols of X)
nb <- function(Y, X, n_class = 3, n_class_x = c(2,3), m = 0) {
  n <- length(Y)
  likelihood <- vector('list', length = n_class)
  prior <- numeric(n_class)
  for(c in 0:(n_class-1)) {
    n_c <- sum(Y == c)
    prior[c+1] <- (n_c + m) / (n + n_class * m)
    for(i in seq_along(n_class_x)) {
      likelihood[[c+1]][[i]] <- numeric(n_class_x[i]) 
      for(j in 0:(n_class_x[i]-1)) {
        n_cj <- sum(Y == c & X[ ,i] == j)
        likelihood[[c+1]][[i]][j+1] <- (n_cj + m) / (n_c + n_class_x[i] * m)    
      }
    }
  }
  
  ret <- list(prior = prior, likelihood = likelihood, n_class = n_class, n_class_x = n_class_x, jointlikelihood = getJointLikelihood())
  class(ret) <- 'nb' 
  ret
}

getJointLikelihood = function() {
  jointlikelihood = list()
  jointlikelihood[[1]] = t(matrix(c(0.2,0.1,0.4,0.2,0.0,0.1), ncol = 3))
  jointlikelihood[[2]] = t(matrix(c(0.6,0.1,0.1,0.1,0.1,0.0), ncol = 3))
  jointlikelihood[[3]] = t(matrix(c(0.1,0.4,0.3,0.0,0.2,0.0), ncol = 3))
  
  return(jointlikelihood)
}

######################################################
# c & d
# compute posterior class probabilities and predicted values using trained 
# Naive Bayes model
# nbfit = fitted Naive Bayes model, object with class 'nb'
# X = predictors as matrix, row = data point, col = variable
# return = vector with predicted values for the data points (if probabilities = FALSE)
#   or class probabilites p(y|x) (if probabilities = TRUE)
predict.nb <- function(nbfit, X, probabilities = FALSE) {
  n <- nrow(X)
  X = X + 1
  prob <- matrix(0, nrow = n, ncol = nbfit$n_class) 
  for(i in 1:n)                 # compute joint probabilities p(x,y)
    for(c in 1:nbfit$n_class) {
      prob[i,c] <- nbfit$prior[c]
      
      prob[i,c] <- prob[i,c] * nbfit$jointlikelihood[[c]][X[i, 2], X[i, 1]]
    }
  prob <- prob / rowSums(prob)      # normalize into conditional probabilities p(y|x) 
  pred <- max.col(prob) - 1        # predict class y as argmax p(y|x)
  
  if(probabilities) 
    prob
  else 
    pred
}

# install.packages('nnet')
library(nnet) # for multinomial logistic regression

n_test <- 1e4
test <- generate_data(n_test) # generate a test set

# transform data frame form for the logistic regression
# notice: predictors are coded as factors --> then modeling function
# uses them as nominal, not numeric variables (if you look at the
# regression coefficients you notice that they are for dummy encoding (pages 82-86 and 117-118 in ISL)).
train_df <- data.frame(Y = train$Y, X1 = factor(train$X[ ,1]), X2 = factor(train$X[ ,2]))
#train_df <- data.frame(Y = train$Y, X1 = train$X[ ,1], X2 = train$X[ ,2])

test_df <- data.frame(Y = test$Y, X1 = factor(test$X[ ,1]), X2 = factor(test$X[ ,2]))
#test_df <- data.frame(Y = test$Y, X1 = test$X[ ,1], X2 = test$X[ ,2])

# fit Naive Bayes model with smoothing parameters m = 0, 1/2, and 1
# and logistic regression without and with the interaction term
nbfit_ML <- nb(train$Y, train$X, m = 0)
nbfit_KT <- nb(train$Y, train$X, m = 1/2)
nbfit_Laplace <- nb(train$Y, train$X, m = 1)
logfit <- multinom(Y ~ X1 + X2, data = train_df)

# test errors 
sum(predict(nbfit_ML, test$X) != test$Y) / n_test
sum(predict(nbfit_KT, test$X) != test$Y) / n_test
sum(predict(nbfit_Laplace, test$X) != test$Y) / n_test
sum(predict(logfit, test_df) != test$Y) / n_test

# predicted values for 10 first test points
predict(nbfit_Laplace, test$X, probabilities = TRUE)[1:10,]
predict(logfit, test_df, type = 'probs')[1:10,]
test_df[1:10, 2:3] # predictors for 10 first test points

# predictions for 10 first test points
predict(nbfit_Laplace, test$X)[1:10]
predict(logfit, test_df)[1:10]
test$Y[1:10] # true classes for 10 first test points

# All smoothing parameters give the same predictions,
# although the posterior probabilities are bit different.
# Also with maximum likelihood there are divisions by
# zero, if the are no some value of the predictor in the training data --> NaN
# When using smoothing, this problem disappears.



# test with different training set sizes
n_train <- c(25, 50, 100, 200, 400, 800, 1600, 3200, 6400, 12800, 25600, 51200)
test_error_ML <- test_error_KT <- test_error_Laplace <- test_error_logistic <- test_error_logistic_ia <- test_error_logloss <- numeric(length(n_train))
for(i in seq_along(n_train)) {
  train <- generate_data(n_train[i])
  train_df <- data.frame(Y = train$Y, X1 = factor(train$X[ ,1]), X2 = factor(train$X[ ,2]))
  
  nbfit_ML <- nb(train$Y, train$X, m = 0)
  nbfit_Laplace <- nb(train$Y, train$X, m = 1)
  nbfit_KT <- nb(train$Y, train$X, m = 1/2)
  logistic_fit <- multinom(Y ~ X1 + X2, data = train_df)
  
  test_error_ML[i] <- sum(predict(nbfit_ML, test$X) != test$Y) / n_test
  test_error_KT[i] <- sum(predict(nbfit_KT, test$X) != test$Y) / n_test
  test_error_Laplace[i] <- sum(predict(nbfit_Laplace, test$X) != test$Y) / n_test
  test_error_logistic[i] <- sum(predict(logistic_fit, test_df) != test$Y) / n_test
}
  
plot(x = n_train, log='x', test_error_Laplace, type = 'b', col = 'blue', lwd = 2, pch = 20, xlab = 'n', ylab = 'test error')
lines(x = n_train, test_error_logistic, type = 'b', col = 'red', lwd = 2, pch = 20)

test_error_Laplace
test_error_logistic


# Test error of the naive Bayes & logistic regression converges to about 0.4.