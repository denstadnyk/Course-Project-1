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

## Let's exploratory analysis begin!

# Of the four types of sources indicated by the 𝚝𝚢𝚙e (point, nonpoint, onroad, nonroad) variable,
# which of these four sources have seen decreases in emissions from 1999–2008 for Baltimore City? 
# Which have seen increases in emissions from 1999–2008?
# Use the ggplot2 plotting system to make a plot answer this question.
data <- NEI[fips == "24510", Emissions:year]
data <- data[, lapply(.SD, sum), by = list(type,year)]
g <- ggplot(data, aes(x = year, y = Emissions, col = type))
png(file="plot3.png",width=480,height=480)
g + geom_line() + ggtitle("Total PM2.5 Emissions in Baltimore County by Source Type") + 
  xlab("Year") + ylab("PM2.5 Emissions")
dev.off()
rm(data, g)
