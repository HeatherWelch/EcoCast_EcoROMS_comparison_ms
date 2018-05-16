####### step 2. run plot_EcoROMS_temporary.R for all days (but first fix this function) ####
source("load_functions.R")
source("/Volumes/SeaGate/EcoROMS/Eco-ROMS-private/EcoROMs/plot_EcoROMS_temporary.R",chdir = T)
library(scales)

namesrisk<-c("Blue shark bycatch","Blue sharks","Sea lions","Leatherbacks","Swordfish")
## weightings: swor
weightings <-c(0,0,0,0,0.1)
weightings <-c(0,0,0,0,0.3)
weightings <-c(0,0,0,0,0.5)
weightings <-c(0,0,0,0,0.7)
weightings <-c(0,0,0,0,0.9)

## weightings: lbst
weightings <-c(0,0,0,-0.1,0)
weightings <-c(0,0,0,-0.3,0)
weightings <-c(0,0,0,-0.5,0)
weightings <-c(0,0,0,-0.7,0)
weightings <-c(0,0,0,-0.9,0)

### scaling weightings
## swor: Marxan range is 0-1, assuming EcoROMS range is 0-3
# M c(.1,.5,.9) ; E
E=rescale(c(.1,.5,.9),c())

###### -------> new run 04.10.18, rerunning with new data and cleaning everything up #####  -----> run ####

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






###### --------> new run 05.01.18, rerunning with comparable weightings to marxan #####
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

# weightings<-c(-0.1,-0.1,-0.05,-0.4,0.1)  # testing leatherback at it's most extreme, swor neutral ## (run 4) ----> run
# for(d in dates){
#   get_date=d
#   print(get_date)
#   Run_ecoroms_hindcast_ratios(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
#   Run_ecoroms_hindcast(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
# }

# weightings<-c(-0.1,-0.1,-0.05,-0.4,0.2)  # testing leatherback even more extreme, swor neutral ## (run 5) ------> run
# for(d in dates){
#   get_date=d
#   print(get_date)
#   #Run_ecoroms_hindcast_ratios(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
#   Run_ecoroms_hindcast(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
# }
# 
# weightings<-c(-0.1,-0.1,-0.05,-0.4,0.4)  # testing leatherback even more extreme, swor neutral ## (run 6) ------> run
# for(d in dates){
#   get_date=d
#   print(get_date)
#   #Run_ecoroms_hindcast_ratios(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
#   Run_ecoroms_hindcast(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
# }



###### -------> new run 05.01.18, rerunning with comparable weightings to marxan, and unscaled ------> run ##### 
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

weightings<-c(-0.1,-0.1,-0.05,-0.4,0.1)  # testing leatherback at it's most extreme, swor neutral ## (run 4) ----> run
for(d in dates){
  get_date=d
  print(get_date)
  Run_ecoroms_hindcast(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
}

weightings<-c(-0.1,-0.1,-0.05,-0.4,0.2)  # testing leatherback even more extreme, swor neutral ## (run 5) ------> run
for(d in dates){
  get_date=d
  print(get_date)
  Run_ecoroms_hindcast(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
}

weightings<-c(-0.1,-0.1,-0.05,-0.4,0.4)  # testing leatherback even more extreme, swor neutral ## (run 6) ------> run
for(d in dates){
  get_date=d
  print(get_date)
  Run_ecoroms_hindcast(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
}


###### -------> new run 05.01.18, extreme EcoROMS ------> running ####
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

weightings<-c(-0.1,-0.1,-0.05,-0.5,0.1)  # testing leatherback at it's most extreme, swor neutral ## (run 7) ----> run
for(d in dates){
  get_date=d
  print(get_date)
  Run_ecoroms_hindcast(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
}

weightings<-c(-0.1,-0.1,-0.05,-0.7,0.1)  # testing leatherback even more extreme, swor neutral ## (run 8) ------> run
for(d in dates){
  get_date=d
  print(get_date)
  Run_ecoroms_hindcast(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
}

weightings<-c(-0.1,-0.1,-0.05,-0.9,0.1)  # testing leatherback even more extreme, swor neutral ## (run 9) ------> run
for(d in dates){
  get_date=d
  print(get_date)
  Run_ecoroms_hindcast(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
}







