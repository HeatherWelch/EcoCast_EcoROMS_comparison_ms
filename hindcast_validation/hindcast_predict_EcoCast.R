####### step 2. run plot_EcoROMS_temporary.R for all days (but first fix this function) ####
source("load_functions.R")
source("/Volumes/SeaGate/EcoROMS/Eco-ROMS-private/EcoROMs/plot_EcoROMS_temporary.R",chdir = T)

#### old stuf pre April 2018 ####

moddir="~/Dropbox/Eco-ROMS/Model Outputs/Final EcoROMS models"
outdir="~/Dropbox/Eco-ROMS/EcoROMSruns"
EcoROMSdir=paste0(outdir,"/output/")
envdir="~/Dropbox/Eco-ROMS/ROMS & Bathym Data/daily_prediction_layers/"
dailypreddir="~/Dropbox/Eco-ROMS/Model Prediction Plots/daily_predictions/"
staticdir="~/Dropbox/Eco-ROMS/ROMS & Bathym Data/Bathymetry ETOPO1/"
namesrisk<-c("Blue shark bycatch","Blue sharks","Sea lions","Leatherbacks","Swordfish")



##### hindcasting 2005 08-11 run
# dates=seq(from=as.Date("2005-08-01",format="%Y-%m-%d"),to=as.Date("2005-11-30",format="%Y-%m-%d"),by="day") %>% as.character()
# 
# weightings<-c(-0.1,-0.1,-0.05,-0.9,0.9)  # testing the effect of swor weighting ## (run 1)
# for(d in dates){
#   get_date=d
#   Run_ecoroms_hindcast(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
# }
# 
# weightings<-c(-0.1,-0.1,-0.05,-1.5,2)  # testing swor at it's most extreme ## (run 2)
# for(d in dates){
#   get_date=d
#   Run_ecoroms_hindcast(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
# }
# 
# weightings<-c(-0.1,-0.1,-0.05,-1.5,.1)  # testing leatherback at it's most extreme, swor neutral ## (run 3)
# for(d in dates){
#   get_date=d
#   Run_ecoroms_hindcast(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
# }



# ##### hindcasting 1997 10-11 run 
# dates=seq(from=as.Date("1997-10-01",format="%Y-%m-%d"),to=as.Date("1997-11-30",format="%Y-%m-%d"),by="day") %>% as.character()
# 
# weightings<-c(-0.1,-0.1,-0.05,-0.9,0.9)  # testing the effect of swor weighting ## (run 1)
# for(d in dates){
#   get_date=d
#   Run_ecoroms_hindcast(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
# }
# 
# weightings<-c(-0.1,-0.1,-0.05,-1.5,2)  # testing swor at it's most extreme ## (run 2)
# for(d in dates){
#   get_date=d
#   Run_ecoroms_hindcast(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
# }
# 
# weightings<-c(-0.1,-0.1,-0.05,-1.5,.1)  # testing leatherback at it's most extreme, swor neutral ## (run 3)
# for(d in dates){
#   get_date=d
#   Run_ecoroms_hindcast(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
# }


# ##### hindcasting 1997 and 2005 run 
# dates=seq(from=as.Date("1997-10-01",format="%Y-%m-%d"),to=as.Date("1997-11-30",format="%Y-%m-%d"),by="day") %>% as.character()
# datess=seq(as.Date("2005-08-01",format="%Y-%m-%d"),as.Date("2005-11-30",format="%Y-%m-%d"),by="day") %>% as.character()
# dates=c(dates,datess)
# 
# weightings<-c(-0.1,-0.1,-0.05,-0.9,0.9)  # testing the effect of swor weighting ## (run 1)
# for(d in dates){
#   get_date=d
#   Run_ecoroms_hindcast_ratios(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
# }
# 
# weightings<-c(-0.1,-0.1,-0.05,-1.5,2)  # testing swor at it's most extreme ## (run 2)
# for(d in dates){
#   get_date=d
#   Run_ecoroms_hindcast_ratios(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
# }
# 
# weightings<-c(-0.1,-0.1,-0.05,-1.5,.1)  # testing leatherback at it's most extreme, swor neutral ## (run 3)
# for(d in dates){
#   get_date=d
#   Run_ecoroms_hindcast_ratios(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
# }

###### -------> new run 04.10.18, rerunning with new data and cleaning everything up #####  -----> running ####

moddir="~/Dropbox/Eco-ROMS/Model Outputs/Final EcoROMS models"
outdir="~/Dropbox/Eco-ROMS/EcoROMSruns"
EcoROMSdir=paste0(outdir,"/output/hindcast/")
envdir="~/Dropbox/Eco-ROMS/ROMS & Bathym Data/daily_prediction_layers/"
dailypreddir="~/Dropbox/Eco-ROMS/Model Prediction Plots/daily_predictions/"
staticdir="~/Dropbox/Eco-ROMS/ROMS & Bathym Data/Bathymetry ETOPO1/"
namesrisk<-c("Blue shark bycatch","Blue sharks","Sea lions","Leatherbacks","Swordfish")

lbst_bycatch=read.csv("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/raw_data/observer_casl_swor_blsh_lbst_roms.csv")%>% mutate(dt=as.Date(dt)) %>% dplyr::filter(SpCd=="DC")  %>% dplyr::select(dt) %>% .[,1]
d1997=seq(as.Date("1997-10-01"),as.Date("1997-11-30"),by=1)
d2005=seq(as.Date("2005-08-01"),as.Date("2005-11-30"),by=1)
d2003=seq(as.Date("2003-04-01"),as.Date("2003-04-30"),by=1)

dates=c(lbst_bycatch,d1997,d2005,d2003) %>% unique() %>% as.character()

# weightings<-c(-0.1,-0.1,-0.05,-1.5,.1)  # testing leatherback at it's most extreme, swor neutral ## (run 3) ----> run
# for(d in dates){
#   get_date=d
#   print(get_date)
#   Run_ecoroms_hindcast_ratios(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
#   Run_ecoroms_hindcast(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
# }

# weightings<-c(-0.1,-0.1,-0.05,-2,.1)  # testing leatherback even more extreme, swor neutral ## (run 4) ------> run
# for(d in dates){
#   get_date=d
#   print(get_date)
#   #Run_ecoroms_hindcast_ratios(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
#   Run_ecoroms_hindcast(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
# }
# 
# weightings<-c(-0.1,-0.1,-0.05,-2.5,.1)  # testing leatherback even more extreme, swor neutral ## (run 4) ------> run
# for(d in dates){
#   get_date=d
#   print(get_date)
#   #Run_ecoroms_hindcast_ratios(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
#   Run_ecoroms_hindcast(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
# }


# weightings<-c(-0.1,-0.1,-0.05,-2.5,1.5)  # testing leatherback even more extreme, swor neutral ## (run 5) ------> run
# for(d in dates){
#   get_date=d
#   print(get_date)
#   #Run_ecoroms_hindcast_ratios(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
#   Run_ecoroms_hindcast(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
# }

weightings<-c(-0.1,-0.1,-0.05,-2.5,2.5)  # testing leatherback even more extreme, swor equally extreme ## (run 6) ------> running
for(d in dates){
  get_date=d
  print(get_date)
  #Run_ecoroms_hindcast_ratios(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
  Run_ecoroms_hindcast(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
}






### really old junk ####

# weightings<-c(-0.1,-0.1,-0.05,-0.9,4)  # testing the effect of swor weighting
# dates=seq(as.Date("2005-08-01",format="%Y-%m-%d"),as.Date("2005-08-20",format="%Y-%m-%d"),by="day") %>% as.character()
# for(d in dates){
#   get_date=d
#   Run_ecoroms_hindcast(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings = weightings,studyarea=studyarea,staticdir=staticdir)
# }
# 
# weightings<-c(-0.1,-0.1,-0.05,-0.9,3)  # testing the effect of swor weighting
# dates=seq(as.Date("2005-08-01",format="%Y-%m-%d"),as.Date("2005-08-20",format="%Y-%m-%d"),by="day") %>% as.character()
# for(d in dates){
#   get_date=d
#   Run_ecoroms_hindcast(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
# }
# 
# weightings<-c(-0.1,-0.1,-0.05,-0.9,2)  # testing the effect of swor weighting
# dates=seq(as.Date("2005-08-01",format="%Y-%m-%d"),as.Date("2005-08-20",format="%Y-%m-%d"),by="day") %>% as.character()
# for(d in dates){
# get_date=d
# Run_ecoroms_hindcast(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
# }
# 
# weightings<-c(-0.1,-0.1,-0.05,-0.9,.5)  # testing the effect of swor weighting
# dates=seq(as.Date("2005-08-01",format="%Y-%m-%d"),as.Date("2005-08-20",format="%Y-%m-%d"),by="day") %>% as.character()
# for(d in dates){
#   get_date=d
#   Run_ecoroms_hindcast(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
# }
# 
# weightings<-c(-0.1,-0.1,-0.05,-0.9,0)  # testing the effect of swor weighting  ##### doesn't work with this current function
# dates=seq(as.Date("2005-08-01",format="%Y-%m-%d"),as.Date("2005-08-20",format="%Y-%m-%d"),by="day") %>% as.character()
# for(d in dates){
#   get_date=d
#   Run_ecoroms_hindcast(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
# }
# 
# weightings<-c(-1,-1,-1,-1,1)  # test raw weightings w sign-age
# dates=seq(as.Date("2005-08-01",format="%Y-%m-%d"),as.Date("2005-08-20",format="%Y-%m-%d"),by="day") %>% as.character()
# for(d in dates){
#   get_date=d
#   Run_ecoroms_hindcast(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
# }
