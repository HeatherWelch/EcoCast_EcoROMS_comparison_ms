#### script to hindcast ecoROMS and ecoMarxan for 2005 08-11 (dates found to have data for all species in Sp_data_prep.R)
### will hindcast full surfaces
### its gonna be fucking sick
### written by HW 02.21.18

# step 1. run Predict_ROMS_mean_se_CIs.R for all days (species hab suitability)
# step 2. run plot_EcoROMS_temporary.R for all days (but first fix this function) (different script)
# step 3. run marxan_clean_02.21.18.R for all days (different script)
# step 4. extract all values at all points for hindcast analysis
# precurser to steps 2&3, decide on species weightins


####### step 1. run Predict_ROMS_mean_se_CIs.R for all days (species hab suitability) ####
source("/Volumes/SeaGate/EcoROMS/Eco-ROMS-private/EcoROMs/Predict_ROMS_mean_se_CIs.R")
source("/Volumes/SeaGate/EcoROMS/Eco-ROMS-private/EcoROMs/create_ROMS_daily_stack.R")
source("/Volumes/SeaGate/EcoROMS/Eco-ROMS-private/EcoROMs/save_png.R")
source("/Volumes/SeaGate/EcoROMS/Eco-ROMS-private/Extracto_Scripts/load_functions.R")
source("/Volumes/SeaGate/EcoROMS/Eco-ROMS-private/EcoROMs/create_ROMS_raster.R")
#dates=seq(as.Date("2005-08-01",format="%Y-%m-%d"),as.Date("2005-11-30",format="%Y-%m-%d"),by="day") ##### hindcasting 2005 08-11 run #run
#dates=seq(as.Date("2005-08-20",format="%Y-%m-%d"),as.Date("2005-11-30",format="%Y-%m-%d"),by="day") ## only here cuz im fixing blueshark obs #run
#dates=seq(from=as.Date("1997-10-01",format="%Y-%m-%d"),to=as.Date("1997-11-30",format="%Y-%m-%d"),by="day")  ##### hindcasting 1997 10-11 run #run
dates1=seq(as.Date("2003-04-01"),as.Date("2003-04-30"),by=1) ## new for extra lbst data
dates2=read.csv("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/raw_data/observer_casl_swor_blsh_lbst_roms.csv")%>% mutate(dt=as.Date(dt)) %>% dplyr::filter(SpCd=="DC")  %>% dplyr::select(dt) %>% .[,1] ## new for all lbst bycatch events
dates=c(dates1,dates2)
outDir="~/Dropbox/Eco-ROMS/Model Prediction Plots/daily_predictions/"
droppath="~/Dropbox/"
predDir=paste0(droppath,"Eco-ROMS/ROMS & Bathym Data/daily_prediction_layers/")
template=raster("~/Dropbox/Eco-ROMS/ROMS & Bathym Data/Bathymetry ETOPO1/template.grd")
staticDir=paste0(droppath,"Eco-ROMS/ROMS & Bathym Data/Bathymetry ETOPO1/")

caslmod=readRDS('~/Dropbox/Eco-ROMS/Model Outputs/Final EcoROMS models/casl.res1.tc4.lr.1.10models.noLat.rds') # 10 unique models
lbstmod=readRDS("~/Dropbox/Eco-ROMS/Model Outputs/Final EcoROMS models/LBST.res1.tc3.lr01.10models.noLat.rds") # 10 unique models
blshmod=readRDS('~/Dropbox/Eco-ROMS/Model Outputs/Final EcoROMS models/BLSH_trk.res1.tc3.lr05.10models.noLat.rds') # 10 unique models
swormod=readRDS('~/Dropbox/Eco-ROMS/Model Outputs/Final EcoROMS models/SWOR.res1.tc3.lr03.10models.rds') # 10 unique models
blshobsmod=readRDS('~/Dropbox/Eco-ROMS/Model Outputs/Final EcoROMS models/BLSH_obs.res1.tc3.lr03.10models.rds') # 10 unique models

batch_predict=function(swormod,caslmod,lbstmod,blshmod,blshobsmod,get_date){
  get_date=get_date
  print(get_date)
  stack=create_ROMS_daily_stack(get_date = get_date,predDir = predDir,staticDir=staticDir,droppath = droppath,template=template)
  predCIs_ROMS(get_date = get_date,modrep=caslmod,spname = "casl_noLat",stack=stack,studyarea = studyarea,template=template,outDir = outDir)
  predCIs_ROMS(get_date = get_date,modrep=lbstmod,spname = "lbst_nolat",stack=stack,studyarea = studyarea,template=template,outDir = outDir)
  predCIs_ROMS(get_date = get_date,modrep=blshmod,spname = "blshtrk_nolat",stack=stack,studyarea = studyarea,template=template,outDir = outDir)
  predCIs_ROMS(get_date = get_date,modrep=swormod,spname = "swor",stack=stack,studyarea = studyarea,template=template,outDir = outDir)
  predCIs_ROMS(get_date = get_date,modrep=blshobsmod,spname = "blshobs",stack=stack,studyarea = studyarea,template=template,outDir = outDir)
}

lapply(dates,swormod = swormod,caslmod = caslmod,lbstmod = lbstmod,blshmod = blshmod,blshobsmod = blshobsmod,FUN=batch_predict)

