plotOutstateVSPrivate = function(data) {
  plot(data$Private, data$Outstate)
  title(main = "Outstate vs. Private")
}

plotOutstateVSElite = function(data) {
  boxplot(data$Outstate, data$Elite, names = c("Outstage", "Elite"), log = "y")
}

library(ISLR)
data("College")
# college = csv.read("college.csv", header = TRUE, sep = ";")

rownames(College) 
#fix(College)

# 8/ii
summary(College)
pairs(College[,1:10])

# 8/iii
plotOutstateVSPrivate(College)

# 8/iv
Elite=rep("No", nrow(College))
Elite[College$Top10perc > 50] = "Yes"
Elite = as.factor(Elite)
College = data.frame(College, Elite)
summary(College)
plotOutstateVSElite(College)

# 8/v
par(mfrow=c(2,2))
hist(x = College$Books)
hist(x = College$Grad.Rate)
hist(x = College$PhD)
hist(x = College$Accept)
