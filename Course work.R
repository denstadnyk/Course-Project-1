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

#################### 1 ####################
# Have total emissions from PM2.5 decreased in the United States from 1999 to 2008?
# Using the base plotting system, make a plot showing the total PM2.5 emission from all
# sources for each of the years 1999, 2002, 2005, and 2008.
EmissionByYear <- NEI[, .(Emission = sum(Emissions)), by=year]
barplot(EmissionByYear[ ,2], names.arg = EmissionByYear[ ,1], ylab = "Emission", xlab = "Year")
rm(EmissionByYear)

#################### 2 ####################
# Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (𝚏𝚒𝚙𝚜 == "𝟸𝟺𝟻𝟷𝟶")
# from 1999 to 2008? Use the base plotting system to make a plot answering this question.
EmissionByYear <- NEI[fips == "24510", .(Emission = sum(Emissions)), by=year]
plot(EmissionByYear, pch = 19, xlab = "Year", ylab = "Emission", cex = 1.3, 
     main = "Total PM2.5 Emissions in Baltimore County", type = "o", lty = 6)
abline(lm(formula = EmissionByYear$Emission ~ EmissionByYear$year), col = "blue")
rm(EmissionByYear)

#################### 3 ####################
# Of the four types of sources indicated by the 𝚝𝚢𝚙e (point, nonpoint, onroad, nonroad) variable,
# which of these four sources have seen decreases in emissions from 1999–2008 for Baltimore City? 
# Which have seen increases in emissions from 1999–2008?
# Use the ggplot2 plotting system to make a plot answer this question.
data <- NEI[fips == "24510", Emissions:year]
data <- data[, lapply(.SD, sum), by = list(type,year)]
g <- ggplot(data, aes(x = year, y = Emissions, col = type))
g + geom_line() + ggtitle("Total PM2.5 Emissions in Baltimore County by Source Type") + 
  xlab("Year") + ylab("PM2.5 Emissions")
rm(data, g)


#################### 4 ####################
# Across the United States, how have emissions from coal combustion-related sources
# changed from 1999–2008?
CoalSCC <-  filter(SCC, grepl("Coal|coal", EI.Sector))$SCC
data <- NEI[SCC %in% CoalSCC, .(Emission = sum(Emissions)), by=year]

g <- ggplot(data, aes(year, Emission))
g + geom_bar(stat="identity") + xlab("Year")
rm(data, g, CoalSCC)


#################### 5 ####################
# How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?
MotorSCC <-  filter(SCC, grepl("Motor|motor", SCC.Level.Three))$SCC
data <- NEI[SCC %in% MotorSCC, .(Emission = sum(Emissions)), by=year]

g <- ggplot(data, aes(year, Emission))
g + geom_point() + geom_line() + xlab("Year")
rm(data, g, MotorSCC)


#################### 6 ####################
# Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle
# sources in Los Angeles County, California (𝚏𝚒𝚙𝚜 == "𝟶𝟼𝟶𝟹𝟽").
# Which city has seen greater changes over time in motor vehicle emissions?
dataLA <- NEI[fips == "06037", .(Emission = sum(Emissions), City = "LA"), by=year]
dataBaltimore <- NEI[fips == "24510", .(Emission = sum(Emissions), City = "Baltimore"), by=year]
data <- full_join(dataLA,dataBaltimore)
data$City <- as.factor(data$City)
data$year <- as.factor(data$year)

g <- ggplot(data = data, aes(x = year, y = Emission, col = City, group = City))
g + geom_point() + geom_line() + xlab("Year")
