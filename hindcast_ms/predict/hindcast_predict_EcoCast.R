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


## scenario B--> isolating the effect of leatherback weightings (5 runs, weightings are the same for both algorithms) (run) ####
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

## scenario C--> testing the ability to manage swordfish and leatherback equally (5 runs, weightings are the same for both algorithms) (running) ####
weightings <-c(0,0,0,-0.1,0.1) #run C.1
for(d in dates){
  get_date=d
  print(get_date)
  Run_ecoroms_hindcast(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
}

weightings <-c(0,0,0,-0.3,0.3) #run C.2
for(d in dates){
  get_date=d
  print(get_date)
  Run_ecoroms_hindcast(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
}

weightings <-c(0,0,0,-0.5,0.5) #run C.3
for(d in dates){
  get_date=d
  print(get_date)
  Run_ecoroms_hindcast(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
}

weightings <-c(0,0,0,-0.7,0.7) #run C.4
for(d in dates){
  get_date=d
  print(get_date)
  Run_ecoroms_hindcast(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
}

weightings <-c(0,0,0,-0.9,0.9) #run C.5
for(d in dates){
  get_date=d
  print(get_date)
  Run_ecoroms_hindcast(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
}


## scenario D--> testing the ability to manage swordfish and leatherback, tailored based on above results (5 runs, weightings are the same for both algorithms) ####
# C.3 was the best for Marxan, the Bs were the best for EcoROMS. Seems like its best when lbst is greater than swor
weightings <-c(0,0,0,-0.5,0.1) #run D.1
for(d in dates){
  get_date=d
  print(get_date)
  Run_ecoroms_hindcast(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
}

weightings <-c(0,0,0,-0.5,0.3) #run D.2
for(d in dates){
  get_date=d
  print(get_date)
  Run_ecoroms_hindcast(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
}

weightings <-c(0,0,0,-0.7,0.1) #run D.3
for(d in dates){
  get_date=d
  print(get_date)
  Run_ecoroms_hindcast(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
}

weightings <-c(0,0,0,-0.7,0.3) #run D.4
for(d in dates){
  get_date=d
  print(get_date)
  Run_ecoroms_hindcast(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
}

weightings <-c(0,0,0,-0.7,0.5) #run D.5
for(d in dates){
  get_date=d
  print(get_date)
  Run_ecoroms_hindcast(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
}
## scenario E--> testing the ability to manage swordfish and leatherback, tailored based on above results, swor > lbst (5 runs, weightings are the same for both algorithms) ####
# in the orginial analysis, this config should make marxan work better
weightings <-c(0,0,0,-0.3,0.7) #run E.1
for(d in dates){
  get_date=d
  print(get_date)
  Run_ecoroms_hindcast(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
}

weightings <-c(0,0,0,-0.3,0.9) #run E.2
for(d in dates){
  get_date=d
  print(get_date)
  Run_ecoroms_hindcast(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
}

weightings <-c(0,0,0,-0.5,0.7) #run E.3
for(d in dates){
  get_date=d
  print(get_date)
  Run_ecoroms_hindcast(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
}

weightings <-c(0,0,0,-0.5,0.9) #run E.4
for(d in dates){
  get_date=d
  print(get_date)
  Run_ecoroms_hindcast(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
}

dates=dates[1]
weightings <-c(0,0,0,-0.7,0.3) #run D.4
a=system.time({
weightings <-c(0,0,0,-0.7,0.9) #run E.5
for(d in dates){
  get_date=d
  print(get_date)
  Run_ecoroms_hindcast(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
}})

## scenario F--> adding in bluesharks. taking the best weightins from A-E and adding some blueshark to see how things change. (run) ####
# in the orginial analysis, this config should make marxan work better
weightings <-c(-0.05,-0.05,0,-0.3,0) #run F.1 (B.2)
for(d in dates){
  get_date=d
  print(get_date)
  Run_ecoroms_hindcast(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
}

weightings <-c(-0.05,-0.05,0,-0.9,0) #run F.2 (B.5)
for(d in dates){
  get_date=d
  print(get_date)
  Run_ecoroms_hindcast(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
}

weightings <-c(-0.05,-0.05,0,-0.5,0.5) #run F.3 (C.3)
for(d in dates){
  get_date=d
  print(get_date)
  Run_ecoroms_hindcast(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
}

weightings <-c(-0.05,-0.05,0,-0.7,0.1) #run F.4 (D.3)
for(d in dates){
  get_date=d
  print(get_date)
  Run_ecoroms_hindcast(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
}

weightings <-c(-0.05,-0.05,0,-0.7,0.3) #run F.5 (D.4)
for(d in dates){
  get_date=d
  print(get_date)
  Run_ecoroms_hindcast(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
}

weightings <-c(-0.05,-0.05,0,-0.3,0.7) #run F.6 (E.1)
for(d in dates){
  get_date=d
  print(get_date)
  Run_ecoroms_hindcast(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
}


## scenario G--> adding in bluesharks, a little bit more. taking the best weightins from A-E and adding some blueshark to see how things change. (run) ####
# in the orginial analysis, this config should make marxan work better
weightings <-c(-0.25,-0.25,0,-0.3,0) #run G.1 (B.2)
for(d in dates){
  get_date=d
  print(get_date)
  Run_ecoroms_hindcast(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
}

weightings <-c(-0.25,-0.25,0,-0.9,0) #run G.2 (B.5)
for(d in dates){
  get_date=d
  print(get_date)
  Run_ecoroms_hindcast(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
}

weightings <-c(-0.25,-0.25,0,-0.5,0.5) #run G.3 (C.3)
for(d in dates){
  get_date=d
  print(get_date)
  Run_ecoroms_hindcast(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
}

weightings <-c(-0.35,-0.35,0,-0.7,0.1) #run G.4 (D.3)
for(d in dates){
  get_date=d
  print(get_date)
  Run_ecoroms_hindcast(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
}

weightings <-c(-0.25,-0.25,0,-0.7,0.3) #run G.5 (D.4)
for(d in dates){
  get_date=d
  print(get_date)
  Run_ecoroms_hindcast(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
}

weightings <-c(-0.25,-0.25,0,-0.3,0.7) #run G.6 (E.1)
for(d in dates){
  get_date=d
  print(get_date)
  Run_ecoroms_hindcast(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
}


## scenario H--> adding in bluesharks, a little bit more x2. taking the best weightins from A-E and adding some blueshark to see how things change. (run) ####
# in the orginial analysis, this config should make marxan work better
weightings <-c(-0.35,-0.35,0,-0.3,0) #run H.1 (B.2)
for(d in dates){
  get_date=d
  print(get_date)
  Run_ecoroms_hindcast(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
}

weightings <-c(-0.35,-0.35,0,-0.9,0) #run H.2 (B.5)
for(d in dates){
  get_date=d
  print(get_date)
  Run_ecoroms_hindcast(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
}

weightings <-c(-0.35,-0.35,0,-0.5,0.5) #run H.3 (C.3)
for(d in dates){
  get_date=d
  print(get_date)
  Run_ecoroms_hindcast(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
}

weightings <-c(-0.35,-0.35,0,-0.7,0.1) #run H.4 (D.3)
for(d in dates){
  get_date=d
  print(get_date)
  Run_ecoroms_hindcast(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
}

weightings <-c(-0.35,-0.35,0,-0.7,0.3) #run H.5 (D.4)
for(d in dates){
  get_date=d
  print(get_date)
  Run_ecoroms_hindcast(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
}

weightings <-c(-0.35,-0.35,0,-0.3,0.7) #run G.6 (E.1)
for(d in dates){
  get_date=d
  print(get_date)
  Run_ecoroms_hindcast(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
}


## scenario I--> adding in bluesharks, and then sealions to check multispecies. taking the best weightins from A-E and adding some blueshark to see how things change. (run) ####
# in the orginial analysis, this config should make marxan work better
weightings <-c(-0.05,-0.05,-0.1,-0.3,0) #run I.1 (B.2)
for(d in dates){
  get_date=d
  print(get_date)
  Run_ecoroms_hindcast(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
}

weightings <-c(-0.05,-0.05,-0.1,-0.9,0) #run I.2 (B.5)
for(d in dates){
  get_date=d
  print(get_date)
  Run_ecoroms_hindcast(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
}

weightings <-c(-0.05,-0.05,-0.1,-0.5,0.5) #run I.3 (C.3)
for(d in dates){
  get_date=d
  print(get_date)
  Run_ecoroms_hindcast(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
}

weightings <-c(-0.05,-0.05,-0.1,-0.7,0.1) #run I.4 (D.3)
for(d in dates){
  get_date=d
  print(get_date)
  Run_ecoroms_hindcast(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
}

weightings <-c(-0.05,-0.05,-0.1,-0.7,0.3) #run I.5 (D.4)
for(d in dates){
  get_date=d
  print(get_date)
  Run_ecoroms_hindcast(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
}

weightings <-c(-0.05,-0.05,-0.1,-0.3,0.7) #run I.6 (E.1)
for(d in dates){
  get_date=d
  print(get_date)
  Run_ecoroms_hindcast(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
}


## scenario J--> adding in bluesharks a little bit more, and then sealions a little bit more to check multispecies. taking the best weightins from A-E and adding some blueshark to see how things change. (run) ####
# in the orginial analysis, this config should make marxan work better
weightings <-c(-0.25,-0.25,-0.5,-0.3,0) #run J.1 (B.2)
for(d in dates){
  get_date=d
  print(get_date)
  Run_ecoroms_hindcast(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
}

weightings <-c(-0.25,-0.25,-0.5,-0.9,0) #run J.2 (B.5)
for(d in dates){
  get_date=d
  print(get_date)
  Run_ecoroms_hindcast(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
}

weightings <-c(-0.25,-0.25,-0.5,-0.5,0.5) #run J.3 (C.3)
for(d in dates){
  get_date=d
  print(get_date)
  Run_ecoroms_hindcast(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
}

weightings <-c(-0.25,-0.25,-0.5,-0.7,0.1) #run J.4 (D.3)
for(d in dates){
  get_date=d
  print(get_date)
  Run_ecoroms_hindcast(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
}

weightings <-c(-0.25,-0.25,-0.5,-0.7,0.3) #run J.5 (D.4)
for(d in dates){
  get_date=d
  print(get_date)
  Run_ecoroms_hindcast(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
}

weightings <-c(-0.25,-0.25,-0.5,-0.3,0.7) #run J.6 (E.1)
for(d in dates){
  get_date=d
  print(get_date)
  Run_ecoroms_hindcast(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
}


## scenario K--> adding in bluesharks a little bit more x2, and then sealions a little bit more to check multispecies. taking the best weightins from A-E and adding some blueshark to see how things change. (run) ####
# in the orginial analysis, this config should make marxan work better
weightings <-c(-0.35,-0.35,-0.7,-0.3,0) #run K.1 (B.2)
for(d in dates){
  get_date=d
  print(get_date)
  Run_ecoroms_hindcast(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
}

weightings <-c(-0.35,-0.35,-0.7,-0.9,0) #run K.2 (B.5)
for(d in dates){
  get_date=d
  print(get_date)
  Run_ecoroms_hindcast(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
}

weightings <-c(-0.35,-0.35,-0.7,-0.5,0.5) #run K.3 (C.3)
for(d in dates){
  get_date=d
  print(get_date)
  Run_ecoroms_hindcast(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
}

weightings <-c(-0.35,-0.35,-0.7,-0.7,0.1) #run K.4 (D.3)
for(d in dates){
  get_date=d
  print(get_date)
  Run_ecoroms_hindcast(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
}

weightings <-c(-0.35,-0.35,-0.7,-0.7,0.3) #run K.5 (D.4)
for(d in dates){
  get_date=d
  print(get_date)
  Run_ecoroms_hindcast(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
}

weightings <-c(-0.35,-0.35,-0.7,-0.3,0.7) #run K.6 (E.1)
for(d in dates){
  get_date=d
  print(get_date)
  Run_ecoroms_hindcast(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
}


## scenario L--> runs to match example mgmt objectives (run) ####
weightings <-c(-0.25,-0.25,-0.05,-0.5,0.5) #run L.1 CASL 10% as important
for(d in dates){
  get_date=d
  print(get_date)
  Run_ecoroms_hindcast(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
}

weightings <-c(-0.025,-0.025,-0.05,-0.5,0.5) #run L.2 BLSH, CASL 10% as important
for(d in dates){
  get_date=d
  print(get_date)
  Run_ecoroms_hindcast(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
}

weightings <-c(-0.15,-0.15,-0.3,-0.3,0.3) #run L.3 RUN, example of caring about all species equally
for(d in dates){
  get_date=d
  print(get_date)
  Run_ecoroms_hindcast(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
}

weightings <-c(-0.15,-0.15,-0.03,-0.3,0.3) #run L.4 CASL 10% as important
for(d in dates){
  get_date=d
  print(get_date)
  Run_ecoroms_hindcast(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
}

weightings <-c(-0.015,-0.015,-0.03,-0.3,0.3) #run L.5 BLSH, CASL 10% as important
for(d in dates){
  get_date=d
  print(get_date)
  Run_ecoroms_hindcast(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
}



## scenario M-->  three extra ecroms runs to meet mike's new add to 1 thing' (run) ####
weightings <-c(0,0,0,0,1) #run M.1
for(d in dates){
  get_date=d
  print(get_date)
  Run_ecoroms_hindcast(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
}

weightings <-c(0,0,0,-1,0) #run M.2
for(d in dates){
  get_date=d
  print(get_date)
  Run_ecoroms_hindcast(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
}

weightings <-c(0,0,0,-1,1) #run M.3
for(d in dates){
  get_date=d
  print(get_date)
  Run_ecoroms_hindcast(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
}

weightings <-c(-0.16,-0.16,0,-0.33,0.33) #run M.4
for(d in dates){
  get_date=d
  print(get_date)
  Run_ecoroms_hindcast(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
}

weightings <-c(-0.125,-0.125,-0.25,-0.25,0.25) #run M.5
for(d in dates){
  get_date=d
  print(get_date)
  Run_ecoroms_hindcast(get_date=get_date,moddir=moddir,dailypreddir = dailypreddir,outdir = outdir,EcoROMSdir = EcoROMSdir,namesrisk=namesrisk,weightings=weightings,studyarea=studyarea,staticdir=staticdir)
}

