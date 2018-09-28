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

if (!"dplyr" %in% installed.packages()) {
        install.packages("dplyr")
}
library(dplyr)
if (!"ggplot2" %in% installed.packages()) {
        install.packages("ggplot2")
}
library(ggplot2)
##############################################################################
#motor-vechicle data for Baltimore and Los Angeles city 
MVBdata<-filter(ED,(fips=="24510") & (type=="ON-ROAD") )
MVLAdata<-filter(ED,(fips=="06037") & (type=="ON-ROAD") )
MVBsumdata<-summarise(group_by(MVBdata,year),TotalEm=sum(Emissions))
MVLAsumdata<-summarise(group_by(MVLAdata,year),TotalEm=sum(Emissions))
MVBsumdata$city<-"Baltimore"
MVLAsumdata$city<-"LA"
cbsumdata<-rbind(MVBsumdata,MVLAsumdata)

#plotting
ggplot(cbsumdata,aes(factor(year),TotalEm,fill=city))+
        geom_bar(stat = "identity")+
        facet_grid(city~.) +
        xlab("Year")+
        ylab("Total PM2.5 Emissions in ton")+
        ggtitle("Motor Vehicle emission comparison between Baltimore and LA")
dev.copy(png,"./EDAProject2/CodeAndPlots/Plot6.png")
dev.off()