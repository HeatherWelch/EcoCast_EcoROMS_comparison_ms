####### step 2. run plot_EcoROMS_temporary.R for all days (but first fix this function) ####
source("load_functions.R")
source("/Volumes/SeaGate/EcoROMS/Eco-ROMS-private/EcoROMs/plot_EcoROMS_temporary.R",chdir = T)

moddir="~/Dropbox/Eco-ROMS/Model Outputs/Final EcoROMS models"
outdir="~/Dropbox/Eco-ROMS/EcoROMSruns"
EcoROMSdir=paste0(outdir,"/output/")
envdir="~/Dropbox/Eco-ROMS/ROMS & Bathym Data/daily_prediction_layers/"
dailypreddir="~/Dropbox/Eco-ROMS/Model Prediction Plots/daily_predictions/"
staticdir="~/Dropbox/Eco-ROMS/ROMS & Bathym Data/Bathymetry ETOPO1/"
namesrisk<-c("Blue shark bycatch","Blue sharks","Sea lions","Leatherbacks","Swordfish")

weightings<-c(-0.1,-0.1,-0.05,-0.9,4)  # testing the effect of swor weighting
dates=seq(as.Date("2005-08-01",format="%Y-%m-%d"),as.Date("2005-08-20",format="%Y-%m-%d"),by="day") %>% as.character()
for(d in dates){
  get_date=d
  Run_ecoroms_hindcast(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings = weightings,studyarea=studyarea,staticdir=staticdir)
}

weightings<-c(-0.1,-0.1,-0.05,-0.9,3)  # testing the effect of swor weighting
dates=seq(as.Date("2005-08-01",format="%Y-%m-%d"),as.Date("2005-08-20",format="%Y-%m-%d"),by="day") %>% as.character()
for(d in dates){
  get_date=d
  Run_ecoroms_hindcast(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
}

weightings<-c(-0.1,-0.1,-0.05,-0.9,2)  # testing the effect of swor weighting
dates=seq(as.Date("2005-08-01",format="%Y-%m-%d"),as.Date("2005-08-20",format="%Y-%m-%d"),by="day") %>% as.character()
for(d in dates){
get_date=d
Run_ecoroms_hindcast(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
}

weightings<-c(-0.1,-0.1,-0.05,-0.9,0.9)  # testing the effect of swor weighting
dates=seq(as.Date("2005-08-01",format="%Y-%m-%d"),as.Date("2005-08-20",format="%Y-%m-%d"),by="day") %>% as.character()
for(d in dates){
  get_date=d
  Run_ecoroms_hindcast(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
}

weightings<-c(-0.1,-0.1,-0.05,-0.9,.5)  # testing the effect of swor weighting
dates=seq(as.Date("2005-08-01",format="%Y-%m-%d"),as.Date("2005-08-20",format="%Y-%m-%d"),by="day") %>% as.character()
for(d in dates){
  get_date=d
  Run_ecoroms_hindcast(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
}

weightings<-c(-0.1,-0.1,-0.05,-0.9,0)  # testing the effect of swor weighting  ##### doesn't work with this current function
dates=seq(as.Date("2005-08-01",format="%Y-%m-%d"),as.Date("2005-08-20",format="%Y-%m-%d"),by="day") %>% as.character()
for(d in dates){
  get_date=d
  Run_ecoroms_hindcast(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
}

weightings<-c(-1,-1,-1,-1,1)  # test raw weightings w sign-age
dates=seq(as.Date("2005-08-01",format="%Y-%m-%d"),as.Date("2005-08-20",format="%Y-%m-%d"),by="day") %>% as.character()
for(d in dates){
  get_date=d
  Run_ecoroms_hindcast(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
}
