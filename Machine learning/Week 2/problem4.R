require(ISLR)
library(MASS)
library(class)
data("Weekly")

getConfusionMatrix = function(predictions, Directions) {
  confusionMatrix = rep("No", length(predictions))
  confusionMatrix[predictions > 0.5] = "Yes"
  confusionMatrix = table(confusionMatrix, Directions)
  
  return(confusionMatrix)
}

printConfusionMatrix = function(confusionMatrix) {
  sprintf("%f of the observations are Correct, %f of the observations are Incorrect instances", (confusionMatrix[1, 1] + confusionMatrix[2, 2]) / sum(confusionMatrix) * 100, (confusionMatrix[1, 2] + confusionMatrix[2, 1]) / sum(confusionMatrix) * 100)
}

# a)
head(Weekly)
summary(Weekly)
par(mfrow=c(3, 2))
plot(x = Weekly$Year, y = Weekly$Lag1)
plot(x = Weekly$Year, y = Weekly$Lag2)
plot(x = Weekly$Year, y = Weekly$Lag3)
plot(x = Weekly$Year, y = Weekly$Lag4)
plot(x = Weekly$Year, y = Weekly$Lag5)
plot(x = Weekly$Direction, y = Weekly$Today)

# b) 
par(mfrow=c(1, 1))
model = glm(Direction ~ Lag1 + Lag2 + Lag3 + Lag4 + Lag5 + Volume, data = Weekly, family = binomial)
summary(model)
coef(model)

# c)
predictions = predict(model, type="response")
confusionMatrix = getConfusionMatrix(predictions, reducedWeekly$Direction)
printConfusionMatrix(confusionMatrix)

# d) 
reducedWeekly = Weekly[(Weekly$Year >= 1990 & Weekly$Year <= 2008),]
model = glm(Direction ~ Lag2, data = reducedWeekly, family = binomial)
predictions = predict(model, type="response")
confusionMatrix = getConfusionMatrix(predictions, reducedWeekly$Direction)
printConfusionMatrix(confusionMatrix)

# e)
model = lda(Direction ~ Lag2, data = reducedWeekly)
predictions = predict(model)
confusionMatrix = table(predictions$class, reducedWeekly$Direction)
printConfusionMatrix(confusionMatrix)

# f)
model = qda(Direction ~ Lag2, data = reducedWeekly)
predictions = predict(model)
confusionMatrix = table(predictions$class, reducedWeekly$Direction)
printConfusionMatrix(confusionMatrix)

# g) 
predictions = knn(train = matrix(Weekly$Lag2, ncol = 1), test = matrix(reducedWeekly$Lag2, ncol = 1), cl = matrix(Weekly$Direction),  k = 1)
confusionMatrix = table(predictions, reducedWeekly$Direction)
printConfusionMatrix(confusionMatrix)
