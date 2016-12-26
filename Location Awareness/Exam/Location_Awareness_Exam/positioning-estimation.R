towerA = c(10, 10)
towerB = c(12, -2)
r = 7
errorPercent = 0.1

#a)
plot(x = c(towerA[1], towerB[1]), y = c(towerA[2], towerB[2]), asp = 1, xlab = "X", ylab = "Y")
#draw.circle(x = towerA[1], y = towerA[2], radius = r)
#draw.circle(x = towerB[1], y = towerB[2], radius = r)

#b)
draw.circle(x = towerA[1], y = towerA[2], radius = (r * (1 + errorPercent)), lty=2)
draw.circle(x = towerA[1], y = towerA[2], radius = (r * (1 - errorPercent)), lty=2)

draw.circle(x = towerB[1], y = towerB[2], radius = (r * (1 + errorPercent)), lty=2)
draw.circle(x = towerB[1], y = towerB[2], radius = (r * (1 - errorPercent)), lty=2)