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
##############################################################################
#Data provided is only for years 1999,2002,2005,2008 ,hence no need for year filter
#Preparing data for Plotting
EDyear<-group_by(ED,year)
EDTotal<-summarise(EDyear,TotalEm=sum(Emissions))
#Preparing Plot
xp<-c(1999,2002,2005,2008)
yp<-c(3000,4000,5000,6000,7000)
plot(EDTotal$year,EDTotal$TotalEm/1000,axes=F,frame.plot = T,type="l",lwd=3,
     xlab = "Years",
     ylab = "PM2.5 Emissions in Kilotons",
     main="PM2.5 Emissions Over Years in U.S.")
axis(1, at=xp)
axis(2, at=yp)

dev.copy(png,"./EDAProject2/CodeAndPlots/Plot1.png")
dev.off()