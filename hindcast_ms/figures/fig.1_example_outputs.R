## figure 1. Examples of how EcoCast and Marxan vary over different mgmg scenarios

source("/Volumes/SeaGate/EcoROMS/Eco-ROMS-private/EcoROMs/save_png.R")

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

## raw species layers ####
blshobs=list.files(blshobsdir,full.names = T) %>% grep(date,.,value=T) %>% grep("mean",.,value=T)
blshtrk=list.files(blshtrkdir,full.names = T) %>% grep(date,.,value=T) %>% grep("mean",.,value=T)
casl=list.files(casldir,full.names = T) %>% grep(date,.,value=T) %>% grep("mean",.,value=T)
lbst=list.files(lbstdir,full.names = T) %>% grep(date,.,value=T) %>% grep("mean",.,value=T)
swor=list.files(swordir,full.names = T) %>% grep(date,.,value=T) %>% grep("mean",.,value=T)

file.copy(blshobs,"/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/hindcast_ms/figures/example_runs_fig1")
file.copy(blshtrk,"/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/hindcast_ms/figures/example_runs_fig1")
file.copy(casl,"/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/hindcast_ms/figures/example_runs_fig1")
file.copy(lbst,"/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/hindcast_ms/figures/example_runs_fig1")
file.copy(swor,"/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/hindcast_ms/figures/example_runs_fig1")

## averaging blsh
a=raster("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/hindcast_ms/figures/example_runs_fig1/blshobs_1997-10-01_mean.grd")
b=raster("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/hindcast_ms/figures/example_runs_fig1/blshtrk_nolat_1997-10-01_mean.grd")
c=mean(a,b)
outdir="/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/hindcast_ms/figures/example_runs_fig1/"
make_png_operationalization(r=c,spname = "blshAve",get_date=date, outDir = outdir,type = "mean")
image(c, col=pal(ncolors), breaks=breaks, ylab="", xlab="", xlim=c(-130,-115.5),ylim=c(30,47))
image.plot(c,col=pal(ncolors),xlim=c(-130,-115),ylim=c(30,47),zlim=c(0,1))

## EcoCast lbst, swor, dual
weightings <-c(0,0,0,0,1) #run M.1
ecocast=list.files(ecodir,full.names = T) %>% grep(paste0(paste(weightings,collapse ="_"),"_",date,"_mean"),.,value=T)%>% grep("unscaled",.,value=T)
file.copy(ecocast,outdir)

weightings <-c(0,0,0,-1,0) #run M.2
ecocast=list.files(ecodir,full.names = T) %>% grep(paste0(paste(weightings,collapse ="_"),"_",date,"_mean"),.,value=T)%>% grep("unscaled",.,value=T)
file.copy(ecocast,outdir)

weightings <-c(0,0,0,-0.5,0.5) #run C.3
ecocast=list.files(ecodir,full.names = T) %>% grep(paste0(paste(weightings,collapse ="_"),"_",date,"_mean"),.,value=T)%>% grep("unscaled",.,value=T)
file.copy(ecocast,outdir)


## EcoCast, increasing numbers of species
# weightings <-c(0,0,0,-1,0) #run M.2 (already copies)
# ecocast=list.files(ecodir,full.names = T) %>% grep(paste0(paste(weightings,collapse ="_"),"_",date,"_mean"),.,value=T)%>% grep("unscaled",.,value=T)
# file.copy(ecocast,outdir)
# 
# weightings <-c(0,0,0,-0.5,0.5) #run C.3  (already copies)
# ecocast=list.files(ecodir,full.names = T) %>% grep(paste0(paste(weightings,collapse ="_"),"_",date,"_mean"),.,value=T)%>% grep("unscaled",.,value=T)
# file.copy(ecocast,outdir)

weightings <-c(-0.25,-0.25,0,-0.5,0.5) #run G.3
ecocast=list.files(ecodir,full.names = T) %>% grep(paste0(paste(weightings,collapse ="_"),"_",date,"_mean"),.,value=T)%>% grep("unscaled",.,value=T)
file.copy(ecocast,outdir)

weightings <-c(-0.25,-0.25,-0.5,-0.5,0.5) #run J.3
ecocast=list.files(ecodir,full.names = T) %>% grep(paste0(paste(weightings,collapse ="_"),"_",date,"_mean"),.,value=T)%>% grep("unscaled",.,value=T)
file.copy(ecocast,outdir)


## Marxan, swordfish
weightings <-c(0,0,0,0,0.1) #run A.1
marxan=list.files(marxdir,full.names = T) %>% grep(paste0(paste(weightings,collapse ="_"),"_",date),.,value=T)%>% grep("raw_unscaled",.,value=T)
file.copy(marxan,outdir)

weightings <-c(0,0,0,0,0.3) #run A.2
marxan=list.files(marxdir,full.names = T) %>% grep(paste0(paste(weightings,collapse ="_"),"_",date),.,value=T)%>% grep("raw_unscaled",.,value=T)
file.copy(marxan,outdir)

weightings <-c(0,0,0,0,0.5) #run A.3
marxan=list.files(marxdir,full.names = T) %>% grep(paste0(paste(weightings,collapse ="_"),"_",date),.,value=T)%>% grep("raw_unscaled",.,value=T)
file.copy(marxan,outdir)

weightings <-c(0,0,0,0,0.7) #run A.4
marxan=list.files(marxdir,full.names = T) %>% grep(paste0(paste(weightings,collapse ="_"),"_",date),.,value=T)%>% grep("raw_unscaled",.,value=T)
file.copy(marxan,outdir)

weightings <-c(0,0,0,0,0.9) #run A.5
marxan=list.files(marxdir,full.names = T) %>% grep(paste0(paste(weightings,collapse ="_"),"_",date),.,value=T)%>% grep("raw_unscaled",.,value=T)
file.copy(marxan,outdir)

## Marxan, leatherback
weightings <-c(0,0,0,-0.1,0) #run B.1
marxan=list.files(marxdir,full.names = T) %>% grep(paste0(paste(weightings,collapse ="_"),"_",date),.,value=T)%>% grep("raw_unscaled",.,value=T)
file.copy(marxan,outdir)

weightings <-c(0,0,0,-0.3,0) #run B.2
marxan=list.files(marxdir,full.names = T) %>% grep(paste0(paste(weightings,collapse ="_"),"_",date),.,value=T)%>% grep("raw_unscaled",.,value=T)
file.copy(marxan,outdir)

weightings <-c(0,0,0,-0.5,0) #run B.3
marxan=list.files(marxdir,full.names = T) %>% grep(paste0(paste(weightings,collapse ="_"),"_",date),.,value=T)%>% grep("raw_unscaled",.,value=T)
file.copy(marxan,outdir)

weightings <-c(0,0,0,-0.7,0) #run B.4
marxan=list.files(marxdir,full.names = T) %>% grep(paste0(paste(weightings,collapse ="_"),"_",date),.,value=T)%>% grep("raw_unscaled",.,value=T)
file.copy(marxan,outdir)

weightings <-c(0,0,0,-0.9,0) #run B.5
marxan=list.files(marxdir,full.names = T) %>% grep(paste0(paste(weightings,collapse ="_"),"_",date),.,value=T)%>% grep("raw_unscaled",.,value=T)
file.copy(marxan,outdir)

## Marxan, leatherback + swor
weightings <-c(0,0,0,-0.1,0.1) #run C.1
marxan=list.files(marxdir,full.names = T) %>% grep(paste0(paste(weightings,collapse ="_"),"_",date),.,value=T)%>% grep("raw_unscaled",.,value=T)
file.copy(marxan,outdir)

weightings <-c(0,0,0,-0.3,0.3) #run C.2
marxan=list.files(marxdir,full.names = T) %>% grep(paste0(paste(weightings,collapse ="_"),"_",date),.,value=T)%>% grep("raw_unscaled",.,value=T)
file.copy(marxan,outdir)

weightings <-c(0,0,0,-0.5,0.5) #run C.3
marxan=list.files(marxdir,full.names = T) %>% grep(paste0(paste(weightings,collapse ="_"),"_",date),.,value=T)%>% grep("raw_unscaled",.,value=T)
file.copy(marxan,outdir)

weightings <-c(0,0,0,-0.7,0.7) #run C.4
marxan=list.files(marxdir,full.names = T) %>% grep(paste0(paste(weightings,collapse ="_"),"_",date),.,value=T)%>% grep("raw_unscaled",.,value=T)
file.copy(marxan,outdir)

weightings <-c(0,0,0,-0.9,0.9) #run C.5
marxan=list.files(marxdir,full.names = T) %>% grep(paste0(paste(weightings,collapse ="_"),"_",date),.,value=T)%>% grep("raw_unscaled",.,value=T)
file.copy(marxan,outdir)

