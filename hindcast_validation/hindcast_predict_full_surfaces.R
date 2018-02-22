#### script to hindcast ecoROMS and ecoMarxan for 2005 08-11 (dates found to have data for all species in Sp_data_prep.R)
### will hindcast full surfaces
### its gonna be fucking sick
### written by HW 02.21.18

# step 1. run Predict_ROMS_mean_se_CIs.R for all days (species hab suitability)
# step 2. run plot_EcoROMS_temporary.R for all days (but first fix this function)
# step 3. run marxan_clean_02.21.18.R for all days
# step 4. extract all values at all points for hindcast analysis
# precurser to steps 2&3, decide on species weightins

source("/Volumes/SeaGate/EcoROMS/Eco-ROMS-private/EcoROMs/Predict_ROMS_mean_se_CIs.R")
dates=seq(as.Date("2005-08-01",format="%Y-%m-%d"),as.Date("2005-11-30",format="%Y-%m-%d"),by="day")
outDir="~/Dropbox/Eco-ROMS/Model Prediction Plots/daily_predictions/"

caslmod=readRDS('~/Dropbox/Eco-ROMS/Model Outputs/Final EcoROMS models/casl.res1.tc4.lr.1.10models.noLat.rds') # 10 unique models
lbstmod=readRDS("~/Dropbox/Eco-ROMS/Model Outputs/Final EcoROMS models/LBST.res1.tc3.lr01.10models.noLat.rds") # 10 unique models
blshmod=readRDS('~/Dropbox/Eco-ROMS/Model Outputs/Final EcoROMS models/BLSH_trk.res1.tc3.lr05.10models.noLat.rds') # 10 unique models
swormod=readRDS('~/Dropbox/Eco-ROMS/Model Outputs/Final EcoROMS models/SWOR.res1.tc3.lr03.10models.rds') # 10 unique models

batch_predict=function(swormod,caslmod,lbstmod,blshmod,get_date){
  get_date=get_date
  print(get_date)
  stack=create_ROMS_daily_stack(get_date = get_date,predDir = predDir,staticDir=staticDir)
  predCIs_ROMS(get_date = get_date,modrep=caslmod,spname = "casl_noLat",stack=stack,studyarea = studyarea,template=template,outDir = outDir)
  predCIs_ROMS(get_date = get_date,modrep=lbstmod,spname = "lbst_nolat",stack=stack,studyarea = studyarea,template=template,outDir = outDir)
  predCIs_ROMS(get_date = get_date,modrep=blshmod,spname = "blshtrk_nolat",stack=stack,studyarea = studyarea,template=template,outDir = outDir)
  predCIs_ROMS(get_date = get_date,modrep=swormod,spname = "swor",stack=stack,studyarea = studyarea,template=template,outDir = outDir)
}

#lapply(dates,FUN=batch_predict(swormod = swormod,caslmod = caslmod,lbstmod = lbstmod,blshmod = blshmod,get_date = dates))
lapply(dates,swormod = swormod,caslmod = caslmod,lbstmod = lbstmod,blshmod = blshmod,FUN=batch_predict)
