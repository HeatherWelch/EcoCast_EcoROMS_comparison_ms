### Figure 4 - how do the tools respond to additional species
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
  master=master %>% filter(run=="run_B.3"|run=="run_C.3"|run=="run_G.3"|run=="run_J.3"|run=="run_M.2"|run=="run_M.4"|run=="run_M.5") %>% mutate(run=gsub("run_","",run)) %>% mutate(Year=as.factor(substr(dt,1,4)))%>% mutate("Ocean_state"="Warm")
  master <- within(master, Ocean_state[Year == '2003'] <- 'Cold')
  
  master$objective=NA
  master <- within(master, objective[run == 'B.3'] <- 'one species_Marxan')
  master <- within(master, objective[run == 'C.3'] <- 'two species_E_M')
  master <- within(master, objective[run == 'G.3'] <- 'three species_Marxan')
  master <- within(master, objective[run == 'J.3'] <- 'four species_Marxan') 
  master <- within(master, objective[run == 'M.2'] <- 'one species_EcoCast')
  master <- within(master, objective[run == 'M.4'] <- 'three species_EcoCast')
  master <- within(master, objective[run == 'M.5'] <- 'four species_EcoCast')
  
  b=master %>% gather(species,sp_value,-c(EcoROMS,Marxan,run,objective,dt,Year,Ocean_state))
  b$inclusion="yes"
  b <- within(b, inclusion[run == 'B.3'& species == 'Swordfish'] <- 'no')
  b <- within(b, inclusion[run == 'B.3'& species == 'Sealion'] <- 'no')
  b <- within(b, inclusion[run == 'B.3'& species == 'Blueshark'] <- 'no')
  b <- within(b, inclusion[run == 'C.3'& species == 'Blueshark'] <- 'no')
  b <- within(b, inclusion[run == 'C.3'& species == 'Sealion'] <- 'no')
  b <- within(b, inclusion[run == 'G.3'& species == 'Sealion'] <- 'no')
  
  b <- within(b, inclusion[run == 'M.2'& species == 'Swordfish'] <- 'no')
  b <- within(b, inclusion[run == 'M.2'& species == 'Sealion'] <- 'no')
  b <- within(b, inclusion[run == 'M.2'& species == 'Blueshark'] <- 'no')
  b <- within(b, inclusion[run == 'M.4'& species == 'Sealion'] <- 'no')
  
  c=b %>% filter(inclusion=="yes")
  
  ##curve
  
  c.1=c %>% filter(objective=="one species_EcoCast")
  a=ggplot(c.1,aes(x=sp_value,y=EcoROMS,group=species,color=species,shape=Ocean_state))+geom_point(aes(alpha=Ocean_state),size=1)+
    scale_alpha_manual("Ocean State",values = c("Warm"=.3,"Cold"=.6))+
    scale_color_manual("Species",values=c("Leatherback"="darkgoldenrod","Swordfish"="cornflowerblue","Blueshark"="coral1","Sealion"="aquamarine4"))+
    scale_shape_manual("Ocean State",values=c("Warm"=3,"Cold"=15))+
    theme(text = element_text(size=5),axis.text = element_text(size=5),plot.title = element_text(hjust=0,size=5),legend.position=c(.1,.85),legend.justification = c(.9,.9),legend.key.size = unit(.5,'lines'))+
    theme(legend.background = element_blank(),legend.box.background = element_rect(color=NA),legend.margin=unit(0.3, "lines"))+
    ylab("EcoCast output")+xlab("Habitat suitability")+ylim(-1,.4)
  a
  A1=a
  
  c.1=c %>% filter(objective=="two species_E_M")
  a=ggplot(c.1,aes(x=sp_value,y=EcoROMS,group=species,color=species,shape=Ocean_state))+geom_point(aes(alpha=Ocean_state),size=1)+stat_smooth(se=F)+
    scale_alpha_manual("Ocean State",values = c("Warm"=.3,"Cold"=.6))+
    scale_color_manual("Species",values=c("Leatherback"="darkgoldenrod","Swordfish"="cornflowerblue","Blueshark"="coral1","Sealion"="aquamarine4"))+
    scale_shape_manual("Ocean State",values=c("Warm"=3,"Cold"=15))+
    theme(text = element_text(size=5),axis.text = element_text(size=5),plot.title = element_text(hjust=0,size=5),legend.position=c(1,.25),legend.justification = c(.9,.9),legend.key.size = unit(.5,'lines'))+
    theme(legend.background = element_blank(),legend.box.background = element_rect(color=NA),legend.margin=unit(0.3, "lines"))+
    ylab("EcoCast output")+xlab("Habitat suitability")+ylim(-1,.4)
  B1=a
  
  c.1=c %>% filter(objective=="three species_EcoCast")
  a=ggplot(c.1,aes(x=sp_value,y=EcoROMS,group=species,color=species,shape=Ocean_state))+geom_point(aes(alpha=Ocean_state),size=1)+stat_smooth(se=F,method = "lm")+
    scale_alpha_manual("Ocean State",values = c("Warm"=.3,"Cold"=.6))+
    scale_color_manual("Species",values=c("Leatherback"="darkgoldenrod","Swordfish"="cornflowerblue","Blueshark"="coral1","Sealion"="aquamarine4"))+
    scale_shape_manual("Ocean State",values=c("Warm"=3,"Cold"=15))+
    theme(text = element_text(size=5),axis.text = element_text(size=5),plot.title = element_text(hjust=0,size=5),legend.position=c(1,.25),legend.justification = c(.9,.9),legend.key.size = unit(.5,'lines'))+
    theme(legend.background = element_blank(),legend.box.background = element_rect(color=NA),legend.margin=unit(0.3, "lines"))+
    ylab("EcoCast output")+xlab("Habitat suitability")+ylim(-1,.4)
  C1=a
  
  c.1=c %>% filter(objective=="four species_EcoCast")
  a=ggplot(c.1,aes(x=sp_value,y=EcoROMS,group=species,color=species,shape=Ocean_state))+geom_point(aes(alpha=Ocean_state),size=1)+stat_smooth(se=F,method = "lm")+
    scale_alpha_manual("Ocean State",values = c("Warm"=.3,"Cold"=.6))+
    scale_color_manual("Species",values=c("Leatherback"="darkgoldenrod","Swordfish"="cornflowerblue","Blueshark"="coral1","Sealion"="aquamarine4"))+
    scale_shape_manual("Ocean State",values=c("Warm"=3,"Cold"=15))+
    theme(text = element_text(size=5),axis.text = element_text(size=5),plot.title = element_text(hjust=0,size=5),legend.position=c(1,.27),legend.justification = c(.9,.9),legend.key.size = unit(.5,'lines'))+
    theme(legend.background = element_blank(),legend.box.background = element_rect(color=NA),legend.margin=unit(0.3, "lines"))+
    ylab("EcoCast output")+xlab("Habitat suitability")+ylim(-1,.4)
  D1=a
  
  c.1=c %>% filter(objective=="one species_Marxan")
  a=ggplot(c.1,aes(x=sp_value,y=Marxan,group=species,color=species,shape=Ocean_state))+geom_point(aes(alpha=Ocean_state),size=1)+stat_smooth(se=F,method = "lm")+
    scale_alpha_manual("Ocean State",values = c("Warm"=.3,"Cold"=.6))+
    scale_color_manual("Species",values=c("Leatherback"="darkgoldenrod","Swordfish"="cornflowerblue","Blueshark"="coral1","Sealion"="aquamarine4"))+
    scale_shape_manual("Ocean State",values=c("Warm"=3,"Cold"=15))+
    theme(text = element_text(size=5),axis.text = element_text(size=5),plot.title = element_text(hjust=0,size=5),legend.position=c(.1,.85),legend.justification = c(.9,.9),legend.key.size = unit(.5,'lines'))+
    theme(legend.background = element_blank(),legend.box.background = element_rect(color=NA),legend.margin=unit(0.3, "lines"))+
    ylab("Marxan output")+xlab("Habitat suitability")+ylim(-1000,0)
  E1=a
  
  c.1=c %>% filter(objective=="two species_E_M")
  a=ggplot(c.1,aes(x=sp_value,y=Marxan,group=species,color=species,shape=Ocean_state))+geom_point(aes(alpha=Ocean_state),size=1)+stat_smooth(se=F,method = "lm")+
    scale_alpha_manual("Ocean State",values = c("Warm"=.3,"Cold"=.6))+
    scale_color_manual("Species",values=c("Leatherback"="darkgoldenrod","Swordfish"="cornflowerblue","Blueshark"="coral1","Sealion"="aquamarine4"))+
    scale_shape_manual("Ocean State",values=c("Warm"=3,"Cold"=15))+
    theme(text = element_text(size=5),axis.text = element_text(size=5),plot.title = element_text(hjust=0,size=5),legend.position=c(1,.25),legend.justification = c(.9,.9),legend.key.size = unit(.5,'lines'))+
    theme(legend.background = element_blank(),legend.box.background = element_rect(color=NA),legend.margin=unit(0.3, "lines"))+
    ylab("Marxan output")+xlab("Habitat suitability")+ylim(-1000,0)
  F1=a
  
  c.1=c %>% filter(objective=="three species_Marxan")
  a=ggplot(c.1,aes(x=sp_value,y=Marxan,group=species,color=species,shape=Ocean_state))+geom_point(aes(alpha=Ocean_state),size=1)+stat_smooth(se=F,method = "lm")+
    scale_alpha_manual("Ocean State",values = c("Warm"=.3,"Cold"=.6))+
    scale_color_manual("Species",values=c("Leatherback"="darkgoldenrod","Swordfish"="cornflowerblue","Blueshark"="coral1","Sealion"="aquamarine4"))+
    scale_shape_manual("Ocean State",values=c("Warm"=3,"Cold"=15))+
    theme(text = element_text(size=5),axis.text = element_text(size=5),plot.title = element_text(hjust=0,size=5),legend.position=c(1,.25),legend.justification = c(.9,.9),legend.key.size = unit(.5,'lines'))+
    theme(legend.background = element_blank(),legend.box.background = element_rect(color=NA),legend.margin=unit(0.3, "lines"))+
    ylab("Marxan output")+xlab("Habitat suitability")+ylim(-1000,0)
  G1=a
  
  c.1=c %>% filter(objective=="four species_Marxan")
  a=ggplot(c.1,aes(x=sp_value,y=Marxan,group=species,color=species,shape=Ocean_state))+geom_point(aes(alpha=Ocean_state),size=1)+stat_smooth(se=F,method = "lm")+
    scale_alpha_manual("Ocean State",values = c("Warm"=.3,"Cold"=.6))+
    scale_color_manual("Species",values=c("Leatherback"="darkgoldenrod","Swordfish"="cornflowerblue","Blueshark"="coral1","Sealion"="aquamarine4"))+
    scale_shape_manual("Ocean State",values=c("Warm"=3,"Cold"=15))+
    theme(text = element_text(size=5),axis.text = element_text(size=5),plot.title = element_text(hjust=0,size=5),legend.position=c(1,1),legend.justification = c(.9,.9),legend.key.size = unit(.5,'lines'))+
    theme(legend.background = element_blank(),legend.box.background = element_rect(color=NA),legend.margin=unit(0.3, "lines"))+
    ylab("Marxan output")+xlab("Habitat suitability")+ylim(-1000,0)
  H1=a
  
  png(paste0(plotdir_ms,"figure4_changing_species_lm.png"),width=20, height=8, units="in", res=400)
  par(ps=10)
  par(cex=1)
  par(mar=c(4,4,1,1))
  plot_grid(A1,B1,C1,D1,E1,F1,G1,H1,nrow=2,ncol=4)
  dev.off()
  
  
  library(magick)
  templateDir="/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/hindcast_ms/summarize_ms/plots/"
  
  file=paste0(plotdir_ms,"figure4_changing_species_lm.png")
  template=paste0(templateDir,"template_#sp.png")
  
  hist=image_read(file)
  template=image_read(template)
  template2=image_scale(template, "8100")
  hist2=image_crop(hist,"+50-0") 
  hist2=image_scale(hist2, "7900")
  
  a=image_composite(template2,hist2,offset = "+200+190")
  a
  image_write(a,path = paste0(plotdir_ms,"figure4_changing_species_lm.png"))
  
  