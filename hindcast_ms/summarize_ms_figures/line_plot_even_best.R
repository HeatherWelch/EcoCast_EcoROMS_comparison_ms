### ecoroms options for managers ### xxx
## no EcoROMS original or marxan raw ###

source("load_functions.R")

library(ggalt)
library(plotly)
library(ggplot2)
library(scales)
library(fmsb)
library(DescTools)


plotdir="hindcast_ms/summarize_ms/plots/"
datadir="hindcast_ms/extract/extractions/"

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
  
  lines=empty %>% mutate(id=paste0(algorithm,"_",run) %>% as.character()) %>% filter(id=="EcoROMS_run_J.3"|id=="Marxan_run_J.3"|id=="EcoROMS_run_J.5"|id=="Marxan_run_I.6")
  
  dff=empty
  dff$id=paste0(dff$algorithm,"_",dff$run) %>% as.character()
  b=dff %>% gather (variable, value,-c(algorithm,id,run)) %>% .[complete.cases(.),] %>% dplyr::rename(Algorithm=algorithm)
  b$variable=factor(b$variable,levels=c("Leatherback","Swordfish","Blueshark","Sealion"))
  b$Algorithm=gsub("_"," ",b$Algorithm)
  b=with(b, b[order(variable),])
  
  ## master
  aa=ggplot(b, aes(x = variable, y = value, group = id)) +   # group = id is important!
    geom_path(aes(color = Algorithm,linetype=Algorithm),
              alpha = 0.5,
              lineend = 'round', linejoin = 'round') +
    scale_y_continuous(name="Correlation [r]",breaks = seq(-1, 1, by = .1), expand = c(.01, .01)) +scale_x_discrete(name="Species",labels=c("Leatherback"="Leatherback","Swordfish"="Swordfish","Blueshark"="Blueshark","Sealion"="California Sea Lion"), expand = c(.01, .01))+
    scale_size(breaks = NULL, range = c(0, 100))+ggtitle("Comparison of species-algorithm correlations across runs")+
    scale_color_manual("Algorithm",values=c("EcoROMS"="cornflowerblue","Marxan"="darkgoldenrod"))+
    scale_linetype_manual("Algorithm",values=c("EcoROMS"="solid","Marxan"="dashed"))+
    theme(text = element_text(size=5),axis.text = element_text(size=5),legend.position=c(.2,1),legend.justification = c(.9,.9),legend.key.size = unit(.5,'lines'),plot.title = element_text(hjust=0,size=5),plot.margin = margin(.3, 1, .3, .3, "cm"))+
    geom_hline(yintercept = 0)+geom_point(aes(x=1,y=-1),size=2)+geom_point(aes(x=2,y=1),size=2)+geom_point(aes(x=3,y=-1),size=2)+geom_point(aes(x=4,y=-1),size=2)
  
  
  aa
  
  c=b %>% filter(id=="EcoROMS_run_J.3"|id=="Marxan_run_J.3"|id=="EcoROMS_run_J.5"|id=="Marxan_run_I.6") #%>% filter(id=="Marxan_run_J.3") %>%filter(id=="EcoROMS_run_J.5") %>%filter(id=="Marxan_run_I.6")
  c$weighting="Equal"
  c <- within(c, weighting[run == 'run_I.6'] <- 'Targeted')
  c <- within(c, weighting[run == 'run_J.5'] <- 'Targeted')
  
  bb=ggplot(b, aes(x = variable, y = value, group = id)) +   # group = id is important!
    geom_path(alpha = 0.5,
              lineend = 'round', linejoin = 'round', color="gray87") +
    scale_y_continuous(name="Correlation [r]",breaks = seq(-1, 1, by = .1), expand = c(.01, .01)) +scale_x_discrete(name="Species",labels=c("Leatherback"="Leatherback","Swordfish"="Swordfish","Blueshark"="Blueshark","Sealion"="California Sea Lion"), expand = c(.01, .01))+
    scale_size(breaks = NULL, range = c(0, 100))+ggtitle("Top 10 runs if management objective is to equally maximize swordfish catch and avoidance of leatherback, blueshark and sea lion")+
    theme(text = element_text(size=5),axis.text = element_text(size=5),plot.title = element_text(hjust=0,size=5),plot.margin = margin(.3, 1, .3, .3, "cm"))+
    geom_vline(xintercept=c(2,3,4))
  
  bb=bb+
    geom_path(data=c,aes(x = variable, y = value, group = id,color = Algorithm,linetype=weighting))+
    scale_color_manual("Product",values=c("EcoROMS"="cornflowerblue","Marxan"="darkgoldenrod"))+
    scale_linetype_manual("Algorithm",values=c("Equal"="solid","Targeted"="dashed"))+
    guides(color=F)+
    geom_hline(yintercept = 0)+geom_point(aes(x=1,y=-1),size=2)+geom_point(aes(x=2,y=1),size=2)+geom_point(aes(x=3,y=-1),size=2)+geom_point(aes(x=4,y=-1),size=2)
  
  bb
  
png(paste0(plotdir,"parellel_coordinate_plot_even_targeted.png"),width=14, height=3.5, units="in", res=400)
par(ps=10)
par(cex=1)
par(mar=c(4,4,1,1))
print({plot_grid(aa,bb,nrow=1,ncol=2)})
dev.off()


### adding in seasonal component
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
#mar_col=D.5, mar_warm=J.6, eco_cold=L.4, eco_warm=J.6 !!!! this one
a=a %>% filter(id=="Marxan_run_D.5_Cold"|id=="Marxan_run_J.6_Warm"|id=="EcoROMS_run_L.4_Cold"|id=="EcoROMS_run_J.6_Warm")
a=a %>% gather(variable,value,-c(algorithm,run,weighting,id)) %>% rename(Algorithm=algorithm)
a$variable=factor(a$variable,levels=c("Leatherback","Swordfish","Blueshark","Sealion"))
a$Algorithm=gsub("_"," ",a$Algorithm)
a=with(a, a[order(variable),])

bb=ggplot(b, aes(x = variable, y = value, group = id,linetype=Algorithm)) +   # group = id is important!
  geom_path(alpha = 0.5,
            lineend = 'round', linejoin = 'round', color="gray87") +
  scale_y_continuous(name="Correlation [r]",breaks = seq(-1, 1, by = .1), expand = c(.01, .01)) +scale_x_discrete(name="Species",labels=c("Leatherback"="Leatherback","Swordfish"="Swordfish","Blueshark"="Blueshark","Sealion"="California Sea Lion"), expand = c(.01, .01))+
  scale_size(breaks = NULL, range = c(0, 100))+ggtitle("Top 10 runs if management objective is to equally maximize swordfish catch and avoidance of leatherback, blueshark and sea lion")+
  theme(text = element_text(size=5),axis.text = element_text(size=5),plot.title = element_text(hjust=0,size=5),plot.margin = margin(.3, 1, .3, .3, "cm"))+
  geom_vline(xintercept=c(2,3,4))

bb=bb+
  geom_path(data=c,aes(x = variable, y = value, group = id,color = weighting,linetype=Algorithm))+
  scale_color_manual("Stuff",values=c("Equal"="black","Targeted"="darkgoldenrod","Warm"="coral1","Cold"="aquamarine4"))+
  #scale_linetype_manual("Algorithm",values=c("Marxan"="solid","EcoROMS"="dashed"))+
  geom_hline(yintercept = 0)+geom_point(aes(x=1,y=-1),size=2)+geom_point(aes(x=2,y=1),size=2)+geom_point(aes(x=3,y=-1),size=2)+geom_point(aes(x=4,y=-1),size=2)

bb=bb+
  geom_path(data=a,aes(x = variable, y = value, group = id,color = weighting,linetype=Algorithm))+
  scale_linetype_manual("Algorithm",values=c("Marxan"="solid","EcoROMS"="dashed"))+
  scale_color_manual("Stuff",values=c("Equal"="black","Targeted"="darkgoldenrod","Warm"="coral1","Cold"="aquamarine4"))+guides(color=guide_legend(override.aes = list(
    linetype = c(rep("solid", 4)),
    shape = c(16,16,16,16))))+
  guides(shape = guide_legend(override.aes = list( shape = c(16,16,16,16))))+
  geom_hline(yintercept = 0)+geom_point(aes(x=1,y=-1),size=2)+geom_point(aes(x=2,y=1),size=2)+geom_point(aes(x=3,y=-1),size=2)+geom_point(aes(x=4,y=-1),size=2)


bb


png(paste0(plotdir,"parellel_coordinate_plot_even_targeted_temp.png"),width=7, height=3.5, units="in", res=400)
par(ps=10)
par(cex=1)
par(mar=c(4,4,1,1))
print({plot_grid(bb,nrow=1,ncol=1)})
dev.off()



#### table accompanying parallel coordinate plot ####

t=rbind(c,a)

d=t %>% mutate(run=gsub("run_","",run))
d=left_join(d,weightings,by="run")

write.csv(d,paste0(plotdir,"parellel_coordinate_table_plot_even_targeted_temp.csv"))

