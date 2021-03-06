## new idea
## seeing if we can improve marxan/ecocast if we set by month
## steps
#1. develope # best metric
# find best run for each month

source("load_functions.R")
plotdir_ms="./hindcast_ms/summarize_ms/plots/"

library(ggalt)
library(plotly)
library(ggplot2)
library(scales)
library(fmsb)
library(DescTools)

weightings=read.csv("hindcast_ms/predict/weighting_scenarios.csv")
datadir="hindcast_ms/extract/extractions/"

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
master=fullon %>% as.data.frame()%>% mutate(blsh=(blshobs+blshtrk)/2) %>% select(-c(X,lon,lat,blshobs,blshtrk)) %>% select(-c(EcoROMS_original,Marxan_raw)) %>% rename(EcoROMS=EcoROMS_original_unscaled) %>% rename(Marxan=Marxan_raw_unscaled) %>% rename(Swordfish=swor) %>% rename(Leatherback=lbst) %>% rename(Sealion=casl) %>% rename(Blueshark=blsh)
detachPackage("bindrcpp")
master=master %>% mutate(y_m=strtrim(dt,7))

### finding the best run for species and temp ####
runs=as.factor(master$run) %>% unique() %>% as.character
times=master$y_m %>% as.factor() %>% unique()
empty=data.frame(Swordfish=NA,Leatherback=NA,Sealion=NA,Blueshark=NA,algorithm=NA,run=NA,time=NA)
for(i in 1:length(runs)){
  for (ii in 1:length(times)){
    timess=times[ii]
  runn=runs[i]
  a=master %>% filter(run==runn) %>% filter(y_m==timess) %>% select(-c(run,dt,y_m)) %>% cor() %>% .[1:2,3:6] %>% as.data.frame() %>% mutate(algorithm=c("EcoROMS","Marxan")) %>% mutate(run=runn) %>% mutate(time=timess)
  empty=rbind(empty,a)
  }
}

df=empty %>% .[complete.cases(.),] %>% mutate(bycatch=rowMeans(.[,2:4])) %>% mutate(eval=Swordfish-bycatch)
dff=df %>% group_by(time,algorithm) %>% filter(eval==max(eval))


df=empty %>% mutate(swor_inverse=1-Swordfish) %>%  mutate(lbst_inverse=Leatherback+1) %>%  mutate(casl_inverse=Sealion+1) %>%  mutate(blsh_inverse=Blueshark+1) 
dff=df %>% mutate(eval=blsh_inverse+casl_inverse+swor_inverse+lbst_inverse) %>% .[complete.cases(.),]
dff=dff %>% group_by(time,algorithm) %>% filter(eval==min(eval))

summary(dff %>% filter(algorithm=="EcoROMS"))
summary(dff %>% filter(algorithm=="Marxan"))

### finding the best runs for species ####
runs=as.factor(master$run) %>% unique() %>% as.character
empty=data.frame(Swordfish=NA,Leatherback=NA,Sealion=NA,Blueshark=NA,algorithm=NA,run=NA)
for(i in 1:length(runs)){
    runn=runs[i]
    a=master %>% filter(run==runn) %>% select(-c(run,dt,y_m)) %>% cor() %>% .[1:2,3:6] %>% as.data.frame() %>% mutate(algorithm=c("EcoROMS","Marxan")) %>% mutate(run=runn) 
    empty=rbind(empty,a)
  }

corP=empty %>% mutate(id=paste0(algorithm,"_",run) %>% as.character()) %>% filter(id=="EcoROMS_run_J.3"|id=="Marxan_run_J.3"|id=="EcoROMS_run_J.5"|id=="Marxan_run_I.6")


df=empty %>% mutate(swor_inverse=1-Swordfish) %>%  mutate(lbst_inverse=Leatherback+1) %>%  mutate(casl_inverse=Sealion+1) %>%  mutate(blsh_inverse=Blueshark+1) 
dff=df %>% mutate(eval=blsh_inverse+casl_inverse+swor_inverse+lbst_inverse) %>% .[complete.cases(.),]
dff=dff %>% group_by(algorithm) %>% filter(eval==min(eval)) #I.6 (Marxan), #J.5 (EcoROMS)

weightings=read.csv("hindcast_ms/predict/weighting_scenarios.csv")
datadir="hindcast_ms/extract/extractions/"

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
master=fullon %>% as.data.frame()%>% mutate(blsh=(blshobs+blshtrk)/2) %>% select(-c(X,lon,lat,blshobs,blshtrk)) %>% select(-c(EcoROMS_original,Marxan_raw)) %>% rename(EcoROMS=EcoROMS_original_unscaled) %>% rename(Marxan=Marxan_raw_unscaled) %>% rename(Swordfish=swor) %>% rename(Leatherback=lbst) %>% rename(Sealion=casl) %>% rename(Blueshark=blsh)
detachPackage("bindrcpp")
master=master %>% filter(run=="run_I.6"|run=="run_J.5") %>% mutate(run=gsub("run_","",run)) %>% mutate(Year=as.factor(substr(dt,1,4)))
b=master %>% gather(species,sp_value,-c(EcoROMS,Marxan,run,dt,Year))

c.1=b %>% filter(run=="J.5")
a=ggplot(c.1,aes(x=sp_value,y=EcoROMS,group=species,color=species,shape=Year))+geom_point(aes(alpha=Year),size=1)+stat_smooth(se=F)+
  scale_alpha_manual("Year",values = c("1997"=.3,"2003"=.6,"2005"=.3))+
  scale_color_manual("Species",values=c("Leatherback"="darkgoldenrod","Swordfish"="cornflowerblue","Blueshark"="coral1","Sealion"="aquamarine4"))+
  scale_shape_manual("Year",values=c("1997"=3,"2003"=15,"2005"=4))+
  theme(text = element_text(size=5),axis.text = element_text(size=5),plot.title = element_text(hjust=0,size=5),legend.position=c(.1,.85),legend.justification = c(.9,.9),legend.key.size = unit(.5,'lines'))+
  theme(legend.background = element_blank(),legend.box.background = element_rect(color=NA),legend.margin=unit(0.3, "lines"))+
  ylab("EcoCast output")+xlab("Habitat suitability")+ylim(-.75,.4)
A1=a

c.1=b %>% filter(run=="I.6")
a=ggplot(c.1,aes(x=sp_value,y=Marxan,group=species,color=species,shape=Year))+geom_point(aes(alpha=Year),size=1)+stat_smooth(se=F)+
  scale_alpha_manual("Year",values = c("1997"=.3,"2003"=.6,"2005"=.3))+
  scale_color_manual("Species",values=c("Leatherback"="darkgoldenrod","Swordfish"="cornflowerblue","Blueshark"="coral1","Sealion"="aquamarine4"))+
  scale_shape_manual("Year",values=c("1997"=3,"2003"=15,"2005"=4))+
  theme(text = element_text(size=5),axis.text = element_text(size=5),plot.title = element_text(hjust=0,size=5),legend.position=c(.1,.85),legend.justification = c(.9,.9),legend.key.size = unit(.5,'lines'))+
  theme(legend.background = element_blank(),legend.box.background = element_rect(color=NA),legend.margin=unit(0.3, "lines"))+
  ylab("Marxan output")+xlab("Habitat suitability")+ylim(-1000,0)
B1=a

png(paste0(plotdir_ms,"sp_Best.png"),width=10, height=4, units="in", res=400)
par(ps=10)
par(cex=1)
par(mar=c(4,4,1,1))
plot_grid(A1,B1,ncol=2)
dev.off()

# df=empty %>% .[complete.cases(.),] %>% mutate(bycatch=rowMeans(.[,2:4])) %>% mutate(eval=Swordfish-bycatch)%>% filter(run!="run_A.5")%>% filter(run!="run_A.4")%>% filter(run!="run_A.3")%>% filter(run!="run_A.2")%>% filter(run!="run_A.1")
# dff=df %>% group_by(algorithm) %>% filter(eval==max(eval))


a=master %>% filter(run=="I.6") %>% select(-c(dt,EcoROMS,run,Year))
b=master %>% filter(run=="J.5") %>% select(-c(dt,Marxan,run,Year,Swordfish,Leatherback,Sealion,Blueshark))
c=cbind(a,b) %>% .[,c(6,1,2,3,4,5)]

png(paste0(plotdir_ms,"correl_plots_sp_best.png"),width=12, height=8, units="in", res=400)
par(ps=10)
c=cor(c)
 corrplot(c, method="color",type="upper", 
          addCoef.col = "black",tl.col="black",title="Fig 7. Correl plot best species",mar=c(1,1,1,1),number.cex=1)

dev.off()
 
 
#### finding the best run for species and temperature
master=master %>% mutate(year=strtrim(dt,4))
master$temp="warm"
master <- within(master, temp[year == '2003'] <- 'cold')

runs=as.factor(master$run) %>% unique() %>% as.character
times=master$temp %>% unique()
empty=data.frame(Swordfish=NA,Leatherback=NA,Sealion=NA,Blueshark=NA,algorithm=NA,run=NA,time=NA)
for(i in 1:length(runs)){
  for (ii in 1:length(times)){
    timess=times[ii]
    runn=runs[i]
    a=master %>% filter(run==runn) %>% filter(temp==timess) %>% select(-c(run,dt,year,temp)) %>% cor() %>% .[1:2,3:6] %>% as.data.frame() %>% mutate(algorithm=c("EcoROMS","Marxan")) %>% mutate(run=runn) %>% mutate(time=timess)
    empty=rbind(empty,a)
  }
}

df=empty %>% mutate(swor_inverse=1-Swordfish) %>%  mutate(lbst_inverse=Leatherback+1) %>%  mutate(casl_inverse=Sealion+1) %>%  mutate(blsh_inverse=Blueshark+1) %>% filter(run!="run_G.6")
dff=df %>% mutate(eval=blsh_inverse+casl_inverse+swor_inverse+lbst_inverse) %>% .[complete.cases(.),]
dff=dff %>% group_by(time,algorithm) %>% filter(eval==min(eval))
dff
#mar_col=D.5, mar_warm=J.6, eco_cold=I.4, eco_warm=J.5

#df=empty %>% .[complete.cases(.),] %>% mutate(bycatch=rowMeans(.[,2:4])) %>% mutate(eval=Swordfish-bycatch)%>% filter(run!="run_A.5")%>%  filter(run!="run_F.1") %>% filter(run!="run_F.3") %>% filter(run!="run_G.3")%>% filter(run!="run_A.5")%>% filter(run!="run_A.4")%>% filter(run!="run_A.3")%>% filter(run!="run_A.2")%>% filter(run!="run_A.1")%>% filter(run!="run_G.6")%>% filter(run!="run_I.6")%>% filter(run!="run_L.2")%>% filter(run!="run_F.6")%>% filter(run!="run_H.3")
df=empty %>% .[complete.cases(.),] %>% mutate(bycatch=rowMeans(.[,2:4])) %>% mutate(eval=Swordfish-bycatch)%>% filter(run!="run_A.5")%>% filter(run!="run_A.4")%>% filter(run!="run_A.3")%>% filter(run!="run_A.2")%>% filter(run!="run_A.1")
df=df %>% filter(Blueshark<=-.1)
dff=df %>% group_by(time,algorithm) %>% filter(eval==max(eval))
dff
#mar_col=D.5, mar_warm=J.6, eco_cold=L.4, eco_warm=J.6 !!!! this one

weightings=read.csv("hindcast_ms/predict/weighting_scenarios.csv")
datadir="hindcast_ms/extract/extractions/"

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
master=fullon %>% as.data.frame()%>% mutate(blsh=(blshobs+blshtrk)/2) %>% select(-c(X,lon,lat,blshobs,blshtrk)) %>% select(-c(EcoROMS_original,Marxan_raw)) %>% rename(EcoROMS=EcoROMS_original_unscaled) %>% rename(Marxan=Marxan_raw_unscaled) %>% rename(Swordfish=swor) %>% rename(Leatherback=lbst) %>% rename(Sealion=casl) %>% rename(Blueshark=blsh)
detachPackage("bindrcpp")
master=master %>% filter(run=="run_D.5"|run=="run_J.6"|run=="run_L.4") %>% mutate(run=gsub("run_","",run)) %>% mutate(Year=as.factor(substr(dt,1,4)))
master$temp="warm"
master <- within(master, temp[Year == '2003'] <- 'cold')

b=master %>% gather(species,sp_value,-c(EcoROMS,Marxan,run,dt,Year,temp))

c.1=b %>% filter(temp=="warm") %>% filter(run=="J.6")
a=ggplot(c.1,aes(x=sp_value,y=EcoROMS,group=species,color=species,shape=Year))+geom_point(aes(alpha=Year),size=1)+stat_smooth(se=F)+
  scale_alpha_manual("Year",values = c("1997"=.3,"2003"=.6,"2005"=.3))+
  scale_color_manual("Species",values=c("Leatherback"="darkgoldenrod","Swordfish"="cornflowerblue","Blueshark"="coral1","Sealion"="aquamarine4"))+
  scale_shape_manual("Year",values=c("1997"=3,"2003"=15,"2005"=4))+
  theme(text = element_text(size=5),axis.text = element_text(size=5),plot.title = element_text(hjust=0,size=5),legend.position=c(.1,.85),legend.justification = c(.9,.9),legend.key.size = unit(.5,'lines'))+
  theme(legend.background = element_blank(),legend.box.background = element_rect(color=NA),legend.margin=unit(0.3, "lines"))+
  ylab("EcoCast output")+xlab("Habitat suitability")+ylim(-.75,.4)
A1=a


c.1=b %>% filter(temp=="warm") %>% filter(run=="J.6")
a=ggplot(c.1,aes(x=sp_value,y=Marxan,group=species,color=species,shape=Year))+geom_point(aes(alpha=Year),size=1)+stat_smooth(se=F)+
  scale_alpha_manual("Year",values = c("1997"=.3,"2003"=.6,"2005"=.3))+
  scale_color_manual("Species",values=c("Leatherback"="darkgoldenrod","Swordfish"="cornflowerblue","Blueshark"="coral1","Sealion"="aquamarine4"))+
  scale_shape_manual("Year",values=c("1997"=3,"2003"=15,"2005"=4))+
  theme(text = element_text(size=5),axis.text = element_text(size=5),plot.title = element_text(hjust=0,size=5),legend.position=c(.1,.85),legend.justification = c(.9,.9),legend.key.size = unit(.5,'lines'))+
  theme(legend.background = element_blank(),legend.box.background = element_rect(color=NA),legend.margin=unit(0.3, "lines"))+
  ylab("Marxan output")+xlab("Habitat suitability")+ylim(-1000,0)
B1=a

c.1=b %>% filter(temp=="cold") %>% filter(run=="L.4")
a=ggplot(c.1,aes(x=sp_value,y=EcoROMS,group=species,color=species,shape=Year))+geom_point(aes(alpha=Year),size=1)+stat_smooth(se=F)+
  scale_alpha_manual("Year",values = c("1997"=.3,"2003"=.6,"2005"=.3))+
  scale_color_manual("Species",values=c("Leatherback"="darkgoldenrod","Swordfish"="cornflowerblue","Blueshark"="coral1","Sealion"="aquamarine4"))+
  scale_shape_manual("Year",values=c("1997"=3,"2003"=15,"2005"=4))+
  theme(text = element_text(size=5),axis.text = element_text(size=5),plot.title = element_text(hjust=0,size=5),legend.position=c(.1,.85),legend.justification = c(.9,.9),legend.key.size = unit(.5,'lines'))+
  theme(legend.background = element_blank(),legend.box.background = element_rect(color=NA),legend.margin=unit(0.3, "lines"))+
  ylab("EcoCast output")+xlab("Habitat suitability")+ylim(-.75,.4)
C1=a

c.1=b %>% filter(temp=="cold") %>% filter(run=="D.5")
a=ggplot(c.1,aes(x=sp_value,y=Marxan,group=species,color=species,shape=Year))+geom_point(aes(alpha=Year),size=1)+stat_smooth(se=F)+
  scale_alpha_manual("Year",values = c("1997"=.3,"2003"=.6,"2005"=.3))+
  scale_color_manual("Species",values=c("Leatherback"="darkgoldenrod","Swordfish"="cornflowerblue","Blueshark"="coral1","Sealion"="aquamarine4"))+
  scale_shape_manual("Year",values=c("1997"=3,"2003"=15,"2005"=4))+
  theme(text = element_text(size=5),axis.text = element_text(size=5),plot.title = element_text(hjust=0,size=5),legend.position=c(.1,.85),legend.justification = c(.9,.9),legend.key.size = unit(.5,'lines'))+
  theme(legend.background = element_blank(),legend.box.background = element_rect(color=NA),legend.margin=unit(0.3, "lines"))+
  ylab("Marxan output")+xlab("Habitat suitability")+ylim(-1000,0)
D1=a

png(paste0(plotdir_ms,"temp_sp_Best.png"),width=10, height=8, units="in", res=400)
par(ps=10)
par(cex=1)
par(mar=c(4,4,1,1))
plot_grid(A1,B1,C1,D1,nrow=2,ncol=2)
dev.off()


#a=master %>% filter(temp=="warm") %>% mutate(id=paste0(temp,"_EcoROMS")) %>% select(-c(run,temp,Marxan,dt)) #%>% spread(id,EcoROMS)
E_warm=master %>% filter(temp=="warm") %>% filter(run=="J.6") %>% rename(EcoROMS_warm=EcoROMS) %>% select(-c(run,temp,Year,dt,Marxan)) #%>% rename(Swordfish_warm=Swordfish) %>% rename(Leatherback_warm=Leatherback) %>% rename(Sealion_warm=Sealion) %>% rename(Blueshark_warm=Blueshark) 
E_cold=master %>% filter(temp=="cold") %>% filter(run=="L.4") %>% rename(EcoROMS_cold=EcoROMS) %>% select(-c(run,temp,Year,dt,Marxan)) #%>% rename(Swordfish_warm=Swordfish) %>% rename(Leatherback_warm=Leatherback) %>% rename(Sealion_warm=Sealion) %>% rename(Blueshark_warm=Blueshark) 
M_warm=master %>% filter(temp=="warm") %>% filter(run=="J.6") %>% rename(Marxan_warm=Marxan) %>% select(-c(run,temp,Year,dt,EcoROMS,Swordfish,Leatherback,Sealion,Blueshark)) #%>% rename(Swordfish_warm=Swordfish) %>% rename(Leatherback_warm=Leatherback) %>% rename(Sealion_warm=Sealion) %>% rename(Blueshark_warm=Blueshark) 
M_cold=master %>% filter(temp=="cold") %>% filter(run=="D.5") %>% rename(Marxan_cold=Marxan) %>% select(-c(run,temp,Year,dt,EcoROMS,Swordfish,Leatherback,Sealion,Blueshark)) #%>% rename(Swordfish_warm=Swordfish) %>% rename(Leatherback_warm=Leatherback) %>% rename(Sealion_warm=Sealion) %>% rename(Blueshark_warm=Blueshark) 

warm=cbind(E_warm,M_warm)%>% .[,c(6,1,2,3,4,5)]
cold=cbind(E_cold,M_cold)%>% .[,c(6,1,2,3,4,5)]


png(paste0(plotdir_ms,"correl_plots_temp_sp_best.png"),width=12, height=8, units="in", res=400)
par(ps=10)
par(mfrow = c(1,2))
a=cor(warm)
corrplot(a, method="color",type="upper",
         addCoef.col = "black",tl.col="black",title="Fig 7. Correl plot warm",mar=c(1,1,1,1),number.cex=1)
b=cor(cold)
corrplot(b, method="color",type="upper",
         addCoef.col = "black",tl.col="black",title="Fig 7. Correl plot cold",mar=c(1,1,1,1),number.cex=1)

dev.off()

### Q; which run is the most "even"

weightings=read.csv("hindcast_ms/predict/weighting_scenarios.csv")
datadir="hindcast_ms/extract/extractions/"

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
master=fullon %>% as.data.frame()%>% mutate(blsh=(blshobs+blshtrk)/2) %>% select(-c(X,lon,lat,blshobs,blshtrk)) %>% select(-c(EcoROMS_original,Marxan_raw)) %>% rename(EcoROMS=EcoROMS_original_unscaled) %>% rename(Marxan=Marxan_raw_unscaled) %>% rename(Swordfish=swor) %>% rename(Leatherback=lbst) %>% rename(Sealion=casl) %>% rename(Blueshark=blsh)
detachPackage("bindrcpp")
master=master %>% mutate(y_m=strtrim(dt,7))

### finding the best runs for species
runs=as.factor(master$run) %>% unique() %>% as.character
empty=data.frame(Swordfish=NA,Leatherback=NA,Sealion=NA,Blueshark=NA,algorithm=NA,run=NA)
for(i in 1:length(runs)){
  timess=times[ii]
  runn=runs[i]
  a=master %>% filter(run==runn) %>% select(-c(run,dt,y_m)) %>% cor() %>% .[1:2,3:6] %>% as.data.frame() %>% mutate(algorithm=c("EcoROMS","Marxan")) %>% mutate(run=runn) 
  empty=rbind(empty,a)
}

install.packages("matrixStats")
library(matrixStats)

a=empty %>% mutate(sd=apply(abs(.[,1:4]),1,sd)) #%>% filter(run!="run_E.1") %>% filter(run!="run_G.6")
#a=a %>% group_by(algorithm) %>% filter(sd==min(sd))

mar=a %>% filter(algorithm=="Marxan") #%>% .[order(sd),]
x=mar[order(mar$sd),]

mar=a %>% filter(algorithm=="EcoROMS") #%>% .[order(sd),]
x=mar[order(mar$sd),]



