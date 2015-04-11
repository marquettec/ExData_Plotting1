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
# Generating plot4
png(file='plot4.png', width=480, height=480)
# 2x2 graphs
par(mfcol=c(2,2))
# 1,1 Graph Global_active_power
# Reusing plot2, Removing main legend
with(subset, plot(Global_active_power ~ DateTime, type='n', xlab='', ylab='Global Active Power'))
with(subset, lines(Global_active_power ~ DateTime, lwd=1))
# 2,1 Graph Sub_metering
# Reusing plot3, removing border on legend
with(subset, plot(Sub_metering_1 ~ DateTime, type='n', xlab='', ylab='Energy sub metering'))
with(subset, lines(Sub_metering_1 ~ DateTime, lwd=1, col='black'))
with(subset, lines(Sub_metering_2 ~ DateTime, lwd=1, col='red'))
with(subset, lines(Sub_metering_3 ~ DateTime, lwd=1, col='blue'))
legend('topright', lwd=1, box.lwd=0, col=c('black', 'red', 'blue'), legend=c('Sub_metering_1', 'Sub_metering_3', 'Sub_metering_3'))
# 1,2 Graph - Voltage
with(subset, plot(Voltage ~ DateTime, type='n', xlab='datetime', ylab='Voltage'))
with(subset, lines(Voltage ~ DateTime, lwd=1))
# 2,2 Graph - Global_reactive_power
with(subset, plot(Global_reactive_power ~ DateTime, type='n', xlab='datetime'))
with(subset, lines(Global_reactive_power ~ DateTime, lwd=1))

dev.off()
