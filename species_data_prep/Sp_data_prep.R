#### code to prepare the EcoCast and EcoROMS species data for analysis
### 1. locate raw species data
### 2. associate EcoCast and EcoROMS extractions with species data
### 3. predict for each species at each raw data point (different script)
### 4. create Eco products under conditions of different species weightings (different script)

## raw observer species data: "~/Dropbox/Eco-ROMS/Species Data/Observer Data"
## "Catch_Life_1990-2017.csv"   = sealions (mammals)
## "Catch_SeaTurtle_1990-2017.csv"  = leatherbacks (turtles)
## "Catch_Spp_1990-2017.csv" = blsh and swor (not sealions not turtles)
## "SpList.csv" = species codes (why are some of these numbers?)
## "Catch_SeaTurtle_1990-2017.csv" = turtles
## species codes: casl: UO ;lbst: DC; swordfish: 91; and blsh: 167, extract by name

library(tidyverse)
library(maps)
library(mapdata)
library(maptools)
library(rgdal)
library(sp)

## extracted observer species data
roms=readRDS("~/Dropbox/Eco-ROMS/Species Data/Observer Data/DGN_allSets_1990-2017_ROMSExtracted.rds") %>% mutate(TripNumber_Set=as.character(TripNumber_Set))
set=read.csv("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/raw_data/Set_ForHeather.csv") %>% mutate(TripNumber_Set=paste0(TripNumber,"_",Set))

##----->end output, csv of swor blsh casl lbst tripNumber_sets w associated ROMS data

### 1. locate raw species data
casl=read.csv("~/Dropbox/Eco-ROMS/Species Data/Observer Data/Catch_Life_1990-2017.csv") %>% filter(SpCd=="UO")%>% mutate(SpCd=as.character(SpCd)) %>% filter(TripNumber_Set!='')%>% mutate(TripNumber_Set=as.character(TripNumber_Set))
swor=read.csv("~/Dropbox/Eco-ROMS/Species Data/Observer Data/Catch_Spp_1990-2017.csv") %>% filter(ScientificName=="Xiphias gladius") %>% select(TripNumber_Set,SpCd,TotCat) %>% mutate(SpCd=as.character(SpCd))
blsh=read.csv("~/Dropbox/Eco-ROMS/Species Data/Observer Data/Catch_Spp_1990-2017.csv") %>% filter(ScientificName=="Prionace glauca") %>% select(TripNumber_Set,SpCd,TotCat)%>% mutate(SpCd=as.character(SpCd))
lbst=read.csv("~/Dropbox/Eco-ROMS/Species Data/Observer Data/Catch_SeaTurtle_1990-2017.csv") %>% filter(SpCd=="DC") %>% mutate(TripNumber_Set=paste0(TripNumber_Set))  %>% select(TripNumber_Set,SpCd) %>% mutate(TotCat=1)%>% mutate(SpCd=as.character(SpCd))

### cleaning up casl
cas=inner_join(casl,set,by="TripNumber_Set") %>% mutate(dt=as.Date(paste(Year,MM,DD,sep="-")) )%>% mutate(lat=LatD1+LatM1/60)%>% mutate(lon=LongD1+LongM1/60) %>% select(TripNumber_Set,SpCd,TotCat,dt,lat,lon)
cas$lon=cas$lon*-1
write.csv(cas,"/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/raw_data/cas.csv")

### check Code_LocallyExtract&CalculateVariables.R for how cas_roms.csv was created
casl_roms=read.csv("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/raw_data/cas_roms.csv") 
casl_roms=casl_roms[,c(3,4,5,6,7,8,9,10,12,13,14,15,16:22,24,25)]
casl_roms=casl_roms[,c(1:7,9:21,8)]


# map("usa", fill=TRUE, col="white", bg="lightblue", ylim=c(-60, 90), mar=c(0,0,0,0))
# staticdir="~/Dropbox/Eco-ROMS/ROMS & Bathym Data/Bathymetry ETOPO1/"
# studyarea=readShapeSpatial(paste0(staticdir,"sa_square_coast3.shp"))
# spdf=SpatialPointsDataFrame(coords=cas[,5:6],data=cas)
# sp::coordinates(cas)=~lon+lat
# crs(cas)="+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0"
# plot(cas)
# plot(studyarea,add=T)
# map('worldHires',add=TRUE,col=grey(0.7),fill=TRUE)

species=do.call("rbind",list(casl,swor,blsh,lbst)) %>% as.tibble() ### final species data frame, raw
#write.csv(species,"/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/raw_data/observer_casl_swor_blsh_lbst_raw.csv")

### 2. associate EcoCast and EcoROMS extractions with species data
### ---------------------------------------> EcoROMS
species_roms=inner_join(species,roms,by="TripNumber_Set")
species_roms=species_roms[,c(1:6,9,11:21,23:25)]
species_roms=rbind(casl_roms,species_roms)

write.csv(species_roms,"/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/raw_data/observer_casl_swor_blsh_lbst_roms.csv")

