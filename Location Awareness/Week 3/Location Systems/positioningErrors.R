errors = read.csv("positioningErrors.csv", header = FALSE, sep = ",")

plot(x = 1:nrow(errors), y = sort(errors[,1]), type = "l", col = "black", xaxt='n', ann=FALSE)
lines(x = 1:nrow(errors), y = sort(errors[,2]), type = "l", col="red")

#text(locator(), labels = "System 1")
#text(locator(), labels = "System 2", col = "red")

mean(errors[,1])
max(errors[,1])
sort(errors[,1])[length(errors[,2]) * 0.99]
sort(errors[,1])[length(errors[,1]) * 0.95]
sort(errors[,1])[length(errors[,1]) * 0.5]

mean(errors[,2])
max(errors[,2])
sort(errors[,2])[length(errors[,2]) * 0.99]
sort(errors[,2])[length(errors[,2]) * 0.95]
sort(errors[,2])[length(errors[,2]) * 0.5]