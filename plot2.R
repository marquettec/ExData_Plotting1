# Packages dependencies
install.packages(c('data.table', 'sqldf', 'reshape2'))
library('data.table')
#library('sqldf')
library('reshape2')
library('dplyr')

# Getting data
if (!file.exists('./data')) {
  dir.create('./data')
}
if (!file.exists('./data/exdata-data-household_power_consumption.zip')) {
  fileUrl <- 'https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip'
  download.file(fileUrl, destfile='./data/exdata-data-household_power_consumption.zip', method='curl')
}
if (!file.exists('./data/household_power_consumption.txt')) {
  unzip('./data/exdata-data-household_power_consumption.zip', exdir='./data')
}

# Preparing data
dataFile <- './data/household_power_consumption.txt'
data <- fread(dataFile, na.strings="?", sep=';', colClasses=c('character', 'character', 'numeric', 'numeric', 'numeric', 'numeric', 'numeric', 'numeric', 'numeric'))
data$Date <- as.Date(data$Date, ,format='%d/%m/%Y')
subset <- subset(data, Date >= as.Date('2007-02-01') & Date <= as.Date('2007-02-02'))
subset <- mutate(subset, DateTime=as.POSIXct(strptime(paste(Date, ' ', Time), '%Y-%m-%d %H:%M:%S')))
subset$Global_active_power = as.double(subset$Global_active_power)

Sys.setlocale("LC_TIME", "en_GB")  # OS X, in UTF-8

# Generating plot2
png(file='plot2.png', width=480, height=480)
with(subset, plot(Global_active_power ~ DateTime, type='n', xlab='', ylab='Global Active Power (kilowatts)'))
with(subset, lines(Global_active_power ~ DateTime, lwd=1))
dev.off()
