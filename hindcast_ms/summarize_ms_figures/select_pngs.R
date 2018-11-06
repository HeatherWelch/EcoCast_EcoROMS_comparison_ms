### extracting correlation based metrics
### was previously that, now its a way to grab files
weightings<-c(-0.1,-0.1,-0.05,-0.4,0.2)
dates=list.files("~/Dropbox/Eco-ROMS/EcoROMSruns/output/hindcast/marxan",pattern=".grd") %>% grep("_raw",.,value=T) %>% grep(paste0(weightings,collapse="_"),.,value=T) %>% 
  gsub(paste0("marxan_nocost_",paste0(weightings,collapse="_"),"_"),"",.) %>% gsub("_raw.grd","",.)

## directories
dailypreddir="~/Dropbox/Eco-ROMS/Model Prediction Plots/daily_predictions/"
speciesdirs=c("blshobs","blshtrk_nolat","casl_noLat","lbst_nolat","swor")
blshobsdir=paste0(dailypreddir,speciesdirs[1],"/")
blshtrkdir=paste0(dailypreddir,speciesdirs[2],"/")
casldir=paste0(dailypreddir,speciesdirs[3],"/")
lbstdir=paste0(dailypreddir,speciesdirs[4],"/")
swordir=paste0(dailypreddir,speciesdirs[5],"/")

tempdir="~/Dropbox/Eco-ROMS/ROMS & Bathym Data/daily_prediction_layers/"
marxdir="~/Dropbox/Eco-ROMS/EcoROMSruns/output/hindcast_ms/marxan/"
ecodir="~/Dropbox/Eco-ROMS/EcoROMSruns/output/hindcast_ms/mean/"

weightings <-c(0,0,0,-0.5,0) #run B.3
paste(weightings,collapse ="_")

date=dates[18]

## get raw files
# blshobs=list.files(blshobsdir,full.names = T) %>% grep(date,.,value=T) %>% grep("mean.grd",.,value=T) %>% raster()
# blshtrk=list.files(blshtrkdir,full.names = T) %>% grep(date,.,value=T) %>% grep("mean.grd",.,value=T) %>% raster()
# casl=list.files(casldir,full.names = T) %>% grep(date,.,value=T) %>% grep("mean.grd",.,value=T) %>% raster()
# lbst=list.files(lbstdir,full.names = T) %>% grep(date,.,value=T) %>% grep("mean.grd",.,value=T) %>% raster()
# swor=list.files(swordir,full.names = T) %>% grep(date,.,value=T) %>% grep("mean.grd",.,value=T) %>% raster()
# 
# temp=paste0(tempdir,date,"/sst.grd") %>% raster()
# marxan=list.files(marxdir,full.names = T) %>% grep(paste0(paste(weightings,collapse ="_"),"_",date),.,value=T)%>% grep("raw_unscaled.grd",.,value=T) %>% raster
# ecocast=list.files(ecodir,full.names = T) %>% grep(paste0(paste(weightings,collapse ="_"),"_",date,"_mean.grd"),.,value=T)%>% grep("unscaled",.,value=T) %>% raster
# 
# allDat=brick(blshobs,blshtrk,casl,lbst,swor,marxan,ecocast,temp)
# corMat=layerStats(allDat,"pearson",na.rm = T)
# colnames(corMat$`pearson correlation coefficient`)=c("blshobs","blshtrk","casl","lbst","swor","marxan","ecocast","temp")
# rownames(corMat$`pearson correlation coefficient`)=c("blshobs","blshtrk","casl","lbst","swor","marxan","ecocast","temp")

#### selecting files
## Fig. 2 Marxan + EcoCast for different mgmt. priorities
weightings <-c(0,0,0,0,0.1) #run A.1
marxan=list.files(marxdir,full.names = T) %>% grep(paste0(paste(weightings,collapse ="_"),"_",date),.,value=T)%>% grep("raw_unscaled",.,value=T)
ecocast=list.files(ecodir,full.names = T) %>% grep(paste0(paste(weightings,collapse ="_"),"_",date,"_mean"),.,value=T)%>% grep("unscaled",.,value=T)
file.copy(marxan,"/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/example_runs")
file.copy(ecocast,"/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/example_runs")

weightings <-c(0,0,0,0,0.3) #run A.2
marxan=list.files(marxdir,full.names = T) %>% grep(paste0(paste(weightings,collapse ="_"),"_",date),.,value=T)%>% grep("raw_unscaled",.,value=T)
ecocast=list.files(ecodir,full.names = T) %>% grep(paste0(paste(weightings,collapse ="_"),"_",date,"_mean"),.,value=T)%>% grep("unscaled",.,value=T)
file.copy(marxan,"/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/example_runs")
file.copy(ecocast,"/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/example_runs")

weightings <-c(0,0,0,0,0.5) #run A.3
marxan=list.files(marxdir,full.names = T) %>% grep(paste0(paste(weightings,collapse ="_"),"_",date),.,value=T)%>% grep("raw_unscaled",.,value=T)
ecocast=list.files(ecodir,full.names = T) %>% grep(paste0(paste(weightings,collapse ="_"),"_",date,"_mean"),.,value=T)%>% grep("unscaled",.,value=T)
file.copy(marxan,"/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/example_runs")
file.copy(ecocast,"/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/example_runs")

weightings <-c(0,0,0,0,0.7) #run A.4
marxan=list.files(marxdir,full.names = T) %>% grep(paste0(paste(weightings,collapse ="_"),"_",date),.,value=T)%>% grep("raw_unscaled",.,value=T)
ecocast=list.files(ecodir,full.names = T) %>% grep(paste0(paste(weightings,collapse ="_"),"_",date,"_mean"),.,value=T)%>% grep("unscaled",.,value=T)
file.copy(marxan,"/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/example_runs")
file.copy(ecocast,"/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/example_runs")

weightings <-c(0,0,0,0,0.9) #run A.5
marxan=list.files(marxdir,full.names = T) %>% grep(paste0(paste(weightings,collapse ="_"),"_",date),.,value=T)%>% grep("raw_unscaled",.,value=T)
ecocast=list.files(ecodir,full.names = T) %>% grep(paste0(paste(weightings,collapse ="_"),"_",date,"_mean"),.,value=T)%>% grep("unscaled",.,value=T)
file.copy(marxan,"/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/example_runs")
file.copy(ecocast,"/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/example_runs")

## other option figure 2
weightings <-c(0,0,0,-0.1,0.1) #run C.1
marxan=list.files(marxdir,full.names = T) %>% grep(paste0(paste(weightings,collapse ="_"),"_",date),.,value=T)%>% grep("raw_unscaled",.,value=T)
ecocast=list.files(ecodir,full.names = T) %>% grep(paste0(paste(weightings,collapse ="_"),"_",date,"_mean"),.,value=T)%>% grep("unscaled",.,value=T)
file.copy(marxan,"/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/example_runs")
file.copy(ecocast,"/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/example_runs")

weightings <-c(0,0,0,-0.3,0.3) #run C.2
marxan=list.files(marxdir,full.names = T) %>% grep(paste0(paste(weightings,collapse ="_"),"_",date),.,value=T)%>% grep("raw_unscaled",.,value=T)
ecocast=list.files(ecodir,full.names = T) %>% grep(paste0(paste(weightings,collapse ="_"),"_",date,"_mean"),.,value=T)%>% grep("unscaled",.,value=T)
file.copy(marxan,"/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/example_runs")
file.copy(ecocast,"/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/example_runs")

weightings <-c(0,0,0,-0.5,0.5) #run C.3
marxan=list.files(marxdir,full.names = T) %>% grep(paste0(paste(weightings,collapse ="_"),"_",date),.,value=T)%>% grep("raw_unscaled",.,value=T)
ecocast=list.files(ecodir,full.names = T) %>% grep(paste0(paste(weightings,collapse ="_"),"_",date,"_mean"),.,value=T)%>% grep("unscaled",.,value=T)
file.copy(marxan,"/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/example_runs")
file.copy(ecocast,"/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/example_runs")

weightings <-c(0,0,0,-0.7,0.7) #run C.4
marxan=list.files(marxdir,full.names = T) %>% grep(paste0(paste(weightings,collapse ="_"),"_",date),.,value=T)%>% grep("raw_unscaled",.,value=T)
ecocast=list.files(ecodir,full.names = T) %>% grep(paste0(paste(weightings,collapse ="_"),"_",date,"_mean"),.,value=T)%>% grep("unscaled",.,value=T)
file.copy(marxan,"/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/example_runs")
file.copy(ecocast,"/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/example_runs")

weightings <-c(0,0,0,-0.9,0.9) #run C.5
marxan=list.files(marxdir,full.names = T) %>% grep(paste0(paste(weightings,collapse ="_"),"_",date),.,value=T)%>% grep("raw_unscaled",.,value=T)
ecocast=list.files(ecodir,full.names = T) %>% grep(paste0(paste(weightings,collapse ="_"),"_",date,"_mean"),.,value=T)%>% grep("unscaled",.,value=T)
file.copy(marxan,"/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/example_runs")
file.copy(ecocast,"/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/example_runs")

## Fig 5. Marxan + EcoCast for different # species
blshobs=list.files(blshobsdir,full.names = T) %>% grep(date,.,value=T) %>% grep("mean",.,value=T)
blshtrk=list.files(blshtrkdir,full.names = T) %>% grep(date,.,value=T) %>% grep("mean",.,value=T)
casl=list.files(casldir,full.names = T) %>% grep(date,.,value=T) %>% grep("mean",.,value=T)
lbst=list.files(lbstdir,full.names = T) %>% grep(date,.,value=T) %>% grep("mean",.,value=T)
swor=list.files(swordir,full.names = T) %>% grep(date,.,value=T) %>% grep("mean",.,value=T)

file.copy(blshobs,"/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/example_runs")
file.copy(blshtrk,"/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/example_runs")
file.copy(casl,"/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/example_runs")
file.copy(lbst,"/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/example_runs")
file.copy(swor,"/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/example_runs")

weightings <-c(0,0,0,-0.5,0) #run B.3
marxan=list.files(marxdir,full.names = T) %>% grep(paste0(paste(weightings,collapse ="_"),"_",date),.,value=T)%>% grep("raw_unscaled",.,value=T)
ecocast=list.files(ecodir,full.names = T) %>% grep(paste0(paste(weightings,collapse ="_"),"_",date,"_mean"),.,value=T)%>% grep("unscaled",.,value=T)
file.copy(marxan,"/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/example_runs")
file.copy(ecocast,"/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/example_runs")

weightings <-c(0,0,0,-0.5,0.5) #run C.3
marxan=list.files(marxdir,full.names = T) %>% grep(paste0(paste(weightings,collapse ="_"),"_",date),.,value=T)%>% grep("raw_unscaled",.,value=T)
ecocast=list.files(ecodir,full.names = T) %>% grep(paste0(paste(weightings,collapse ="_"),"_",date,"_mean"),.,value=T)%>% grep("unscaled",.,value=T)
file.copy(marxan,"/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/example_runs")
file.copy(ecocast,"/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/example_runs")

weightings <-c(-0.25,-0.25,0,-0.5,0.5) #run G.3
marxan=list.files(marxdir,full.names = T) %>% grep(paste0(paste(weightings,collapse ="_"),"_",date),.,value=T)%>% grep("raw_unscaled",.,value=T)
ecocast=list.files(ecodir,full.names = T) %>% grep(paste0(paste(weightings,collapse ="_"),"_",date,"_mean"),.,value=T)%>% grep("unscaled",.,value=T)
file.copy(marxan,"/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/example_runs")
file.copy(ecocast,"/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/example_runs")

weightings <-c(-0.25,-0.25,-0.5,-0.5,0.5) #run J.3
marxan=list.files(marxdir,full.names = T) %>% grep(paste0(paste(weightings,collapse ="_"),"_",date),.,value=T)%>% grep("raw_unscaled",.,value=T)
ecocast=list.files(ecodir,full.names = T) %>% grep(paste0(paste(weightings,collapse ="_"),"_",date,"_mean"),.,value=T)%>% grep("unscaled",.,value=T)
file.copy(marxan,"/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/example_runs")
file.copy(ecocast,"/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/example_runs")
