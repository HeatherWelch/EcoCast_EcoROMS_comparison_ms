#### code to predict the EcoCast and EcoROMS species models at the locations/times of catch/bycatch events
### 3. predict for each species at each raw data point
### 4. create Eco products under conditions of different species weightings

source("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/load_functions.R")

## A. rasterRescale
Rescale<-function(r){
  r.min = min(r)
  r.max = max(r)
  r.scale <- ((r - r.min) / (r.max - r.min) - 0.5 ) * 2
  return(r.scale) #(r-rmin)/(rmax-rmin)
}

## A2. rasterRescale (-1 to r.max) ## this is for when swordfish = 0, we still rescale the min value to -1 to fit within app.R color range ##test
alt_Rescale=function(r){
  r.min = min(r)
  r.max = max(r)
  r.scale = -1+(0--1)*(r-r.min)/(r.max-r.min)
  return(r.scale)
}

### 3. predict for each species at each raw data point ####
## 1. read in species models
swor=readRDS("/Users/heatherwelch/Dropbox/Eco-ROMS/Model Outputs/Final EcoROMS models/SWOR.res1.tc3.lr03.10models.rds")
blsh_obs=readRDS("/Users/heatherwelch/Dropbox/Eco-ROMS/Model Outputs/Final EcoROMS models/BLSH_obs.res1.tc3.lr03.10models.rds")
blsh_trk=readRDS("/Users/heatherwelch/Dropbox/Eco-ROMS/Model Outputs/Final EcoROMS models/BLSH_trk.res1.tc3.lr05.10models.noLat.rds")
casl=readRDS("/Users/heatherwelch/Dropbox/Eco-ROMS/Model Outputs/Final EcoROMS models/casl.res1.tc4.lr.1.10models.rds")
lbst=readRDS("/Users/heatherwelch/Dropbox/Eco-ROMS/Model Outputs/Final EcoROMS models/LBST.res1.tc3.lr01.10models.rds")

## 1. read in species data
species=read.csv("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/raw_data/observer_casl_swor_blsh_lbst_roms.csv") %>% mutate(SpCd=as.factor(SpCd))

pred_fcn <- function(dataInput,model_object){
  ## Predict on model data using the best tree for predicting
  mod_pred10 <- lapply(model_object,FUN=predict.gbm,newdata=dataInput,n.trees=1000,type='response')
  mod_pred10s <- do.call(cbind,lapply(mod_pred10,data.frame,stringsAsFactors=FALSE))
  colnames(mod_pred10s) <- as.character(seq(1,10,by=1))
  meanPred <- apply(mod_pred10s,1,mean)
  return(meanPred)
}

species$swor=pred_fcn(species,swor)
species$blsh_obs=pred_fcn(species,blsh_obs)
species$blsh_trk=pred_fcn(species,blsh_trk)
species$casl=pred_fcn(species,casl)
species$lbst=pred_fcn(species,lbst)


### 4. create Eco products under conditions of different species weightings ####
weightings<-c(-0.1,-0.1,-0.05,-0.9,0.9)
namesrisk<-c("Blue shark bycatch","Blue sharks","Sea lions","Leatherbacks","Swordfish")

eco_product=function(weightings,dataInput){
  colnam=paste0("eco_",paste0(weightings,collapse="_"))
  dataInput=mutate(dataInput,test=blsh_obs*risk[1]+blsh_trk*risk[2]+casl*risk[3]+lbst*risk[4]+swor*risk[5])
  if(weightings[5]==0){dataInput$test=alt_Rescale(dataInput$test)}
  else(dataInput$test=Rescale(dataInput$test))
  names(dataInput)[names(dataInput)=="test"]<-colnam
  return(dataInput)
}
weightings<-c(-0.1,-0.1,-0.05,-0.9,0.9)
species=eco_product(weightings = weightings,dataInput = species)

weightings<-c(-0.1,-0.1,-0.05,-0.9,0)
species=eco_product(weightings = weightings,dataInput = species)
