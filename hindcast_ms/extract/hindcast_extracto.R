## function to batch extract from hindcast runs
source("load_functions.R")
source("hindcast_ms/extract/extract_function.R")

hindcast_extracto=function(points,outdir,ER_weightings,M_weightings,preddir,run,marxandir){
  ##### c. run extracto (ecoroms scaled) ####
  ecoroms_original=list.files(paste0(preddir,"mean"),pattern=".grd",full.names = T) %>% grep(paste0(paste0(ER_weightings,collapse="_"),"_"),.,value=T)%>% grep("original",.,value=T) %>% grep("_unscaled_",.,value=T,invert=T)
  a=extracto_raster(pts=points,algorithm="EcoROMS_original",solution_list = ecoroms_original,weightings = ER_weightings)
  
  ##### c. run extracto (ecoroms unscaled) ####
  ecoroms_original=list.files(paste0(preddir,"mean"),pattern=".grd",full.names = T) %>% grep(paste0(paste0(ER_weightings,collapse="_"),"_"),.,value=T)%>% grep("original",.,value=T) %>% grep("_unscaled_",.,value=T)
  a=extracto_raster(pts=a,algorithm="EcoROMS_original_unscaled",solution_list = ecoroms_original,weightings = ER_weightings)
  
  ##### c. run extracto (marxan scaled) ####
  marxan_raw=list.files(paste0(preddir,marxandir),pattern=".grd",full.names = T) %>% grep(paste0(paste0(M_weightings,collapse="_"),"_"),.,value=T) %>% grep("_unscaled",.,value=T,invert=T)
  a=extracto_raster(pts=a,algorithm="Marxan_raw",solution_list = marxan_raw,weightings = M_weightings)
  
  ##### c. run extracto (marxan unscaled) ####
  marxan_raw=list.files(paste0(preddir,marxandir),pattern=".grd",full.names = T) %>% grep(paste0(paste0(M_weightings,collapse="_"),"_"),.,value=T) %>% grep("_unscaled",.,value=T)
  a=extracto_raster(pts=a,algorithm="Marxan_raw_unscaled",solution_list = marxan_raw,weightings = M_weightings)
  
  ##### c. run extracto (species habitat suitability layers) ####
  swor=list.files("/Users/heatherwelch/Dropbox/Eco-ROMS/Model Prediction Plots/daily_predictions/swor/",pattern=".grd",full.names = T) %>% grep("mean",.,value=T)
  lbst=list.files("/Users/heatherwelch/Dropbox/Eco-ROMS/Model Prediction Plots/daily_predictions/lbst_nolat/",pattern=".grd",full.names = T) %>% grep("mean",.,value=T)
  casl=list.files("/Users/heatherwelch/Dropbox/Eco-ROMS/Model Prediction Plots/daily_predictions/casl_nolat/",pattern=".grd",full.names = T) %>% grep("mean",.,value=T)
  blshobs=list.files("/Users/heatherwelch/Dropbox/Eco-ROMS/Model Prediction Plots/daily_predictions/blshobs/",pattern=".grd",full.names = T) %>% grep("mean",.,value=T)
  blshtrk=list.files("/Users/heatherwelch/Dropbox/Eco-ROMS/Model Prediction Plots/daily_predictions/blshtrk_nolat/",pattern=".grd",full.names = T) %>% grep("mean",.,value=T)
  
  a=extracto_raster(pts=a,algorithm="swor",solution_list = swor,weightings = M_weightings)
  a=extracto_raster(pts=a,algorithm="lbst",solution_list = lbst,weightings = M_weightings)
  a=extracto_raster(pts=a,algorithm="casl",solution_list = casl,weightings = M_weightings)
  a=extracto_raster(pts=a,algorithm="blshobs",solution_list = blshobs,weightings = M_weightings)
  master=extracto_raster(pts=a,algorithm="blshtrk",solution_list = blshtrk,weightings = M_weightings) %>% .[complete.cases(.),]
  
  ################## -------------------- write out
  write.csv(master,paste0(outdir,"run_",run,".csv"))
}

# #demo run
# preddir="~/Dropbox/Eco-ROMS/EcoROMSruns/output/hindcast_ms/"
# outdir="hindcast_ms/extract/extractions/"
# marxandir="marxan_run_A/"
# points=read.csv("hindcast_ms/extract/random_points.csv")
# ER_weightings<-c(-0.1,-0.1,-0.05,-0.5,0.1)
# M_weightings<-c(-0.1,-0.1,-0.05,-0.5,0.1)
# run="test"
# 
# hindcast_extracto(points=points,outdir=outdir,ER_weightings=ER_weightings,M_weightings=M_weightings,preddir=preddir,run=run)



