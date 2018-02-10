### trialing marxan in R
### 01/08/18

### package marxanui: http://marxan.net/index.php/marxanui
### dependencies ####
pkgTest("doParallel")
pkgTest("foreach")
pkgTest("foreign")
pkgTest("gplots")
pkgTest("Hmisc")
pkgTest("iptools")
pkgTest("labdsv")
pkgTest("leaflet")
pkgTest("maptools")
pkgTest("PBSmapping")
pkgTest("png")
pkgTest("rgdal")
pkgTest("rgeos")
pkgTest("rhandsontable")
pkgTest("rjson")
pkgTest("shiny")
pkgTest("shinyBS")
pkgTest("sp")
pkgTest("sqldf")
pkgTest("vegan")
pkgTest("xtable")
pkgTest("sf")
library(marxanui)
#####


### launching apps ####
library(marxanui)       # Load the R package

launch_app("import")    # Launch the import app to import your own data

launch_app("marxan")    # Launch the marxan app to run Marxan

launch_app("mxptest")   # Launch the parameter testing app to do BLM, SPF calibration, and target sensitivity testing

launch_app("marzone")   # Launch the marzone app to run MarZone

launch_app("manage")    # Launch the manage app to manage your datasets
#####

### new route, library(marxan) ####
rasterRescale<-function(r){
  r.min = cellStats(r, "min")
  r.max = cellStats(r, "max")
  r.scale <- ((r - r.min) / (r.max - r.min) - 0.5 ) * 2
  return(r.scale) #(r-rmin)/(rmax-rmin)
}

alt_rasterRescale=function(r){
  r.min = cellStats(r, "min")
  r.max = cellStats(r, "max")
  #r.scale <--1+(r.max--1)*(r-r.min)/(r.max-r.min)
  r.scale <- -1+(r-r.min)*((0--1)/(r.max-r.min))
  #r.scale <- (r - r.min) / (r.max - r.min)
  return(r.scale)
}

install.packages("marxan")
if (!require('devtools'))
  install.packages('devtools', repo='http://cran.rstudio.com', dep=TRUE)
devtools::install_github('paleo13/marxan')
#devtools::install_github('jeffreyhanson/marxan')

vignette('quickstart', package='marxan')
vignette('tutorial', package='marxan')
vignette('classes', package='marxan')

library(marxan)
library(tidyverse)

##tasinvis=rasterStack
get_date="2014-11-01"
speciesdirs=c("blshobs","blshtrk","casl","lbst","swor")
dailypreddir="~/Dropbox/Eco-ROMS/Model Prediction Plots/daily_predictions/"

#speciesdirs=c("blshobs","blshtrk_nolat","casl_noLat","lbst_nolat","swor") nahhh cuz swor is gonna be the cost
speciesdirs=c("blshobs","blshtrk_nolat","casl_noLat","lbst_nolat")
fullnames=lapply(speciesdirs,function(x)paste0(dailypreddir,x,"/",x,"_",get_date,"_mean.grd")) %>% stack() ## biodiversity features

### cost
swor=paste0(dailypreddir,"swor/swor_",get_date,"_mean.grd") %>% raster()
a=rasterToPolygons(swor)
a@data$id=1:nrow(a)
a@data$cost=a@data$layer
a@data$status=0L
a@data=a@data[,2:4]

results<-marxan(a, fullnames, targets="20%", spf=1, NUMREPS=100L, NCORES=2L, BLM=0, lengthFactor=1e-5)
results2<-marxan(a, fullnames, targets="20%", spf=1, NUMREPS=1000L, NCORES=2L, BLM=0, lengthFactor=1e-5)

hist(rowMeans(targetsmet(results)), freq=TRUE, xlim=c(0,1), las=1,
     main='Histogram of representation in portfolio',
     ylab='Frequency of solutions',
     xlab='Proportion of veg. classes adequately represented'
)

results2.repr<-rowMeans(targetsmet(results2))

plot(results,colramp='YlGnBu')
b=results %>% raster()
plot(results2,colramp='YlGnBu')
b=results2@results@summary

summary(results@results@selections)
dim(results@results@selections)
b=results2@results@selections %>% as.matrix()
#*1 %>% as.tibble()
c=b*1
d=as.data.frame(c) %>% colSums()
e=as.matrix(d) %>% as.data.frame()
colnames(e)[1]="Freq"
#e$lon=results@data@polygons$X

a$selection_freq=e$Freq
aa=rasterize(a,swor,"selection_freq")
plot(aa)
bb=rasterRescale(aa)

### 0 - 1

par(mar=c(4,4,1,1)) # I usually set my margins before each plot
pal <- colorRampPalette(c("red","orange","white","cyan","blue")) #c("red","orange","white","cyan","blue")
#pal <- colorRampPalette(c("purple4", "white", "blue"))
ncolors <- 100
breaks <- seq(-1,1,,ncolors+1)
image(bb, col=rev(pal(ncolors)), breaks=breaks, ylab="", xlab="", xlim=c(-130,-115.5),ylim=c(30,48))
maps::map('worldHires',add=TRUE,col=grey(0.7),fill=TRUE)
contour(bb, add=TRUE, col="black",levels=c(300,600,900))

### fill w swor
cc=aa
values(cc)[values(cc)<100]=NA 
  tt=cc*-1
  tt=alt_rasterRescale(tt)
dd=cover(tt,swor)
ee=rasterRescale(dd)
par(mar=c(4,4,1,1)) # I usually set my margins before each plot
pal <- colorRampPalette(c("red","orange","white","cyan","blue")) #c("red","orange","white","cyan","blue")
#pal <- colorRampPalette(c("purple4", "white", "blue"))
ncolors <- 100
breaks <- seq(-1,1,,ncolors+1)
image(ee, col=rev(pal(ncolors)), breaks=breaks, ylab="", xlab="", xlim=c(-130,-115.5),ylim=c(30,48))
maps::map('worldHires',add=TRUE,col=grey(0.7),fill=TRUE)
contour(ee, add=TRUE, col="black",levels=c(-.5,.5))


#a=setValues(swor,e)
