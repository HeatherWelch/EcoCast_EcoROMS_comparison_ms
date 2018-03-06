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
library(lubridate)

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
casl_roms$dt=casl_roms$dt %>% as.Date()


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




#### ---------> new code 02-21-18 to add in tracking data, and select date subsets to run full analysis
species_roms=read.csv("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/raw_data/observer_casl_swor_blsh_lbst_roms.csv")%>% mutate(dt=as.Date(dt))
blsh_trk <- readRDS("~/Dropbox/Eco-ROMS/Species Data/Tracking Data/bstrp_lists_w_data/blsh_bstrp_list.rds") %>% lapply(.,function(DataInput_Fit)DataInput_Fit[complete.cases(DataInput_Fit),]) %>% do.call("rbind",.) %>% .[,1:(ncol(.)-1)] %>% mutate(dt=as.Date(dt))
lbst_trk <- readRDS("~/Dropbox/Eco-ROMS/Species Data/Tracking Data/bstrp_lists_w_data/lbst_bstrp_list.rds") %>% lapply(.,function(DataInput_Fit)DataInput_Fit[complete.cases(DataInput_Fit),]) %>% do.call("rbind",.) %>% .[,1:(ncol(.)-1)] %>% mutate(dt=as.Date(dt))
casl_trk <- readRDS(paste0("~/Dropbox/Eco-ROMS/Species Data/Tracking Data/bstrp_lists_w_data/","casl_bstrp_list.rds")) %>% lapply(.,function(DataInput_Fit)DataInput_Fit[complete.cases(DataInput_Fit),]) %>% do.call("rbind",.) %>% .[,1:(ncol(.)-1)]

png(paste0("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/hist_all_data.png"),width=7,height=5,units='in',res=400)
par(mfrow=c(2,2))
hist(blsh_trk$dt,"year",freq = T)
hist(lbst_trk$dt,"year",freq = T)
hist(casl_trk$dt,"year",freq = T)
hist(species_roms$dt,"year",freq = T)
dev.off()

## 2005 looks like a good year
blsh_trk_2005=blsh_trk %>% filter(dt>"2005-01-01" & dt<"2005-12-31")
lbst_trk_2005=lbst_trk %>% filter(dt>"2005-01-01" & dt<"2005-12-31")
casl_trk_2005=casl_trk %>% filter(dt>"2005-01-01" & dt<"2005-12-31")
species_roms_2005=species_roms %>% filter(dt>"2005-01-01" & dt<"2005-12-31")

png(paste0("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/hist_all_data_2005.png"),width=7,height=5,units='in',res=400)
par(mfrow=c(2,2))
hist(blsh_trk_2005$dt,"month",freq = T)
hist(lbst_trk_2005$dt,"month",freq = T)
hist(casl_trk_2005$dt,"month",freq = T,ylim=c(0,1000))
hist(species_roms_2005$dt,"month",freq = T)
dev.off()

## 08-11 looks like a good month
blsh_trk_2005_10=blsh_trk_2005 %>% filter(as.Date(dt,format="%Y-%m-%d")>as.Date("2005-08-01",format="%Y-%m-%d")& as.Date(dt,format="%Y-%m-%d")<as.Date("2005-11-30",format="%Y-%m-%d")) %>% select(-c(X,iter,ptt,flag)) %>% add_column(sp_name="blshtrk")
lbst_trk_2005_10=lbst_trk_2005 %>% filter(as.Date(dt,format="%Y-%m-%d")>as.Date("2005-08-01",format="%Y-%m-%d")& as.Date(dt,format="%Y-%m-%d")<as.Date("2005-11-30",format="%Y-%m-%d")) %>% select(-c(id,iteration,flag,RN)) %>% add_column(sp_name="lbst")
casl_trk_2005_10=casl_trk %>% filter(as.Date(dt,format="%Y-%m-%d")>as.Date("2005-08-01",format="%Y-%m-%d")& as.Date(dt,format="%Y-%m-%d")<as.Date("2005-11-30",format="%Y-%m-%d")) %>% select(-c(id,iteration,flag,RN)) %>% add_column(sp_name="casl")
species_roms_2005_10=species_roms %>% filter(as.Date(dt,format="%Y-%m-%d")>as.Date("2005-08-01",format="%Y-%m-%d")& as.Date(dt,format="%Y-%m-%d")<as.Date("2005-11-30",format="%Y-%m-%d"))

png(paste0("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/hist_all_data_2005_08-11.png"),width=7,height=5,units='in',res=400)
par(mfrow=c(2,2))
hist(blsh_trk_2005_10$dt,"day",freq = T)
hist(lbst_trk_2005_10$dt,"day",freq = T)
hist(casl_trk_2005_10$dt,"day",freq = T,ylim=c(0,1000))
hist(species_roms_2005_10$dt,"day",freq = T)
dev.off()

### write out final data files for 08-11 extraction
trk=do.call("rbind",list(blsh_trk_2005_10,lbst_trk_2005_10,casl_trk_2005_10))
write.csv(trk,"/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/raw_data/trk_casl_blsh_lbst_roms_2005_08_10.csv") ## trking
write.csv(species_roms_2005_10,"/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/raw_data/observer_casl_swor_blsh_lbst_roms_2005_08_10.csv") ## observer
