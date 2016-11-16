require(ISLR)
data("Weekly")

getConfusionMatrix = function(predictions) {
  confusionMatrix = rep("No", length(predictions))
  confusionMatrix[predictions > 0.5] = "Yes"
  confusionMatrix = table(confusionMatrix)
  
  return(confusionMatrix)
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
confusionMatrix = getConfusionMatrix(predictions)
sprintf("%f of the observations are Yes, %f of the observations are No instances", confusionMatrix[2] / length(predictions) * 100,confusionMatrix[1] / length(predictions) * 100)