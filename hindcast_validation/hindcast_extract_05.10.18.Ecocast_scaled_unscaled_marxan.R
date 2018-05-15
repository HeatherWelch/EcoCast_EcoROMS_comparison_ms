#### this extraction will be run on new data: months in 1997, 2003, 2005 and all dates that had lbst bycatch events
## this is an extraction of all runs on scaled and unscaled EcoCast and marxan, all run at extreme weightingss (>.5)
## written by HW 2018-04-10

path = "/Volumes/EcoCast_SeaGate/ERD_DOM/EcoCast_CodeArchive"
staticdir=paste0(path,"/static_variables/")
studyarea=readOGR(dsn=staticdir,layer="sa_square_coast3")

source("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/hindcast_validation/extract_function.R")

################## -------------------------------------------------> random data second

regular=spsample(studyarea,n=1700,type="regular")  ### wow dat was easy
datess=sample(seq(as.Date('2005/08/01'), as.Date('2005/11/30'), by="day"), 1000,replace = T)
datess2=sample(seq(as.Date('1997/10/01'), as.Date('1997/11/30'), by="day"), 500,replace = T)
datess3=sample(seq(as.Date('2003/04/01'), as.Date('2003/04/30'), by="day"), 200,replace = T)
datess=c(datess,datess2,datess3)
species=regular@coords %>% as.tibble() %>% dplyr::select(lon=x1,lat=x2) %>% add_column(dt=datess[1:1697])

################## -------------------- run 7
#### run extractions and save
ER_weightings<-c(-0.1,-0.1,-0.05,-0.5,0.1)
M_weightings<-c(-0.1,-0.1,-0.05,-0.5,0.1)

##### c. run extracto (ecoroms scaled) ####
ecoroms_original=list.files("~/Dropbox/Eco-ROMS/EcoROMSruns/output/hindcast/mean",pattern=".grd",full.names = T) %>% grep(paste0(ER_weightings,collapse="_"),.,value=T)%>% grep("original",.,value=T) %>% grep("_unscaled_",.,value=T,invert=T)
a=extracto_raster(pts=species,algorithm="EcoROMS_original",solution_list = ecoroms_original,weightings = ER_weightings)

##### c. run extracto (ecoroms unscaled) ####
ecoroms_original=list.files("~/Dropbox/Eco-ROMS/EcoROMSruns/output/hindcast/mean",pattern=".grd",full.names = T) %>% grep(paste0(ER_weightings,collapse="_"),.,value=T)%>% grep("original",.,value=T) %>% grep("_unscaled_",.,value=T)
a=extracto_raster(pts=a,algorithm="EcoROMS_original_unscaled",solution_list = ecoroms_original,weightings = ER_weightings)

##### c. run extracto (marxan scaled) ####
marxan_raw=list.files("~/Dropbox/Eco-ROMS/EcoROMSruns/output/hindcast/marxan",pattern=".grd",full.names = T) %>% grep(paste0(M_weightings,collapse="_"),.,value=T) %>% grep("_unscaled",.,value=T,invert=T)
a=extracto_raster(pts=a,algorithm="Marxan_raw",solution_list = marxan_raw,weightings = M_weightings)

##### c. run extracto (marxan unscaled) ####
marxan_raw=list.files("~/Dropbox/Eco-ROMS/EcoROMSruns/output/hindcast/marxan",pattern=".grd",full.names = T) %>% grep(paste0(M_weightings,collapse="_"),.,value=T) %>% grep("_unscaled",.,value=T)
a=extracto_raster(pts=a,algorithm="Marxan_raw_unscaled",solution_list = marxan_raw,weightings = M_weightings)

##### c. run extracto (species habitat suitability layers) ####
swor=list.files("/Users/heatherwelch/Dropbox/Eco-ROMS/Model Prediction Plots/daily_predictions/swor/",pattern=".grd",full.names = T) %>% grep("mean",.,value=T)#%>% grep("_2005-",.,value=T)
lbst=list.files("/Users/heatherwelch/Dropbox/Eco-ROMS/Model Prediction Plots/daily_predictions/lbst_nolat/",pattern=".grd",full.names = T) %>% grep("mean",.,value=T)#%>% grep("_2005-",.,value=T)
casl=list.files("/Users/heatherwelch/Dropbox/Eco-ROMS/Model Prediction Plots/daily_predictions/casl_nolat/",pattern=".grd",full.names = T) %>% grep("mean",.,value=T)#%>% grep("_2005-",.,value=T)
blshobs=list.files("/Users/heatherwelch/Dropbox/Eco-ROMS/Model Prediction Plots/daily_predictions/blshobs/",pattern=".grd",full.names = T) %>% grep("mean",.,value=T)#%>% grep("_2005-",.,value=T)
blshtrk=list.files("/Users/heatherwelch/Dropbox/Eco-ROMS/Model Prediction Plots/daily_predictions/blshtrk_nolat/",pattern=".grd",full.names = T) %>% grep("mean",.,value=T)#%>% grep("_2005-",.,value=T)

a=extracto_raster(pts=a,algorithm="swor",solution_list = swor,weightings = M_weightings)
a=extracto_raster(pts=a,algorithm="lbst",solution_list = lbst,weightings = M_weightings)
a=extracto_raster(pts=a,algorithm="casl",solution_list = casl,weightings = M_weightings)
a=extracto_raster(pts=a,algorithm="blshobs",solution_list = blshobs,weightings = M_weightings)
master=extracto_raster(pts=a,algorithm="blshtrk",solution_list = blshtrk,weightings = M_weightings) %>% .[complete.cases(.),]

################## -------------------- write out
write.csv(master,"/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/raw_data/species_predict_05.10.18_random_scaled_unscaled_run7.csv")

################## -------------------- run 8
#### run extractions and save
ER_weightings<-c(-0.1,-0.1,-0.05,-0.7,0.1)
M_weightings<-c(-0.1,-0.1,-0.05,-0.7,0.1)

##### c. run extracto (ecoroms scaled) ####
ecoroms_original=list.files("~/Dropbox/Eco-ROMS/EcoROMSruns/output/hindcast/mean",pattern=".grd",full.names = T) %>% grep(paste0(ER_weightings,collapse="_"),.,value=T)%>% grep("original",.,value=T) %>% grep("_unscaled_",.,value=T,invert=T)
a=extracto_raster(pts=species,algorithm="EcoROMS_original",solution_list = ecoroms_original,weightings = ER_weightings)

##### c. run extracto (ecoroms unscaled) ####
ecoroms_original=list.files("~/Dropbox/Eco-ROMS/EcoROMSruns/output/hindcast/mean",pattern=".grd",full.names = T) %>% grep(paste0(ER_weightings,collapse="_"),.,value=T)%>% grep("original",.,value=T) %>% grep("_unscaled_",.,value=T)
a=extracto_raster(pts=a,algorithm="EcoROMS_original_unscaled",solution_list = ecoroms_original,weightings = ER_weightings)

##### c. run extracto (marxan scaled) ####
marxan_raw=list.files("~/Dropbox/Eco-ROMS/EcoROMSruns/output/hindcast/marxan",pattern=".grd",full.names = T) %>% grep(paste0(M_weightings,collapse="_"),.,value=T) %>% grep("_unscaled",.,value=T,invert=T)
a=extracto_raster(pts=a,algorithm="Marxan_raw",solution_list = marxan_raw,weightings = M_weightings)

##### c. run extracto (marxan unscaled) ####
marxan_raw=list.files("~/Dropbox/Eco-ROMS/EcoROMSruns/output/hindcast/marxan",pattern=".grd",full.names = T) %>% grep(paste0(M_weightings,collapse="_"),.,value=T) %>% grep("_unscaled",.,value=T)
a=extracto_raster(pts=a,algorithm="Marxan_raw_unscaled",solution_list = marxan_raw,weightings = M_weightings)

##### c. run extracto (species habitat suitability layers) ####
swor=list.files("/Users/heatherwelch/Dropbox/Eco-ROMS/Model Prediction Plots/daily_predictions/swor/",pattern=".grd",full.names = T) %>% grep("mean",.,value=T)#%>% grep("_2005-",.,value=T)
lbst=list.files("/Users/heatherwelch/Dropbox/Eco-ROMS/Model Prediction Plots/daily_predictions/lbst_nolat/",pattern=".grd",full.names = T) %>% grep("mean",.,value=T)#%>% grep("_2005-",.,value=T)
casl=list.files("/Users/heatherwelch/Dropbox/Eco-ROMS/Model Prediction Plots/daily_predictions/casl_nolat/",pattern=".grd",full.names = T) %>% grep("mean",.,value=T)#%>% grep("_2005-",.,value=T)
blshobs=list.files("/Users/heatherwelch/Dropbox/Eco-ROMS/Model Prediction Plots/daily_predictions/blshobs/",pattern=".grd",full.names = T) %>% grep("mean",.,value=T)#%>% grep("_2005-",.,value=T)
blshtrk=list.files("/Users/heatherwelch/Dropbox/Eco-ROMS/Model Prediction Plots/daily_predictions/blshtrk_nolat/",pattern=".grd",full.names = T) %>% grep("mean",.,value=T)#%>% grep("_2005-",.,value=T)

a=extracto_raster(pts=a,algorithm="swor",solution_list = swor,weightings = M_weightings)
a=extracto_raster(pts=a,algorithm="lbst",solution_list = lbst,weightings = M_weightings)
a=extracto_raster(pts=a,algorithm="casl",solution_list = casl,weightings = M_weightings)
a=extracto_raster(pts=a,algorithm="blshobs",solution_list = blshobs,weightings = M_weightings)
master=extracto_raster(pts=a,algorithm="blshtrk",solution_list = blshtrk,weightings = M_weightings) %>% .[complete.cases(.),]

################## -------------------- write out
write.csv(master,"/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/raw_data/species_predict_05.10.18_random_scaled_unscaled_run8.csv")

################## -------------------- run 9
#### run extractions and save
ER_weightings<-c(-0.1,-0.1,-0.05,-0.9,0.1)
M_weightings<-c(-0.1,-0.1,-0.05,-0.9,0.1)

##### c. run extracto (ecoroms scaled) ####
ecoroms_original=list.files("~/Dropbox/Eco-ROMS/EcoROMSruns/output/hindcast/mean",pattern=".grd",full.names = T) %>% grep(paste0(ER_weightings,collapse="_"),.,value=T)%>% grep("original",.,value=T) %>% grep("_unscaled_",.,value=T,invert=T)
a=extracto_raster(pts=species,algorithm="EcoROMS_original",solution_list = ecoroms_original,weightings = ER_weightings)

##### c. run extracto (ecoroms unscaled) ####
ecoroms_original=list.files("~/Dropbox/Eco-ROMS/EcoROMSruns/output/hindcast/mean",pattern=".grd",full.names = T) %>% grep(paste0(ER_weightings,collapse="_"),.,value=T)%>% grep("original",.,value=T) %>% grep("_unscaled_",.,value=T)
a=extracto_raster(pts=a,algorithm="EcoROMS_original_unscaled",solution_list = ecoroms_original,weightings = ER_weightings)

##### c. run extracto (marxan scaled) ####
marxan_raw=list.files("~/Dropbox/Eco-ROMS/EcoROMSruns/output/hindcast/marxan",pattern=".grd",full.names = T) %>% grep(paste0(M_weightings,collapse="_"),.,value=T) %>% grep("_unscaled",.,value=T,invert=T)
a=extracto_raster(pts=a,algorithm="Marxan_raw",solution_list = marxan_raw,weightings = M_weightings)

##### c. run extracto (marxan unscaled) ####
marxan_raw=list.files("~/Dropbox/Eco-ROMS/EcoROMSruns/output/hindcast/marxan",pattern=".grd",full.names = T) %>% grep(paste0(M_weightings,collapse="_"),.,value=T) %>% grep("_unscaled",.,value=T)
a=extracto_raster(pts=a,algorithm="Marxan_raw_unscaled",solution_list = marxan_raw,weightings = M_weightings)

##### c. run extracto (species habitat suitability layers) ####
swor=list.files("/Users/heatherwelch/Dropbox/Eco-ROMS/Model Prediction Plots/daily_predictions/swor/",pattern=".grd",full.names = T) %>% grep("mean",.,value=T)#%>% grep("_2005-",.,value=T)
lbst=list.files("/Users/heatherwelch/Dropbox/Eco-ROMS/Model Prediction Plots/daily_predictions/lbst_nolat/",pattern=".grd",full.names = T) %>% grep("mean",.,value=T)#%>% grep("_2005-",.,value=T)
casl=list.files("/Users/heatherwelch/Dropbox/Eco-ROMS/Model Prediction Plots/daily_predictions/casl_nolat/",pattern=".grd",full.names = T) %>% grep("mean",.,value=T)#%>% grep("_2005-",.,value=T)
blshobs=list.files("/Users/heatherwelch/Dropbox/Eco-ROMS/Model Prediction Plots/daily_predictions/blshobs/",pattern=".grd",full.names = T) %>% grep("mean",.,value=T)#%>% grep("_2005-",.,value=T)
blshtrk=list.files("/Users/heatherwelch/Dropbox/Eco-ROMS/Model Prediction Plots/daily_predictions/blshtrk_nolat/",pattern=".grd",full.names = T) %>% grep("mean",.,value=T)#%>% grep("_2005-",.,value=T)

a=extracto_raster(pts=a,algorithm="swor",solution_list = swor,weightings = M_weightings)
a=extracto_raster(pts=a,algorithm="lbst",solution_list = lbst,weightings = M_weightings)
a=extracto_raster(pts=a,algorithm="casl",solution_list = casl,weightings = M_weightings)
a=extracto_raster(pts=a,algorithm="blshobs",solution_list = blshobs,weightings = M_weightings)
master=extracto_raster(pts=a,algorithm="blshtrk",solution_list = blshtrk,weightings = M_weightings) %>% .[complete.cases(.),]

################## -------------------- write out
write.csv(master,"/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/raw_data/species_predict_05.10.18_random_scaled_unscaled_run9.csv")



