library(ISLR)
data("Auto")

Auto[1,2:3] = NA # replacing columns with null (NA) values

mean(Auto$cylinders) # the result is NA because there are missing values in this column