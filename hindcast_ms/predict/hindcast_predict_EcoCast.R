####### step 2. run plot_EcoROMS_temporary.R for all days (but first fix this function) ####
source("load_functions.R")
source("/Volumes/SeaGate/EcoROMS/Eco-ROMS-private/EcoROMs/plot_EcoROMS_temporary.R",chdir = T)

moddir="~/Dropbox/Eco-ROMS/Model Outputs/Final EcoROMS models"
outdir="~/Dropbox/Eco-ROMS/EcoROMSruns"
EcoROMSdir=paste0(outdir,"/output/hindcast_ms/")
envdir="~/Dropbox/Eco-ROMS/ROMS & Bathym Data/daily_prediction_layers/"
dailypreddir="~/Dropbox/Eco-ROMS/Model Prediction Plots/daily_predictions/"
staticdir="~/Dropbox/Eco-ROMS/ROMS & Bathym Data/Bathymetry ETOPO1/"
namesrisk<-c("Blue shark bycatch","Blue sharks","Sea lions","Leatherbacks","Swordfish")

weightings<-c(-0.1,-0.1,-0.05,-0.4,0.2)
dates=list.files("~/Dropbox/Eco-ROMS/EcoROMSruns/output/hindcast/marxan",pattern=".grd") %>% grep("_raw",.,value=T) %>% grep(paste0(weightings,collapse="_"),.,value=T) %>% 
  gsub(paste0("marxan_nocost_",paste0(weightings,collapse="_"),"_"),"",.) %>% gsub("_raw.grd","",.)

## scenario A--> isolating the effect of swordfish weightings (5 runs, weightings are the same for both algorithms) (run) #### 
weightings <-c(0,0,0,0,0.1) #run A.1
for(d in dates){
  get_date=d
  print(get_date)
  Run_ecoroms_hindcast(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
}

weightings <-c(0,0,0,0,0.3) #run A.2
for(d in dates){
  get_date=d
  print(get_date)
  Run_ecoroms_hindcast(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
}

weightings <-c(0,0,0,0,0.5) #run A.3
for(d in dates){
  get_date=d
  print(get_date)
  Run_ecoroms_hindcast(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
}

weightings <-c(0,0,0,0,0.7) #run A.4
for(d in dates){
  get_date=d
  print(get_date)
  Run_ecoroms_hindcast(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
}

weightings <-c(0,0,0,0,0.9) #run A.5
for(d in dates){
  get_date=d
  print(get_date)
  Run_ecoroms_hindcast(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
}


## scenario B--> isolating the effect of leatherback weightings (5 runs, weightings are the same for both algorithms) (running) ####
weightings <-c(0,0,0,-0.1,0) #run B.1
for(d in dates){
  get_date=d
  print(get_date)
  Run_ecoroms_hindcast(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
}

weightings <-c(0,0,0,-0.3,0) #run B.2
for(d in dates){
  get_date=d
  print(get_date)
  Run_ecoroms_hindcast(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
}

weightings <-c(0,0,0,-0.5,0) #run B.3
for(d in dates){
  get_date=d
  print(get_date)
  Run_ecoroms_hindcast(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
}

weightings <-c(0,0,0,-0.7,0) #run B.4
for(d in dates){
  get_date=d
  print(get_date)
  Run_ecoroms_hindcast(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
}

weightings <-c(0,0,0,-0.9,0) #run B.5
for(d in dates){
  get_date=d
  print(get_date)
  Run_ecoroms_hindcast(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
}
