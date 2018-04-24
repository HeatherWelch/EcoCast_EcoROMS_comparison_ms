# step 3. run marxan_clean_02.21.18.R for all days (different script)
source("load_functions.R")

### old stuff pre April 2018 ####
source("marxan/marxan_clean_02.21.18.R")
## load marxan_clean_02.21.18.R

#get_date="2011-09-01"
biofeats=c("blshobs","blshtrk_nolat","casl_noLat","lbst_nolat","swor")
cost="swor"
dailypreddir="~/Dropbox/Eco-ROMS/Model Prediction Plots/daily_predictions/"
namesrisk<-c("Blue shark bycatch","Blue sharks","Sea lions","Leatherbacks","Swordfish")
outdir="~/Dropbox/Eco-ROMS/EcoROMSruns/output/marxan/"



##### hindcasting 2005 08-11 run
# dates=seq(as.Date("2005-08-01",format="%Y-%m-%d"),as.Date("2005-11-30",format="%Y-%m-%d"),by="day") %>% as.character()
# 
# weightings<-c(-0.1,-0.1,-0.05,-0.2,0.1) ## (run 1)
# for(d in dates){
#   print(d)
#   get_date=d
#   scp(get_date = get_date,biofeats = biofeats,cost=cost,dailypreddir = dailypreddir,weightings = weightings,namesrisk = namesrisk)
# }
# 
# weightings<-c(-0.1,-0.1,-0.05,-0.3,0.6) # testing swor at it's most extreme ## (run 2)
# for(d in dates){
#   print(d)
#   get_date=d
#   scp(get_date = get_date,biofeats = biofeats,cost=cost,dailypreddir = dailypreddir,weightings = weightings,namesrisk = namesrisk)
# }
# 
# 
# weightings<-c(-0.1,-0.1,-0.05,-0.3,0.1) # testing leatherback at it's most extreme, swor neutral ## (run 3)
# for(d in dates){
#   print(d)
#   get_date=d
#   scp(get_date = get_date,biofeats = biofeats,cost=cost,dailypreddir = dailypreddir,weightings = weightings,namesrisk = namesrisk)
# }


# ##### hindcasting 1997 10-11 run
# dates=seq(from=as.Date("1997-10-01",format="%Y-%m-%d"),to=as.Date("1997-11-30",format="%Y-%m-%d"),by="day") %>% as.character()
# 
# weightings<-c(-0.1,-0.1,-0.05,-0.2,0.1) ## (run 1)
# for(d in dates){
#   print(d)
#   get_date=d
#   scp(get_date = get_date,biofeats = biofeats,cost=cost,dailypreddir = dailypreddir,weightings = weightings,namesrisk = namesrisk)
# }
# 
# weightings<-c(-0.1,-0.1,-0.05,-0.3,0.6) # testing swor at it's most extreme ## (run 2)
# for(d in dates){
#   print(d)
#   get_date=d
#   scp(get_date = get_date,biofeats = biofeats,cost=cost,dailypreddir = dailypreddir,weightings = weightings,namesrisk = namesrisk)
# }
# 
# 
# weightings<-c(-0.1,-0.1,-0.05,-0.3,0.1) # testing leatherback at it's most extreme, swor neutral ## (run 3)
# for(d in dates){
#   print(d)
#   get_date=d
#   scp(get_date = get_date,biofeats = biofeats,cost=cost,dailypreddir = dailypreddir,weightings = weightings,namesrisk = namesrisk)
# }



##### hindcasting 1997 10-11 and 2005 08-11 run with new marxan function ---------> running now
# dates=seq(from=as.Date("1997-10-01",format="%Y-%m-%d"),to=as.Date("1997-11-30",format="%Y-%m-%d"),by="day") %>% as.character()
# datess=seq(as.Date("2005-08-01",format="%Y-%m-%d"),as.Date("2005-11-30",format="%Y-%m-%d"),by="day") %>% as.character()
# dates=c(dates,datess)
# 
# weightings<-c(-0.1,-0.1,-0.05,-0.2,0.1) ## (run 1)
# for(d in dates){
#   print(d)
#   get_date=d
#   scp_swor(get_date = get_date,biofeats = biofeats,cost=cost,dailypreddir = dailypreddir,weightings = weightings,namesrisk = namesrisk)
# }
# 
# weightings<-c(-0.1,-0.1,-0.05,-0.3,0.6) # testing swor at it's most extreme ## (run 2)
# for(d in dates){
#   print(d)
#   get_date=d
#   scp_swor(get_date = get_date,biofeats = biofeats,cost=cost,dailypreddir = dailypreddir,weightings = weightings,namesrisk = namesrisk)
# }
# 
# 
# weightings<-c(-0.1,-0.1,-0.05,-0.3,0.1) # testing leatherback at it's most extreme, swor neutral ## (run 3)
# for(d in dates){
#   print(d)
#   get_date=d
#   scp_swor(get_date = get_date,biofeats = biofeats,cost=cost,dailypreddir = dailypreddir,weightings = weightings,namesrisk = namesrisk)
# }
# 

###### -------> new run 04.10.18, rerunning with new data and cleaning everything up ------> running now ##### 
source("marxan/marxan_clean_04.10.18.R")

#get_date="2011-09-01"
biofeats=c("blshobs","blshtrk_nolat","casl_noLat","lbst_nolat","swor")
cost="swor"
dailypreddir="~/Dropbox/Eco-ROMS/Model Prediction Plots/daily_predictions/"
namesrisk<-c("Blue shark bycatch","Blue sharks","Sea lions","Leatherbacks","Swordfish")
outdir="~/Dropbox/Eco-ROMS/EcoROMSruns/output/hindcast/marxan/"
dates=read.csv("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/raw_data/allspecies_04_11_2018.csv") %>% dplyr::select(dt)%>% .[,1] %>% as.character() %>% unique()

# weightings<-c(-0.1,-0.1,-0.05,-0.3,0.1) # testing leatherback at it's most extreme, swor neutral ## (run 3) -----> run
# for(d in dates){
#   print(d)
#   get_date=d
#   scp_swor(get_date = get_date,biofeats = biofeats,cost=cost,dailypreddir = dailypreddir,weightings = weightings,namesrisk = namesrisk)
# }


# weightings<-c(-0.1,-0.1,-0.05,-0.4,0.1) # testing leatherback at it's most extreme, swor neutral ## (run 4) -----> run
# for(d in dates){
#   print(d)
#   get_date=d
#   print(get_date)
#   scp_swor(get_date = get_date,biofeats = biofeats,cost=cost,dailypreddir = dailypreddir,weightings = weightings,namesrisk = namesrisk)
# }

weightings<-c(-0.1,-0.1,-0.05,-0.4,0.2) # testing leatherback at it's most extreme, swor upweighted ## (run 4) -----> running
for(d in dates){
  print(d)
  get_date=d
  print(get_date)
  scp_swor(get_date = get_date,biofeats = biofeats,cost=cost,dailypreddir = dailypreddir,weightings = weightings,namesrisk = namesrisk)
}

### really old junk ####

# weightings<-c(-0.1,-0.1,-0.05,-0.2,0)=============================# get_date=dates[1]
# scp(get_date = get_date,biofeats = biofeats,cost=cost,dailypreddir = dailypreddir,weightings = weightings,namesrisk = namesrisk)
# 
# weightings<-c(-0.1,-0.1,-0.05,-0.2,0.1)
# get_date=dates[1]
# scp(get_date = get_date,biofeats = biofeats,cost=cost,dailypreddir = dailypreddir,weightings = weightings,namesrisk = namesrisk)
# 
# weightings<-c(-0.1,-0.1,-0.05,-0.2,0.5)
# get_date=dates[1]
# scp(get_date = get_date,biofeats = biofeats,cost=cost,dailypreddir = dailypreddir,weightings = weightings,namesrisk = namesrisk)
# 
# weightings<-c(-0.1,-0.1,-0.05,-0.2,0.9)
# get_date=dates[1]
# scp(get_date = get_date,biofeats = biofeats,cost=cost,dailypreddir = dailypreddir,weightings = weightings,namesrisk = namesrisk)
# 
# weightings<-c(-0.1,-0.1,-0.05,-0.3,0.5)
# get_date=dates[1]
# scp(get_date = get_date,biofeats = biofeats,cost=cost,dailypreddir = dailypreddir,weightings = weightings,namesrisk = namesrisk)
