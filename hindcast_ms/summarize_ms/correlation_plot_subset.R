## correlation plont

datadir="./hindcast_ms/extract/extractions/"
plotdir_ms="./hindcast_ms/summarize_ms/plots/"#;dir.create(plotdir_ms)
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


master=fullon %>% mutate(blsh=(blshobs+blshtrk)/2) %>% select(-c(X,lon,lat,dt,blshobs,blshtrk)) %>% select(-c(EcoROMS_original,Marxan_raw)) %>% rename(EcoROMS=EcoROMS_original_unscaled) %>% rename(Marxan=Marxan_raw_unscaled) %>% rename(Swordfish=swor) %>% rename(Leatherback=lbst) %>% rename(Sealion=casl) %>% rename(Blueshark=blsh)
a=master %>% filter(run=="run_A.3"|run=="run_B.3"|run=="run_G.3"|run=="run_J.3") %>% mutate(run=gsub("run_","",run))
a=a %>% gather("Algorithm","ag_value",-c(Swordfish,Leatherback,Sealion,run,Blueshark))
a=a %>% mutate(ag_run=paste(Algorithm,run,sep="_"))
b=a %>% spread(ag_run,ag_value)

png(paste0(plotdir_ms,"correl_plots_even.png"),width=12, height=8, units="in", res=400)
par(ps=10)
#par(mar=c(5.1,4.1,7.1,2.1))
par(mfrow = c(2, 3))

a=master %>% filter(run=="run_A.3") %>% mutate(run=gsub("run_","",run)) %>% select(-run)
a=cor(a)
corrplot(a, method="color",type="upper", 
        addCoef.col = "black",tl.col="black",title="c(0,0,0,0,0.5) #run A.3",mar=c(1,1,1,1))

a=master %>% filter(run=="run_B.3") %>% mutate(run=gsub("run_","",run)) %>% select(-run)
a=cor(a)
corrplot(a, method="color",type="upper", 
         addCoef.col = "black",tl.col="black",title="c(0,0,0,-0.5,0) #run B.3",mar=c(1,1,1,1))

a=master %>% filter(run=="run_C.3") %>% mutate(run=gsub("run_","",run)) %>% select(-run)
a=cor(a)
corrplot(a, method="color",type="upper", 
         addCoef.col = "black",tl.col="black",title="c(0,0,0,-0.5,0.5) #run C.3",mar=c(1,1,1,1))

a=master %>% filter(run=="run_G.3") %>% mutate(run=gsub("run_","",run)) %>% select(-run)
a=cor(a)
corrplot(a, method="color",type="upper", 
         addCoef.col = "black",tl.col="black",title="c(-0.25,-0.25,0,-0.5,0.5) #run G.3",mar=c(1,1,1,1))

a=master %>% filter(run=="run_J.3") %>% mutate(run=gsub("run_","",run)) %>% select(-run)
a=cor(a)
corrplot(a, method="color",type="upper", 
         addCoef.col = "black",tl.col="black",title="c(-0.25,-0.25,-0.5,-0.5,0.5) #run J.3",mar=c(1,1,1,1))

dev.off()

png(paste0(plotdir_ms,"correl_plots_10percent.png"),width=12, height=8, units="in", res=400)
par(ps=10)
#par(mar=c(5.1,4.1,7.1,2.1))
par(mfrow = c(2, 3))

a=master %>% filter(run=="run_J.3") %>% mutate(run=gsub("run_","",run)) %>% select(-run)
a=cor(a)
corrplot(a, method="color",type="upper", 
         addCoef.col = "black",tl.col="black",title="c(-0.25,-0.25,-0.5,-0.5,0.5) #run J.3  ",mar=c(1,1,1,1))

a=master %>% filter(run=="run_L.1") %>% mutate(run=gsub("run_","",run)) %>% select(-run)
a=cor(a)
corrplot(a, method="color",type="upper", 
         addCoef.col = "black",tl.col="black",title="(-0.25,-0.25,-0.05,-0.5,0.5) #run L.1",mar=c(1,1,1,1))

a=master %>% filter(run=="run_L.2") %>% mutate(run=gsub("run_","",run)) %>% select(-run)
a=cor(a)
corrplot(a, method="color",type="upper", 
         addCoef.col = "black",tl.col="black",title="(-0.025,-0.025,-0.05,-0.5,0.5) #run L.2",mar=c(1,1,1,1))

a=master %>% filter(run=="run_L.3") %>% mutate(run=gsub("run_","",run)) %>% select(-run)
a=cor(a)
corrplot(a, method="color",type="upper", 
         addCoef.col = "black",tl.col="black",title="(-0.15,-0.15,-0.3,-0.3,0.3) #run L.3",mar=c(1,1,1,1))

a=master %>% filter(run=="run_L.4") %>% mutate(run=gsub("run_","",run)) %>% select(-run)
a=cor(a)
corrplot(a, method="color",type="upper", 
         addCoef.col = "black",tl.col="black",title="(-0.15,-0.15,-0.03,-0.3,0.3) #run L.4",mar=c(1,1,1,1))

a=master %>% filter(run=="run_L.5") %>% mutate(run=gsub("run_","",run)) %>% select(-run)
a=cor(a)
corrplot(a, method="color",type="upper", 
         addCoef.col = "black",tl.col="black",title="(-0.015,-0.015,-0.03,-0.3,0.3) #run L.5",mar=c(1,1,1,1))

dev.off()

### hot and cold years divided

master=fullon %>% mutate(blsh=(blshobs+blshtrk)/2) %>% select(-c(X,lon,lat,blshobs,blshtrk)) %>% select(-c(EcoROMS_original,Marxan_raw)) %>% rename(EcoROMS=EcoROMS_original_unscaled) %>% rename(Marxan=Marxan_raw_unscaled) %>% rename(Swordfish=swor) %>% rename(Leatherback=lbst) %>% rename(Sealion=casl) %>% rename(Blueshark=blsh)
master=master %>% mutate(Year=as.factor(substr(dt,1,4)))
master=master %>% filter(Year=="2005"| Year=="1997") %>% select(-c(dt,Year))

png(paste0(plotdir_ms,"correl_plots_even_warm.png"),width=12, height=8, units="in", res=400)
par(ps=10)
#par(mar=c(5.1,4.1,7.1,2.1))
par(mfrow = c(2, 3))

a=master %>% filter(run=="run_A.3") %>% mutate(run=gsub("run_","",run)) %>% select(-run)
a=cor(a)
corrplot(a, method="color",type="upper", 
         addCoef.col = "black",tl.col="black",title="c(0,0,0,0,0.5) #run A.3",mar=c(1,1,1,1))

a=master %>% filter(run=="run_B.3") %>% mutate(run=gsub("run_","",run)) %>% select(-run)
a=cor(a)
corrplot(a, method="color",type="upper", 
         addCoef.col = "black",tl.col="black",title="c(0,0,0,-0.5,0) #run B.3",mar=c(1,1,1,1))

a=master %>% filter(run=="run_C.3") %>% mutate(run=gsub("run_","",run)) %>% select(-run)
a=cor(a)
corrplot(a, method="color",type="upper", 
         addCoef.col = "black",tl.col="black",title="c(0,0,0,-0.5,0.5) #run C.3",mar=c(1,1,1,1))

a=master %>% filter(run=="run_G.3") %>% mutate(run=gsub("run_","",run)) %>% select(-run)
a=cor(a)
corrplot(a, method="color",type="upper", 
         addCoef.col = "black",tl.col="black",title="c(-0.25,-0.25,0,-0.5,0.5) #run G.3",mar=c(1,1,1,1))

a=master %>% filter(run=="run_J.3") %>% mutate(run=gsub("run_","",run)) %>% select(-run)
a=cor(a)
corrplot(a, method="color",type="upper", 
         addCoef.col = "black",tl.col="black",title="c(-0.25,-0.25,-0.5,-0.5,0.5) #run J.3",mar=c(1,1,1,1))

dev.off()


master=fullon %>% mutate(blsh=(blshobs+blshtrk)/2) %>% select(-c(X,lon,lat,blshobs,blshtrk)) %>% select(-c(EcoROMS_original,Marxan_raw)) %>% rename(EcoROMS=EcoROMS_original_unscaled) %>% rename(Marxan=Marxan_raw_unscaled) %>% rename(Swordfish=swor) %>% rename(Leatherback=lbst) %>% rename(Sealion=casl) %>% rename(Blueshark=blsh)
master=master %>% mutate(Year=as.factor(substr(dt,1,4)))
master=master %>% filter(Year=="1997") %>% select(-c(dt,Year))

png(paste0(plotdir_ms,"correl_plots_even_cold.png"),width=12, height=8, units="in", res=400)
par(ps=10)
#par(mar=c(5.1,4.1,7.1,2.1))
par(mfrow = c(2, 3))

a=master %>% filter(run=="run_A.3") %>% mutate(run=gsub("run_","",run)) %>% select(-run)
a=cor(a)
corrplot(a, method="color",type="upper", 
         addCoef.col = "black",tl.col="black",title="c(0,0,0,0,0.5) #run A.3",mar=c(1,1,1,1))

a=master %>% filter(run=="run_B.3") %>% mutate(run=gsub("run_","",run)) %>% select(-run)
a=cor(a)
corrplot(a, method="color",type="upper", 
         addCoef.col = "black",tl.col="black",title="c(0,0,0,-0.5,0) #run B.3",mar=c(1,1,1,1))

a=master %>% filter(run=="run_C.3") %>% mutate(run=gsub("run_","",run)) %>% select(-run)
a=cor(a)
corrplot(a, method="color",type="upper", 
         addCoef.col = "black",tl.col="black",title="c(0,0,0,-0.5,0.5) #run C.3",mar=c(1,1,1,1))

a=master %>% filter(run=="run_G.3") %>% mutate(run=gsub("run_","",run)) %>% select(-run)
a=cor(a)
corrplot(a, method="color",type="upper", 
         addCoef.col = "black",tl.col="black",title="c(-0.25,-0.25,0,-0.5,0.5) #run G.3",mar=c(1,1,1,1))

a=master %>% filter(run=="run_J.3") %>% mutate(run=gsub("run_","",run)) %>% select(-run)
a=cor(a)
corrplot(a, method="color",type="upper", 
         addCoef.col = "black",tl.col="black",title="c(-0.25,-0.25,-0.5,-0.5,0.5) #run J.3",mar=c(1,1,1,1))

dev.off()


#### trying something new
#Fig 4. Correl plot of changing weightings
source("~/Dropbox/Eco-ROMS/heather_working/Eco-ROMS-private/Extracto_Scripts/Extracto_ROMS.R")
source("load_functions.R")
ROMS_files_hist <- list.files("~/Dropbox/Eco-ROMS/ROMS & Bathym Data/wcra31_daily_1980-2010",pattern=".nc", full.names=T)
ROMS_files_newNRT <- list.files("~/Dropbox/Eco-ROMS/ROMS & Bathym Data/WCNRT",pattern=".nc", full.names=T)

master=fullon %>% mutate(blsh=(blshobs+blshtrk)/2) %>% select(-c(X,blshobs,blshtrk)) %>% select(-c(EcoROMS_original,Marxan_raw)) %>% rename(EcoROMS=EcoROMS_original_unscaled) %>% rename(Marxan=Marxan_raw_unscaled) %>% rename(Swordfish=swor) %>% rename(Leatherback=lbst) %>% rename(Sealion=casl) %>% rename(Blueshark=blsh)
a=master %>% filter(run=="run_B.1"|run=="run_B.2"|run=="run_B.3"|run=="run_B.4"|run=="run_B.5")
input_file <- getvarROMS(ROMS_files_hist[7], 'sst', a, desired.resolution = 0.1, mean, 'mean_0.1')
input_file_newRT <- getvarROMS(ROMS_files_newNRT[7], 'sst', input_file, desired.resolution = 0.1, mean, 'mean_0.1')

b=input_file_newRT %>%select(-Marxan) %>%  spread(run,EcoROMS) %>% rename(EcoCast_B.5=run_B.5)%>% rename(EcoCast_B.1=run_B.1)%>% rename(EcoCast_B.2=run_B.2)%>% rename(EcoCast_B.3=run_B.3)%>% rename(EcoCast_B.4=run_B.4) %>% select(-c(lat,lon,dt))
c=input_file_newRT %>%select(-EcoROMS) %>%  spread(run,Marxan)%>%  rename(Marxan_B.5=run_B.5)%>% rename(Marxan_B.1=run_B.1)%>% rename(Marxan_B.2=run_B.2)%>% rename(Marxan_B.3=run_B.3)%>% rename(Marxan_B.4=run_B.4) %>% select(-c(lat,lon,dt))
a=cbind(b,c[,6:10]) %>% .[complete.cases(.),]
a=cor(a)
png(paste0(plotdir_ms,"correl_plots_Q1_Bs.png"),width=12, height=8, units="in", res=400)
par(ps=10)
corrplot(a, method="color",type="upper", 
         addCoef.col = "black",tl.col="black",title="Fig 4. Correl plot of changing weightings, Bs",mar=c(1,1,1,1))
dev.off()

##
a=master %>% filter(run=="run_B.1"|run=="run_B.2"|run=="run_B.3"|run=="run_B.4"|run=="run_B.5"|run=="run_C.1"|run=="run_C.2"|run=="run_C.3"|run=="run_C.4"|run=="run_C.5")
input_file <- getvarROMS(ROMS_files_hist[7], 'sst', a, desired.resolution = 0.1, mean, 'mean_0.1')
input_file_newRT <- getvarROMS(ROMS_files_newNRT[7], 'sst', input_file, desired.resolution = 0.1, mean, 'mean_0.1')

b=input_file_newRT %>%select(-Marxan) %>%  spread(run,EcoROMS) %>%rename(EcoCast_B.5=run_B.5)%>% rename(EcoCast_B.1=run_B.1)%>% rename(EcoCast_B.2=run_B.2)%>% rename(EcoCast_B.3=run_B.3)%>% rename(EcoCast_B.4=run_B.4) %>% rename(EcoCast_C.5=run_C.5)%>% rename(EcoCast_C.1=run_C.1)%>% rename(EcoCast_C.2=run_C.2)%>% rename(EcoCast_C.3=run_C.3)%>% rename(EcoCast_C.4=run_C.4) %>% select(-c(lat,lon,dt))
c=input_file_newRT %>%select(-EcoROMS) %>%  spread(run,Marxan)%>%  rename(Marxan_B.5=run_B.5)%>%rename(Marxan_B.1=run_B.1)%>% rename(Marxan_B.2=run_B.2)%>% rename(Marxan_B.3=run_B.3)%>% rename(Marxan_B.4=run_B.4) %>% rename(Marxan_C.5=run_C.5)%>%   rename(Marxan_C.1=run_C.1)%>% rename(Marxan_C.2=run_C.2)%>% rename(Marxan_C.3=run_C.3)%>% rename(Marxan_C.4=run_C.4) %>% select(-c(lat,lon,dt))
a=cbind(b,c[,6:15]) %>% .[complete.cases(.),]
a=cor(a)
png(paste0(plotdir_ms,"correl_plots_Q1_BCs.png"),width=12, height=8, units="in", res=400)
par(ps=10)
corrplot(a, method="color",type="upper", 
         addCoef.col = "black",tl.col="black",title="Fig 4. Correl plot of changing weightings, BCs",mar=c(1,1,1,1),number.cex=.5)
dev.off()

##
a=master %>% filter(run=="run_C.1"|run=="run_C.2"|run=="run_C.3"|run=="run_C.4"|run=="run_C.5")
input_file <- getvarROMS(ROMS_files_hist[7], 'sst', a, desired.resolution = 0.1, mean, 'mean_0.1')
input_file_newRT <- getvarROMS(ROMS_files_newNRT[7], 'sst', input_file, desired.resolution = 0.1, mean, 'mean_0.1')

b=input_file_newRT %>%select(-Marxan) %>%  spread(run,EcoROMS) %>% rename(EcoCast_C.5=run_C.5)%>% rename(EcoCast_C.1=run_C.1)%>% rename(EcoCast_C.2=run_C.2)%>% rename(EcoCast_C.3=run_C.3)%>% rename(EcoCast_C.4=run_C.4) %>% select(-c(lat,lon,dt))
c=input_file_newRT %>%select(-EcoROMS) %>%  spread(run,Marxan)%>%  rename(Marxan_C.5=run_C.5)%>% rename(Marxan_C.1=run_C.1)%>% rename(Marxan_C.2=run_C.2)%>% rename(Marxan_C.3=run_C.3)%>% rename(Marxan_C.4=run_C.4) %>% select(-c(lat,lon,dt))
a=cbind(b,c[,6:10]) %>% .[complete.cases(.),]
a=cor(a)
png(paste0(plotdir_ms,"correl_plots_Q1_Cs.png"),width=12, height=8, units="in", res=400)
par(ps=10)
corrplot(a, method="color",type="upper", 
         addCoef.col = "black",tl.col="black",title="Fig 4. Correl plot of changing weightings, Cs",mar=c(1,1,1,1))
dev.off()


#Fig 7. Correl plot of different # species
source("~/Dropbox/Eco-ROMS/heather_working/Eco-ROMS-private/Extracto_Scripts/Extracto_ROMS.R")
source("load_functions.R")

ROMS_files_hist <- list.files("~/Dropbox/Eco-ROMS/ROMS & Bathym Data/wcra31_daily_1980-2010",pattern=".nc", full.names=T)
ROMS_files_newNRT <- list.files("~/Dropbox/Eco-ROMS/ROMS & Bathym Data/WCNRT",pattern=".nc", full.names=T)

master=fullon %>% mutate(blsh=(blshobs+blshtrk)/2) %>% select(-c(X,blshobs,blshtrk)) %>% select(-c(EcoROMS_original,Marxan_raw)) %>% rename(EcoROMS=EcoROMS_original_unscaled) %>% rename(Marxan=Marxan_raw_unscaled) %>% rename(Swordfish=swor) %>% rename(Leatherback=lbst) %>% rename(Sealion=casl) %>% rename(Blueshark=blsh)
a=master %>% filter(run=="run_A.3"|run=="run_B.3"|run=="run_C.3"|run=="run_G.3"|run=="run_J.3")
input_file <- getvarROMS(ROMS_files_hist[7], 'sst', a, desired.resolution = 0.1, mean, 'mean_0.1')
input_file_newRT <- getvarROMS(ROMS_files_newNRT[7], 'sst', input_file, desired.resolution = 0.1, mean, 'mean_0.1')

b=input_file_newRT %>%select(-Marxan) %>%  spread(run,EcoROMS) %>% rename(EcoCast_A.3=run_A.3)%>% rename(EcoCast_B.3=run_B.3)%>% rename(EcoCast_C.3=run_C.3)%>% rename(EcoCast_G.3=run_G.3)%>% rename(EcoCast_J.3=run_J.3) %>% select(-c(lat,lon,dt))
c=input_file_newRT %>%select(-EcoROMS) %>%  spread(run,Marxan)%>% rename(Marxan_A.3=run_A.3)%>% rename(Marxan_B.3=run_B.3)%>% rename(Marxan_C.3=run_C.3)%>% rename(Marxan_G.3=run_G.3)%>% rename(Marxan_J.3=run_J.3) %>% select(-c(lat,lon,dt))
a=cbind(b,c[,6:10]) %>% .[complete.cases(.),]
a=cor(a)
png(paste0(plotdir_ms,"correl_plots_Q2.png"),width=12, height=8, units="in", res=400)
par(ps=10)
corrplot(a, method="color",type="upper", 
         addCoef.col = "black",tl.col="black",title="Fig 7. Correl plot of different # species",mar=c(1,1,1,1),number.cex=.5)

dev.off()


a=master %>% filter(run=="run_B.3"|run=="run_C.3"|run=="run_G.3"|run=="run_J.3")
b=a %>%select(-Marxan) %>%  spread(run,EcoROMS) %>%  rename(EcoCast_B.3=run_B.3)%>% rename(EcoCast_C.3=run_C.3)%>% rename(EcoCast_G.3=run_G.3)%>% rename(EcoCast_J.3=run_J.3)
c=a %>%select(-EcoROMS) %>%  spread(run,Marxan)%>% rename(Marxan_B.3=run_B.3)%>% rename(Marxan_C.3=run_C.3)%>% rename(Marxan_G.3=run_G.3)%>% rename(Marxan_J.3=run_J.3)
a=cbind(b,c[,6:10])
a=cor(a)
corrplot(a, method="color",type="upper", 
         addCoef.col = "black",tl.col="black",title="c(-0.25,-0.25,-0.5,-0.5,0.5) #run J.3",mar=c(1,1,1,1))

