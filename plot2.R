# For each year and for each type of PM source, the NEI records how many tons of PM2.5
# were emitted from that source over the course of the entire year. 
# The data that you will use for this assignment are for 1999, 2002, 2005, and 2008.
library(data.table)
library(dplyr)

if (!file.exists("exdata_data_NEI_data.zip")) {
  download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip",
                destfile = "exdata_data_NEI_data.zip")
  unzip("exdata_data_NEI_data.zip")
}

# Now we have files "summarySCC_PM25.rds" and "Source_Classification_Code.rds". Import!
NEI <- readRDS("summarySCC_PM25.rds") %>% data.table()

## Let's exploratory analysis begin!

# Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (𝚏𝚒𝚙𝚜 == "𝟸𝟺𝟻𝟷𝟶")
# from 1999 to 2008? Use the base plotting system to make a plot answering this question.
png(file="plot2.png",width=480,height=480)
plot(EmissionByYear, pch = 19, xlab = "Year", ylab = "Emission", cex = 1.3, 
     main = "Total PM2.5 Emissions in Baltimore County", type = "o", lty = 6)
abline(lm(formula = EmissionByYear$Emission ~ EmissionByYear$year), col = "blue")
dev.off()
