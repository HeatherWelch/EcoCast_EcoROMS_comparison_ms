datadir="hindcast_ms/extract/extractions/"
plotdir_ms="~/Dropbox/EcoEast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/hindcast_ms/summarize_ms/plots/"#;dir.create(plotdir_ms)
library(scales)
library(fmsb)
source("load_functions.R")

file_list=list.files(datadir) %>% grep("run",.,value=T)
master=list()
for (file in file_list){
  a=read.csv(paste0(datadir,file))
  name=gsub(".csv","",file)
  a$run=name
  assign(name,a)
  master[[name]]<-a
}

fullon=do.call("rbind",master)
master=fullon %>% mutate(blsh=(blshobs+blshtrk)/2) %>% select(-c(X,lon,lat,dt,blshobs,blshtrk)) %>% select(-c(EcoROMS_original,Marxan_raw)) %>% rename(EcoROMS=EcoROMS_original_unscaled) %>% rename(Marxan=Marxan_raw_unscaled) %>% rename(Swordfish=swor) %>% rename(Leatherback=lbst) %>% rename(Sealion=casl) %>% rename(Blueshark=blsh)
mas=master %>% dplyr::gather(species,hab_suit,-c(EcoROMS,Marxan,run))

master$id=paste0(dff$product,"_",dff$run) %>% as.character()