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
