# For each year and for each type of PM source, the NEI records how many tons of PM2.5
# were emitted from that source over the course of the entire year. 
# The data that you will use for this assignment are for 1999, 2002, 2005, and 2008.
library(data.table)
library(dplyr)
library(ggplot2)

if (!file.exists("exdata_data_NEI_data.zip")) {
  download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip",
                destfile = "exdata_data_NEI_data.zip")
  unzip("exdata_data_NEI_data.zip")
}

# Now we have files "summarySCC_PM25.rds" and "Source_Classification_Code.rds". Import!
NEI <- readRDS("summarySCC_PM25.rds") %>% data.table()
SCC <- readRDS("Source_Classification_Code.rds") %>% data.table()

## Let's exploratory analysis begin!

# Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle
# sources in Los Angeles County, California (𝚏𝚒𝚙𝚜 == "𝟶𝟼𝟶𝟹𝟽").
# Which city has seen greater changes over time in motor vehicle emissions?
## Motor vehicle - ON-ROAD vehicle
NEI <- NEI[type == "ON-ROAD",]
dataLA <- NEI[fips == "06037", .(Emission = sum(Emissions), City = "LA"), by=year]
dataBaltimore <- NEI[fips == "24510", .(Emission = sum(Emissions), City = "Baltimore"), by=year]
data <- full_join(dataLA,dataBaltimore)
data$City <- as.factor(data$City)
data$year <- as.factor(data$year)

png(file="plot6.png",width=480,height=480)
g <- ggplot(data = data, aes(x = year, y = Emission, col = City, group = City))
g + geom_point() + geom_line() + xlab("Year")
dev.off()
