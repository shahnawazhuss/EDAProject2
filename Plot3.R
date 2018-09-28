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
#Data provided is only for years 1999,2002,2005,2008 ,hence no need for year filter
EDBltmr<-filter(ED,fips=="24510")
EDBtyyr<-group_by(EDBltmr,type,year)
EDBsum<-summarise(EDBtyyr,TotalBltmrEm=sum(Emissions))
EDBsum$type<-factor(EDBsum$type,levels = c("ON-ROAD", "NON-ROAD", "POINT", "NONPOINT"))
#Plotting
ggplot(EDBsum,aes(factor(year),TotalBltmrEm,fill=type))+geom_bar(stat="identity")+facet_grid(.~type)+xlab("Year")+ylab("Total Tons of PM2.5 Emmisions")+ggtitle("Total Tons of PM2.5 Emission by Source Type")+theme(axis.text.x = element_text(angle = 90))
dev.copy(png,"./EDAProject2/CodeAndPlots/Plot3.png")
dev.off()