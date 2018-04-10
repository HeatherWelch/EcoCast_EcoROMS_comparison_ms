#### on 1997 10 - 11 hindcast, and 2005 08-11 hindcast, AND trying out a random sample of species habitat suitability layers
## written by HW 2018-03-13

################## -------------------------------------------------> real data first
### prep species data
path = "/Volumes/EcoCast_SeaGate/ERD_DOM/EcoCast_CodeArchive"
staticdir=paste0(path,"/static_variables/")
studyarea=readOGR(dsn=staticdir,layer="sa_square_coast3")

sp_1997=read.csv("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/raw_data/observer_casl_swor_blsh_lbst_roms_1997_10_11.csv")%>% dplyr::select(c("SpCd","dt","lat","lon"))
sp_2005=read.csv("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/raw_data/observer_casl_swor_blsh_lbst_roms_2005_08_10.csv")%>% dplyr::select(c("SpCd","dt","lat","lon"))
species=rbind(sp_1997,sp_2005)

species$sp_name=NA
species[species$SpCd=="UO","sp_name"]="CASL"
species[species$SpCd=="DC","sp_name"]="lbst"
species[species$SpCd=="91","sp_name"]="SWOR"
species[species$SpCd=="167","sp_name"]="BLSH"

species=species%>% dplyr::select(-SpCd)

tracking=read.csv("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/raw_data/trk_casl_blsh_lbst_roms_2005_08_10.csv") %>% dplyr::select(c("sp_name","dt","lat","lon"))

species=rbind(species,tracking)

### write new extraction function ####
source("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/hindcast_validation/extract_function.R")

#### run extractions and save
#### -------------------------------------------------- > ## (run 1) ####
##### c. run extracto (ecoroms) ####
ER_weightings<-c(-0.1,-0.1,-0.05,-0.9,0.9)
ecoroms=list.files("~/Dropbox/Eco-ROMS/EcoROMSruns/output/mean",pattern=".grd",full.names = T) %>% grep(paste0(ER_weightings,collapse="_"),.,value=T) #%>% grep("_2005-",.,value=T)
a=extracto_raster(pts=species,algorithm="EcoROMS",solution_list = ecoroms,weightings = ER_weightings)

##### c. run extracto (marxan) ####
M_weightings<-c(-0.1,-0.1,-0.05,-0.2,0.1)
marxan_raw=list.files("~/Dropbox/Eco-ROMS/EcoROMSruns/output/marxan",pattern=".grd",full.names = T) %>% grep(paste0(M_weightings,collapse="_"),.,value=T) %>% grep("_raw",.,value=T)
marxan_mosaic=list.files("~/Dropbox/Eco-ROMS/EcoROMSruns/output/marxan",pattern=".grd",full.names = T) %>% grep(paste0(M_weightings,collapse="_"),.,value=T) %>% grep("_mosaic.grd$",.,value=T)
marxan_mosaic01=list.files("~/Dropbox/Eco-ROMS/EcoROMSruns/output/marxan",pattern=".grd",full.names = T) %>% grep(paste0(M_weightings,collapse="_"),.,value=T) %>% grep("_mosaic01.grd$",.,value=T)

a=extracto_raster(pts=a,algorithm="Marxan_raw",solution_list = marxan_raw,weightings = M_weightings)
a=extracto_raster(pts=a,algorithm="Marxan_mosaic",solution_list = marxan_mosaic,weightings = M_weightings)
a=extracto_raster(pts=a,algorithm="Marxan_mosaic01",solution_list = marxan_mosaic01,weightings = M_weightings) #%>% dplyr::select(-SpCd)

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

write.csv(master,"/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/raw_data/species_predict_1997_2005_run1.csv")

#### -------------------------------------------------- > ## (run 2) ####
##### c. run extracto (ecoroms) ####
ER_weightings<-c(-0.1,-0.1,-0.05,-1.5,2)
M_weightings<-c(-0.1,-0.1,-0.05,-0.3,0.6)
ecoroms=list.files("~/Dropbox/Eco-ROMS/EcoROMSruns/output/mean",pattern=".grd",full.names = T) %>% grep(paste0(ER_weightings,collapse="_"),.,value=T) #%>% grep("_2005-",.,value=T)
a=extracto_raster(pts=species,algorithm="EcoROMS",solution_list = ecoroms,weightings = ER_weightings)

##### c. run extracto (marxan) ####
marxan_raw=list.files("~/Dropbox/Eco-ROMS/EcoROMSruns/output/marxan",pattern=".grd",full.names = T) %>% grep(paste0(M_weightings,collapse="_"),.,value=T) %>% grep("_raw",.,value=T)
marxan_mosaic=list.files("~/Dropbox/Eco-ROMS/EcoROMSruns/output/marxan",pattern=".grd",full.names = T) %>% grep(paste0(M_weightings,collapse="_"),.,value=T) %>% grep("_mosaic.grd$",.,value=T)
marxan_mosaic01=list.files("~/Dropbox/Eco-ROMS/EcoROMSruns/output/marxan",pattern=".grd",full.names = T) %>% grep(paste0(M_weightings,collapse="_"),.,value=T) %>% grep("_mosaic01.grd$",.,value=T)

a=extracto_raster(pts=a,algorithm="Marxan_raw",solution_list = marxan_raw,weightings = M_weightings)
a=extracto_raster(pts=a,algorithm="Marxan_mosaic",solution_list = marxan_mosaic,weightings = M_weightings)
a=extracto_raster(pts=a,algorithm="Marxan_mosaic01",solution_list = marxan_mosaic01,weightings = M_weightings) #%>% dplyr::select(-SpCd)

##### c. run extracto (species habitat suitability layers) ####
swor=list.files("/Users/heatherwelch/Dropbox/Eco-ROMS/Model Prediction Plots/daily_predictions/swor/",pattern=".grd",full.names = T) %>% grep("mean",.,value=T)#%>% grep("_2005-",.,value=T)
lbst=list.files("/Users/heatherwelch/Dropbox/Eco-ROMS/Model Prediction Plots/daily_predictions/lbst_nolat/",pattern=".grd",full.names = T) %>% grep("mean",.,value=T)#%>% grep("_2005-",.,value=T)
casl=list.files("/Users/heatherwelch/Dropbox/Eco-ROMS/Model Prediction Plots/daily_predictions/casl_nolat/",pattern=".grd",full.names = T) %>% grep("mean",.,value=T)#%>% grep("_2005-",.,value=T)
blshobs=list.files("/Users/heatherwelch/Dropbox/Eco-ROMS/Model Prediction Plots/daily_predictions/blshobs/",pattern=".grd",full.names = T) %>% grep("mean",.,value=T)%>% grep("_2005-",.,value=T)
blshtrk=list.files("/Users/heatherwelch/Dropbox/Eco-ROMS/Model Prediction Plots/daily_predictions/blshtrk_nolat/",pattern=".grd",full.names = T) %>% grep("mean",.,value=T)#%>% grep("_2005-",.,value=T)

a=extracto_raster(pts=a,algorithm="swor",solution_list = swor,weightings = M_weightings)
a=extracto_raster(pts=a,algorithm="lbst",solution_list = lbst,weightings = M_weightings)
a=extracto_raster(pts=a,algorithm="casl",solution_list = casl,weightings = M_weightings)
a=extracto_raster(pts=a,algorithm="blshobs",solution_list = blshobs,weightings = M_weightings)
master=extracto_raster(pts=a,algorithm="blshtrk",solution_list = blshtrk,weightings = M_weightings) %>% .[complete.cases(.),]

write.csv(master,"/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/raw_data/species_predict_1997_2005_run2.csv")

#### -------------------------------------------------- > ## (run 3) ####
##### c. run extracto (ecoroms) ####
ER_weightings<-c(-0.1,-0.1,-0.05,-1.5,.1)
M_weightings<-c(-0.1,-0.1,-0.05,-0.3,0.1)
ecoroms=list.files("~/Dropbox/Eco-ROMS/EcoROMSruns/output/mean",pattern=".grd",full.names = T) %>% grep(paste0(ER_weightings,collapse="_"),.,value=T) #%>% grep("_2005-",.,value=T)
a=extracto_raster(pts=species,algorithm="EcoROMS",solution_list = ecoroms,weightings = ER_weightings)

##### c. run extracto (marxan) ####
marxan_raw=list.files("~/Dropbox/Eco-ROMS/EcoROMSruns/output/marxan",pattern=".grd",full.names = T) %>% grep(paste0(M_weightings,collapse="_"),.,value=T) %>% grep("_raw",.,value=T)
marxan_mosaic=list.files("~/Dropbox/Eco-ROMS/EcoROMSruns/output/marxan",pattern=".grd",full.names = T) %>% grep(paste0(M_weightings,collapse="_"),.,value=T) %>% grep("_mosaic.grd$",.,value=T)
marxan_mosaic01=list.files("~/Dropbox/Eco-ROMS/EcoROMSruns/output/marxan",pattern=".grd",full.names = T) %>% grep(paste0(M_weightings,collapse="_"),.,value=T) %>% grep("_mosaic01.grd$",.,value=T)

a=extracto_raster(pts=a,algorithm="Marxan_raw",solution_list = marxan_raw,weightings = M_weightings)
a=extracto_raster(pts=a,algorithm="Marxan_mosaic",solution_list = marxan_mosaic,weightings = M_weightings)
a=extracto_raster(pts=a,algorithm="Marxan_mosaic01",solution_list = marxan_mosaic01,weightings = M_weightings) #%>% dplyr::select(-SpCd)

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

write.csv(master,"/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/raw_data/species_predict_1997_2005_run3.csv")



################## -------------------------------------------------> random data second

regular=spsample(studyarea,n=1500,type="regular")  ### wow dat was easy
datess=sample(seq(as.Date('2005/08/01'), as.Date('2005/11/30'), by="day"), 1000,replace = T)
datess2=sample(seq(as.Date('1997/10/01'), as.Date('1997/11/30'), by="day"), 500,replace = T)
datess=c(datess,datess2)
species=regular@coords %>% as.tibble() %>% dplyr::select(lon=x1,lat=x2) %>% add_column(dt=datess[1:1464])

### write new extraction function ####
source("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/hindcast_validation/extract_function.R")

#### run extractions and save
#### -------------------------------------------------- > ## (run 1) ####
##### c. run extracto (ecoroms) ####
ER_weightings<-c(-0.1,-0.1,-0.05,-0.9,0.9)
ecoroms=list.files("~/Dropbox/Eco-ROMS/EcoROMSruns/output/mean",pattern=".grd",full.names = T) %>% grep(paste0(ER_weightings,collapse="_"),.,value=T) #%>% grep("_2005-",.,value=T)
a=extracto_raster(pts=species,algorithm="EcoROMS",solution_list = ecoroms,weightings = ER_weightings)

##### c. run extracto (marxan) ####
M_weightings<-c(-0.1,-0.1,-0.05,-0.2,0.1)
marxan_raw=list.files("~/Dropbox/Eco-ROMS/EcoROMSruns/output/marxan",pattern=".grd",full.names = T) %>% grep(paste0(M_weightings,collapse="_"),.,value=T) %>% grep("_raw",.,value=T)
marxan_mosaic=list.files("~/Dropbox/Eco-ROMS/EcoROMSruns/output/marxan",pattern=".grd",full.names = T) %>% grep(paste0(M_weightings,collapse="_"),.,value=T) %>% grep("_mosaic.grd$",.,value=T)
marxan_mosaic01=list.files("~/Dropbox/Eco-ROMS/EcoROMSruns/output/marxan",pattern=".grd",full.names = T) %>% grep(paste0(M_weightings,collapse="_"),.,value=T) %>% grep("_mosaic01.grd$",.,value=T)

a=extracto_raster(pts=a,algorithm="Marxan_raw",solution_list = marxan_raw,weightings = M_weightings)
a=extracto_raster(pts=a,algorithm="Marxan_mosaic",solution_list = marxan_mosaic,weightings = M_weightings)
a=extracto_raster(pts=a,algorithm="Marxan_mosaic01",solution_list = marxan_mosaic01,weightings = M_weightings) #%>% dplyr::select(-SpCd)

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

write.csv(master,"/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/raw_data/species_predict_1997_2005_random_run1.csv")

#### -------------------------------------------------- > ## (run 2) ####
##### c. run extracto (ecoroms) ####
ER_weightings<-c(-0.1,-0.1,-0.05,-1.5,2)
M_weightings<-c(-0.1,-0.1,-0.05,-0.3,0.6)
ecoroms=list.files("~/Dropbox/Eco-ROMS/EcoROMSruns/output/mean",pattern=".grd",full.names = T) %>% grep(paste0(ER_weightings,collapse="_"),.,value=T)# %>% grep("_2005-",.,value=T)
a=extracto_raster(pts=species,algorithm="EcoROMS",solution_list = ecoroms,weightings = ER_weightings)

##### c. run extracto (marxan) ####
marxan_raw=list.files("~/Dropbox/Eco-ROMS/EcoROMSruns/output/marxan",pattern=".grd",full.names = T) %>% grep(paste0(M_weightings,collapse="_"),.,value=T) %>% grep("_raw",.,value=T)
marxan_mosaic=list.files("~/Dropbox/Eco-ROMS/EcoROMSruns/output/marxan",pattern=".grd",full.names = T) %>% grep(paste0(M_weightings,collapse="_"),.,value=T) %>% grep("_mosaic.grd$",.,value=T)
marxan_mosaic01=list.files("~/Dropbox/Eco-ROMS/EcoROMSruns/output/marxan",pattern=".grd",full.names = T) %>% grep(paste0(M_weightings,collapse="_"),.,value=T) %>% grep("_mosaic01.grd$",.,value=T)

a=extracto_raster(pts=a,algorithm="Marxan_raw",solution_list = marxan_raw,weightings = M_weightings)
a=extracto_raster(pts=a,algorithm="Marxan_mosaic",solution_list = marxan_mosaic,weightings = M_weightings)
a=extracto_raster(pts=a,algorithm="Marxan_mosaic01",solution_list = marxan_mosaic01,weightings = M_weightings) #%>% dplyr::select(-SpCd)

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

write.csv(master,"/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/raw_data/species_predict_1997_2005_random_run2.csv")

#### -------------------------------------------------- > ## (run 3) ####
##### c. run extracto (ecoroms) ####
ER_weightings<-c(-0.1,-0.1,-0.05,-1.5,.1)
M_weightings<-c(-0.1,-0.1,-0.05,-0.3,0.1)
ecoroms=list.files("~/Dropbox/Eco-ROMS/EcoROMSruns/output/mean",pattern=".grd",full.names = T) %>% grep(paste0(ER_weightings,collapse="_"),.,value=T)# %>% grep("_2005-",.,value=T)
a=extracto_raster(pts=species,algorithm="EcoROMS",solution_list = ecoroms,weightings = ER_weightings)

##### c. run extracto (marxan) ####
marxan_raw=list.files("~/Dropbox/Eco-ROMS/EcoROMSruns/output/marxan",pattern=".grd",full.names = T) %>% grep(paste0(M_weightings,collapse="_"),.,value=T) %>% grep("_raw",.,value=T)
marxan_mosaic=list.files("~/Dropbox/Eco-ROMS/EcoROMSruns/output/marxan",pattern=".grd",full.names = T) %>% grep(paste0(M_weightings,collapse="_"),.,value=T) %>% grep("_mosaic.grd$",.,value=T)
marxan_mosaic01=list.files("~/Dropbox/Eco-ROMS/EcoROMSruns/output/marxan",pattern=".grd",full.names = T) %>% grep(paste0(M_weightings,collapse="_"),.,value=T) %>% grep("_mosaic01.grd$",.,value=T)

a=extracto_raster(pts=a,algorithm="Marxan_raw",solution_list = marxan_raw,weightings = M_weightings)
a=extracto_raster(pts=a,algorithm="Marxan_mosaic",solution_list = marxan_mosaic,weightings = M_weightings)
a=extracto_raster(pts=a,algorithm="Marxan_mosaic01",solution_list = marxan_mosaic01,weightings = M_weightings) #%>% dplyr::select(-SpCd)

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

write.csv(master,"/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/raw_data/species_predict_1997_2005_random_run3.csv")



