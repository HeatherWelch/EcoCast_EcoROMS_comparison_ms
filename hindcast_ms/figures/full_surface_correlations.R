### calculating full surface correlations by date

plotdir_ms="./hindcast_ms/figures/plots/"

weightings<-c(-0.1,-0.1,-0.05,-0.4,0.2)
dates=list.files("~/Dropbox/Eco-ROMS/EcoROMSruns/output/hindcast/marxan",pattern=".grd") %>% grep("_raw",.,value=T) %>% grep(paste0(weightings,collapse="_"),.,value=T) %>% 
  gsub(paste0("marxan_nocost_",paste0(weightings,collapse="_"),"_"),"",.) %>% gsub("_raw.grd","",.)

# 
# run_correlations=function(dates,weightings,run){
  weightingscsv=read.csv("hindcast_ms/predict/weighting_scenarios.csv")
  
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

# run =weightingscsv[grep(paste(weightings,collapse =","),weightingscsv$weighting),2] %>% as.character()
# paste(weightings,collapse ="_")

#date=dates[18]

## raw species layers ####
#toMatch=c("M.1","M.2","C.3","E.1","D.4","A","B","M.4","M.5","G.3","J.3")
toMatch=c("C.3","E.1","D.4","A","B","G.3","J.3") # do Ms later
weightings=grep(paste(toMatch,collapse="|"),weightingscsv$run) %>% weightingscsv[.,2]
empty=data.frame(Blueshark=NA,Sealion=NA,Leatherback=NA,Swordfish=NA,dt=NA,weighting=NA,Algorithm=NA)

for (date in dates){
  print(date)
blshobs=list.files(blshobsdir,full.names = T) %>% grep(date,.,value=T) %>% grep("mean.grd",.,value=T) %>% raster()
blshtrk=list.files(blshtrkdir,full.names = T) %>% grep(date,.,value=T) %>% grep("mean.grd",.,value=T) %>% raster()
blsh=mean(blshobs,blshtrk)
casl=list.files(casldir,full.names = T) %>% grep(date,.,value=T) %>% grep("mean.grd",.,value=T) %>% raster()
lbst=list.files(lbstdir,full.names = T) %>% grep(date,.,value=T) %>% grep("mean.grd",.,value=T) %>% raster()
swor=list.files(swordir,full.names = T) %>% grep(date,.,value=T) %>% grep("mean.grd",.,value=T) %>% raster()

  for (weighting in weightings){
  print(weighting)
  weighting=gsub(",","_",weighting)
  marxan=list.files(marxdir,full.names = T) %>% grep(paste0(weighting,"_",date),.,value=T)%>% grep("raw_unscaled.grd",.,value=T) %>% raster()
ecocast=list.files(ecodir,full.names = T) %>% grep(paste0(weighting,"_",date,"_mean.grd"),.,value=T)%>% grep("unscaled",.,value=T) %>% raster()
allDat=brick(marxan,ecocast,blsh,casl,lbst,swor)
names(allDat)=c("Marxan","Ecocast","Blueshark","Sealion","Leatherback","Swordfish")
corMat=layerStats(allDat,"pearson",na.rm = T)
a=corMat$`pearson correlation coefficient`[1:2,3:6] %>% as.data.frame() %>% mutate(dt=date) %>% mutate(weighting=weighting) %>% mutate(Algorithm=c("Marxan","EcoCast"))
empty=rbind(empty,a)

}
}


toMatch=c("M.1","M.2","M.4","M.5")
weightings=grep(paste(toMatch,collapse="|"),weightingscsv$run) %>% weightingscsv[.,2]
empty2=data.frame(Blueshark=NA,Sealion=NA,Leatherback=NA,Swordfish=NA,dt=NA,weighting=NA,Algorithm=NA)
for (date in dates){
  print(date)
  blshobs=list.files(blshobsdir,full.names = T) %>% grep(date,.,value=T) %>% grep("mean.grd",.,value=T) %>% raster()
  blshtrk=list.files(blshtrkdir,full.names = T) %>% grep(date,.,value=T) %>% grep("mean.grd",.,value=T) %>% raster()
  blsh=mean(blshobs,blshtrk)
  casl=list.files(casldir,full.names = T) %>% grep(date,.,value=T) %>% grep("mean.grd",.,value=T) %>% raster()
  lbst=list.files(lbstdir,full.names = T) %>% grep(date,.,value=T) %>% grep("mean.grd",.,value=T) %>% raster()
  swor=list.files(swordir,full.names = T) %>% grep(date,.,value=T) %>% grep("mean.grd",.,value=T) %>% raster()
  
  for (weighting in weightings){
    print(weighting)
    weighting=gsub(",","_",weighting)
    #marxan=list.files(marxdir,full.names = T) %>% grep(paste0(weighting,"_",date),.,value=T)%>% grep("raw_unscaled.grd",.,value=T) %>% raster()
    ecocast=list.files(ecodir,full.names = T) %>% grep(paste0(weighting,"_",date,"_mean.grd"),.,value=T)%>% grep("unscaled",.,value=T) %>% raster()
    allDat=brick(ecocast,blsh,casl,lbst,swor)
    names(allDat)=c("Ecocast","Blueshark","Sealion","Leatherback","Swordfish")
    corMat=layerStats(allDat,"pearson",na.rm = T)
    a=corMat$`pearson correlation coefficient`[1,2:5] %>% t() %>% as.data.frame() %>% mutate(dt=date) %>% mutate(weighting=weighting) %>% mutate(Algorithm=c("EcoCast"))
    empty2=rbind(empty2,a)
    
  }
}

master=rbind(empty,empty2) %>% .[complete.cases(.),]
write.csv(master,paste0(plotdir_ms,"full_surface_cor.csv"))


weightingscsv=weightingscsv %>% mutate(join_col=gsub(",","_",weighting))
master=left_join(master,weightingscsv,by=c("weighting"="join_col"))

eco=master %>% filter(Algorithm=="EcoCast") %>% filter(run=="C.3"|run=="D.4"|run=="E.1"|run=="M.4"|run=="M.5")
ggplot(eco,aes(x=Leatherback,y=Swordfish,group=run,color=run))+geom_point()+xlim(1,-1)

mar=master %>% filter(Algorithm=="Marxan")%>% filter(run=="C.3"|run=="D.4"|run=="E.1")
ggplot(mar,aes(x=Leatherback,y=Swordfish,group=run,color=run))+geom_point()+xlim(1,-1)

head(master)
a=master %>% group_by(Algorithm,run) %>% summarise(meanb=mean(Blueshark),meanl=mean(Leatherback),means=mean(Swordfish)) %>% as.data.frame()

mar=master %>% filter(Algorithm=="Marxan")%>% filter(run=="C.3"|run=="D.4"|run=="E.1")
ggplot(mar,aes(x=dt,y=Leatherback,group=run,color=run))+geom_line()

eco=master %>% filter(Algorithm=="EcoCast")%>% filter(run=="C.3"|run=="D.4"|run=="E.1")
ggplot(eco,aes(x=dt,y=Swordfish,group=run,color=run))+geom_line()
