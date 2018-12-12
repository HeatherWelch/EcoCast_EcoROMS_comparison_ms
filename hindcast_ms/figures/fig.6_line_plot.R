## new idea
## seeing if we can improve marxan/ecocast if we 1. allowing weightings to be flexible, 2. set different weightings for ocean state
## steps
#1. develope # best metric
# find best run for each month

source("load_functions.R")
plotdir="./hindcast_ms/figures/plots/"

library(ggalt)
library(plotly)
library(ggplot2)
library(scales)
library(fmsb)
library(DescTools)

weightings=read.csv("hindcast_ms/predict/weighting_scenarios.csv")
datadir="hindcast_ms/extract/extractions/"
plotdir="hindcast_ms/figures/plots/"

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

### finding the best run for species and ocean state ####
# runs=as.factor(master$run) %>% unique() %>% as.character
# times=master$y_m %>% as.factor() %>% unique()
# empty=data.frame(Swordfish=NA,Leatherback=NA,Sealion=NA,Blueshark=NA,algorithm=NA,run=NA,time=NA)
# for(i in 1:length(runs)){
#   for (ii in 1:length(times)){
#     timess=times[ii]
#   runn=runs[i]
#   a=master %>% filter(run==runn) %>% filter(y_m==timess) %>% select(-c(run,dt,y_m)) %>% cor() %>% .[1:2,3:6] %>% as.data.frame() %>% mutate(algorithm=c("EcoROMS","Marxan")) %>% mutate(run=runn) %>% mutate(time=timess)
#   empty=rbind(empty,a)
#   }
# }
# 
# df=empty %>% .[complete.cases(.),] %>% mutate(bycatch=rowMeans(.[,2:4])) %>% mutate(eval=Swordfish-bycatch)
# dff=df %>% group_by(time,algorithm) %>% filter(eval==max(eval))
# 
# 
# df=empty %>% mutate(swor_inverse=1-Swordfish) %>%  mutate(lbst_inverse=Leatherback+1) %>%  mutate(casl_inverse=Sealion+1) %>%  mutate(blsh_inverse=Blueshark+1) 
# dff=df %>% mutate(eval=blsh_inverse+casl_inverse+swor_inverse+lbst_inverse) %>% .[complete.cases(.),]
# dff=dff %>% group_by(time,algorithm) %>% filter(eval==min(eval))
# 
# summary(dff %>% filter(algorithm=="EcoROMS"))
# summary(dff %>% filter(algorithm=="Marxan"))

### finding the best runs for species ####
runs=as.factor(master$run) %>% unique() %>% as.character
empty=data.frame(Swordfish=NA,Leatherback=NA,Sealion=NA,Blueshark=NA,algorithm=NA,run=NA)
for(i in 1:length(runs)){
    runn=runs[i]
    a=master %>% filter(run==runn) %>% select(-c(run,dt,y_m)) %>% cor() %>% .[1:2,3:6] %>% as.data.frame() %>% mutate(algorithm=c("EcoROMS","Marxan")) %>% mutate(run=runn) 
    empty=rbind(empty,a)
  }

#corP=empty %>% mutate(id=paste0(algorithm,"_",run) %>% as.character()) %>% filter(id=="EcoROMS_run_J.3"|id=="Marxan_run_J.3"|id=="EcoROMS_run_J.5"|id=="Marxan_run_I.6")

empty=empty %>% filter(!(algorithm=="Marxan"&run=="run_M.5"))%>% filter(!(algorithm=="Marxan"&run=="run_M.4"))%>% filter(!(algorithm=="Marxan"&run=="run_M.3"))%>% filter(!(algorithm=="Marxan"&run=="run_M.2"))%>% filter(!(algorithm=="Marxan"&run=="run_M.1"))

# method 1
df=empty %>% mutate(swor_inverse=1-Swordfish) %>%  mutate(lbst_inverse=Leatherback+1) %>%  mutate(casl_inverse=Sealion+1) %>%  mutate(blsh_inverse=Blueshark+1) 
dff=df %>% mutate(eval=blsh_inverse+casl_inverse+swor_inverse+lbst_inverse) %>% .[complete.cases(.),]
dff=dff %>% group_by(algorithm) %>% filter(eval==min(eval)) #I.6 (Marxan), #J.5 (EcoROMS) THIS ONE!!!

# method 2
# #df=empty %>% .[complete.cases(.),] %>% mutate(bycatch=rowMeans(.[,2:4])) %>% mutate(eval=Swordfish-bycatch)
# df=empty %>% .[complete.cases(.),] %>% mutate(bycatch=rowMeans(.[,2:4])) %>% mutate(eval=Swordfish-bycatch)%>% filter(run!="run_A.5")%>% filter(run!="run_A.4")%>% filter(run!="run_A.3")%>% filter(run!="run_A.2")%>% filter(run!="run_A.1")
# dff=df %>% group_by(algorithm) %>% filter(eval==max(eval)) #D.2 (Marxan), #J.6 (EcoROMS)

#####
# weightings=read.csv("hindcast_ms/predict/weighting_scenarios.csv")
# datadir="hindcast_ms/extract/extractions/"
# 
# file_list=list.files(datadir) %>% grep("run",.,value=T)
# master=list()
# for (file in file_list){
#   a=read.csv(paste0(datadir,file))
#   name=gsub(".csv","",file)
#   a$run=name
#   assign(name,a)
#   master[[name]]<-a
# }
# 
# fullon=do.call("rbind",master)
# master=fullon %>% as.data.frame()%>% mutate(blsh=(blshobs+blshtrk)/2) %>% select(-c(X,lon,lat,blshobs,blshtrk)) %>% select(-c(EcoROMS_original,Marxan_raw)) %>% rename(EcoROMS=EcoROMS_original_unscaled) %>% rename(Marxan=Marxan_raw_unscaled) %>% rename(Swordfish=swor) %>% rename(Leatherback=lbst) %>% rename(Sealion=casl) %>% rename(Blueshark=blsh)
# detachPackage("bindrcpp")
# master=master %>% filter(run=="run_I.6"|run=="run_J.5") %>% mutate(run=gsub("run_","",run)) %>% mutate(Year=as.factor(substr(dt,1,4)))
# b=master %>% gather(species,sp_value,-c(EcoROMS,Marxan,run,dt,Year))
# 
# c.1=b %>% filter(run=="J.5")
# a=ggplot(c.1,aes(x=sp_value,y=EcoROMS,group=species,color=species,shape=Year))+geom_point(aes(alpha=Year),size=1)+stat_smooth(se=F)+
#   scale_alpha_manual("Year",values = c("1997"=.3,"2003"=.6,"2005"=.3))+
#   scale_color_manual("Species",values=c("Leatherback"="darkgoldenrod","Swordfish"="cornflowerblue","Blueshark"="coral1","Sealion"="aquamarine4"))+
#   scale_shape_manual("Year",values=c("1997"=3,"2003"=15,"2005"=4))+
#   theme(text = element_text(size=5),axis.text = element_text(size=5),plot.title = element_text(hjust=0,size=5),legend.position=c(.1,.85),legend.justification = c(.9,.9),legend.key.size = unit(.5,'lines'))+
#   theme(legend.background = element_blank(),legend.box.background = element_rect(color=NA),legend.margin=unit(0.3, "lines"))+
#   ylab("EcoCast output")+xlab("Habitat suitability")+ylim(-.75,.4)
# A1=a
# 
# c.1=b %>% filter(run=="I.6")
# a=ggplot(c.1,aes(x=sp_value,y=Marxan,group=species,color=species,shape=Year))+geom_point(aes(alpha=Year),size=1)+stat_smooth(se=F)+
#   scale_alpha_manual("Year",values = c("1997"=.3,"2003"=.6,"2005"=.3))+
#   scale_color_manual("Species",values=c("Leatherback"="darkgoldenrod","Swordfish"="cornflowerblue","Blueshark"="coral1","Sealion"="aquamarine4"))+
#   scale_shape_manual("Year",values=c("1997"=3,"2003"=15,"2005"=4))+
#   theme(text = element_text(size=5),axis.text = element_text(size=5),plot.title = element_text(hjust=0,size=5),legend.position=c(.1,.85),legend.justification = c(.9,.9),legend.key.size = unit(.5,'lines'))+
#   theme(legend.background = element_blank(),legend.box.background = element_rect(color=NA),legend.margin=unit(0.3, "lines"))+
#   ylab("Marxan output")+xlab("Habitat suitability")+ylim(-1000,0)
# B1=a
# 
# png(paste0(plotdir_ms,"sp_Best.png"),width=10, height=4, units="in", res=400)
# par(ps=10)
# par(cex=1)
# par(mar=c(4,4,1,1))
# plot_grid(A1,B1,ncol=2)
# dev.off()

# df=empty %>% .[complete.cases(.),] %>% mutate(bycatch=rowMeans(.[,2:4])) %>% mutate(eval=Swordfish-bycatch)%>% filter(run!="run_A.5")%>% filter(run!="run_A.4")%>% filter(run!="run_A.3")%>% filter(run!="run_A.2")%>% filter(run!="run_A.1")
# dff=df %>% group_by(algorithm) %>% filter(eval==max(eval))


# a=master %>% filter(run=="I.6") %>% select(-c(dt,EcoROMS,run,Year))
# b=master %>% filter(run=="J.5") %>% select(-c(dt,Marxan,run,Year,Swordfish,Leatherback,Sealion,Blueshark))
# c=cbind(a,b) %>% .[,c(6,1,2,3,4,5)]
# 
# png(paste0(plotdir_ms,"correl_plots_sp_best.png"),width=12, height=8, units="in", res=400)
# par(ps=10)
# c=cor(c)
#  corrplot(c, method="color",type="upper", 
#           addCoef.col = "black",tl.col="black",title="Fig 7. Correl plot best species",mar=c(1,1,1,1),number.cex=1)
# 
# dev.off()
 
 
#### finding the best run for species and temperature ####
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
    a=master %>% filter(run==runn) %>% filter(temp==timess) %>% select(-c(run,dt,year,temp,y_m)) %>% cor() %>% .[1:2,3:6] %>% as.data.frame() %>% mutate(algorithm=c("EcoROMS","Marxan")) %>% mutate(run=runn) %>% mutate(time=timess)
    empty=rbind(empty,a)
  }
}

empty=empty %>% filter(!(algorithm=="Marxan"&run=="run_M.5"))%>% filter(!(algorithm=="Marxan"&run=="run_M.4"))%>% filter(!(algorithm=="Marxan"&run=="run_M.3"))%>% filter(!(algorithm=="Marxan"&run=="run_M.2"))%>% filter(!(algorithm=="Marxan"&run=="run_M.1"))

## method 1
df=empty %>% mutate(swor_inverse=1-Swordfish) %>%  mutate(lbst_inverse=Leatherback+1) %>%  mutate(casl_inverse=Sealion+1) %>%  mutate(blsh_inverse=Blueshark+1) %>% filter(run!="run_G.6")
dff=df %>% mutate(eval=blsh_inverse+casl_inverse+swor_inverse+lbst_inverse) %>% .[complete.cases(.),]
dff=dff %>% group_by(time,algorithm) %>% filter(eval==min(eval))
dff
#mar_cold=D.5, mar_warm=J.6, eco_cold=I.4, eco_warm=J.5 THIS ONE!

## method 2
# df=empty %>% .[complete.cases(.),] %>% mutate(bycatch=rowMeans(.[,2:4])) %>% mutate(eval=Swordfish-bycatch)%>% filter(run!="run_A.5")%>% filter(run!="run_A.4")%>% filter(run!="run_A.3")%>% filter(run!="run_A.2")%>% filter(run!="run_A.1")
# df=df %>% filter(Blueshark<=-.1)
# dff=df %>% group_by(time,algorithm) %>% filter(eval==max(eval))
# dff
# #mar_col=D.5, mar_warm=J.6, eco_cold=L.4, eco_warm=J.6 

### making the line plot with all of the shit ####
weightings=read.csv("hindcast_ms/predict/weighting_scenarios.csv")

### grabbing flexible components ####
weightings=read.csv("hindcast_ms/predict/weighting_scenarios.csv")

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
master=fullon %>% as.data.frame()%>% mutate(blsh=(blshobs+blshtrk)/2) %>% select(-c(X,lon,lat,dt,blshobs,blshtrk)) %>% select(-c(EcoROMS_original,Marxan_raw)) %>% rename(EcoROMS=EcoROMS_original_unscaled) %>% rename(Marxan=Marxan_raw_unscaled) %>% rename(Swordfish=swor) %>% rename(Leatherback=lbst) %>% rename(Sealion=casl) %>% rename(Blueshark=blsh)
detachPackage("bindrcpp")

runs=as.factor(master$run) %>% unique() %>% as.character()
empty=data.frame(Swordfish=NA,Leatherback=NA,Sealion=NA,Blueshark=NA,algorithm=NA,run=NA)
for(i in 1:length(runs)){
  runn=runs[i]
  a=master %>% filter(run==runn) %>% select(-run) %>% cor() %>% .[1:2,3:6] %>% as.data.frame() %>% mutate(algorithm=c("EcoROMS","Marxan")) %>% mutate(run=runn)
  empty=rbind(empty,a)
}

dff=empty
dff$id=paste0(dff$algorithm,"_",dff$run) %>% as.character()
b=dff %>% gather (variable, value,-c(algorithm,id,run)) %>% .[complete.cases(.),] %>% dplyr::rename(Algorithm=algorithm)
b$variable=factor(b$variable,levels=c("Leatherback","Swordfish","Blueshark","Sealion"))
b$Algorithm=gsub("_"," ",b$Algorithm)
b=with(b, b[order(variable),]) ### all runs

c=b %>% filter(id=="EcoROMS_run_M.5"|id=="Marxan_run_J.3"|id=="EcoROMS_run_J.5"|id=="Marxan_run_I.6") 
c$weighting="Equivalent"
c <- within(c, weighting[run == 'run_I.6'] <- 'Flexible')
c <- within(c, weighting[run == 'run_J.5'] <- 'Flexible') ### flexible component

### grabbing seasonal component####
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

master=master %>% mutate(year=strtrim(dt,4))
master$temp="Warm"
master <- within(master, temp[year == '2003'] <- 'Cold')

runs=as.factor(master$run) %>% unique() %>% as.character
times=master$temp %>% as.factor() %>% unique()
empty=data.frame(Swordfish=NA,Leatherback=NA,Sealion=NA,Blueshark=NA,algorithm=NA,run=NA,weighting=NA)
for(i in 1:length(runs)){
  for (ii in 1:length(times)){
    timess=times[ii]
    runn=runs[i]
    a=master %>% filter(run==runn) %>% filter(temp==timess) %>% select(-c(run,dt,year,temp)) %>% cor() %>% .[1:2,3:6] %>% as.data.frame() %>% mutate(algorithm=c("EcoROMS","Marxan")) %>% mutate(run=runn) %>% mutate(weighting=timess)
    empty=rbind(empty,a)
  }
}

a=empty %>% mutate(id=paste(algorithm,run,weighting,sep="_"))
#mar_col=D.5, mar_warm=J.6, eco_cold=I.4, eco_warm=J.5
a=a %>% filter(id=="Marxan_run_D.5_Cold"|id=="Marxan_run_J.6_Warm"|id=="EcoROMS_run_L.4_Cold"|id=="EcoROMS_run_J.6_Warm")
a=a %>% gather(variable,value,-c(algorithm,run,weighting,id)) %>% rename(Algorithm=algorithm)
a$variable=factor(a$variable,levels=c("Leatherback","Swordfish","Blueshark","Sealion"))
a$Algorithm=gsub("_"," ",a$Algorithm)
a=with(a, a[order(variable),]) ### stuff to plot for seasonal bests
a <- within(a, Algorithm[Algorithm == 'EcoROMS'] <- 'EcoCast')
c <- within(c, Algorithm[Algorithm == 'EcoROMS'] <- 'EcoCast')
b <- within(b, Algorithm[Algorithm == 'EcoROMS'] <- 'EcoCast')
t=rbind(c,a)
t$weighting=factor(t$weighting,levels=c("Equivalent","Flexible","Cold","Warm"))

### making the plot ####
bb=ggplot(a, aes(x = variable, y = value, group = id,linetype=Algorithm)) +   # group = id is important!
  geom_path(alpha = 0.5,
            lineend = 'round', linejoin = 'round', color="gray87") +
  scale_y_continuous(name="Correlation [r]",breaks = seq(-1, 1, by = .1), expand = c(.01, .01)) +scale_x_discrete(name="Species",labels=c("Leatherback"="Leatherback","Swordfish"="Swordfish","Blueshark"="Blueshark","Sealion"="California Sea Lion"), expand = c(.01, .01))+
  scale_size(breaks = NULL, range = c(0, 100))+
  theme(text = element_text(size=5),axis.text = element_text(size=5),plot.title = element_text(hjust=0,size=5),plot.margin = margin(.3, 1, .3, .3, "cm"))+
  geom_vline(xintercept=c(2,3,4))

# bb=bb+
#   geom_path(data=c,aes(x = variable, y = value, group = id,color = weighting,linetype=Algorithm))+
#   scale_color_manual("Weighting type",values=c("Equivalent"="black","Flexible"="darkgoldenrod","Warm"="coral1","Cold"="aquamarine4"))+
#   #scale_linetype_manual("Algorithm",values=c("Marxan"="solid","EcoCast"="dashed"))+
#   geom_hline(yintercept = 0)+geom_point(aes(x=1,y=-1),size=2)+geom_point(aes(x=2,y=1),size=2)+geom_point(aes(x=3,y=-1),size=2)+geom_point(aes(x=4,y=-1),size=2)

bb=bb+
  geom_path(data=t,aes(x = variable, y = value, group = id,color = weighting,linetype=Algorithm))+
  scale_linetype_manual("Algorithm",values=c("Marxan"="solid","EcoCast"="dashed"))+
  scale_color_manual("Weighting type",values=c("Warm"="coral1","Equivalent"="black","Flexible"="darkgoldenrod","Cold"="aquamarine4"))+guides(color=guide_legend(override.aes = list(
    linetype = c(rep("solid", 4)),
    shape = c(16,16,16,16))))+
  guides(shape = guide_legend(override.aes = list( shape = c(16,16,16,16))))+
  geom_hline(yintercept = 0)+geom_point(aes(x=1,y=-1),size=2)+geom_point(aes(x=2,y=1),size=2)+geom_point(aes(x=3,y=-1),size=2)+geom_point(aes(x=4,y=-1),size=2)+
  theme(legend.key.size = unit(.5,'lines'),legend.margin=unit(0.3, "lines"),legend.position=c(.9,.85))


bb

png(paste0(plotdir,"fig.6_line_plot.png"),width=7, height=3.5, units="in", res=400)
par(ps=10)
par(cex=1)
par(mar=c(4,4,1,1))
print({plot_grid(bb,nrow=1,ncol=1)})
dev.off()

#### table accompanying parallel coordinate plot ####

t=rbind(c,a)

d=t %>% mutate(run=gsub("run_","",run))
d=left_join(d,weightings,by="run")

write.csv(d,paste0(plotdir,"fig.6_line_plot.csv"))


### new calculation of table
b=a %>% filter(id=="Marxan_run_D.5_Cold"|id=="Marxan_run_J.6_Warm"|id=="EcoROMS_run_L.4_Cold"|id=="EcoROMS_run_J.6_Warm"|id=="EcoROMS_run_M.5_Warm"|id=="EcoROMS_run_M.5_Cold"|id=="Marxan_run_J.3_Warm"|id=="Marxan_run_J.3_Cold"|id=="EcoROMS_run_J.5_Warm"|id=="EcoROMS_run_J.5_Cold"|id=="Marxan_run_I.6_Warm"|id=="Marxan_run_I.6_Cold")

#c=b %>% filter(id=="EcoROMS_run_M.5"|id=="Marxan_run_J.3"|id=="EcoROMS_run_J.5"|id=="Marxan_run_I.6")
b <- within(b, weighting[run == 'run_M.5'] <- 'Equivalent')
b <- within(b, weighting[run == 'run_J.3'] <- 'Equivalent')
b <- within(b, weighting[run == 'run_J.5'] <- 'Flexible')
a <- within(b, weighting[run == 'run_I.6'] <- 'Flexible')
a=a %>% gather(variable,value,-c(algorithm,run,weighting,id)) %>% rename(Algorithm=algorithm)
a$variable=factor(a$variable,levels=c("Leatherback","Swordfish","Blueshark","Sealion"))
a$Algorithm=gsub("_"," ",a$Algorithm)
b=a %>% mutate(run=gsub("run_","",run))
b=left_join(b,weightings,by="run")

write.csv(b,paste0(plotdir,"fig.6_line_plot_divided.csv"))
