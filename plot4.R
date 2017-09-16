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

# Across the United States, how have emissions from coal combustion-related sources
# changed from 1999–2008?
CoalSCC <-  filter(SCC, grepl("Coal|coal", EI.Sector))$SCC
data <- NEI[SCC %in% CoalSCC, .(Emission = sum(Emissions)), by=year]

png(file="plot4.png",width=480,height=480)
g <- ggplot(data, aes(year, Emission))
g + geom_bar(stat="identity") + xlab("Year")
dev.off()
