require(dplyr)
require(lubridate)
## Script to generate plot3

# Shuts down all open graphics devices to ensure only the correct device is used.
graphics.off()

# Download Electric power consumption data if not exist in current working directory
inputfile="household_power_consumption.txt"
if (!file.exists(inputfile)) {
  if (!file.exists("exdata-data-household_power_consumption.zip")) {
    url="https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
    download.file(url, destfile="./exdata-data-household_power_consumption.zip", method="curl")
  }
  unzip("exdata-data-household_power_consumption.zip")
}

if (!file.exists(inputfile)) {
  stop (paste0("Expecting to find 'household_power_consumption.txt' file in current work directory.\n\n",
               "Unable to extract 'household_power_consumption.txt' file from 'exdata-data-household_power_consumption.zip'\n\n",
               "Please provide the correct 'household_power_consumption.txt' or 'exdata-data-household_power_consumption.zip' file in ",
               "the current work directory: ", getwd()))
}

# Read and extract only household_power_consumption.txt data from the dates 2007-02-01 and 2007-02-02
df<-read.table(
  inputfile,
  sep=";",
  col.names=c("Date","Time","Global_active_power","Global_reactive_power","Voltage","Global_intensity","Sub_metering_1","Sub_metering_2","Sub_metering_3"),
  na.strings ="?",stringsAsFactors = F, skip=66600, nrows= 4000)
df<-filter(df, Date=="1/2/2007" | Date=="2/2/2007")
df<-mutate(df, DateTime=dmy_hms(paste(Date, Time,sep=" ")))

# Open png device
png("plot3.png", width=480, height=480, units = "px")

# Generate plot3
with(df, {
  plot(DateTime,
       Sub_metering_1,
       ylab="Energy sub metering",
       xlab="",
       col="black",
       type="l")
  lines(DateTime,
        Sub_metering_2,
        col="red",
        type="l")
  lines(DateTime,
        Sub_metering_3,
        col="blue",
        type="l")
  })
legend("topright",
       lty=c(1,1),
       col = c("black", "red", "blue"),
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))


# Close graphic devices
dev.off()
