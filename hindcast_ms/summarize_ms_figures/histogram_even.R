### ecoroms options for managers ### xxx
## no EcoROMS original or marxan raw ###

source("load_functions.R")

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
  master=master %>% filter(run=="run_B.3"|run=="run_C.3"|run=="run_G.3"|run=="run_J.3") %>% mutate(run=gsub("run_","",run)) %>% mutate(Year=as.factor(substr(dt,1,4)))
  
  # runs=as.factor(master$run) %>% unique() %>% as.character()
  # empty=data.frame(Swordfish=NA,Leatherback=NA,Sealion=NA,Blueshark=NA,algorithm=NA,run=NA)
  # for(i in 1:length(runs)){
  #   runn=runs[i]
  #   a=master %>% filter(run==runn) %>% select(-run) %>% cor() %>% .[1:2,3:6] %>% as.data.frame() %>% mutate(algorithm=c("EcoROMS","Marxan")) %>% mutate(run=runn)
  #   empty=rbind(empty,a)
  # }
  # 
  # empty$objective=NA
  # empty <- within(empty, objective[run == 'A.3'] <- 'one species')
  # empty <- within(empty, objective[run == 'B.3'] <- 'one species')
  # empty <- within(empty, objective[run == 'C.3'] <- 'two species')
  # empty <- within(empty, objective[run == 'G.3'] <- 'three species')
  # empty <- within(empty, objective[run == 'J.3'] <- 'four species')
  # 
  # empty=empty[complete.cases(empty),]
  # empty=empty %>% gather(species,correlation,-c(algorithm,run,objective)) %>% dplyr::rename(Algorithm=algorithm)
  # empty$objective=factor(empty$objective,levels=c("one species","two species","three species","four species"))
  # b=empty %>% dplyr::group_by(Algorithm,species,run) %>% summarise(mean=mean(correlation))
  # 
  # a=ggplot(data=empty,aes(x=objective,y=correlation,color=species))+geom_boxplot()+facet_grid(~Algorithm)
  
  ### new idea
  
  master$objective=NA
  master <- within(master, objective[run == 'A.3'] <- 'one species')
  master <- within(master, objective[run == 'B.3'] <- 'one species')
  master <- within(master, objective[run == 'C.3'] <- 'two species')
  master <- within(master, objective[run == 'G.3'] <- 'three species')
  master <- within(master, objective[run == 'J.3'] <- 'four species')
  
  b=master %>% gather(species,sp_value,-c(EcoROMS,Marxan,run,objective,dt,Year))
  b$inclusion="yes"
  b <- within(b, inclusion[run == 'B.3'& species == 'Swordfish'] <- 'no')
  b <- within(b, inclusion[run == 'B.3'& species == 'Sealion'] <- 'no')
  b <- within(b, inclusion[run == 'B.3'& species == 'Blueshark'] <- 'no')
  b <- within(b, inclusion[run == 'C.3'& species == 'Blueshark'] <- 'no')
  b <- within(b, inclusion[run == 'C.3'& species == 'Sealion'] <- 'no')
  b <- within(b, inclusion[run == 'G.3'& species == 'Sealion'] <- 'no')
  
  c=b %>% filter(inclusion=="yes")
  
  c.1=c %>% filter(objective=="one species")
  a=ggplot(c.1,aes(x=sp_value,y=EcoROMS,group=species,color=species,shape=Year))+geom_point(aes(alpha=Year),size=1)+
    scale_alpha_manual("Year",values = c("1997"=.3,"2003"=1,"2005"=.3))+
   scale_color_manual("Species",values=c("Leatherback"="darkgoldenrod","Swordfish"="cornflowerblue","Blueshark"="coral1","Sealion"="aquamarine4"))+
    scale_shape_manual("Year",values=c("1997"=3,"2003"=15,"2005"=4))+
    theme(text = element_text(size=5),axis.text = element_text(size=5),plot.title = element_text(hjust=0,size=5),legend.position=c(.1,.9),legend.justification = c(.9,.9),legend.key.size = unit(.5,'lines'))+
    theme(legend.background = element_blank(),legend.box.background = element_rect(color=NA),legend.margin=unit(0.3, "lines"))+
    ylab("EcoCast")+xlab("Swordfish habitat suitability")
  A1=a
  
  c.1=c %>% filter(objective=="two species")
  a=ggplot(c.1,aes(x=sp_value,y=EcoROMS,group=species,color=species,shape=Year))+geom_point(aes(alpha=Year),size=1)+stat_smooth(se=F,method="lm")+
    scale_alpha_manual("Year",values = c("1997"=.3,"2003"=1,"2005"=.3))+
    scale_color_manual("Species",values=c("Leatherback"="darkgoldenrod","Swordfish"="cornflowerblue","Blueshark"="coral1","Sealion"="aquamarine4"))+
    scale_shape_manual("Year",values=c("1997"=3,"2003"=15,"2005"=4))+
    theme(text = element_text(size=5),axis.text = element_text(size=5),plot.title = element_text(hjust=0,size=5),legend.position=c(.1,.9),legend.justification = c(.9,.9),legend.key.size = unit(.5,'lines'))+
    theme(legend.background = element_blank(),legend.box.background = element_rect(color=NA),legend.margin=unit(0.3, "lines"))+
    ylab("EcoCast")+xlab("Swordfish habitat suitability")
  B1=a
  
  c.1=c %>% filter(objective=="three species")
  a=ggplot(c.1,aes(x=sp_value,y=EcoROMS,group=species,color=species,shape=Year))+geom_point(aes(alpha=Year),size=1)+stat_smooth(se=F,method="lm")+
    scale_alpha_manual("Year",values = c("1997"=.3,"2003"=1,"2005"=.3))+
    scale_color_manual("Species",values=c("Leatherback"="darkgoldenrod","Swordfish"="cornflowerblue","Blueshark"="coral1","Sealion"="aquamarine4"))+
    scale_shape_manual("Year",values=c("1997"=3,"2003"=15,"2005"=4))+
    theme(text = element_text(size=5),axis.text = element_text(size=5),plot.title = element_text(hjust=0,size=5),legend.position=c(.1,.9),legend.justification = c(.9,.9),legend.key.size = unit(.5,'lines'))+
    theme(legend.background = element_blank(),legend.box.background = element_rect(color=NA),legend.margin=unit(0.3, "lines"))+
    ylab("EcoCast")+xlab("Swordfish habitat suitability")
  C1=a
  
  c.1=c %>% filter(objective=="four species")
  a=ggplot(c.1,aes(x=sp_value,y=EcoROMS,group=species,color=species,shape=Year))+geom_point(aes(alpha=Year),size=1)+stat_smooth(se=F,method="lm")+
    scale_alpha_manual("Year",values = c("1997"=.3,"2003"=1,"2005"=.3))+
    scale_color_manual("Species",values=c("Leatherback"="darkgoldenrod","Swordfish"="cornflowerblue","Blueshark"="coral1","Sealion"="aquamarine4"))+
    scale_shape_manual("Year",values=c("1997"=3,"2003"=15,"2005"=4))+
    theme(text = element_text(size=5),axis.text = element_text(size=5),plot.title = element_text(hjust=0,size=5),legend.position=c(.1,.9),legend.justification = c(.9,.9),legend.key.size = unit(.5,'lines'))+
    theme(legend.background = element_blank(),legend.box.background = element_rect(color=NA),legend.margin=unit(0.3, "lines"))+
    ylab("EcoCast")+xlab("Swordfish habitat suitability")
  D1=a
  
  c.1=c %>% filter(objective=="one species")
  a=ggplot(c.1,aes(x=sp_value,y=Marxan,group=species,color=species,shape=Year))+geom_point(aes(alpha=Year),size=1)+
    scale_alpha_manual("Year",values = c("1997"=.3,"2003"=1,"2005"=.3))+
    scale_color_manual("Species",values=c("Leatherback"="darkgoldenrod","Swordfish"="cornflowerblue","Blueshark"="coral1","Sealion"="aquamarine4"))+
    scale_shape_manual("Year",values=c("1997"=3,"2003"=15,"2005"=4))+
    theme(text = element_text(size=5),axis.text = element_text(size=5),plot.title = element_text(hjust=0,size=5),legend.position=c(.1,.9),legend.justification = c(.9,.9),legend.key.size = unit(.5,'lines'))+
    theme(legend.background = element_blank(),legend.box.background = element_rect(color=NA),legend.margin=unit(0.3, "lines"))+
    ylab("EcoCast")+xlab("Swordfish habitat suitability")
  E1=a
  
  c.1=c %>% filter(objective=="two species")
  a=ggplot(c.1,aes(x=sp_value,y=Marxan,group=species,color=species,shape=Year))+geom_point(aes(alpha=Year),size=1)+stat_smooth(se=F,method="lm")+
    scale_alpha_manual("Year",values = c("1997"=.3,"2003"=1,"2005"=.3))+
    scale_color_manual("Species",values=c("Leatherback"="darkgoldenrod","Swordfish"="cornflowerblue","Blueshark"="coral1","Sealion"="aquamarine4"))+
    scale_shape_manual("Year",values=c("1997"=3,"2003"=15,"2005"=4))+
    theme(text = element_text(size=5),axis.text = element_text(size=5),plot.title = element_text(hjust=0,size=5),legend.position=c(.1,.9),legend.justification = c(.9,.9),legend.key.size = unit(.5,'lines'))+
    theme(legend.background = element_blank(),legend.box.background = element_rect(color=NA),legend.margin=unit(0.3, "lines"))+
    ylab("EcoCast")+xlab("Swordfish habitat suitability")
  F1=a
  
  c.1=c %>% filter(objective=="three species")
  a=ggplot(c.1,aes(x=sp_value,y=Marxan,group=species,color=species,shape=Year))+geom_point(aes(alpha=Year),size=1)+stat_smooth(se=F,method="lm")+
    scale_alpha_manual("Year",values = c("1997"=.3,"2003"=1,"2005"=.3))+
    scale_color_manual("Species",values=c("Leatherback"="darkgoldenrod","Swordfish"="cornflowerblue","Blueshark"="coral1","Sealion"="aquamarine4"))+
    scale_shape_manual("Year",values=c("1997"=3,"2003"=15,"2005"=4))+
    theme(text = element_text(size=5),axis.text = element_text(size=5),plot.title = element_text(hjust=0,size=5),legend.position=c(.1,.9),legend.justification = c(.9,.9),legend.key.size = unit(.5,'lines'))+
    theme(legend.background = element_blank(),legend.box.background = element_rect(color=NA),legend.margin=unit(0.3, "lines"))+
    ylab("EcoCast")+xlab("Swordfish habitat suitability")
  G1=a
  
  c.1=c %>% filter(objective=="four species")
  a=ggplot(c.1,aes(x=sp_value,y=Marxan,group=species,color=species,shape=Year))+geom_point(aes(alpha=Year),size=1)+stat_smooth(se=F,method="lm")+
    scale_alpha_manual("Year",values = c("1997"=.3,"2003"=1,"2005"=.3))+
    scale_color_manual("Species",values=c("Leatherback"="darkgoldenrod","Swordfish"="cornflowerblue","Blueshark"="coral1","Sealion"="aquamarine4"))+
    scale_shape_manual("Year",values=c("1997"=3,"2003"=15,"2005"=4))+
    theme(text = element_text(size=5),axis.text = element_text(size=5),plot.title = element_text(hjust=0,size=5),legend.position=c(.1,.9),legend.justification = c(.9,.9),legend.key.size = unit(.5,'lines'))+
    theme(legend.background = element_blank(),legend.box.background = element_rect(color=NA),legend.margin=unit(0.3, "lines"))+
    ylab("EcoCast")+xlab("Swordfish habitat suitability")
  H1=a
  
  png(paste0(plotdir_ms,"histograms_even.png"),width=20, height=8, units="in", res=400)
  par(ps=10)
  par(cex=1)
  par(mar=c(4,4,1,1))
  plot_grid(A1,B1,C1,D1,E1,F1,G1,H1,nrow=2,ncol=4)
  dev.off()
  
  ##curve
  
  c.1=c %>% filter(objective=="one species")
  a=ggplot(c.1,aes(x=sp_value,y=EcoROMS,group=species,color=species,shape=Year))+geom_point(aes(alpha=Year),size=1)+
    scale_alpha_manual("Year",values = c("1997"=.3,"2003"=1,"2005"=.3))+
    scale_color_manual("Species",values=c("Leatherback"="darkgoldenrod","Swordfish"="cornflowerblue","Blueshark"="coral1","Sealion"="aquamarine4"))+
    scale_shape_manual("Year",values=c("1997"=3,"2003"=15,"2005"=4))+
    theme(text = element_text(size=5),axis.text = element_text(size=5),plot.title = element_text(hjust=0,size=5),legend.position=c(.1,.9),legend.justification = c(.9,.9),legend.key.size = unit(.5,'lines'))+
    theme(legend.background = element_blank(),legend.box.background = element_rect(color=NA),legend.margin=unit(0.3, "lines"))+
    ylab("EcoCast")+xlab("Swordfish habitat suitability")
  A1=a
  
  c.1=c %>% filter(objective=="two species")
  a=ggplot(c.1,aes(x=sp_value,y=EcoROMS,group=species,color=species,shape=Year))+geom_point(aes(alpha=Year),size=1)+stat_smooth(se=F)+
    scale_alpha_manual("Year",values = c("1997"=.3,"2003"=1,"2005"=.3))+
    scale_color_manual("Species",values=c("Leatherback"="darkgoldenrod","Swordfish"="cornflowerblue","Blueshark"="coral1","Sealion"="aquamarine4"))+
    scale_shape_manual("Year",values=c("1997"=3,"2003"=15,"2005"=4))+
    theme(text = element_text(size=5),axis.text = element_text(size=5),plot.title = element_text(hjust=0,size=5),legend.position=c(.1,.9),legend.justification = c(.9,.9),legend.key.size = unit(.5,'lines'))+
    theme(legend.background = element_blank(),legend.box.background = element_rect(color=NA),legend.margin=unit(0.3, "lines"))+
    ylab("EcoCast")+xlab("Swordfish habitat suitability")
  B1=a
  
  c.1=c %>% filter(objective=="three species")
  a=ggplot(c.1,aes(x=sp_value,y=EcoROMS,group=species,color=species,shape=Year))+geom_point(aes(alpha=Year),size=1)+stat_smooth(se=F)+
    scale_alpha_manual("Year",values = c("1997"=.3,"2003"=1,"2005"=.3))+
    scale_color_manual("Species",values=c("Leatherback"="darkgoldenrod","Swordfish"="cornflowerblue","Blueshark"="coral1","Sealion"="aquamarine4"))+
    scale_shape_manual("Year",values=c("1997"=3,"2003"=15,"2005"=4))+
    theme(text = element_text(size=5),axis.text = element_text(size=5),plot.title = element_text(hjust=0,size=5),legend.position=c(.1,.9),legend.justification = c(.9,.9),legend.key.size = unit(.5,'lines'))+
    theme(legend.background = element_blank(),legend.box.background = element_rect(color=NA),legend.margin=unit(0.3, "lines"))+
    ylab("EcoCast")+xlab("Swordfish habitat suitability")
  C1=a
  
  c.1=c %>% filter(objective=="four species")
  a=ggplot(c.1,aes(x=sp_value,y=EcoROMS,group=species,color=species,shape=Year))+geom_point(aes(alpha=Year),size=1)+stat_smooth(se=F)+
    scale_alpha_manual("Year",values = c("1997"=.3,"2003"=1,"2005"=.3))+
    scale_color_manual("Species",values=c("Leatherback"="darkgoldenrod","Swordfish"="cornflowerblue","Blueshark"="coral1","Sealion"="aquamarine4"))+
    scale_shape_manual("Year",values=c("1997"=3,"2003"=15,"2005"=4))+
    theme(text = element_text(size=5),axis.text = element_text(size=5),plot.title = element_text(hjust=0,size=5),legend.position=c(.1,.9),legend.justification = c(.9,.9),legend.key.size = unit(.5,'lines'))+
    theme(legend.background = element_blank(),legend.box.background = element_rect(color=NA),legend.margin=unit(0.3, "lines"))+
    ylab("EcoCast")+xlab("Swordfish habitat suitability")
  D1=a
  
  c.1=c %>% filter(objective=="one species")
  a=ggplot(c.1,aes(x=sp_value,y=Marxan,group=species,color=species,shape=Year))+geom_point(aes(alpha=Year),size=1)+stat_smooth(se=F)+
    scale_alpha_manual("Year",values = c("1997"=.3,"2003"=1,"2005"=.3))+
    scale_color_manual("Species",values=c("Leatherback"="darkgoldenrod","Swordfish"="cornflowerblue","Blueshark"="coral1","Sealion"="aquamarine4"))+
    scale_shape_manual("Year",values=c("1997"=3,"2003"=15,"2005"=4))+
    theme(text = element_text(size=5),axis.text = element_text(size=5),plot.title = element_text(hjust=0,size=5),legend.position=c(.1,.9),legend.justification = c(.9,.9),legend.key.size = unit(.5,'lines'))+
    theme(legend.background = element_blank(),legend.box.background = element_rect(color=NA),legend.margin=unit(0.3, "lines"))+
    ylab("EcoCast")+xlab("Swordfish habitat suitability")
  E1=a
  
  c.1=c %>% filter(objective=="two species")
  a=ggplot(c.1,aes(x=sp_value,y=Marxan,group=species,color=species,shape=Year))+geom_point(aes(alpha=Year),size=1)+stat_smooth(se=F)+
    scale_alpha_manual("Year",values = c("1997"=.3,"2003"=1,"2005"=.3))+
    scale_color_manual("Species",values=c("Leatherback"="darkgoldenrod","Swordfish"="cornflowerblue","Blueshark"="coral1","Sealion"="aquamarine4"))+
    scale_shape_manual("Year",values=c("1997"=3,"2003"=15,"2005"=4))+
    theme(text = element_text(size=5),axis.text = element_text(size=5),plot.title = element_text(hjust=0,size=5),legend.position=c(.1,.9),legend.justification = c(.9,.9),legend.key.size = unit(.5,'lines'))+
    theme(legend.background = element_blank(),legend.box.background = element_rect(color=NA),legend.margin=unit(0.3, "lines"))+
    ylab("EcoCast")+xlab("Swordfish habitat suitability")
  F1=a
  
  c.1=c %>% filter(objective=="three species")
  a=ggplot(c.1,aes(x=sp_value,y=Marxan,group=species,color=species,shape=Year))+geom_point(aes(alpha=Year),size=1)+stat_smooth(se=F)+
    scale_alpha_manual("Year",values = c("1997"=.3,"2003"=1,"2005"=.3))+
    scale_color_manual("Species",values=c("Leatherback"="darkgoldenrod","Swordfish"="cornflowerblue","Blueshark"="coral1","Sealion"="aquamarine4"))+
    scale_shape_manual("Year",values=c("1997"=3,"2003"=15,"2005"=4))+
    theme(text = element_text(size=5),axis.text = element_text(size=5),plot.title = element_text(hjust=0,size=5),legend.position=c(.1,.9),legend.justification = c(.9,.9),legend.key.size = unit(.5,'lines'))+
    theme(legend.background = element_blank(),legend.box.background = element_rect(color=NA),legend.margin=unit(0.3, "lines"))+
    ylab("EcoCast")+xlab("Swordfish habitat suitability")
  G1=a
  
  c.1=c %>% filter(objective=="four species")
  a=ggplot(c.1,aes(x=sp_value,y=Marxan,group=species,color=species,shape=Year))+geom_point(aes(alpha=Year),size=1)+stat_smooth(se=F)+
    scale_alpha_manual("Year",values = c("1997"=.3,"2003"=1,"2005"=.3))+
    scale_color_manual("Species",values=c("Leatherback"="darkgoldenrod","Swordfish"="cornflowerblue","Blueshark"="coral1","Sealion"="aquamarine4"))+
    scale_shape_manual("Year",values=c("1997"=3,"2003"=15,"2005"=4))+
    theme(text = element_text(size=5),axis.text = element_text(size=5),plot.title = element_text(hjust=0,size=5),legend.position=c(.1,.9),legend.justification = c(.9,.9),legend.key.size = unit(.5,'lines'))+
    theme(legend.background = element_blank(),legend.box.background = element_rect(color=NA),legend.margin=unit(0.3, "lines"))+
    ylab("EcoCast")+xlab("Swordfish habitat suitability")
  H1=a
  
  png(paste0(plotdir_ms,"histograms_even_curve.png"),width=20, height=8, units="in", res=400)
  par(ps=10)
  par(cex=1)
  par(mar=c(4,4,1,1))
  plot_grid(A1,B1,C1,D1,E1,F1,G1,H1,nrow=2,ncol=4)
  dev.off()
  
  
  ##seperate trendline
  c$temp="Warm"
  c <- within(c, temp[Year == '2003'] <- 'Cold')
  c$sp_temp=paste0(c$species,"_",c$temp)
  
  c.1=c %>% filter(objective=="one species")
  a=ggplot(c.1,aes(x=sp_value,y=EcoROMS,group=species,color=species,shape=Year))+geom_point(aes(alpha=Year),size=1)+
    scale_alpha_manual("Year",values = c("1997"=.3,"2003"=1,"2005"=.3))+
    scale_color_manual("Species",values=c("Leatherback"="darkgoldenrod","Swordfish"="cornflowerblue","Blueshark"="coral1","Sealion"="aquamarine4"))+
    scale_shape_manual("Year",values=c("1997"=3,"2003"=15,"2005"=4))+
    theme(text = element_text(size=5),axis.text = element_text(size=5),plot.title = element_text(hjust=0,size=5),legend.position=c(.1,.9),legend.justification = c(.9,.9),legend.key.size = unit(.5,'lines'))+
    theme(legend.background = element_blank(),legend.box.background = element_rect(color=NA),legend.margin=unit(0.3, "lines"))+
    ylab("EcoCast")+xlab("Swordfish habitat suitability")
  A1=a
  
  c.1=c %>% filter(objective=="two species")
  a=ggplot(c.1,aes(x=sp_value,y=EcoROMS,group=species,color=species,shape=Year))+geom_point(aes(alpha=Year),size=1)+stat_smooth(aes(group=sp_temp,linetype=temp),se=F)+
    scale_alpha_manual("Year",values = c("1997"=.3,"2003"=1,"2005"=.3))+
    scale_color_manual("Species",values=c("Leatherback"="darkgoldenrod","Swordfish"="cornflowerblue","Blueshark"="coral1","Sealion"="aquamarine4"))+
    scale_shape_manual("Year",values=c("1997"=3,"2003"=15,"2005"=4))+
    theme(text = element_text(size=5),axis.text = element_text(size=5),plot.title = element_text(hjust=0,size=5),legend.position=c(.1,.9),legend.justification = c(.9,.9),legend.key.size = unit(.5,'lines'))+
    theme(legend.background = element_blank(),legend.box.background = element_rect(color=NA),legend.margin=unit(0.3, "lines"))+
    ylab("EcoCast")+xlab("Swordfish habitat suitability")
  B1=a
  
  c.1=c %>% filter(objective=="three species")
  a=ggplot(c.1,aes(x=sp_value,y=EcoROMS,group=species,color=species,shape=Year))+geom_point(aes(alpha=Year),size=1)+stat_smooth(aes(group=sp_temp,linetype=temp),se=F)+
    scale_alpha_manual("Year",values = c("1997"=.3,"2003"=1,"2005"=.3))+
    scale_color_manual("Species",values=c("Leatherback"="darkgoldenrod","Swordfish"="cornflowerblue","Blueshark"="coral1","Sealion"="aquamarine4"))+
    scale_shape_manual("Year",values=c("1997"=3,"2003"=15,"2005"=4))+
    theme(text = element_text(size=5),axis.text = element_text(size=5),plot.title = element_text(hjust=0,size=5),legend.position=c(.1,.9),legend.justification = c(.9,.9),legend.key.size = unit(.5,'lines'))+
    theme(legend.background = element_blank(),legend.box.background = element_rect(color=NA),legend.margin=unit(0.3, "lines"))+
    ylab("EcoCast")+xlab("Swordfish habitat suitability")
  C1=a
  
  c.1=c %>% filter(objective=="four species")
  a=ggplot(c.1,aes(x=sp_value,y=EcoROMS,group=species,color=species,shape=Year))+geom_point(aes(alpha=Year),size=1)+stat_smooth(aes(group=sp_temp,linetype=temp),se=F)+
    scale_alpha_manual("Year",values = c("1997"=.3,"2003"=1,"2005"=.3))+
    scale_color_manual("Species",values=c("Leatherback"="darkgoldenrod","Swordfish"="cornflowerblue","Blueshark"="coral1","Sealion"="aquamarine4"))+
    scale_shape_manual("Year",values=c("1997"=3,"2003"=15,"2005"=4))+
    theme(text = element_text(size=5),axis.text = element_text(size=5),plot.title = element_text(hjust=0,size=5),legend.position=c(.1,.9),legend.justification = c(.9,.9),legend.key.size = unit(.5,'lines'))+
    theme(legend.background = element_blank(),legend.box.background = element_rect(color=NA),legend.margin=unit(0.3, "lines"))+
    ylab("EcoCast")+xlab("Swordfish habitat suitability")
  D1=a
  
  c.1=c %>% filter(objective=="one species")
  a=ggplot(c.1,aes(x=sp_value,y=Marxan,group=species,color=species,shape=Year))+geom_point(aes(alpha=Year),size=1)+stat_smooth(aes(group=sp_temp,linetype=temp),se=F)+
    scale_alpha_manual("Year",values = c("1997"=.3,"2003"=1,"2005"=.3))+
    scale_color_manual("Species",values=c("Leatherback"="darkgoldenrod","Swordfish"="cornflowerblue","Blueshark"="coral1","Sealion"="aquamarine4"))+
    scale_shape_manual("Year",values=c("1997"=3,"2003"=15,"2005"=4))+
    theme(text = element_text(size=5),axis.text = element_text(size=5),plot.title = element_text(hjust=0,size=5),legend.position=c(.1,.9),legend.justification = c(.9,.9),legend.key.size = unit(.5,'lines'))+
    theme(legend.background = element_blank(),legend.box.background = element_rect(color=NA),legend.margin=unit(0.3, "lines"))+
    ylab("EcoCast")+xlab("Swordfish habitat suitability")
  E1=a
  
  c.1=c %>% filter(objective=="two species")
  a=ggplot(c.1,aes(x=sp_value,y=Marxan,group=species,color=species,shape=Year))+geom_point(aes(alpha=Year),size=1)+stat_smooth(aes(group=sp_temp,linetype=temp),se=F)+
    scale_alpha_manual("Year",values = c("1997"=.3,"2003"=1,"2005"=.3))+
    scale_color_manual("Species",values=c("Leatherback"="darkgoldenrod","Swordfish"="cornflowerblue","Blueshark"="coral1","Sealion"="aquamarine4"))+
    scale_shape_manual("Year",values=c("1997"=3,"2003"=15,"2005"=4))+
    theme(text = element_text(size=5),axis.text = element_text(size=5),plot.title = element_text(hjust=0,size=5),legend.position=c(.1,.9),legend.justification = c(.9,.9),legend.key.size = unit(.5,'lines'))+
    theme(legend.background = element_blank(),legend.box.background = element_rect(color=NA),legend.margin=unit(0.3, "lines"))+
    ylab("EcoCast")+xlab("Swordfish habitat suitability")
  F1=a
  
  c.1=c %>% filter(objective=="three species")
  a=ggplot(c.1,aes(x=sp_value,y=Marxan,group=species,color=species,shape=Year))+geom_point(aes(alpha=Year),size=1)+stat_smooth(aes(group=sp_temp,linetype=temp),se=F)+
    scale_alpha_manual("Year",values = c("1997"=.3,"2003"=1,"2005"=.3))+
    scale_color_manual("Species",values=c("Leatherback"="darkgoldenrod","Swordfish"="cornflowerblue","Blueshark"="coral1","Sealion"="aquamarine4"))+
    scale_shape_manual("Year",values=c("1997"=3,"2003"=15,"2005"=4))+
    theme(text = element_text(size=5),axis.text = element_text(size=5),plot.title = element_text(hjust=0,size=5),legend.position=c(.1,.9),legend.justification = c(.9,.9),legend.key.size = unit(.5,'lines'))+
    theme(legend.background = element_blank(),legend.box.background = element_rect(color=NA),legend.margin=unit(0.3, "lines"))+
    ylab("EcoCast")+xlab("Swordfish habitat suitability")
  G1=a
  
  c.1=c %>% filter(objective=="four species")
  a=ggplot(c.1,aes(x=sp_value,y=Marxan,group=species,color=species,shape=Year))+geom_point(aes(alpha=Year),size=1)+stat_smooth(aes(group=sp_temp,linetype=temp),se=F)+
    scale_alpha_manual("Year",values = c("1997"=.3,"2003"=1,"2005"=.3))+
    scale_color_manual("Species",values=c("Leatherback"="darkgoldenrod","Swordfish"="cornflowerblue","Blueshark"="coral1","Sealion"="aquamarine4"))+
    scale_shape_manual("Year",values=c("1997"=3,"2003"=15,"2005"=4))+
    theme(text = element_text(size=5),axis.text = element_text(size=5),plot.title = element_text(hjust=0,size=5),legend.position=c(.1,.9),legend.justification = c(.9,.9),legend.key.size = unit(.5,'lines'))+
    theme(legend.background = element_blank(),legend.box.background = element_rect(color=NA),legend.margin=unit(0.3, "lines"))+
    ylab("EcoCast")+xlab("Swordfish habitat suitability")
  H1=a
  
  png(paste0(plotdir_ms,"histograms_even_curve_split.png"),width=20, height=8, units="in", res=400)
  par(ps=10)
  par(cex=1)
  par(mar=c(4,4,1,1))
  plot_grid(A1,B1,C1,D1,E1,F1,G1,H1,nrow=2,ncol=4)
  dev.off()