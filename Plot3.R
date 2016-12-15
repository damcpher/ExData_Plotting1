#In this section I load the dataset, load it, filter to only the dates I want, and tidy it up a bit
#Seriously, there's a lot of crap that needs to be fixed.
library(dplyr)
target = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
temp <- tempfile()
download.file(target,temp)
data <- read.table(unz(temp, "household_power_consumption.txt"), skip=21998, nrows=524600, sep = ";")
unlink(temp)
data = filter(data, V1 == "1/2/2007" | V1 == "2/2/2007")
colnames(data)=c("Date","Time","GAP","GRP","Voltage","G_Intensity","Sub1","Sub2","Sub3")

data[,1]=as.character(data[,1])
data[,2]=as.numeric(as.ITime(as.character(data[,2])))
data = mutate(data, datetime= Time + (as.numeric(Date=="Fri")*86340))
for(i in 3:8){data[,i]=as.numeric(as.character(data[,i]))}

data[(data[,1] == "1/2/2007"),1] = "Thu"
data[(data[,1] == "2/2/2007"),1] = "Fri"

#Finally, we call the plot to a PNG graphics device, voila!

png("Plot3.png")
plot(Sub1~datetime, data=data, type="l", xlab = "Time (seconds from Thu morning)", ylab = "Energy Sub Metering")
points(Sub2~datetime, data=data, type="l", col="red")
points(Sub3~datetime, data=data, type="l", col="blue")
legend("topright", lwd = 1, col=c("black","red","blue"),legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))
dev.off()



