# step 4. extract all values at all points for hindcast analysis
# a. strip data down to date, lat, long, sp_name
# b. build new extracto function for ecoroms and marxan
# c. run extracto
# d. make some plots
namesrisk<-c("Blue shark bycatch","Blue sharks","Sea lions","Leatherbacks","Swordfish")
library(tidyverse)
library(raster)
library(sp)
library(tidyverse)
library(rworldmap)
library(rgdal)
library(rasterVis)
library(RColorBrewer)
library(ggmap)
library(grid)
library(lattice)
library(gridExtra)
library(maptools)
library(dplyr)
library(reshape)
library(tidyverse)

##### b. build new extracto function for ecoroms and marxan ####
## ---------------------------- > putting this in a new R file so it can be sourced
extracto_raster=function(algorithm,pts,solution_list,weightings){
  dates=pts$dt %>% unique() %>% as.character()
  for(x in dates){
    print(x)
    ras=grep(x,solution_list,value = T) %>% raster()
    points=filter(pts,dt==x)
    coordinates(points)=~lon+lat
    ex=extract(ras,points)
    pts[pts$dt==x,algorithm]=ex
  }
  return(pts)
}

#### -------------------------------------------------- > ## (run 1) ####
##### a. strip observer and tracking data down to date, lat, long, sp_name #####
species=read.csv("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/raw_data/observer_casl_swor_blsh_lbst_roms_2005_08_10.csv") %>% select(c("SpCd","dt","lat","lon"))
species$sp_name=NA
species[species$SpCd=="UO","sp_name"]="CASL"
species[species$SpCd=="DC","sp_name"]="LBST"
species[species$SpCd=="91","sp_name"]="SWOR"
species[species$SpCd=="167","sp_name"]="BLSH"



tracking=read.csv("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/raw_data/trk_casl_blsh_lbst_roms_2005_08_10.csv") %>% select(c("sp_name","dt","lat","lon"))

#### observer first ####
##### c. run extracto (ecoroms) ####
weightings<-c(-0.1,-0.1,-0.05,-0.9,0.9)
ecoroms=list.files("~/Dropbox/Eco-ROMS/EcoROMSruns/output/mean",pattern=".grd",full.names = T) %>% grep(paste0(weightings,collapse="_"),.,value=T) #%>% grep("_2005-",.,value=T)
a=extracto_raster(pts=species,algorithm="EcoROMS",solution_list = ecoroms,weightings = weightings)

##### c. run extracto (marxan) ####
weightings<-c(-0.1,-0.1,-0.05,-0.2,0.1)
marxan_raw=list.files("~/Dropbox/Eco-ROMS/EcoROMSruns/output/marxan",pattern=".grd",full.names = T) %>% grep(paste0(weightings,collapse="_"),.,value=T) %>% grep("_raw",.,value=T)
marxan_mosaic=list.files("~/Dropbox/Eco-ROMS/EcoROMSruns/output/marxan",pattern=".grd",full.names = T) %>% grep(paste0(weightings,collapse="_"),.,value=T) %>% grep("_mosaic.grd$",.,value=T)
marxan_mosaic01=list.files("~/Dropbox/Eco-ROMS/EcoROMSruns/output/marxan",pattern=".grd",full.names = T) %>% grep(paste0(weightings,collapse="_"),.,value=T) %>% grep("_mosaic01.grd$",.,value=T)

a=extracto_raster(pts=a,algorithm="Marxan_raw",solution_list = marxan_raw,weightings = weightings)
a=extracto_raster(pts=a,algorithm="Marxan_mosaic",solution_list = marxan_mosaic,weightings = weightings)
obs=extracto_raster(pts=a,algorithm="Marxan_mosaic01",solution_list = marxan_mosaic01,weightings = weightings) %>% select(-SpCd)

## tracking second ####
#### c. run extracto (ecoroms) ####
weightings<-c(-0.1,-0.1,-0.05,-0.9,0.9)
a=extracto_raster(pts=tracking,algorithm="EcoROMS",solution_list = ecoroms,weightings = weightings)

##### c. run extracto (marxan) ####
weightings<-c(-0.1,-0.1,-0.05,-0.2,0.1)

a=extracto_raster(pts=a,algorithm="Marxan_raw",solution_list = marxan_raw,weightings = weightings)
a=extracto_raster(pts=a,algorithm="Marxan_mosaic",solution_list = marxan_mosaic,weightings = weightings)
trk=extracto_raster(pts=a,algorithm="Marxan_mosaic01",solution_list = marxan_mosaic01,weightings = weightings)

##### d. make some plots ####
master=rbind(obs,trk)
write.csv(master,"/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/raw_data/species_predict_2005_08_10_run1.csv")

### boxplots ####
weightings<-c(-0.1,-0.1,-0.05,-0.9,0.9)
algorithm="EcoROMS"
index=NULL
index=grep(print(algorithm),names(master))
subtitle=paste0(namesrisk[1],": ",weightings[1],", ",namesrisk[2],": ",weightings[2],", ",namesrisk[3],": ",weightings[3],", ",namesrisk[4],": ",weightings[4],", ",namesrisk[5],": ",weightings[5])
a=ggplot(data=master,aes(x=sp_name,y=master[,index]))+geom_boxplot()
a=a+ggtitle(label = paste0("Weighted ", algorithm," predictions at obs & trk data from 2005"),subtitle = subtitle)+labs(x="Species catch events")+labs(y="EcoROMS prediction")+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
png(paste0("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/box_",paste0(weightings,collapse="_"),"_",algorithm,".png"),width=5,height=5,units='in',res=400)
a
dev.off()

weightings<-c(-0.1,-0.1,-0.05,-0.2,0.1)
algorithm="Marxan_raw"
index=NULL
index=grep(print(algorithm),names(master))
subtitle=paste0(namesrisk[1],": ",weightings[1],", ",namesrisk[2],": ",weightings[2],", ",namesrisk[3],": ",weightings[3],", ",namesrisk[4],": ",weightings[4],", ",namesrisk[5],": ",weightings[5])
a=ggplot(data=master,aes(x=sp_name,y=master[,index]))+geom_boxplot()
a=a+ggtitle(label = paste0("Weighted ", algorithm," predictions at obs & trk data from 2005"),subtitle = subtitle)+labs(x="Species catch events")+labs(y="EcoROMS prediction")+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
png(paste0("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/box_",paste0(weightings,collapse="_"),"_",algorithm,".png"),width=5,height=5,units='in',res=400)
a
dev.off()

weightings<-c(-0.1,-0.1,-0.05,-0.2,0.1)
algorithm="^Marxan_mosaic$"
index=NULL
index=grep(print(algorithm),names(master))
subtitle=paste0(namesrisk[1],": ",weightings[1],", ",namesrisk[2],": ",weightings[2],", ",namesrisk[3],": ",weightings[3],", ",namesrisk[4],": ",weightings[4],", ",namesrisk[5],": ",weightings[5])
a=ggplot(data=master,aes(x=sp_name,y=master[,index]))+geom_boxplot()
a=a+ggtitle(label = paste0("Weighted ", algorithm," predictions at obs & trk data from 2005"),subtitle = subtitle)+labs(x="Species catch events")+labs(y="EcoROMS prediction")+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
png(paste0("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/box_",paste0(weightings,collapse="_"),"_",algorithm,".png"),width=5,height=5,units='in',res=400)
a
dev.off()

weightings<-c(-0.1,-0.1,-0.05,-0.2,0.1)
algorithm="^Marxan_mosaic01$"
index=NULL
index=grep(print(algorithm),names(master))
subtitle=paste0(namesrisk[1],": ",weightings[1],", ",namesrisk[2],": ",weightings[2],", ",namesrisk[3],": ",weightings[3],", ",namesrisk[4],": ",weightings[4],", ",namesrisk[5],": ",weightings[5])
a=ggplot(data=master,aes(x=sp_name,y=master[,index]))+geom_boxplot()
a=a+ggtitle(label = paste0("Weighted ", algorithm," predictions at obs & trk data from 2005"),subtitle = subtitle)+labs(x="Species catch events")+labs(y="EcoROMS prediction")+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
png(paste0("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/box_",paste0(weightings,collapse="_"),"_",algorithm,".png"),width=5,height=5,units='in',res=400)
a
dev.off()


### maps full #####
clean=master[complete.cases(master),]
map.US <- map_data(map="state")

weightings<-c(-0.1,-0.1,-0.05,-0.9,0.9)
algorithm="EcoROMS"
index=NULL
index=grep(print(algorithm),names(master))
subtitle=paste0(namesrisk[1],": ",weightings[1],", ",namesrisk[2],": ",weightings[2],", ",namesrisk[3],": ",weightings[3],", ",namesrisk[4],": ",weightings[4],", ",namesrisk[5],": ",weightings[5])
a=ggplot()+geom_map(data=map.US,map=map.US,aes(map_id=region,x=long,y=lat),fill="grey")+coord_cartesian()
a=a+geom_point(data=clean,aes(lon,lat,color=clean[,index]),size=.7,alpha=.4)+coord_cartesian()
a=a+ggtitle(label = paste0("Weighted ", algorithm," predictions at obs & trk data from 2005"),subtitle = subtitle)+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+coord_cartesian(xlim=c(-133,-115),ylim=c(29,49),expand=F)
png(paste0("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/mapfull_",paste0(weightings,collapse="_"),"_",algorithm,".png"),width=5,height=5,units='in',res=400)
a
dev.off()

weightings<-c(-0.1,-0.1,-0.05,-0.2,0.1)
algorithm="Marxan_raw"
index=NULL
index=grep(print(algorithm),names(master))
subtitle=paste0(namesrisk[1],": ",weightings[1],", ",namesrisk[2],": ",weightings[2],", ",namesrisk[3],": ",weightings[3],", ",namesrisk[4],": ",weightings[4],", ",namesrisk[5],": ",weightings[5])
a=ggplot()+geom_map(data=map.US,map=map.US,aes(map_id=region,x=long,y=lat),fill="grey")+coord_cartesian()
a=a+geom_point(data=clean,aes(lon,lat,color=clean[,index]),size=.7,alpha=.4)+coord_cartesian()
a=a+ggtitle(label = paste0("Weighted ", algorithm," predictions at obs & trk data from 2005"),subtitle = subtitle)+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+coord_cartesian(xlim=c(-133,-115),ylim=c(29,49),expand=F)
png(paste0("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/mapfull_",paste0(weightings,collapse="_"),"_",algorithm,".png"),width=5,height=5,units='in',res=400)
a
dev.off()

weightings<-c(-0.1,-0.1,-0.05,-0.2,0.1)
algorithm="^Marxan_mosaic$"
index=NULL
index=grep(print(algorithm),names(master))
subtitle=paste0(namesrisk[1],": ",weightings[1],", ",namesrisk[2],": ",weightings[2],", ",namesrisk[3],": ",weightings[3],", ",namesrisk[4],": ",weightings[4],", ",namesrisk[5],": ",weightings[5])
a=ggplot()+geom_map(data=map.US,map=map.US,aes(map_id=region,x=long,y=lat),fill="grey")+coord_cartesian()
a=a+geom_point(data=clean,aes(lon,lat,color=clean[,index]),size=.7,alpha=.4)+coord_cartesian()
a=a+ggtitle(label = paste0("Weighted ", algorithm," predictions at obs & trk data from 2005"),subtitle = subtitle)+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+coord_cartesian(xlim=c(-133,-115),ylim=c(29,49),expand=F)
png(paste0("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/mapfull_",paste0(weightings,collapse="_"),"_",algorithm,".png"),width=5,height=5,units='in',res=400)
a
dev.off()

weightings<-c(-0.1,-0.1,-0.05,-0.2,0.1)
algorithm="^Marxan_mosaic01$"
index=NULL
index=grep(print(algorithm),names(master))
subtitle=paste0(namesrisk[1],": ",weightings[1],", ",namesrisk[2],": ",weightings[2],", ",namesrisk[3],": ",weightings[3],", ",namesrisk[4],": ",weightings[4],", ",namesrisk[5],": ",weightings[5])
a=ggplot()+geom_map(data=map.US,map=map.US,aes(map_id=region,x=long,y=lat),fill="grey")+coord_cartesian()
a=a+geom_point(data=clean,aes(lon,lat,color=clean[,index]),size=.7,alpha=.4)+coord_cartesian()
a=a+ggtitle(label = paste0("Weighted ", algorithm," predictions at obs & trk data from 2005"),subtitle = subtitle)+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+coord_cartesian(xlim=c(-133,-115),ylim=c(29,49),expand=F)
png(paste0("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/mapfull_",paste0(weightings,collapse="_"),"_",algorithm,".png"),width=5,height=5,units='in',res=400)
a
dev.off()

### maps by species: turtles #####
clean=master[complete.cases(master),] %>% filter(sp_name=="lbst")
map.US <- map_data(map="state")

weightings<-c(-0.1,-0.1,-0.05,-0.9,0.9)
algorithm="EcoROMS"
index=NULL
index=grep(print(algorithm),names(master))
subtitle=paste0(namesrisk[1],": ",weightings[1],", ",namesrisk[2],": ",weightings[2],", ",namesrisk[3],": ",weightings[3],", ",namesrisk[4],": ",weightings[4],", ",namesrisk[5],": ",weightings[5])
a=ggplot()+geom_map(data=map.US,map=map.US,aes(map_id=region,x=long,y=lat),fill="grey")+coord_cartesian()
a=a+geom_point(data=clean,aes(lon,lat,color=clean[,index]),size=.7,alpha=.4)+coord_cartesian()
a=a+ggtitle(label = paste0("Weighted ", algorithm," predictions at obs & trk data from 2005: lbst"),subtitle = subtitle)+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+coord_cartesian(xlim=c(-133,-115),ylim=c(29,49),expand=F)
png(paste0("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/map_lbst_",paste0(weightings,collapse="_"),"_",algorithm,".png"),width=5,height=5,units='in',res=400)
a
dev.off()

weightings<-c(-0.1,-0.1,-0.05,-0.2,0.1)
algorithm="Marxan_raw"
index=NULL
index=grep(print(algorithm),names(master))
subtitle=paste0(namesrisk[1],": ",weightings[1],", ",namesrisk[2],": ",weightings[2],", ",namesrisk[3],": ",weightings[3],", ",namesrisk[4],": ",weightings[4],", ",namesrisk[5],": ",weightings[5])
a=ggplot()+geom_map(data=map.US,map=map.US,aes(map_id=region,x=long,y=lat),fill="grey")+coord_cartesian()
a=a+geom_point(data=clean,aes(lon,lat,color=clean[,index]),size=.7,alpha=.4)+coord_cartesian()
a=a+ggtitle(label = paste0("Weighted ", algorithm," predictions at obs & trk data from 2005: lbst"),subtitle = subtitle)+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+coord_cartesian(xlim=c(-133,-115),ylim=c(29,49),expand=F)
png(paste0("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/map_lbst_",paste0(weightings,collapse="_"),"_",algorithm,".png"),width=5,height=5,units='in',res=400)
a
dev.off()

weightings<-c(-0.1,-0.1,-0.05,-0.2,0.1)
algorithm="^Marxan_mosaic$"
index=NULL
index=grep(print(algorithm),names(master))
subtitle=paste0(namesrisk[1],": ",weightings[1],", ",namesrisk[2],": ",weightings[2],", ",namesrisk[3],": ",weightings[3],", ",namesrisk[4],": ",weightings[4],", ",namesrisk[5],": ",weightings[5])
a=ggplot()+geom_map(data=map.US,map=map.US,aes(map_id=region,x=long,y=lat),fill="grey")+coord_cartesian()
a=a+geom_point(data=clean,aes(lon,lat,color=clean[,index]),size=.7,alpha=.4)+coord_cartesian()
a=a+ggtitle(label = paste0("Weighted ", algorithm," predictions at obs & trk data from 2005: lbst"),subtitle = subtitle)+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+coord_cartesian(xlim=c(-133,-115),ylim=c(29,49),expand=F)
png(paste0("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/map_lbst_",paste0(weightings,collapse="_"),"_",algorithm,".png"),width=5,height=5,units='in',res=400)
a
dev.off()

weightings<-c(-0.1,-0.1,-0.05,-0.2,0.1)
algorithm="^Marxan_mosaic01$"
index=NULL
index=grep(print(algorithm),names(master))
subtitle=paste0(namesrisk[1],": ",weightings[1],", ",namesrisk[2],": ",weightings[2],", ",namesrisk[3],": ",weightings[3],", ",namesrisk[4],": ",weightings[4],", ",namesrisk[5],": ",weightings[5])
a=ggplot()+geom_map(data=map.US,map=map.US,aes(map_id=region,x=long,y=lat),fill="grey")+coord_cartesian()
a=a+geom_point(data=clean,aes(lon,lat,color=clean[,index]),size=.7,alpha=.4)+coord_cartesian()
a=a+ggtitle(label = paste0("Weighted ", algorithm," predictions at obs & trk data from 2005: lbst"),subtitle = subtitle)+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+coord_cartesian(xlim=c(-133,-115),ylim=c(29,49),expand=F)
png(paste0("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/map_lbst_",paste0(weightings,collapse="_"),"_",algorithm,".png"),width=5,height=5,units='in',res=400)
a
dev.off()


### maps by species: swor #####
clean=master[complete.cases(master),] %>% filter(sp_name=="SWOR")
map.US <- map_data(map="state")

weightings<-c(-0.1,-0.1,-0.05,-0.9,0.9)
algorithm="EcoROMS"
index=NULL
index=grep(print(algorithm),names(master))
subtitle=paste0(namesrisk[1],": ",weightings[1],", ",namesrisk[2],": ",weightings[2],", ",namesrisk[3],": ",weightings[3],", ",namesrisk[4],": ",weightings[4],", ",namesrisk[5],": ",weightings[5])
a=ggplot()+geom_map(data=map.US,map=map.US,aes(map_id=region,x=long,y=lat),fill="grey")+coord_cartesian()
a=a+geom_point(data=clean,aes(lon,lat,color=clean[,index]),size=.7,alpha=.4)+coord_cartesian()
a=a+ggtitle(label = paste0("Weighted ", algorithm," predictions at obs & trk data from 2005: swor"),subtitle = subtitle)+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+coord_cartesian(xlim=c(-133,-115),ylim=c(29,49),expand=F)
png(paste0("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/map_swor_",paste0(weightings,collapse="_"),"_",algorithm,".png"),width=5,height=5,units='in',res=400)
a
dev.off()

weightings<-c(-0.1,-0.1,-0.05,-0.2,0.1)
algorithm="Marxan_raw"
index=NULL
index=grep(print(algorithm),names(master))
subtitle=paste0(namesrisk[1],": ",weightings[1],", ",namesrisk[2],": ",weightings[2],", ",namesrisk[3],": ",weightings[3],", ",namesrisk[4],": ",weightings[4],", ",namesrisk[5],": ",weightings[5])
a=ggplot()+geom_map(data=map.US,map=map.US,aes(map_id=region,x=long,y=lat),fill="grey")+coord_cartesian()
a=a+geom_point(data=clean,aes(lon,lat,color=clean[,index]),size=.7,alpha=.4)+coord_cartesian()
a=a+ggtitle(label = paste0("Weighted ", algorithm," predictions at obs & trk data from 2005: swor"),subtitle = subtitle)+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+coord_cartesian(xlim=c(-133,-115),ylim=c(29,49),expand=F)
png(paste0("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/map_swor_",paste0(weightings,collapse="_"),"_",algorithm,".png"),width=5,height=5,units='in',res=400)
a
dev.off()

weightings<-c(-0.1,-0.1,-0.05,-0.2,0.1)
algorithm="^Marxan_mosaic$"
index=NULL
index=grep(print(algorithm),names(master))
subtitle=paste0(namesrisk[1],": ",weightings[1],", ",namesrisk[2],": ",weightings[2],", ",namesrisk[3],": ",weightings[3],", ",namesrisk[4],": ",weightings[4],", ",namesrisk[5],": ",weightings[5])
a=ggplot()+geom_map(data=map.US,map=map.US,aes(map_id=region,x=long,y=lat),fill="grey")+coord_cartesian()
a=a+geom_point(data=clean,aes(lon,lat,color=clean[,index]),size=.7,alpha=.4)+coord_cartesian()
a=a+ggtitle(label = paste0("Weighted ", algorithm," predictions at obs & trk data from 2005: swor"),subtitle = subtitle)+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+coord_cartesian(xlim=c(-133,-115),ylim=c(29,49),expand=F)
png(paste0("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/map_swor_",paste0(weightings,collapse="_"),"_",algorithm,".png"),width=5,height=5,units='in',res=400)
a
dev.off()

weightings<-c(-0.1,-0.1,-0.05,-0.2,0.1)
algorithm="^Marxan_mosaic01$"
index=NULL
index=grep(print(algorithm),names(master))
subtitle=paste0(namesrisk[1],": ",weightings[1],", ",namesrisk[2],": ",weightings[2],", ",namesrisk[3],": ",weightings[3],", ",namesrisk[4],": ",weightings[4],", ",namesrisk[5],": ",weightings[5])
a=ggplot()+geom_map(data=map.US,map=map.US,aes(map_id=region,x=long,y=lat),fill="grey")+coord_cartesian()
a=a+geom_point(data=clean,aes(lon,lat,color=clean[,index]),size=.7,alpha=.4)+coord_cartesian()
a=a+ggtitle(label = paste0("Weighted ", algorithm," predictions at obs & trk data from 2005: swor"),subtitle = subtitle)+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+coord_cartesian(xlim=c(-133,-115),ylim=c(29,49),expand=F)
png(paste0("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/map_swor_",paste0(weightings,collapse="_"),"_",algorithm,".png"),width=5,height=5,units='in',res=400)
a
dev.off()


### maps by species: casl #####
clean=master[complete.cases(master),] %>% filter(sp_name=="casl")
map.US <- map_data(map="state")

weightings<-c(-0.1,-0.1,-0.05,-0.9,0.9)
algorithm="EcoROMS"
index=NULL
index=grep(print(algorithm),names(master))
subtitle=paste0(namesrisk[1],": ",weightings[1],", ",namesrisk[2],": ",weightings[2],", ",namesrisk[3],": ",weightings[3],", ",namesrisk[4],": ",weightings[4],", ",namesrisk[5],": ",weightings[5])
a=ggplot()+geom_map(data=map.US,map=map.US,aes(map_id=region,x=long,y=lat),fill="grey")+coord_cartesian()
a=a+geom_point(data=clean,aes(lon,lat,color=clean[,index]),size=.7,alpha=.4)+coord_cartesian()
a=a+ggtitle(label = paste0("Weighted ", algorithm," predictions at obs & trk data from 2005: casl"),subtitle = subtitle)+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+coord_cartesian(xlim=c(-133,-115),ylim=c(29,49),expand=F)
png(paste0("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/map_casl_",paste0(weightings,collapse="_"),"_",algorithm,".png"),width=5,height=5,units='in',res=400)
a
dev.off()

weightings<-c(-0.1,-0.1,-0.05,-0.2,0.1)
algorithm="Marxan_raw"
index=NULL
index=grep(print(algorithm),names(master))
subtitle=paste0(namesrisk[1],": ",weightings[1],", ",namesrisk[2],": ",weightings[2],", ",namesrisk[3],": ",weightings[3],", ",namesrisk[4],": ",weightings[4],", ",namesrisk[5],": ",weightings[5])
a=ggplot()+geom_map(data=map.US,map=map.US,aes(map_id=region,x=long,y=lat),fill="grey")+coord_cartesian()
a=a+geom_point(data=clean,aes(lon,lat,color=clean[,index]),size=.7,alpha=.4)+coord_cartesian()
a=a+ggtitle(label = paste0("Weighted ", algorithm," predictions at obs & trk data from 2005: casl"),subtitle = subtitle)+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+coord_cartesian(xlim=c(-133,-115),ylim=c(29,49),expand=F)
png(paste0("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/map_casl_",paste0(weightings,collapse="_"),"_",algorithm,".png"),width=5,height=5,units='in',res=400)
a
dev.off()

weightings<-c(-0.1,-0.1,-0.05,-0.2,0.1)
algorithm="^Marxan_mosaic$"
index=NULL
index=grep(print(algorithm),names(master))
subtitle=paste0(namesrisk[1],": ",weightings[1],", ",namesrisk[2],": ",weightings[2],", ",namesrisk[3],": ",weightings[3],", ",namesrisk[4],": ",weightings[4],", ",namesrisk[5],": ",weightings[5])
a=ggplot()+geom_map(data=map.US,map=map.US,aes(map_id=region,x=long,y=lat),fill="grey")+coord_cartesian()
a=a+geom_point(data=clean,aes(lon,lat,color=clean[,index]),size=.7,alpha=.4)+coord_cartesian()
a=a+ggtitle(label = paste0("Weighted ", algorithm," predictions at obs & trk data from 2005: casl"),subtitle = subtitle)+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+coord_cartesian(xlim=c(-133,-115),ylim=c(29,49),expand=F)
png(paste0("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/map_casl_",paste0(weightings,collapse="_"),"_",algorithm,".png"),width=5,height=5,units='in',res=400)
a
dev.off()

weightings<-c(-0.1,-0.1,-0.05,-0.2,0.1)
algorithm="^Marxan_mosaic01$"
index=NULL
index=grep(print(algorithm),names(master))
subtitle=paste0(namesrisk[1],": ",weightings[1],", ",namesrisk[2],": ",weightings[2],", ",namesrisk[3],": ",weightings[3],", ",namesrisk[4],": ",weightings[4],", ",namesrisk[5],": ",weightings[5])
a=ggplot()+geom_map(data=map.US,map=map.US,aes(map_id=region,x=long,y=lat),fill="grey")+coord_cartesian()
a=a+geom_point(data=clean,aes(lon,lat,color=clean[,index]),size=.7,alpha=.4)+coord_cartesian()
a=a+ggtitle(label = paste0("Weighted ", algorithm," predictions at obs & trk data from 2005: casl"),subtitle = subtitle)+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+coord_cartesian(xlim=c(-133,-115),ylim=c(29,49),expand=F)
png(paste0("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/map_casl_",paste0(weightings,collapse="_"),"_",algorithm,".png"),width=5,height=5,units='in',res=400)
a
dev.off()


### maps by species: blshtrk #####
clean=master[complete.cases(master),] %>% filter(sp_name=="blshtrk")
map.US <- map_data(map="state")

weightings<-c(-0.1,-0.1,-0.05,-0.9,0.9)
algorithm="EcoROMS"
index=NULL
index=grep(print(algorithm),names(master))
subtitle=paste0(namesrisk[1],": ",weightings[1],", ",namesrisk[2],": ",weightings[2],", ",namesrisk[3],": ",weightings[3],", ",namesrisk[4],": ",weightings[4],", ",namesrisk[5],": ",weightings[5])
a=ggplot()+geom_map(data=map.US,map=map.US,aes(map_id=region,x=long,y=lat),fill="grey")+coord_cartesian()
a=a+geom_point(data=clean,aes(lon,lat,color=clean[,index]),size=.7,alpha=.4)+coord_cartesian()
a=a+ggtitle(label = paste0("Weighted ", algorithm," predictions at obs & trk data from 2005: blshtrk"),subtitle = subtitle)+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+coord_cartesian(xlim=c(-133,-115),ylim=c(29,49),expand=F)
png(paste0("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/map_blshtrk_",paste0(weightings,collapse="_"),"_",algorithm,".png"),width=5,height=5,units='in',res=400)
a
dev.off()

weightings<-c(-0.1,-0.1,-0.05,-0.2,0.1)
algorithm="Marxan_raw"
index=NULL
index=grep(print(algorithm),names(master))
subtitle=paste0(namesrisk[1],": ",weightings[1],", ",namesrisk[2],": ",weightings[2],", ",namesrisk[3],": ",weightings[3],", ",namesrisk[4],": ",weightings[4],", ",namesrisk[5],": ",weightings[5])
a=ggplot()+geom_map(data=map.US,map=map.US,aes(map_id=region,x=long,y=lat),fill="grey")+coord_cartesian()
a=a+geom_point(data=clean,aes(lon,lat,color=clean[,index]),size=.7,alpha=.4)+coord_cartesian()
a=a+ggtitle(label = paste0("Weighted ", algorithm," predictions at obs & trk data from 2005: blshtrk"),subtitle = subtitle)+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+coord_cartesian(xlim=c(-133,-115),ylim=c(29,49),expand=F)
png(paste0("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/map_blshtrk_",paste0(weightings,collapse="_"),"_",algorithm,".png"),width=5,height=5,units='in',res=400)
a
dev.off()

weightings<-c(-0.1,-0.1,-0.05,-0.2,0.1)
algorithm="^Marxan_mosaic$"
index=NULL
index=grep(print(algorithm),names(master))
subtitle=paste0(namesrisk[1],": ",weightings[1],", ",namesrisk[2],": ",weightings[2],", ",namesrisk[3],": ",weightings[3],", ",namesrisk[4],": ",weightings[4],", ",namesrisk[5],": ",weightings[5])
a=ggplot()+geom_map(data=map.US,map=map.US,aes(map_id=region,x=long,y=lat),fill="grey")+coord_cartesian()
a=a+geom_point(data=clean,aes(lon,lat,color=clean[,index]),size=.7,alpha=.4)+coord_cartesian()
a=a+ggtitle(label = paste0("Weighted ", algorithm," predictions at obs & trk data from 2005: blshtrk"),subtitle = subtitle)+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+coord_cartesian(xlim=c(-133,-115),ylim=c(29,49),expand=F)
png(paste0("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/map_blshtrk_",paste0(weightings,collapse="_"),"_",algorithm,".png"),width=5,height=5,units='in',res=400)
a
dev.off()

weightings<-c(-0.1,-0.1,-0.05,-0.2,0.1)
algorithm="^Marxan_mosaic01$"
index=NULL
index=grep(print(algorithm),names(master))
subtitle=paste0(namesrisk[1],": ",weightings[1],", ",namesrisk[2],": ",weightings[2],", ",namesrisk[3],": ",weightings[3],", ",namesrisk[4],": ",weightings[4],", ",namesrisk[5],": ",weightings[5])
a=ggplot()+geom_map(data=map.US,map=map.US,aes(map_id=region,x=long,y=lat),fill="grey")+coord_cartesian()
a=a+geom_point(data=clean,aes(lon,lat,color=clean[,index]),size=.7,alpha=.4)+coord_cartesian()
a=a+ggtitle(label = paste0("Weighted ", algorithm," predictions at obs & trk data from 2005: blshtrk"),subtitle = subtitle)+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+coord_cartesian(xlim=c(-133,-115),ylim=c(29,49),expand=F)
png(paste0("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/map_blshtrk_",paste0(weightings,collapse="_"),"_",algorithm,".png"),width=5,height=5,units='in',res=400)
a
dev.off()

### maps by species: blshobs #####
clean=master[complete.cases(master),] %>% filter(sp_name=="BLSH")
map.US <- map_data(map="state")

weightings<-c(-0.1,-0.1,-0.05,-0.9,0.9)
algorithm="EcoROMS"
index=NULL
index=grep(print(algorithm),names(master))
subtitle=paste0(namesrisk[1],": ",weightings[1],", ",namesrisk[2],": ",weightings[2],", ",namesrisk[3],": ",weightings[3],", ",namesrisk[4],": ",weightings[4],", ",namesrisk[5],": ",weightings[5])
a=ggplot()+geom_map(data=map.US,map=map.US,aes(map_id=region,x=long,y=lat),fill="grey")+coord_cartesian()
a=a+geom_point(data=clean,aes(lon,lat,color=clean[,index]),size=.7,alpha=.4)+coord_cartesian()
a=a+ggtitle(label = paste0("Weighted ", algorithm," predictions at obs & trk data from 2005: BLSH"),subtitle = subtitle)+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+coord_cartesian(xlim=c(-133,-115),ylim=c(29,49),expand=F)
png(paste0("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/map_BLSH_",paste0(weightings,collapse="_"),"_",algorithm,".png"),width=5,height=5,units='in',res=400)
a
dev.off()

weightings<-c(-0.1,-0.1,-0.05,-0.2,0.1)
algorithm="Marxan_raw"
index=NULL
index=grep(print(algorithm),names(master))
subtitle=paste0(namesrisk[1],": ",weightings[1],", ",namesrisk[2],": ",weightings[2],", ",namesrisk[3],": ",weightings[3],", ",namesrisk[4],": ",weightings[4],", ",namesrisk[5],": ",weightings[5])
a=ggplot()+geom_map(data=map.US,map=map.US,aes(map_id=region,x=long,y=lat),fill="grey")+coord_cartesian()
a=a+geom_point(data=clean,aes(lon,lat,color=clean[,index]),size=.7,alpha=.4)+coord_cartesian()
a=a+ggtitle(label = paste0("Weighted ", algorithm," predictions at obs & trk data from 2005: BLSH"),subtitle = subtitle)+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+coord_cartesian(xlim=c(-133,-115),ylim=c(29,49),expand=F)
png(paste0("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/map_BLSH_",paste0(weightings,collapse="_"),"_",algorithm,".png"),width=5,height=5,units='in',res=400)
a
dev.off()

weightings<-c(-0.1,-0.1,-0.05,-0.2,0.1)
algorithm="^Marxan_mosaic$"
index=NULL
index=grep(print(algorithm),names(master))
subtitle=paste0(namesrisk[1],": ",weightings[1],", ",namesrisk[2],": ",weightings[2],", ",namesrisk[3],": ",weightings[3],", ",namesrisk[4],": ",weightings[4],", ",namesrisk[5],": ",weightings[5])
a=ggplot()+geom_map(data=map.US,map=map.US,aes(map_id=region,x=long,y=lat),fill="grey")+coord_cartesian()
a=a+geom_point(data=clean,aes(lon,lat,color=clean[,index]),size=.7,alpha=.4)+coord_cartesian()
a=a+ggtitle(label = paste0("Weighted ", algorithm," predictions at obs & trk data from 2005: BLSH"),subtitle = subtitle)+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+coord_cartesian(xlim=c(-133,-115),ylim=c(29,49),expand=F)
png(paste0("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/map_BLSH_",paste0(weightings,collapse="_"),"_",algorithm,".png"),width=5,height=5,units='in',res=400)
a
dev.off()

weightings<-c(-0.1,-0.1,-0.05,-0.2,0.1)
algorithm="^Marxan_mosaic01$"
index=NULL
index=grep(print(algorithm),names(master))
subtitle=paste0(namesrisk[1],": ",weightings[1],", ",namesrisk[2],": ",weightings[2],", ",namesrisk[3],": ",weightings[3],", ",namesrisk[4],": ",weightings[4],", ",namesrisk[5],": ",weightings[5])
a=ggplot()+geom_map(data=map.US,map=map.US,aes(map_id=region,x=long,y=lat),fill="grey")+coord_cartesian()
a=a+geom_point(data=clean,aes(lon,lat,color=clean[,index]),size=.7,alpha=.4)+coord_cartesian()
a=a+ggtitle(label = paste0("Weighted ", algorithm," predictions at obs & trk data from 2005: BLSH"),subtitle = subtitle)+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+coord_cartesian(xlim=c(-133,-115),ylim=c(29,49),expand=F)
png(paste0("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/map_BLSH_",paste0(weightings,collapse="_"),"_",algorithm,".png"),width=5,height=5,units='in',res=400)
a
dev.off()





# -------------------------------------------------- > ## (run 2)


#### -------------------------------------------------- > ## (run 2) ####
#### a. strip data down to date, lat, long, sp_name####
species=read.csv("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/raw_data/observer_casl_swor_blsh_lbst_roms_2005_08_10.csv") %>% select(c("SpCd","dt","lat","lon"))
species$sp_name=NA
species[species$SpCd=="UO","sp_name"]="CASL"
species[species$SpCd=="DC","sp_name"]="LBST"
species[species$SpCd=="91","sp_name"]="SWOR"
species[species$SpCd=="167","sp_name"]="BLSH"

tracking=read.csv("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/raw_data/trk_casl_blsh_lbst_roms_2005_08_10.csv") %>% select(c("sp_name","dt","lat","lon"))

#### observer first ####
##### c. run extracto (ecoroms) ####
weightings<-c(-0.1,-0.1,-0.05,-1.5,2) 
ecoroms=list.files("~/Dropbox/Eco-ROMS/EcoROMSruns/output/mean",pattern=".grd",full.names = T) %>% grep(paste0(weightings,collapse="_"),.,value=T) #%>% grep("_2005-",.,value=T)
a=extracto_raster(pts=species,algorithm="EcoROMS",solution_list = ecoroms,weightings = weightings)

##### c. run extracto (marxan) ####
weightings<-c(-0.1,-0.1,-0.05,-0.3,0.6)
marxan_raw=list.files("~/Dropbox/Eco-ROMS/EcoROMSruns/output/marxan",pattern=".grd",full.names = T) %>% grep(paste0(weightings,collapse="_"),.,value=T) %>% grep("_raw",.,value=T)
marxan_mosaic=list.files("~/Dropbox/Eco-ROMS/EcoROMSruns/output/marxan",pattern=".grd",full.names = T) %>% grep(paste0(weightings,collapse="_"),.,value=T) %>% grep("_mosaic.grd$",.,value=T)
marxan_mosaic01=list.files("~/Dropbox/Eco-ROMS/EcoROMSruns/output/marxan",pattern=".grd",full.names = T) %>% grep(paste0(weightings,collapse="_"),.,value=T) %>% grep("_mosaic01.grd$",.,value=T)

a=extracto_raster(pts=a,algorithm="Marxan_raw",solution_list = marxan_raw,weightings = weightings)
a=extracto_raster(pts=a,algorithm="Marxan_mosaic",solution_list = marxan_mosaic,weightings = weightings)
obs=extracto_raster(pts=a,algorithm="Marxan_mosaic01",solution_list = marxan_mosaic01,weightings = weightings) %>% select(-SpCd)

## tracking second ####
#### c. run extracto (ecoroms) ####
weightings<-c(-0.1,-0.1,-0.05,-1.5,2) 
a=extracto_raster(pts=tracking,algorithm="EcoROMS",solution_list = ecoroms,weightings = weightings)

##### c. run extracto (marxan) ####
weightings<-c(-0.1,-0.1,-0.05,-0.3,0.6)

a=extracto_raster(pts=a,algorithm="Marxan_raw",solution_list = marxan_raw,weightings = weightings)
a=extracto_raster(pts=a,algorithm="Marxan_mosaic",solution_list = marxan_mosaic,weightings = weightings)
trk=extracto_raster(pts=a,algorithm="Marxan_mosaic01",solution_list = marxan_mosaic01,weightings = weightings)
##### d. make some plots ####
master=rbind(obs,trk)
write.csv(master,"/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/raw_data/species_predict_2005_08_10_run2.csv")


### boxplots, more extreme species weightings # testing swor at it's most extreme ####
weightings<-c(-0.1,-0.1,-0.05,-1.5,2) 
algorithm="EcoROMS"
index=NULL
index=grep(print(algorithm),names(master))
subtitle=paste0(namesrisk[1],": ",weightings[1],", ",namesrisk[2],": ",weightings[2],", ",namesrisk[3],": ",weightings[3],", ",namesrisk[4],": ",weightings[4],", ",namesrisk[5],": ",weightings[5])
a=ggplot(data=master,aes(x=sp_name,y=master[,index]))+geom_boxplot()
a=a+ggtitle(label = paste0("Weighted ", algorithm," predictions at obs & trk data from 2005"),subtitle = subtitle)+labs(x="Species catch events")+labs(y="EcoROMS prediction")+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
png(paste0("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/box_",paste0(weightings,collapse="_"),"_",algorithm,".png"),width=5,height=5,units='in',res=400)
a
dev.off()

weightings<-c(-0.1,-0.1,-0.05,-0.3,0.6)
algorithm="Marxan_raw"
index=NULL
index=grep(print(algorithm),names(master))
subtitle=paste0(namesrisk[1],": ",weightings[1],", ",namesrisk[2],": ",weightings[2],", ",namesrisk[3],": ",weightings[3],", ",namesrisk[4],": ",weightings[4],", ",namesrisk[5],": ",weightings[5])
a=ggplot(data=master,aes(x=sp_name,y=master[,index]))+geom_boxplot()
a=a+ggtitle(label = paste0("Weighted ", algorithm," predictions at obs & trk data from 2005"),subtitle = subtitle)+labs(x="Species catch events")+labs(y="EcoROMS prediction")+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
png(paste0("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/box_",paste0(weightings,collapse="_"),"_",algorithm,".png"),width=5,height=5,units='in',res=400)
a
dev.off()

weightings<-c(-0.1,-0.1,-0.05,-0.3,0.6)
algorithm="^Marxan_mosaic$"
index=NULL
index=grep(print(algorithm),names(master))
subtitle=paste0(namesrisk[1],": ",weightings[1],", ",namesrisk[2],": ",weightings[2],", ",namesrisk[3],": ",weightings[3],", ",namesrisk[4],": ",weightings[4],", ",namesrisk[5],": ",weightings[5])
a=ggplot(data=master,aes(x=sp_name,y=master[,index]))+geom_boxplot()
a=a+ggtitle(label = paste0("Weighted ", algorithm," predictions at obs & trk data from 2005"),subtitle = subtitle)+labs(x="Species catch events")+labs(y="EcoROMS prediction")+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
png(paste0("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/box_",paste0(weightings,collapse="_"),"_",algorithm,".png"),width=5,height=5,units='in',res=400)
a
dev.off()

weightings<-c(-0.1,-0.1,-0.05,-0.3,0.6)
algorithm="^Marxan_mosaic01$"
index=NULL
index=grep(print(algorithm),names(master))
subtitle=paste0(namesrisk[1],": ",weightings[1],", ",namesrisk[2],": ",weightings[2],", ",namesrisk[3],": ",weightings[3],", ",namesrisk[4],": ",weightings[4],", ",namesrisk[5],": ",weightings[5])
a=ggplot(data=master,aes(x=sp_name,y=master[,index]))+geom_boxplot()
a=a+ggtitle(label = paste0("Weighted ", algorithm," predictions at obs & trk data from 2005"),subtitle = subtitle)+labs(x="Species catch events")+labs(y="EcoROMS prediction")+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
png(paste0("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/box_",paste0(weightings,collapse="_"),"_",algorithm,".png"),width=5,height=5,units='in',res=400)
a
dev.off()

# -------------------------------------------------- > ## (run 3)
### maps full #####
clean=master[complete.cases(master),]
map.US <- map_data(map="state")

weightings<-c(-0.1,-0.1,-0.05,-1.5,2) 
algorithm="EcoROMS"
index=NULL
index=grep(print(algorithm),names(master))
subtitle=paste0(namesrisk[1],": ",weightings[1],", ",namesrisk[2],": ",weightings[2],", ",namesrisk[3],": ",weightings[3],", ",namesrisk[4],": ",weightings[4],", ",namesrisk[5],": ",weightings[5])
a=ggplot()+geom_map(data=map.US,map=map.US,aes(map_id=region,x=long,y=lat),fill="grey")+coord_cartesian()
a=a+geom_point(data=clean,aes(lon,lat,color=clean[,index]),size=.7,alpha=.4)+coord_cartesian()
a=a+ggtitle(label = paste0("Weighted ", algorithm," predictions at obs & trk data from 2005"),subtitle = subtitle)+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+coord_cartesian(xlim=c(-133,-115),ylim=c(29,49),expand=F)
png(paste0("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/mapfull_",paste0(weightings,collapse="_"),"_",algorithm,".png"),width=5,height=5,units='in',res=400)
a
dev.off()

weightings<-c(-0.1,-0.1,-0.05,-0.3,0.6)
algorithm="Marxan_raw"
index=NULL
index=grep(print(algorithm),names(master))
subtitle=paste0(namesrisk[1],": ",weightings[1],", ",namesrisk[2],": ",weightings[2],", ",namesrisk[3],": ",weightings[3],", ",namesrisk[4],": ",weightings[4],", ",namesrisk[5],": ",weightings[5])
a=ggplot()+geom_map(data=map.US,map=map.US,aes(map_id=region,x=long,y=lat),fill="grey")+coord_cartesian()
a=a+geom_point(data=clean,aes(lon,lat,color=clean[,index]),size=.7,alpha=.4)+coord_cartesian()
a=a+ggtitle(label = paste0("Weighted ", algorithm," predictions at obs & trk data from 2005"),subtitle = subtitle)+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+coord_cartesian(xlim=c(-133,-115),ylim=c(29,49),expand=F)
png(paste0("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/mapfull_",paste0(weightings,collapse="_"),"_",algorithm,".png"),width=5,height=5,units='in',res=400)
a
dev.off()

weightings<-c(-0.1,-0.1,-0.05,-0.3,0.6)
algorithm="^Marxan_mosaic$"
index=NULL
index=grep(print(algorithm),names(master))
subtitle=paste0(namesrisk[1],": ",weightings[1],", ",namesrisk[2],": ",weightings[2],", ",namesrisk[3],": ",weightings[3],", ",namesrisk[4],": ",weightings[4],", ",namesrisk[5],": ",weightings[5])
a=ggplot()+geom_map(data=map.US,map=map.US,aes(map_id=region,x=long,y=lat),fill="grey")+coord_cartesian()
a=a+geom_point(data=clean,aes(lon,lat,color=clean[,index]),size=.7,alpha=.4)+coord_cartesian()
a=a+ggtitle(label = paste0("Weighted ", algorithm," predictions at obs & trk data from 2005"),subtitle = subtitle)+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+coord_cartesian(xlim=c(-133,-115),ylim=c(29,49),expand=F)
png(paste0("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/mapfull_",paste0(weightings,collapse="_"),"_",algorithm,".png"),width=5,height=5,units='in',res=400)
a
dev.off()

weightings<-c(-0.1,-0.1,-0.05,-0.3,0.6)
algorithm="^Marxan_mosaic01$"
index=NULL
index=grep(print(algorithm),names(master))
subtitle=paste0(namesrisk[1],": ",weightings[1],", ",namesrisk[2],": ",weightings[2],", ",namesrisk[3],": ",weightings[3],", ",namesrisk[4],": ",weightings[4],", ",namesrisk[5],": ",weightings[5])
a=ggplot()+geom_map(data=map.US,map=map.US,aes(map_id=region,x=long,y=lat),fill="grey")+coord_cartesian()
a=a+geom_point(data=clean,aes(lon,lat,color=clean[,index]),size=.7,alpha=.4)+coord_cartesian()
a=a+ggtitle(label = paste0("Weighted ", algorithm," predictions at obs & trk data from 2005"),subtitle = subtitle)+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+coord_cartesian(xlim=c(-133,-115),ylim=c(29,49),expand=F)
png(paste0("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/mapfull_",paste0(weightings,collapse="_"),"_",algorithm,".png"),width=5,height=5,units='in',res=400)
a
dev.off()

### maps by species: turtles #####
clean=master[complete.cases(master),] %>% filter(sp_name=="lbst")
map.US <- map_data(map="state")

weightings<-c(-0.1,-0.1,-0.05,-1.5,2) 
algorithm="EcoROMS"
index=NULL
index=grep(print(algorithm),names(master))
subtitle=paste0(namesrisk[1],": ",weightings[1],", ",namesrisk[2],": ",weightings[2],", ",namesrisk[3],": ",weightings[3],", ",namesrisk[4],": ",weightings[4],", ",namesrisk[5],": ",weightings[5])
a=ggplot()+geom_map(data=map.US,map=map.US,aes(map_id=region,x=long,y=lat),fill="grey")+coord_cartesian()
a=a+geom_point(data=clean,aes(lon,lat,color=clean[,index]),size=.7,alpha=.4)+coord_cartesian()
a=a+ggtitle(label = paste0("Weighted ", algorithm," predictions at obs & trk data from 2005: lbst"),subtitle = subtitle)+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+coord_cartesian(xlim=c(-133,-115),ylim=c(29,49),expand=F)
png(paste0("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/map_lbst_",paste0(weightings,collapse="_"),"_",algorithm,".png"),width=5,height=5,units='in',res=400)
a
dev.off()

weightings<-c(-0.1,-0.1,-0.05,-0.3,0.6)
algorithm="Marxan_raw"
index=NULL
index=grep(print(algorithm),names(master))
subtitle=paste0(namesrisk[1],": ",weightings[1],", ",namesrisk[2],": ",weightings[2],", ",namesrisk[3],": ",weightings[3],", ",namesrisk[4],": ",weightings[4],", ",namesrisk[5],": ",weightings[5])
a=ggplot()+geom_map(data=map.US,map=map.US,aes(map_id=region,x=long,y=lat),fill="grey")+coord_cartesian()
a=a+geom_point(data=clean,aes(lon,lat,color=clean[,index]),size=.7,alpha=.4)+coord_cartesian()
a=a+ggtitle(label = paste0("Weighted ", algorithm," predictions at obs & trk data from 2005: lbst"),subtitle = subtitle)+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+coord_cartesian(xlim=c(-133,-115),ylim=c(29,49),expand=F)
png(paste0("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/map_lbst_",paste0(weightings,collapse="_"),"_",algorithm,".png"),width=5,height=5,units='in',res=400)
a
dev.off()

weightings<-c(-0.1,-0.1,-0.05,-0.3,0.6)
algorithm="^Marxan_mosaic$"
index=NULL
index=grep(print(algorithm),names(master))
subtitle=paste0(namesrisk[1],": ",weightings[1],", ",namesrisk[2],": ",weightings[2],", ",namesrisk[3],": ",weightings[3],", ",namesrisk[4],": ",weightings[4],", ",namesrisk[5],": ",weightings[5])
a=ggplot()+geom_map(data=map.US,map=map.US,aes(map_id=region,x=long,y=lat),fill="grey")+coord_cartesian()
a=a+geom_point(data=clean,aes(lon,lat,color=clean[,index]),size=.7,alpha=.4)+coord_cartesian()
a=a+ggtitle(label = paste0("Weighted ", algorithm," predictions at obs & trk data from 2005: lbst"),subtitle = subtitle)+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+coord_cartesian(xlim=c(-133,-115),ylim=c(29,49),expand=F)
png(paste0("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/map_lbst_",paste0(weightings,collapse="_"),"_",algorithm,".png"),width=5,height=5,units='in',res=400)
a
dev.off()

weightings<-c(-0.1,-0.1,-0.05,-0.3,0.6)
algorithm="^Marxan_mosaic01$"
index=NULL
index=grep(print(algorithm),names(master))
subtitle=paste0(namesrisk[1],": ",weightings[1],", ",namesrisk[2],": ",weightings[2],", ",namesrisk[3],": ",weightings[3],", ",namesrisk[4],": ",weightings[4],", ",namesrisk[5],": ",weightings[5])
a=ggplot()+geom_map(data=map.US,map=map.US,aes(map_id=region,x=long,y=lat),fill="grey")+coord_cartesian()
a=a+geom_point(data=clean,aes(lon,lat,color=clean[,index]),size=.7,alpha=.4)+coord_cartesian()
a=a+ggtitle(label = paste0("Weighted ", algorithm," predictions at obs & trk data from 2005: lbst"),subtitle = subtitle)+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+coord_cartesian(xlim=c(-133,-115),ylim=c(29,49),expand=F)
png(paste0("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/map_lbst_",paste0(weightings,collapse="_"),"_",algorithm,".png"),width=5,height=5,units='in',res=400)
a
dev.off()


### maps by species: swor #####
clean=master[complete.cases(master),] %>% filter(sp_name=="SWOR")
map.US <- map_data(map="state")

weightings<-c(-0.1,-0.1,-0.05,-1.5,2) 
algorithm="EcoROMS"
index=NULL
index=grep(print(algorithm),names(master))
subtitle=paste0(namesrisk[1],": ",weightings[1],", ",namesrisk[2],": ",weightings[2],", ",namesrisk[3],": ",weightings[3],", ",namesrisk[4],": ",weightings[4],", ",namesrisk[5],": ",weightings[5])
a=ggplot()+geom_map(data=map.US,map=map.US,aes(map_id=region,x=long,y=lat),fill="grey")+coord_cartesian()
a=a+geom_point(data=clean,aes(lon,lat,color=clean[,index]),size=.7,alpha=.4)+coord_cartesian()
a=a+ggtitle(label = paste0("Weighted ", algorithm," predictions at obs & trk data from 2005: swor"),subtitle = subtitle)+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+coord_cartesian(xlim=c(-133,-115),ylim=c(29,49),expand=F)
png(paste0("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/map_swor_",paste0(weightings,collapse="_"),"_",algorithm,".png"),width=5,height=5,units='in',res=400)
a
dev.off()

weightings<-c(-0.1,-0.1,-0.05,-0.3,0.6)
algorithm="Marxan_raw"
index=NULL
index=grep(print(algorithm),names(master))
subtitle=paste0(namesrisk[1],": ",weightings[1],", ",namesrisk[2],": ",weightings[2],", ",namesrisk[3],": ",weightings[3],", ",namesrisk[4],": ",weightings[4],", ",namesrisk[5],": ",weightings[5])
a=ggplot()+geom_map(data=map.US,map=map.US,aes(map_id=region,x=long,y=lat),fill="grey")+coord_cartesian()
a=a+geom_point(data=clean,aes(lon,lat,color=clean[,index]),size=.7,alpha=.4)+coord_cartesian()
a=a+ggtitle(label = paste0("Weighted ", algorithm," predictions at obs & trk data from 2005: swor"),subtitle = subtitle)+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+coord_cartesian(xlim=c(-133,-115),ylim=c(29,49),expand=F)
png(paste0("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/map_swor_",paste0(weightings,collapse="_"),"_",algorithm,".png"),width=5,height=5,units='in',res=400)
a
dev.off()

weightings<-c(-0.1,-0.1,-0.05,-0.3,0.6)
algorithm="^Marxan_mosaic$"
index=NULL
index=grep(print(algorithm),names(master))
subtitle=paste0(namesrisk[1],": ",weightings[1],", ",namesrisk[2],": ",weightings[2],", ",namesrisk[3],": ",weightings[3],", ",namesrisk[4],": ",weightings[4],", ",namesrisk[5],": ",weightings[5])
a=ggplot()+geom_map(data=map.US,map=map.US,aes(map_id=region,x=long,y=lat),fill="grey")+coord_cartesian()
a=a+geom_point(data=clean,aes(lon,lat,color=clean[,index]),size=.7,alpha=.4)+coord_cartesian()
a=a+ggtitle(label = paste0("Weighted ", algorithm," predictions at obs & trk data from 2005: swor"),subtitle = subtitle)+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+coord_cartesian(xlim=c(-133,-115),ylim=c(29,49),expand=F)
png(paste0("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/map_swor_",paste0(weightings,collapse="_"),"_",algorithm,".png"),width=5,height=5,units='in',res=400)
a
dev.off()

weightings<-c(-0.1,-0.1,-0.05,-0.3,0.6)
algorithm="^Marxan_mosaic01$"
index=NULL
index=grep(print(algorithm),names(master))
subtitle=paste0(namesrisk[1],": ",weightings[1],", ",namesrisk[2],": ",weightings[2],", ",namesrisk[3],": ",weightings[3],", ",namesrisk[4],": ",weightings[4],", ",namesrisk[5],": ",weightings[5])
a=ggplot()+geom_map(data=map.US,map=map.US,aes(map_id=region,x=long,y=lat),fill="grey")+coord_cartesian()
a=a+geom_point(data=clean,aes(lon,lat,color=clean[,index]),size=.7,alpha=.4)+coord_cartesian()
a=a+ggtitle(label = paste0("Weighted ", algorithm," predictions at obs & trk data from 2005: swor"),subtitle = subtitle)+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+coord_cartesian(xlim=c(-133,-115),ylim=c(29,49),expand=F)
png(paste0("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/map_swor_",paste0(weightings,collapse="_"),"_",algorithm,".png"),width=5,height=5,units='in',res=400)
a
dev.off()


### maps by species: casl #####
clean=master[complete.cases(master),] %>% filter(sp_name=="casl")
map.US <- map_data(map="state")

weightings<-c(-0.1,-0.1,-0.05,-1.5,2) 
algorithm="EcoROMS"
index=NULL
index=grep(print(algorithm),names(master))
subtitle=paste0(namesrisk[1],": ",weightings[1],", ",namesrisk[2],": ",weightings[2],", ",namesrisk[3],": ",weightings[3],", ",namesrisk[4],": ",weightings[4],", ",namesrisk[5],": ",weightings[5])
a=ggplot()+geom_map(data=map.US,map=map.US,aes(map_id=region,x=long,y=lat),fill="grey")+coord_cartesian()
a=a+geom_point(data=clean,aes(lon,lat,color=clean[,index]),size=.7,alpha=.4)+coord_cartesian()
a=a+ggtitle(label = paste0("Weighted ", algorithm," predictions at obs & trk data from 2005: casl"),subtitle = subtitle)+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+coord_cartesian(xlim=c(-133,-115),ylim=c(29,49),expand=F)
png(paste0("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/map_casl_",paste0(weightings,collapse="_"),"_",algorithm,".png"),width=5,height=5,units='in',res=400)
a
dev.off()

weightings<-c(-0.1,-0.1,-0.05,-0.3,0.6)
algorithm="Marxan_raw"
index=NULL
index=grep(print(algorithm),names(master))
subtitle=paste0(namesrisk[1],": ",weightings[1],", ",namesrisk[2],": ",weightings[2],", ",namesrisk[3],": ",weightings[3],", ",namesrisk[4],": ",weightings[4],", ",namesrisk[5],": ",weightings[5])
a=ggplot()+geom_map(data=map.US,map=map.US,aes(map_id=region,x=long,y=lat),fill="grey")+coord_cartesian()
a=a+geom_point(data=clean,aes(lon,lat,color=clean[,index]),size=.7,alpha=.4)+coord_cartesian()
a=a+ggtitle(label = paste0("Weighted ", algorithm," predictions at obs & trk data from 2005: casl"),subtitle = subtitle)+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+coord_cartesian(xlim=c(-133,-115),ylim=c(29,49),expand=F)
png(paste0("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/map_casl_",paste0(weightings,collapse="_"),"_",algorithm,".png"),width=5,height=5,units='in',res=400)
a
dev.off()

weightings<-c(-0.1,-0.1,-0.05,-0.3,0.6)
algorithm="^Marxan_mosaic$"
index=NULL
index=grep(print(algorithm),names(master))
subtitle=paste0(namesrisk[1],": ",weightings[1],", ",namesrisk[2],": ",weightings[2],", ",namesrisk[3],": ",weightings[3],", ",namesrisk[4],": ",weightings[4],", ",namesrisk[5],": ",weightings[5])
a=ggplot()+geom_map(data=map.US,map=map.US,aes(map_id=region,x=long,y=lat),fill="grey")+coord_cartesian()
a=a+geom_point(data=clean,aes(lon,lat,color=clean[,index]),size=.7,alpha=.4)+coord_cartesian()
a=a+ggtitle(label = paste0("Weighted ", algorithm," predictions at obs & trk data from 2005: casl"),subtitle = subtitle)+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+coord_cartesian(xlim=c(-133,-115),ylim=c(29,49),expand=F)
png(paste0("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/map_casl_",paste0(weightings,collapse="_"),"_",algorithm,".png"),width=5,height=5,units='in',res=400)
a
dev.off()

weightings<-c(-0.1,-0.1,-0.05,-0.3,0.6)
algorithm="^Marxan_mosaic01$"
index=NULL
index=grep(print(algorithm),names(master))
subtitle=paste0(namesrisk[1],": ",weightings[1],", ",namesrisk[2],": ",weightings[2],", ",namesrisk[3],": ",weightings[3],", ",namesrisk[4],": ",weightings[4],", ",namesrisk[5],": ",weightings[5])
a=ggplot()+geom_map(data=map.US,map=map.US,aes(map_id=region,x=long,y=lat),fill="grey")+coord_cartesian()
a=a+geom_point(data=clean,aes(lon,lat,color=clean[,index]),size=.7,alpha=.4)+coord_cartesian()
a=a+ggtitle(label = paste0("Weighted ", algorithm," predictions at obs & trk data from 2005: casl"),subtitle = subtitle)+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+coord_cartesian(xlim=c(-133,-115),ylim=c(29,49),expand=F)
png(paste0("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/map_casl_",paste0(weightings,collapse="_"),"_",algorithm,".png"),width=5,height=5,units='in',res=400)
a
dev.off()


### maps by species: blshtrk #####
clean=master[complete.cases(master),] %>% filter(sp_name=="blshtrk")
map.US <- map_data(map="state")

weightings<-c(-0.1,-0.1,-0.05,-1.5,2) 
algorithm="EcoROMS"
index=NULL
index=grep(print(algorithm),names(master))
subtitle=paste0(namesrisk[1],": ",weightings[1],", ",namesrisk[2],": ",weightings[2],", ",namesrisk[3],": ",weightings[3],", ",namesrisk[4],": ",weightings[4],", ",namesrisk[5],": ",weightings[5])
a=ggplot()+geom_map(data=map.US,map=map.US,aes(map_id=region,x=long,y=lat),fill="grey")+coord_cartesian()
a=a+geom_point(data=clean,aes(lon,lat,color=clean[,index]),size=.7,alpha=.4)+coord_cartesian()
a=a+ggtitle(label = paste0("Weighted ", algorithm," predictions at obs & trk data from 2005: blshtrk"),subtitle = subtitle)+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+coord_cartesian(xlim=c(-133,-115),ylim=c(29,49),expand=F)
png(paste0("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/map_blshtrk_",paste0(weightings,collapse="_"),"_",algorithm,".png"),width=5,height=5,units='in',res=400)
a
dev.off()

weightings<-c(-0.1,-0.1,-0.05,-0.3,0.6)
algorithm="Marxan_raw"
index=NULL
index=grep(print(algorithm),names(master))
subtitle=paste0(namesrisk[1],": ",weightings[1],", ",namesrisk[2],": ",weightings[2],", ",namesrisk[3],": ",weightings[3],", ",namesrisk[4],": ",weightings[4],", ",namesrisk[5],": ",weightings[5])
a=ggplot()+geom_map(data=map.US,map=map.US,aes(map_id=region,x=long,y=lat),fill="grey")+coord_cartesian()
a=a+geom_point(data=clean,aes(lon,lat,color=clean[,index]),size=.7,alpha=.4)+coord_cartesian()
a=a+ggtitle(label = paste0("Weighted ", algorithm," predictions at obs & trk data from 2005: blshtrk"),subtitle = subtitle)+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+coord_cartesian(xlim=c(-133,-115),ylim=c(29,49),expand=F)
png(paste0("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/map_blshtrk_",paste0(weightings,collapse="_"),"_",algorithm,".png"),width=5,height=5,units='in',res=400)
a
dev.off()

weightings<-c(-0.1,-0.1,-0.05,-0.3,0.6)
algorithm="^Marxan_mosaic$"
index=NULL
index=grep(print(algorithm),names(master))
subtitle=paste0(namesrisk[1],": ",weightings[1],", ",namesrisk[2],": ",weightings[2],", ",namesrisk[3],": ",weightings[3],", ",namesrisk[4],": ",weightings[4],", ",namesrisk[5],": ",weightings[5])
a=ggplot()+geom_map(data=map.US,map=map.US,aes(map_id=region,x=long,y=lat),fill="grey")+coord_cartesian()
a=a+geom_point(data=clean,aes(lon,lat,color=clean[,index]),size=.7,alpha=.4)+coord_cartesian()
a=a+ggtitle(label = paste0("Weighted ", algorithm," predictions at obs & trk data from 2005: blshtrk"),subtitle = subtitle)+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+coord_cartesian(xlim=c(-133,-115),ylim=c(29,49),expand=F)
png(paste0("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/map_blshtrk_",paste0(weightings,collapse="_"),"_",algorithm,".png"),width=5,height=5,units='in',res=400)
a
dev.off()

weightings<-c(-0.1,-0.1,-0.05,-0.3,0.6)
algorithm="^Marxan_mosaic01$"
index=NULL
index=grep(print(algorithm),names(master))
subtitle=paste0(namesrisk[1],": ",weightings[1],", ",namesrisk[2],": ",weightings[2],", ",namesrisk[3],": ",weightings[3],", ",namesrisk[4],": ",weightings[4],", ",namesrisk[5],": ",weightings[5])
a=ggplot()+geom_map(data=map.US,map=map.US,aes(map_id=region,x=long,y=lat),fill="grey")+coord_cartesian()
a=a+geom_point(data=clean,aes(lon,lat,color=clean[,index]),size=.7,alpha=.4)+coord_cartesian()
a=a+ggtitle(label = paste0("Weighted ", algorithm," predictions at obs & trk data from 2005: blshtrk"),subtitle = subtitle)+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+coord_cartesian(xlim=c(-133,-115),ylim=c(29,49),expand=F)
png(paste0("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/map_blshtrk_",paste0(weightings,collapse="_"),"_",algorithm,".png"),width=5,height=5,units='in',res=400)
a
dev.off()

### maps by species: blshobs #####
clean=master[complete.cases(master),] %>% filter(sp_name=="BLSH")
map.US <- map_data(map="state")

weightings<-c(-0.1,-0.1,-0.05,-1.5,2) 
algorithm="EcoROMS"
index=NULL
index=grep(print(algorithm),names(master))
subtitle=paste0(namesrisk[1],": ",weightings[1],", ",namesrisk[2],": ",weightings[2],", ",namesrisk[3],": ",weightings[3],", ",namesrisk[4],": ",weightings[4],", ",namesrisk[5],": ",weightings[5])
a=ggplot()+geom_map(data=map.US,map=map.US,aes(map_id=region,x=long,y=lat),fill="grey")+coord_cartesian()
a=a+geom_point(data=clean,aes(lon,lat,color=clean[,index]),size=.7,alpha=.4)+coord_cartesian()
a=a+ggtitle(label = paste0("Weighted ", algorithm," predictions at obs & trk data from 2005: BLSH"),subtitle = subtitle)+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+coord_cartesian(xlim=c(-133,-115),ylim=c(29,49),expand=F)
png(paste0("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/map_BLSH_",paste0(weightings,collapse="_"),"_",algorithm,".png"),width=5,height=5,units='in',res=400)
a
dev.off()

weightings<-c(-0.1,-0.1,-0.05,-0.3,0.6)
algorithm="Marxan_raw"
index=NULL
index=grep(print(algorithm),names(master))
subtitle=paste0(namesrisk[1],": ",weightings[1],", ",namesrisk[2],": ",weightings[2],", ",namesrisk[3],": ",weightings[3],", ",namesrisk[4],": ",weightings[4],", ",namesrisk[5],": ",weightings[5])
a=ggplot()+geom_map(data=map.US,map=map.US,aes(map_id=region,x=long,y=lat),fill="grey")+coord_cartesian()
a=a+geom_point(data=clean,aes(lon,lat,color=clean[,index]),size=.7,alpha=.4)+coord_cartesian()
a=a+ggtitle(label = paste0("Weighted ", algorithm," predictions at obs & trk data from 2005: BLSH"),subtitle = subtitle)+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+coord_cartesian(xlim=c(-133,-115),ylim=c(29,49),expand=F)
png(paste0("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/map_BLSH_",paste0(weightings,collapse="_"),"_",algorithm,".png"),width=5,height=5,units='in',res=400)
a
dev.off()

weightings<-c(-0.1,-0.1,-0.05,-0.3,0.6)
algorithm="^Marxan_mosaic$"
index=NULL
index=grep(print(algorithm),names(master))
subtitle=paste0(namesrisk[1],": ",weightings[1],", ",namesrisk[2],": ",weightings[2],", ",namesrisk[3],": ",weightings[3],", ",namesrisk[4],": ",weightings[4],", ",namesrisk[5],": ",weightings[5])
a=ggplot()+geom_map(data=map.US,map=map.US,aes(map_id=region,x=long,y=lat),fill="grey")+coord_cartesian()
a=a+geom_point(data=clean,aes(lon,lat,color=clean[,index]),size=.7,alpha=.4)+coord_cartesian()
a=a+ggtitle(label = paste0("Weighted ", algorithm," predictions at obs & trk data from 2005: BLSH"),subtitle = subtitle)+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+coord_cartesian(xlim=c(-133,-115),ylim=c(29,49),expand=F)
png(paste0("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/map_BLSH_",paste0(weightings,collapse="_"),"_",algorithm,".png"),width=5,height=5,units='in',res=400)
a
dev.off()

weightings<-c(-0.1,-0.1,-0.05,-0.3,0.6)
algorithm="^Marxan_mosaic01$"
index=NULL
index=grep(print(algorithm),names(master))
subtitle=paste0(namesrisk[1],": ",weightings[1],", ",namesrisk[2],": ",weightings[2],", ",namesrisk[3],": ",weightings[3],", ",namesrisk[4],": ",weightings[4],", ",namesrisk[5],": ",weightings[5])
a=ggplot()+geom_map(data=map.US,map=map.US,aes(map_id=region,x=long,y=lat),fill="grey")+coord_cartesian()
a=a+geom_point(data=clean,aes(lon,lat,color=clean[,index]),size=.7,alpha=.4)+coord_cartesian()
a=a+ggtitle(label = paste0("Weighted ", algorithm," predictions at obs & trk data from 2005: BLSH"),subtitle = subtitle)+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+coord_cartesian(xlim=c(-133,-115),ylim=c(29,49),expand=F)
png(paste0("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/map_BLSH_",paste0(weightings,collapse="_"),"_",algorithm,".png"),width=5,height=5,units='in',res=400)
a
dev.off()




### -------------------------------------------------- > ## (run 3) ####
#### a. strip data down to date, lat, long, sp_name####
species=read.csv("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/raw_data/observer_casl_swor_blsh_lbst_roms_2005_08_10.csv") %>% select(c("SpCd","dt","lat","lon"))
species$sp_name=NA
species[species$SpCd=="UO","sp_name"]="CASL"
species[species$SpCd=="DC","sp_name"]="LBST"
species[species$SpCd=="91","sp_name"]="SWOR"
species[species$SpCd=="167","sp_name"]="BLSH"

tracking=read.csv("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/raw_data/trk_casl_blsh_lbst_roms_2005_08_10.csv") %>% select(c("sp_name","dt","lat","lon"))

#### observer first ####
##### c. run extracto (ecoroms) ####
weightings<-c(-0.1,-0.1,-0.05,-1.5,.1) 
ecoroms=list.files("~/Dropbox/Eco-ROMS/EcoROMSruns/output/mean",pattern=".grd",full.names = T) %>% grep(paste0(weightings,collapse="_"),.,value=T) #%>% grep("_2005-",.,value=T)
a=extracto_raster(pts=species,algorithm="EcoROMS",solution_list = ecoroms,weightings = weightings)

##### c. run extracto (marxan) ####
weightings<-c(-0.1,-0.1,-0.05,-0.3,0.1)
marxan_raw=list.files("~/Dropbox/Eco-ROMS/EcoROMSruns/output/marxan",pattern=".grd",full.names = T) %>% grep(paste0(weightings,collapse="_"),.,value=T) %>% grep("_raw",.,value=T)
marxan_mosaic=list.files("~/Dropbox/Eco-ROMS/EcoROMSruns/output/marxan",pattern=".grd",full.names = T) %>% grep(paste0(weightings,collapse="_"),.,value=T) %>% grep("_mosaic.grd$",.,value=T)
marxan_mosaic01=list.files("~/Dropbox/Eco-ROMS/EcoROMSruns/output/marxan",pattern=".grd",full.names = T) %>% grep(paste0(weightings,collapse="_"),.,value=T) %>% grep("_mosaic01.grd$",.,value=T)

a=extracto_raster(pts=a,algorithm="Marxan_raw",solution_list = marxan_raw,weightings = weightings)
a=extracto_raster(pts=a,algorithm="Marxan_mosaic",solution_list = marxan_mosaic,weightings = weightings)
obs=extracto_raster(pts=a,algorithm="Marxan_mosaic01",solution_list = marxan_mosaic01,weightings = weightings) %>% select(-SpCd)

## tracking second ####
#### c. run extracto (ecoroms) ####
weightings<-c(-0.1,-0.1,-0.05,-1.5,.1)
a=extracto_raster(pts=tracking,algorithm="EcoROMS",solution_list = ecoroms,weightings = weightings)

##### c. run extracto (marxan) ####
weightings<-c(-0.1,-0.1,-0.05,-0.3,0.1)

a=extracto_raster(pts=a,algorithm="Marxan_raw",solution_list = marxan_raw,weightings = weightings)
a=extracto_raster(pts=a,algorithm="Marxan_mosaic",solution_list = marxan_mosaic,weightings = weightings)
trk=extracto_raster(pts=a,algorithm="Marxan_mosaic01",solution_list = marxan_mosaic01,weightings = weightings)

##### d. make some plots ####
master=rbind(obs,trk)
write.csv(master,"/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/raw_data/species_predict_2005_08_10_run3.csv")

### boxplots, more extreme species weightings  # testing leatherback at it's most extreme, swor neutral ####
weightings<-c(-0.1,-0.1,-0.05,-1.5,.1)
algorithm="EcoROMS"
index=NULL
index=grep(print(algorithm),names(master))
subtitle=paste0(namesrisk[1],": ",weightings[1],", ",namesrisk[2],": ",weightings[2],", ",namesrisk[3],": ",weightings[3],", ",namesrisk[4],": ",weightings[4],", ",namesrisk[5],": ",weightings[5])
a=ggplot(data=master,aes(x=sp_name,y=master[,index]))+geom_boxplot()
a=a+ggtitle(label = paste0("Weighted ", algorithm," predictions at obs & trk data from 2005"),subtitle = subtitle)+labs(x="Species catch events")+labs(y="EcoROMS prediction")+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
png(paste0("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/box_",paste0(weightings,collapse="_"),"_",algorithm,".png"),width=5,height=5,units='in',res=400)
a
dev.off()

weightings<-c(-0.1,-0.1,-0.05,-0.3,0.1)
algorithm="Marxan_raw"
index=NULL
index=grep(print(algorithm),names(master))
subtitle=paste0(namesrisk[1],": ",weightings[1],", ",namesrisk[2],": ",weightings[2],", ",namesrisk[3],": ",weightings[3],", ",namesrisk[4],": ",weightings[4],", ",namesrisk[5],": ",weightings[5])
a=ggplot(data=master,aes(x=sp_name,y=master[,index]))+geom_boxplot()
a=a+ggtitle(label = paste0("Weighted ", algorithm," predictions at obs & trk data from 2005"),subtitle = subtitle)+labs(x="Species catch events")+labs(y="EcoROMS prediction")+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
png(paste0("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/box_",paste0(weightings,collapse="_"),"_",algorithm,".png"),width=5,height=5,units='in',res=400)
a
dev.off()

weightings<-c(-0.1,-0.1,-0.05,-0.3,0.1)
algorithm="^Marxan_mosaic$"
index=NULL
index=grep(print(algorithm),names(master))
subtitle=paste0(namesrisk[1],": ",weightings[1],", ",namesrisk[2],": ",weightings[2],", ",namesrisk[3],": ",weightings[3],", ",namesrisk[4],": ",weightings[4],", ",namesrisk[5],": ",weightings[5])
a=ggplot(data=master,aes(x=sp_name,y=master[,index]))+geom_boxplot()
a=a+ggtitle(label = paste0("Weighted ", algorithm," predictions at obs & trk data from 2005"),subtitle = subtitle)+labs(x="Species catch events")+labs(y="EcoROMS prediction")+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
png(paste0("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/box_",paste0(weightings,collapse="_"),"_",algorithm,".png"),width=5,height=5,units='in',res=400)
a
dev.off()

weightings<-c(-0.1,-0.1,-0.05,-0.3,0.1)
algorithm="^Marxan_mosaic01$"
index=NULL
index=grep(print(algorithm),names(master))
subtitle=paste0(namesrisk[1],": ",weightings[1],", ",namesrisk[2],": ",weightings[2],", ",namesrisk[3],": ",weightings[3],", ",namesrisk[4],": ",weightings[4],", ",namesrisk[5],": ",weightings[5])
a=ggplot(data=master,aes(x=sp_name,y=master[,index]))+geom_boxplot()
a=a+ggtitle(label = paste0("Weighted ", algorithm," predictions at obs & trk data from 2005"),subtitle = subtitle)+labs(x="Species catch events")+labs(y="EcoROMS prediction")+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
png(paste0("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/box_",paste0(weightings,collapse="_"),"_",algorithm,".png"),width=5,height=5,units='in',res=400)
a
dev.off()


### maps full #####
clean=master[complete.cases(master),]
map.US <- map_data(map="state")

weightings<-c(-0.1,-0.1,-0.05,-1.5,.1)
algorithm="EcoROMS"
index=NULL
index=grep(print(algorithm),names(master))
subtitle=paste0(namesrisk[1],": ",weightings[1],", ",namesrisk[2],": ",weightings[2],", ",namesrisk[3],": ",weightings[3],", ",namesrisk[4],": ",weightings[4],", ",namesrisk[5],": ",weightings[5])
a=ggplot()+geom_map(data=map.US,map=map.US,aes(map_id=region,x=long,y=lat),fill="grey")+coord_cartesian()
a=a+geom_point(data=clean,aes(lon,lat,color=clean[,index]),size=.7,alpha=.4)+coord_cartesian()
a=a+ggtitle(label = paste0("Weighted ", algorithm," predictions at obs & trk data from 2005"),subtitle = subtitle)+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+coord_cartesian(xlim=c(-133,-115),ylim=c(29,49),expand=F)
png(paste0("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/mapfull_",paste0(weightings,collapse="_"),"_",algorithm,".png"),width=5,height=5,units='in',res=400)
a
dev.off()

weightings<-c(-0.1,-0.1,-0.05,-0.3,0.1)
algorithm="Marxan_raw"
index=NULL
index=grep(print(algorithm),names(master))
subtitle=paste0(namesrisk[1],": ",weightings[1],", ",namesrisk[2],": ",weightings[2],", ",namesrisk[3],": ",weightings[3],", ",namesrisk[4],": ",weightings[4],", ",namesrisk[5],": ",weightings[5])
a=ggplot()+geom_map(data=map.US,map=map.US,aes(map_id=region,x=long,y=lat),fill="grey")+coord_cartesian()
a=a+geom_point(data=clean,aes(lon,lat,color=clean[,index]),size=.7,alpha=.4)+coord_cartesian()
a=a+ggtitle(label = paste0("Weighted ", algorithm," predictions at obs & trk data from 2005"),subtitle = subtitle)+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+coord_cartesian(xlim=c(-133,-115),ylim=c(29,49),expand=F)
png(paste0("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/mapfull_",paste0(weightings,collapse="_"),"_",algorithm,".png"),width=5,height=5,units='in',res=400)
a
dev.off()

weightings<-c(-0.1,-0.1,-0.05,-0.3,0.1)
algorithm="^Marxan_mosaic$"
index=NULL
index=grep(print(algorithm),names(master))
subtitle=paste0(namesrisk[1],": ",weightings[1],", ",namesrisk[2],": ",weightings[2],", ",namesrisk[3],": ",weightings[3],", ",namesrisk[4],": ",weightings[4],", ",namesrisk[5],": ",weightings[5])
a=ggplot()+geom_map(data=map.US,map=map.US,aes(map_id=region,x=long,y=lat),fill="grey")+coord_cartesian()
a=a+geom_point(data=clean,aes(lon,lat,color=clean[,index]),size=.7,alpha=.4)+coord_cartesian()
a=a+ggtitle(label = paste0("Weighted ", algorithm," predictions at obs & trk data from 2005"),subtitle = subtitle)+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+coord_cartesian(xlim=c(-133,-115),ylim=c(29,49),expand=F)
png(paste0("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/mapfull_",paste0(weightings,collapse="_"),"_",algorithm,".png"),width=5,height=5,units='in',res=400)
a
dev.off()

weightings<-c(-0.1,-0.1,-0.05,-0.3,0.1)
algorithm="^Marxan_mosaic01$"
index=NULL
index=grep(print(algorithm),names(master))
subtitle=paste0(namesrisk[1],": ",weightings[1],", ",namesrisk[2],": ",weightings[2],", ",namesrisk[3],": ",weightings[3],", ",namesrisk[4],": ",weightings[4],", ",namesrisk[5],": ",weightings[5])
a=ggplot()+geom_map(data=map.US,map=map.US,aes(map_id=region,x=long,y=lat),fill="grey")+coord_cartesian()
a=a+geom_point(data=clean,aes(lon,lat,color=clean[,index]),size=.7,alpha=.4)+coord_cartesian()
a=a+ggtitle(label = paste0("Weighted ", algorithm," predictions at obs & trk data from 2005"),subtitle = subtitle)+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+coord_cartesian(xlim=c(-133,-115),ylim=c(29,49),expand=F)
png(paste0("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/mapfull_",paste0(weightings,collapse="_"),"_",algorithm,".png"),width=5,height=5,units='in',res=400)
a
dev.off()

### maps by species: turtles #####
clean=master[complete.cases(master),] %>% filter(sp_name=="lbst")
map.US <- map_data(map="state")

weightings<-c(-0.1,-0.1,-0.05,-1.5,.1)
algorithm="EcoROMS"
index=NULL
index=grep(print(algorithm),names(master))
subtitle=paste0(namesrisk[1],": ",weightings[1],", ",namesrisk[2],": ",weightings[2],", ",namesrisk[3],": ",weightings[3],", ",namesrisk[4],": ",weightings[4],", ",namesrisk[5],": ",weightings[5])
a=ggplot()+geom_map(data=map.US,map=map.US,aes(map_id=region,x=long,y=lat),fill="grey")+coord_cartesian()
a=a+geom_point(data=clean,aes(lon,lat,color=clean[,index]),size=.7,alpha=.4)+coord_cartesian()
a=a+ggtitle(label = paste0("Weighted ", algorithm," predictions at obs & trk data from 2005: lbst"),subtitle = subtitle)+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+coord_cartesian(xlim=c(-133,-115),ylim=c(29,49),expand=F)
png(paste0("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/map_lbst_",paste0(weightings,collapse="_"),"_",algorithm,".png"),width=5,height=5,units='in',res=400)
a
dev.off()

weightings<-c(-0.1,-0.1,-0.05,-0.3,0.1)
algorithm="Marxan_raw"
index=NULL
index=grep(print(algorithm),names(master))
subtitle=paste0(namesrisk[1],": ",weightings[1],", ",namesrisk[2],": ",weightings[2],", ",namesrisk[3],": ",weightings[3],", ",namesrisk[4],": ",weightings[4],", ",namesrisk[5],": ",weightings[5])
a=ggplot()+geom_map(data=map.US,map=map.US,aes(map_id=region,x=long,y=lat),fill="grey")+coord_cartesian()
a=a+geom_point(data=clean,aes(lon,lat,color=clean[,index]),size=.7,alpha=.4)+coord_cartesian()
a=a+ggtitle(label = paste0("Weighted ", algorithm," predictions at obs & trk data from 2005: lbst"),subtitle = subtitle)+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+coord_cartesian(xlim=c(-133,-115),ylim=c(29,49),expand=F)
png(paste0("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/map_lbst_",paste0(weightings,collapse="_"),"_",algorithm,".png"),width=5,height=5,units='in',res=400)
a
dev.off()

weightings<-c(-0.1,-0.1,-0.05,-0.3,0.1)
algorithm="^Marxan_mosaic$"
index=NULL
index=grep(print(algorithm),names(master))
subtitle=paste0(namesrisk[1],": ",weightings[1],", ",namesrisk[2],": ",weightings[2],", ",namesrisk[3],": ",weightings[3],", ",namesrisk[4],": ",weightings[4],", ",namesrisk[5],": ",weightings[5])
a=ggplot()+geom_map(data=map.US,map=map.US,aes(map_id=region,x=long,y=lat),fill="grey")+coord_cartesian()
a=a+geom_point(data=clean,aes(lon,lat,color=clean[,index]),size=.7,alpha=.4)+coord_cartesian()
a=a+ggtitle(label = paste0("Weighted ", algorithm," predictions at obs & trk data from 2005: lbst"),subtitle = subtitle)+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+coord_cartesian(xlim=c(-133,-115),ylim=c(29,49),expand=F)
png(paste0("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/map_lbst_",paste0(weightings,collapse="_"),"_",algorithm,".png"),width=5,height=5,units='in',res=400)
a
dev.off()

weightings<-c(-0.1,-0.1,-0.05,-0.3,0.1)
algorithm="^Marxan_mosaic01$"
index=NULL
index=grep(print(algorithm),names(master))
subtitle=paste0(namesrisk[1],": ",weightings[1],", ",namesrisk[2],": ",weightings[2],", ",namesrisk[3],": ",weightings[3],", ",namesrisk[4],": ",weightings[4],", ",namesrisk[5],": ",weightings[5])
a=ggplot()+geom_map(data=map.US,map=map.US,aes(map_id=region,x=long,y=lat),fill="grey")+coord_cartesian()
a=a+geom_point(data=clean,aes(lon,lat,color=clean[,index]),size=.7,alpha=.4)+coord_cartesian()
a=a+ggtitle(label = paste0("Weighted ", algorithm," predictions at obs & trk data from 2005: lbst"),subtitle = subtitle)+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+coord_cartesian(xlim=c(-133,-115),ylim=c(29,49),expand=F)
png(paste0("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/map_lbst_",paste0(weightings,collapse="_"),"_",algorithm,".png"),width=5,height=5,units='in',res=400)
a
dev.off()


### maps by species: swor #####
clean=master[complete.cases(master),] %>% filter(sp_name=="SWOR")
map.US <- map_data(map="state")

weightings<-c(-0.1,-0.1,-0.05,-1.5,.1)
algorithm="EcoROMS"
index=NULL
index=grep(print(algorithm),names(master))
subtitle=paste0(namesrisk[1],": ",weightings[1],", ",namesrisk[2],": ",weightings[2],", ",namesrisk[3],": ",weightings[3],", ",namesrisk[4],": ",weightings[4],", ",namesrisk[5],": ",weightings[5])
a=ggplot()+geom_map(data=map.US,map=map.US,aes(map_id=region,x=long,y=lat),fill="grey")+coord_cartesian()
a=a+geom_point(data=clean,aes(lon,lat,color=clean[,index]),size=.7,alpha=.4)+coord_cartesian()
a=a+ggtitle(label = paste0("Weighted ", algorithm," predictions at obs & trk data from 2005: swor"),subtitle = subtitle)+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+coord_cartesian(xlim=c(-133,-115),ylim=c(29,49),expand=F)
png(paste0("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/map_swor_",paste0(weightings,collapse="_"),"_",algorithm,".png"),width=5,height=5,units='in',res=400)
a
dev.off()

weightings<-c(-0.1,-0.1,-0.05,-0.3,0.1)
algorithm="Marxan_raw"
index=NULL
index=grep(print(algorithm),names(master))
subtitle=paste0(namesrisk[1],": ",weightings[1],", ",namesrisk[2],": ",weightings[2],", ",namesrisk[3],": ",weightings[3],", ",namesrisk[4],": ",weightings[4],", ",namesrisk[5],": ",weightings[5])
a=ggplot()+geom_map(data=map.US,map=map.US,aes(map_id=region,x=long,y=lat),fill="grey")+coord_cartesian()
a=a+geom_point(data=clean,aes(lon,lat,color=clean[,index]),size=.7,alpha=.4)+coord_cartesian()
a=a+ggtitle(label = paste0("Weighted ", algorithm," predictions at obs & trk data from 2005: swor"),subtitle = subtitle)+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+coord_cartesian(xlim=c(-133,-115),ylim=c(29,49),expand=F)
png(paste0("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/map_swor_",paste0(weightings,collapse="_"),"_",algorithm,".png"),width=5,height=5,units='in',res=400)
a
dev.off()

weightings<-c(-0.1,-0.1,-0.05,-0.3,0.1)
algorithm="^Marxan_mosaic$"
index=NULL
index=grep(print(algorithm),names(master))
subtitle=paste0(namesrisk[1],": ",weightings[1],", ",namesrisk[2],": ",weightings[2],", ",namesrisk[3],": ",weightings[3],", ",namesrisk[4],": ",weightings[4],", ",namesrisk[5],": ",weightings[5])
a=ggplot()+geom_map(data=map.US,map=map.US,aes(map_id=region,x=long,y=lat),fill="grey")+coord_cartesian()
a=a+geom_point(data=clean,aes(lon,lat,color=clean[,index]),size=.7,alpha=.4)+coord_cartesian()
a=a+ggtitle(label = paste0("Weighted ", algorithm," predictions at obs & trk data from 2005: swor"),subtitle = subtitle)+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+coord_cartesian(xlim=c(-133,-115),ylim=c(29,49),expand=F)
png(paste0("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/map_swor_",paste0(weightings,collapse="_"),"_",algorithm,".png"),width=5,height=5,units='in',res=400)
a
dev.off()

weightings<-c(-0.1,-0.1,-0.05,-0.3,0.1)
algorithm="^Marxan_mosaic01$"
index=NULL
index=grep(print(algorithm),names(master))
subtitle=paste0(namesrisk[1],": ",weightings[1],", ",namesrisk[2],": ",weightings[2],", ",namesrisk[3],": ",weightings[3],", ",namesrisk[4],": ",weightings[4],", ",namesrisk[5],": ",weightings[5])
a=ggplot()+geom_map(data=map.US,map=map.US,aes(map_id=region,x=long,y=lat),fill="grey")+coord_cartesian()
a=a+geom_point(data=clean,aes(lon,lat,color=clean[,index]),size=.7,alpha=.4)+coord_cartesian()
a=a+ggtitle(label = paste0("Weighted ", algorithm," predictions at obs & trk data from 2005: swor"),subtitle = subtitle)+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+coord_cartesian(xlim=c(-133,-115),ylim=c(29,49),expand=F)
png(paste0("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/map_swor_",paste0(weightings,collapse="_"),"_",algorithm,".png"),width=5,height=5,units='in',res=400)
a
dev.off()


### maps by species: casl #####
clean=master[complete.cases(master),] %>% filter(sp_name=="casl")
map.US <- map_data(map="state")

weightings<-c(-0.1,-0.1,-0.05,-1.5,.1)
algorithm="EcoROMS"
index=NULL
index=grep(print(algorithm),names(master))
subtitle=paste0(namesrisk[1],": ",weightings[1],", ",namesrisk[2],": ",weightings[2],", ",namesrisk[3],": ",weightings[3],", ",namesrisk[4],": ",weightings[4],", ",namesrisk[5],": ",weightings[5])
a=ggplot()+geom_map(data=map.US,map=map.US,aes(map_id=region,x=long,y=lat),fill="grey")+coord_cartesian()
a=a+geom_point(data=clean,aes(lon,lat,color=clean[,index]),size=.7,alpha=.4)+coord_cartesian()
a=a+ggtitle(label = paste0("Weighted ", algorithm," predictions at obs & trk data from 2005: casl"),subtitle = subtitle)+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+coord_cartesian(xlim=c(-133,-115),ylim=c(29,49),expand=F)
png(paste0("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/map_casl_",paste0(weightings,collapse="_"),"_",algorithm,".png"),width=5,height=5,units='in',res=400)
a
dev.off()

weightings<-c(-0.1,-0.1,-0.05,-0.3,0.1)
algorithm="Marxan_raw"
index=NULL
index=grep(print(algorithm),names(master))
subtitle=paste0(namesrisk[1],": ",weightings[1],", ",namesrisk[2],": ",weightings[2],", ",namesrisk[3],": ",weightings[3],", ",namesrisk[4],": ",weightings[4],", ",namesrisk[5],": ",weightings[5])
a=ggplot()+geom_map(data=map.US,map=map.US,aes(map_id=region,x=long,y=lat),fill="grey")+coord_cartesian()
a=a+geom_point(data=clean,aes(lon,lat,color=clean[,index]),size=.7,alpha=.4)+coord_cartesian()
a=a+ggtitle(label = paste0("Weighted ", algorithm," predictions at obs & trk data from 2005: casl"),subtitle = subtitle)+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+coord_cartesian(xlim=c(-133,-115),ylim=c(29,49),expand=F)
png(paste0("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/map_casl_",paste0(weightings,collapse="_"),"_",algorithm,".png"),width=5,height=5,units='in',res=400)
a
dev.off()

weightings<-c(-0.1,-0.1,-0.05,-0.3,0.1)
algorithm="^Marxan_mosaic$"
index=NULL
index=grep(print(algorithm),names(master))
subtitle=paste0(namesrisk[1],": ",weightings[1],", ",namesrisk[2],": ",weightings[2],", ",namesrisk[3],": ",weightings[3],", ",namesrisk[4],": ",weightings[4],", ",namesrisk[5],": ",weightings[5])
a=ggplot()+geom_map(data=map.US,map=map.US,aes(map_id=region,x=long,y=lat),fill="grey")+coord_cartesian()
a=a+geom_point(data=clean,aes(lon,lat,color=clean[,index]),size=.7,alpha=.4)+coord_cartesian()
a=a+ggtitle(label = paste0("Weighted ", algorithm," predictions at obs & trk data from 2005: casl"),subtitle = subtitle)+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+coord_cartesian(xlim=c(-133,-115),ylim=c(29,49),expand=F)
png(paste0("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/map_casl_",paste0(weightings,collapse="_"),"_",algorithm,".png"),width=5,height=5,units='in',res=400)
a
dev.off()

weightings<-c(-0.1,-0.1,-0.05,-0.3,0.1)
algorithm="^Marxan_mosaic01$"
index=NULL
index=grep(print(algorithm),names(master))
subtitle=paste0(namesrisk[1],": ",weightings[1],", ",namesrisk[2],": ",weightings[2],", ",namesrisk[3],": ",weightings[3],", ",namesrisk[4],": ",weightings[4],", ",namesrisk[5],": ",weightings[5])
a=ggplot()+geom_map(data=map.US,map=map.US,aes(map_id=region,x=long,y=lat),fill="grey")+coord_cartesian()
a=a+geom_point(data=clean,aes(lon,lat,color=clean[,index]),size=.7,alpha=.4)+coord_cartesian()
a=a+ggtitle(label = paste0("Weighted ", algorithm," predictions at obs & trk data from 2005: casl"),subtitle = subtitle)+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+coord_cartesian(xlim=c(-133,-115),ylim=c(29,49),expand=F)
png(paste0("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/map_casl_",paste0(weightings,collapse="_"),"_",algorithm,".png"),width=5,height=5,units='in',res=400)
a
dev.off()


### maps by species: blshtrk #####
clean=master[complete.cases(master),] %>% filter(sp_name=="blshtrk")
map.US <- map_data(map="state")

weightings<-c(-0.1,-0.1,-0.05,-1.5,.1)
algorithm="EcoROMS"
index=NULL
index=grep(print(algorithm),names(master))
subtitle=paste0(namesrisk[1],": ",weightings[1],", ",namesrisk[2],": ",weightings[2],", ",namesrisk[3],": ",weightings[3],", ",namesrisk[4],": ",weightings[4],", ",namesrisk[5],": ",weightings[5])
a=ggplot()+geom_map(data=map.US,map=map.US,aes(map_id=region,x=long,y=lat),fill="grey")+coord_cartesian()
a=a+geom_point(data=clean,aes(lon,lat,color=clean[,index]),size=.7,alpha=.4)+coord_cartesian()
a=a+ggtitle(label = paste0("Weighted ", algorithm," predictions at obs & trk data from 2005: blshtrk"),subtitle = subtitle)+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+coord_cartesian(xlim=c(-133,-115),ylim=c(29,49),expand=F)
png(paste0("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/map_blshtrk_",paste0(weightings,collapse="_"),"_",algorithm,".png"),width=5,height=5,units='in',res=400)
a
dev.off()

weightings<-c(-0.1,-0.1,-0.05,-0.3,0.1)
algorithm="Marxan_raw"
index=NULL
index=grep(print(algorithm),names(master))
subtitle=paste0(namesrisk[1],": ",weightings[1],", ",namesrisk[2],": ",weightings[2],", ",namesrisk[3],": ",weightings[3],", ",namesrisk[4],": ",weightings[4],", ",namesrisk[5],": ",weightings[5])
a=ggplot()+geom_map(data=map.US,map=map.US,aes(map_id=region,x=long,y=lat),fill="grey")+coord_cartesian()
a=a+geom_point(data=clean,aes(lon,lat,color=clean[,index]),size=.7,alpha=.4)+coord_cartesian()
a=a+ggtitle(label = paste0("Weighted ", algorithm," predictions at obs & trk data from 2005: blshtrk"),subtitle = subtitle)+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+coord_cartesian(xlim=c(-133,-115),ylim=c(29,49),expand=F)
png(paste0("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/map_blshtrk_",paste0(weightings,collapse="_"),"_",algorithm,".png"),width=5,height=5,units='in',res=400)
a
dev.off()

weightings<-c(-0.1,-0.1,-0.05,-0.3,0.1)
algorithm="^Marxan_mosaic$"
index=NULL
index=grep(print(algorithm),names(master))
subtitle=paste0(namesrisk[1],": ",weightings[1],", ",namesrisk[2],": ",weightings[2],", ",namesrisk[3],": ",weightings[3],", ",namesrisk[4],": ",weightings[4],", ",namesrisk[5],": ",weightings[5])
a=ggplot()+geom_map(data=map.US,map=map.US,aes(map_id=region,x=long,y=lat),fill="grey")+coord_cartesian()
a=a+geom_point(data=clean,aes(lon,lat,color=clean[,index]),size=.7,alpha=.4)+coord_cartesian()
a=a+ggtitle(label = paste0("Weighted ", algorithm," predictions at obs & trk data from 2005: blshtrk"),subtitle = subtitle)+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+coord_cartesian(xlim=c(-133,-115),ylim=c(29,49),expand=F)
png(paste0("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/map_blshtrk_",paste0(weightings,collapse="_"),"_",algorithm,".png"),width=5,height=5,units='in',res=400)
a
dev.off()

weightings<-c(-0.1,-0.1,-0.05,-0.3,0.1)
algorithm="^Marxan_mosaic01$"
index=NULL
index=grep(print(algorithm),names(master))
subtitle=paste0(namesrisk[1],": ",weightings[1],", ",namesrisk[2],": ",weightings[2],", ",namesrisk[3],": ",weightings[3],", ",namesrisk[4],": ",weightings[4],", ",namesrisk[5],": ",weightings[5])
a=ggplot()+geom_map(data=map.US,map=map.US,aes(map_id=region,x=long,y=lat),fill="grey")+coord_cartesian()
a=a+geom_point(data=clean,aes(lon,lat,color=clean[,index]),size=.7,alpha=.4)+coord_cartesian()
a=a+ggtitle(label = paste0("Weighted ", algorithm," predictions at obs & trk data from 2005: blshtrk"),subtitle = subtitle)+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+coord_cartesian(xlim=c(-133,-115),ylim=c(29,49),expand=F)
png(paste0("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/map_blshtrk_",paste0(weightings,collapse="_"),"_",algorithm,".png"),width=5,height=5,units='in',res=400)
a
dev.off()

### maps by species: blshobs #####
clean=master[complete.cases(master),] %>% filter(sp_name=="BLSH")
map.US <- map_data(map="state")

weightings<-c(-0.1,-0.1,-0.05,-1.5,.1)
algorithm="EcoROMS"
index=NULL
index=grep(print(algorithm),names(master))
subtitle=paste0(namesrisk[1],": ",weightings[1],", ",namesrisk[2],": ",weightings[2],", ",namesrisk[3],": ",weightings[3],", ",namesrisk[4],": ",weightings[4],", ",namesrisk[5],": ",weightings[5])
a=ggplot()+geom_map(data=map.US,map=map.US,aes(map_id=region,x=long,y=lat),fill="grey")+coord_cartesian()
a=a+geom_point(data=clean,aes(lon,lat,color=clean[,index]),size=.7,alpha=.4)+coord_cartesian()
a=a+ggtitle(label = paste0("Weighted ", algorithm," predictions at obs & trk data from 2005: BLSH"),subtitle = subtitle)+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+coord_cartesian(xlim=c(-133,-115),ylim=c(29,49),expand=F)
png(paste0("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/map_BLSH_",paste0(weightings,collapse="_"),"_",algorithm,".png"),width=5,height=5,units='in',res=400)
a
dev.off()

weightings<-c(-0.1,-0.1,-0.05,-0.3,0.1)
algorithm="Marxan_raw"
index=NULL
index=grep(print(algorithm),names(master))
subtitle=paste0(namesrisk[1],": ",weightings[1],", ",namesrisk[2],": ",weightings[2],", ",namesrisk[3],": ",weightings[3],", ",namesrisk[4],": ",weightings[4],", ",namesrisk[5],": ",weightings[5])
a=ggplot()+geom_map(data=map.US,map=map.US,aes(map_id=region,x=long,y=lat),fill="grey")+coord_cartesian()
a=a+geom_point(data=clean,aes(lon,lat,color=clean[,index]),size=.7,alpha=.4)+coord_cartesian()
a=a+ggtitle(label = paste0("Weighted ", algorithm," predictions at obs & trk data from 2005: BLSH"),subtitle = subtitle)+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+coord_cartesian(xlim=c(-133,-115),ylim=c(29,49),expand=F)
png(paste0("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/map_BLSH_",paste0(weightings,collapse="_"),"_",algorithm,".png"),width=5,height=5,units='in',res=400)
a
dev.off()

weightings<-c(-0.1,-0.1,-0.05,-0.3,0.1)
algorithm="^Marxan_mosaic$"
index=NULL
index=grep(print(algorithm),names(master))
subtitle=paste0(namesrisk[1],": ",weightings[1],", ",namesrisk[2],": ",weightings[2],", ",namesrisk[3],": ",weightings[3],", ",namesrisk[4],": ",weightings[4],", ",namesrisk[5],": ",weightings[5])
a=ggplot()+geom_map(data=map.US,map=map.US,aes(map_id=region,x=long,y=lat),fill="grey")+coord_cartesian()
a=a+geom_point(data=clean,aes(lon,lat,color=clean[,index]),size=.7,alpha=.4)+coord_cartesian()
a=a+ggtitle(label = paste0("Weighted ", algorithm," predictions at obs & trk data from 2005: BLSH"),subtitle = subtitle)+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+coord_cartesian(xlim=c(-133,-115),ylim=c(29,49),expand=F)
png(paste0("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/map_BLSH_",paste0(weightings,collapse="_"),"_",algorithm,".png"),width=5,height=5,units='in',res=400)
a
dev.off()

weightings<-c(-0.1,-0.1,-0.05,-0.3,0.1)
algorithm="^Marxan_mosaic01$"
index=NULL
index=grep(print(algorithm),names(master))
subtitle=paste0(namesrisk[1],": ",weightings[1],", ",namesrisk[2],": ",weightings[2],", ",namesrisk[3],": ",weightings[3],", ",namesrisk[4],": ",weightings[4],", ",namesrisk[5],": ",weightings[5])
a=ggplot()+geom_map(data=map.US,map=map.US,aes(map_id=region,x=long,y=lat),fill="grey")+coord_cartesian()
a=a+geom_point(data=clean,aes(lon,lat,color=clean[,index]),size=.7,alpha=.4)+coord_cartesian()
a=a+ggtitle(label = paste0("Weighted ", algorithm," predictions at obs & trk data from 2005: BLSH"),subtitle = subtitle)+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+coord_cartesian(xlim=c(-133,-115),ylim=c(29,49),expand=F)
png(paste0("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/map_BLSH_",paste0(weightings,collapse="_"),"_",algorithm,".png"),width=5,height=5,units='in',res=400)
a
dev.off()

