## correlation plot showing correlations w changing weightings
## adapted from correaltion_plot_subset.R

datadir="./hindcast_ms/extract/extractions/"
plotdir_ms="./hindcast_ms/figures/plots/"#;dir.create(plotdir_ms)
library(corrplot)
library(ggradar)
library(scales)
library(fmsb)

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

master=fullon %>% mutate(blsh=(blshobs+blshtrk)/2) %>% select(-c(X,blshobs,blshtrk)) %>% select(-c(EcoROMS_original,Marxan_raw)) %>% rename(EcoROMS=EcoROMS_original_unscaled) %>% rename(Marxan=Marxan_raw_unscaled) %>% rename(Swordfish=swor) %>% rename(Leatherback=lbst) %>% rename(Sealion=casl) %>% rename(Blueshark=blsh)
master=master %>% select(-c(lon,lat,dt,EcoROMS,Marxan,run))
a=cor(master)
png(paste0(plotdir_ms,"sp_cor.png"),width=4, height=4, units="in", res=400)
par(ps=10)
corrplot(a, method="color",type="upper", 
         addCoef.col = "white",tl.col="black",mar=c(0,0,0,0),number.cex=1,cl.pos="n")
dev.off()


#master=fullon %>% mutate(Year=as.factor(substr(dt,1,4))) %>% filter(Year=="1997"|Year=="2005") %>% select(-Year)
master=fullon %>% mutate(Year=as.factor(substr(dt,1,4))) %>% filter(Year=="2003") %>% select(-Year)

master=fullon %>% mutate(blsh=(blshobs+blshtrk)/2) %>% select(-c(X,blshobs,blshtrk)) %>% select(-c(EcoROMS_original,Marxan_raw)) %>% rename(EcoROMS=EcoROMS_original_unscaled) %>% rename(Marxan=Marxan_raw_unscaled) %>% rename(Swordfish=swor) %>% rename(Leatherback=lbst) %>% rename(Sealion=casl) %>% rename(Blueshark=blsh)
b=master %>% filter(run=="run_M.2"|run=="run_C.3"|run=="run_E.1"|run=="run_D.4") %>%select(-Marxan) %>%  spread(run,EcoROMS) %>%rename(EcoCast_M.2=run_M.2)%>%rename(EcoCast_C.3=run_C.3)%>%rename(EcoCast_E.1=run_E.1)%>%rename(EcoCast_D.4=run_D.4)%>% select(-c(lat,lon,dt))
c=master %>% filter(run=="run_B.2"|run=="run_B.3"|run=="run_B.4"|run=="run_C.3"|run=="run_E.1"|run=="run_D.4")  %>%select(-EcoROMS) %>%  spread(run,Marxan)%>% rename(Marxan_B.2=run_B.2)%>% rename(Marxan_B.3=run_B.3)%>% rename(Marxan_B.4=run_B.4)%>% rename(Marxan_D.4=run_D.4)%>% rename(Marxan_E.1=run_E.1)%>% rename(Marxan_C.3=run_C.3) %>% select(-c(lat,lon,dt))
a=cbind(b,c[,5:ncol(c)]) %>% .[complete.cases(.),] %>% select(-c(Sealion,Blueshark)) %>% .[,c(1:2,6,5,3,4,7:ncol(.))]
a=cor(a)
png(paste0(plotdir_ms,"figure3_changing_weightings_cor.png"),width=12, height=8, units="in", res=400)
par(ps=10)
corrplot(a, method="color",type="upper", 
         addCoef.col = "black",tl.col="black",title="Fig 4. Correl plot of changing weightings, BCs",mar=c(1,1,1,1),number.cex=1)
dev.off()

## trying with better names

b=master %>% filter(run=="run_M.2"|run=="run_C.3"|run=="run_E.1"|run=="run_D.4") %>%select(-Marxan) %>%  spread(run,EcoROMS) %>%rename("E: lbst (1)"=run_M.2)%>%rename("E: lbst/swor (-.5/.5)"=run_C.3)%>%rename("E:lbst/swor (-.3/.7)"=run_E.1)%>%rename("E:lbst/swor (-.7/.3)"=run_D.4)%>% select(-c(lat,lon,dt))
c=master %>% filter(run=="run_B.2"|run=="run_B.3"|run=="run_B.4"|run=="run_C.3"|run=="run_E.1"|run=="run_D.4")  %>%select(-EcoROMS) %>%  spread(run,Marxan) %>% rename("M: lbst (-.3)"=run_B.2)%>% rename("M: lbst (-.5)"=run_B.3)%>% rename("M: lbst (-.7)"=run_B.4) %>% rename("M: lbst/swor (-.3/.7)"=run_E.1)%>% rename("M: lbst/swor (-.5/.5)"=run_C.3)%>% rename("M: lbst/swor (-.7/.3)"=run_D.4) %>% select(-c(lat,lon,dt))
a=cbind(b,c[,5:ncol(c)]) %>% .[complete.cases(.),] %>% select(-c(Sealion,Blueshark)) %>% .[,c(1:2,6,5,3,4,7:9,12,10,11)]
a=cor(a)
png(paste0(plotdir_ms,"figure3_changing_weightings_cor.png"),width=12, height=8, units="in", res=400)
par(ps=10)
corrplot(a, method="color",type="upper", 
         addCoef.col = "black",tl.col="black",number.cex=.9)
dev.off()


#Fig 7. Correl plot of different # species
# source("~/Dropbox/Eco-ROMS/heather_working/Eco-ROMS-private/Extracto_Scripts/Extracto_ROMS.R")
# source("load_functions.R")
# 
# ROMS_files_hist <- list.files("~/Dropbox/Eco-ROMS/ROMS & Bathym Data/wcra31_daily_1980-2010",pattern=".nc", full.names=T)
# ROMS_files_newNRT <- list.files("~/Dropbox/Eco-ROMS/ROMS & Bathym Data/WCNRT",pattern=".nc", full.names=T)
# 
# master=fullon %>% mutate(blsh=(blshobs+blshtrk)/2) %>% select(-c(X,blshobs,blshtrk)) %>% select(-c(EcoROMS_original,Marxan_raw)) %>% rename(EcoROMS=EcoROMS_original_unscaled) %>% rename(Marxan=Marxan_raw_unscaled) %>% rename(Swordfish=swor) %>% rename(Leatherback=lbst) %>% rename(Sealion=casl) %>% rename(Blueshark=blsh)
# a=master %>% filter(run=="run_B.3"|run=="run_C.3"|run=="run_G.3"|run=="run_J.3")
# input_file <- getvarROMS(ROMS_files_hist[7], 'sst', a, desired.resolution = 0.1, mean, 'mean_0.1')
# input_file_newRT <- getvarROMS(ROMS_files_newNRT[7], 'sst', input_file, desired.resolution = 0.1, mean, 'mean_0.1')
# 
# b=input_file_newRT %>%select(-Marxan) %>%  spread(run,EcoROMS) %>% rename(EcoCast_B.3=run_B.3)%>% rename(EcoCast_C.3=run_C.3)%>% rename(EcoCast_G.3=run_G.3)%>% rename(EcoCast_J.3=run_J.3) %>% select(-c(lat,lon,dt))
# c=input_file_newRT %>%select(-EcoROMS) %>%  spread(run,Marxan) %>% rename(Marxan_B.3=run_B.3)%>% rename(Marxan_C.3=run_C.3)%>% rename(Marxan_G.3=run_G.3)%>% rename(Marxan_J.3=run_J.3) %>% select(-c(lat,lon,dt))
# a=cbind(b,c[,6:9]) %>% .[complete.cases(.),]
# a=cor(a)
# png(paste0(plotdir_ms,"correl_plots_Q2.png"),width=12, height=8, units="in", res=400)
# par(ps=10)
# corrplot(a, method="color",type="upper", 
#          addCoef.col = "black",tl.col="black",title="Fig 7. Correl plot of different # species",mar=c(1,1,1,1),number.cex=.5)
# 
# dev.off()
# 
# 
# a=master %>% filter(run=="run_B.3"|run=="run_C.3"|run=="run_G.3"|run=="run_J.3")
# b=a %>%select(-Marxan) %>%  spread(run,EcoROMS) %>%  rename(EcoCast_B.3=run_B.3)%>% rename(EcoCast_C.3=run_C.3)%>% rename(EcoCast_G.3=run_G.3)%>% rename(EcoCast_J.3=run_J.3)
# c=a %>%select(-EcoROMS) %>%  spread(run,Marxan)%>% rename(Marxan_B.3=run_B.3)%>% rename(Marxan_C.3=run_C.3)%>% rename(Marxan_G.3=run_G.3)%>% rename(Marxan_J.3=run_J.3)
# a=cbind(b,c[,6:10])
# a=cor(a)
# corrplot(a, method="color",type="upper", 
#          addCoef.col = "black",tl.col="black",title="c(-0.25,-0.25,-0.5,-0.5,0.5) #run J.3",mar=c(1,1,1,1))
# 
