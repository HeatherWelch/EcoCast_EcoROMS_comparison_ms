## Figure 2. Understanding the tools' responses to changing management priorities
#Q: How do the weightings affect output for each algorithms
## marxan_raw_unscaled, ecoroms_original_unscaled
## adapted from summarize_ms/histograms3.1.R

source("load_functions.R")
library(scales)
library(magick)
plotdir_ms="./hindcast_ms/resubmission/plots/";#dir.create(plotdir_ms)
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
master=fullon %>% as.data.frame()%>% mutate(blsh=(blshobs+blshtrk)/2) %>% select(-c(X,lon,lat,blshobs,blshtrk)) #%>% select(-c(EcoROMS_original,Marxan_raw)) %>% rename(EcoROMS=EcoROMS_original_unscaled) %>% rename(Marxan=Marxan_raw_unscaled) %>% rename(Swordfish=swor) %>% rename(Leatherback=lbst) %>% rename(Sealion=casl) %>% rename(Blueshark=blsh)
master=master %>% mutate(EcoROMS_original_unscaled=rescale(EcoROMS_original_unscaled,to=c(0,1))) %>% mutate(Marxan_raw_unscaled=rescale(Marxan_raw_unscaled,to=c(0,1)))
detachPackage("bindrcpp")
master=master %>% filter(run=="run_C.3"|run=="run_C.3"|run=="run_E.1"|run=="run_D.4") %>% mutate(run=gsub("run_","",run)) %>% mutate(Year=as.factor(substr(dt,1,4)))%>% mutate("Ocean_state"="Warm")
master <- within(master, Ocean_state[Year == '2003'] <- 'Cold')

master$weighting=NA
master <- within(master, weighting[run == 'C.3'] <- '-0.5/0.5')
master <- within(master, weighting[run == 'E.1'] <- '-0.3/0.7') 
master <- within(master, weighting[run == 'D.4'] <- '-0.7/0.3')

EcoC=master %>% mutate(weighting=as.factor(weighting))

C1=ggplot(EcoC,aes(x=swor,y=EcoROMS_original_unscaled,group=weighting,color=weighting,shape=Ocean_state))+geom_point(aes(alpha=Ocean_state),size=1)+stat_smooth(se=F,method = "gam",formula = y~s(x, bs="cr"))+
  scale_alpha_manual("Ocean State",values = c("Warm"=.3,"Cold"=1))+
  scale_color_manual("Weighting",values=c("+/-0.1"="darkgoldenrod","-0.3/0.7"="darkgoldenrod","-0.5/0.5"="coral1","-0.7/0.3"="dimgray","+/-0.9"="dimgray"))+
  scale_shape_manual("Ocean State",values=c("Warm"=3,"Cold"=15))+
  theme(text = element_text(size=8),axis.text = element_text(size=8),plot.title = element_text(hjust=0,size=8),legend.position=c(.15,.95),legend.justification = c(.9,.9),legend.key.size = unit(.5,'lines'))+
  theme(legend.background = element_blank(),legend.box.background = element_rect(colour = NA),legend.margin=unit(0.3, "lines"))+
  #ggtitle("Effect of equal opposing swordfish/leatherback weightings on the relationship between EcoCast values and swordfish habitat suitability values")+
  ylab("EcoCast output")+xlab("Habitat suitability")+scale_y_continuous(limits = c(0,1))+scale_x_continuous(limits = c(0,1))

C2=ggplot(EcoC,aes(x=swor,y=Marxan_raw_unscaled,group=weighting,color=weighting,shape=Ocean_state))+geom_point(aes(alpha=Ocean_state),size=1)+stat_smooth(se=F,method = "gam",formula = y~s(x, bs="cr"))+
  scale_alpha_manual("Ocean State",values = c("Warm"=.3,"Cold"=1))+
  scale_color_manual("Weighting",values=c("+/-0.1"="darkgoldenrod","-0.3/0.7"="darkgoldenrod","-0.5/0.5"="coral1","-0.7/0.3"="dimgray","+/-0.9"="dimgray"))+
  scale_shape_manual("Ocean State",values=c("Warm"=3,"Cold"=15))+
  theme(text = element_text(size=8),axis.text = element_text(size=8),plot.title = element_text(hjust=0,size=8),legend.position=c(.15,.95),legend.justification = c(.9,.9),legend.key.size = unit(.5,'lines'))+
  theme(legend.background = element_blank(),legend.box.background = element_rect(colour = NA),legend.margin=unit(0.3, "lines"))+
  #ggtitle("Effect of equal opposing swordfish/leatherback weightings between Marxan values and swordfish habitat suitability values")+
  ylab("Marxan output")+xlab("Habitat suitability")+scale_y_continuous(limits = c(0,1))+scale_x_continuous(limits = c(0,1))

C3=ggplot(EcoC,aes(x=lbst,y=EcoROMS_original_unscaled,group=weighting,color=weighting,shape=Ocean_state))+geom_point(aes(alpha=Ocean_state),size=1)+stat_smooth(se=F,method = "gam",formula = y~s(x, bs="cr"))+
  scale_alpha_manual("Ocean State",values = c("Warm"=.3,"Cold"=1))+
  scale_color_manual("Weighting",values=c("+/-0.1"="darkgoldenrod","-0.3/0.7"="darkgoldenrod","-0.5/0.5"="coral1","-0.7/0.3"="dimgray","+/-0.9"="dimgray"))+
  scale_shape_manual("Ocean State",values=c("Warm"=3,"Cold"=15))+
  theme(text = element_text(size=8),axis.text = element_text(size=8),plot.title = element_text(hjust=0,size=8),legend.position=c(.15,.3),legend.justification = c(.9,.9),legend.key.size = unit(.5,'lines'))+
  theme(legend.background = element_blank(),legend.box.background = element_rect(colour = NA),legend.margin=unit(0.3, "lines"))+
  #ggtitle("Effect of equal opposing swordfish/leatherback weightings on the relationship between EcoCast values and leatherback habitat suitability values")+
  ylab("EcoCast output")+xlab("Habitat suitability")+scale_y_continuous(limits = c(0,1))+scale_x_continuous(limits = c(0,1))

C3

C4=ggplot(EcoC,aes(x=lbst,y=Marxan_raw_unscaled,group=weighting,color=weighting,shape=Ocean_state))+geom_point(aes(alpha=Ocean_state),size=1)+stat_smooth(se=F,method = "gam",formula = y~s(x, bs="cr"))+
  scale_alpha_manual("Ocean State",values = c("Warm"=.3,"Cold"=1))+
  scale_color_manual("Weighting",values=c("+/-0.1"="darkgoldenrod","-0.3/0.7"="darkgoldenrod","-0.5/0.5"="coral1","-0.7/0.3"="dimgray","+/-0.9"="dimgray"))+
  scale_shape_manual("Ocean State",values=c("Warm"=3,"Cold"=15))+
  theme(text = element_text(size=8),axis.text = element_text(size=8),plot.title = element_text(hjust=0,size=8),legend.position=c(.95,.95),legend.justification = c(.9,.9),legend.key.size = unit(.5,'lines'))+
  theme(legend.background = element_blank(),legend.box.background = element_rect(colour = NA),legend.margin=unit(0.3, "lines"))+
  #ggtitle("Effect of equal opposing swordfish/leatherback weightings between Marxan values and leatherback habitat suitability values")+
  ylab("Marxan output")+xlab("Habitat suitability")+scale_y_continuous(limits = c(0,1))+scale_x_continuous(limits = c(0,1))

C4

png(paste0(plotdir_ms,"figure2_changing_weightings_temp3.1.png"),width=10, height=8, units="in", res=400)
par(ps=10)
par(cex=1)
par(mar=c(4,4,1,1))
plot_grid(C1,C3,C2,C4,nrow=2,ncol=2)
dev.off()

library(magick)
templateDir="./hindcast_ms/figures.01.10.19/plots/"

file=paste0(plotdir_ms,"figure2_changing_weightings_temp3.1.png")
template=paste0(templateDir,"template.png")

hist=image_read(file)
template=image_read(template)
template2=image_scale(template, "4100")
#hist2=image_scale(hist, "970")
hist2=image_crop(hist,"+50-0") 

a=image_composite(template2,hist2,offset = "+200+240")
a
image_write(a,path = paste0(plotdir_ms,"figure2_changing_weightings_temp3.1.png"))

