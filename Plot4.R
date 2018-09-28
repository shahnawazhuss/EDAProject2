####################Section for Directories-FileDownload and Library Setup###################
dir<-"./EDAProject2/Data"
if (!dir.exists(dir)){
        dir.create(dir)
}
plotdir<-"./EDAProject2/CodeAndPlots"
if(!dir.exists(plotdir)){
        dir.create(plotdir)
}
FileURL<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
zipfile<-"./EDAProject2/Data/DownloadFile.zip"
if (!file.exists(zipfile)){
        download.file(FileURL,destfile = "./EDAProject2/Data/DownloadFile.zip")
        unzip(zipfile = zipfile,exdir = dir)
}

ED<-readRDS("./EDAProject2/Data/summarySCC_PM25.rds")
SD<-readRDS("./EDAProject2/Data/Source_Classification_Code.rds")

if (!"dplyr" %in% installed.packages()) {
        install.packages("dplyr")
}
library(dplyr)
##############################################################################
#Find the Lines which have Data Related to Coal Combustion in SD 
#Creating Logical vector to  fetch lines in SD for Coal Combustion
SDCoal<-grepl("Fuel Comb.*Coal",SD$EI.Sector)
#subsetting relevent data from SD 
subSDCoal<-SD[SDCoal,]
#Capturing data from ED file 
coaldata<-ED[ED$SCC %in% subSDCoal$SCC,]
coalDataSum<-summarise(group_by(coaldata,year),TotalEm=sum(Emissions))
if (!"ggplot2" %in% installed.packages()) {
        install.packages("ggplot2")
}
library(ggplot2)
ggplot(coalDataSum,aes(factor(year),TotalEm/1000,fill=year)) +
        geom_bar(stat="identity") +
        xlab("Year") +
        ylab("Total PM2.5 Emissions in Kiloton") +
        ggtitle("Emissions from Coal combustion - related Sources")
dev.copy(png,"./EDAProject2/CodeAndPlots/Plot4.png")
dev.off()
