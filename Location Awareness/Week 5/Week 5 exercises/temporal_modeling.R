discretizeData = function(data) {
  data$secondsSinceMidnight = 0
  data$timeSlot = 0
  for (i in 1:nrow(data)) {
    epochTimestamp = data[i,]$arrival
    
    data[i,]$secondsSinceMidnight = getSecondsFromMidnight(epochTimestamp)
    data[i,]$timeSlot = round(data[i,]$secondsSinceMidnight / (15 * 60) + 1)
  }
  return(data)
}

convertToDate = function(epochTimestamp) {
  date = as.POSIXlt(epochTimestamp, origin="1970-01-01", tz = "UTC")
  
  return(date)
} 

getSecondsFromMidnight = function(epochTimestamp) {
  date = convertToDate(epochTimestamp)
  return(date$hour * 3600 + date$min * 60 + date$sec)
}

# a)
data = read.csv("temporal.csv", header = TRUE)
data = discretizeData(data)

# b)
timeslotDifferences = c()

for (i in 1:(nrow(data) - 1)) {
  timeslotDifferences = c(timeslotDifferences, abs(data[i + 1,]$timeSlot - data[i,]$timeSlot))
}