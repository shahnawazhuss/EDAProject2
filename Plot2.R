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
EDBaltimore<-filter(ED,fips=="24510")
EDBaltiGrpbyY<-group_by(EDBaltimore,year)
BaltiEmByY<-summarise(EDBaltiGrpbyY,TotBalEm=sum(Emissions))
#Plotting 
px<-c(1999,2002,2005,2008)
py<-c(2000,2500,3000,3500)
plot(BaltiEmByY$year,BaltiEmByY$TotBalEm,type="l",axes=F,frame.plot = T,lwd=2,
     main = "PM2.5 Emissions in Baltimore Over Years",
     xlab = "Years",
     ylab = "Tons of PM2.5 Emissions")
axis(1,at=px)
axis(2,at=py)

dev.copy(png,"./EDAProject2/CodeAndPlots/Plot2.png")
dev.off()