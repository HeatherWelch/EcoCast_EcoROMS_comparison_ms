## Figure 1: ECDF plots
#Q: How do the weightings affect output for each algorithms
## marxan_raw, ecoroms_original_unscaled
## same as histograms 3, but cold year (2003) only

source("load_functions.R")
library(scales)
plotdir_ms="~/Dropbox/EcoEast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/hindcast_ms/summarize_ms/plots/"#;dir.create(plotdir_ms)

## scenario A--> isolating the effect of swordfish weightings (5 runs, weightings are the same for both algorithms) (run) #### 
one=read.csv("hindcast_ms/extract/extractions/run_A.1.csv") %>% mutate(weighting=.1)
two=read.csv("hindcast_ms/extract/extractions/run_A.2.csv") %>% mutate(weighting=.3)
three=read.csv("hindcast_ms/extract/extractions/run_A.3.csv") %>% mutate(weighting=.5)
four=read.csv("hindcast_ms/extract/extractions/run_A.4.csv") %>% mutate(weighting=.7)
five=read.csv("hindcast_ms/extract/extractions/run_A.5.csv") %>% mutate(weighting=.9)

dataframelist=list(one,two,three,four,five)
dataframelist=do.call("rbind",dataframelist)
dataframelist=dataframelist %>% mutate(weighting=as.factor(weighting)) %>% mutate(EcoROMS_original_unscaled=rescale(EcoROMS_original_unscaled,to=c(-1,1))) %>% mutate(Year=as.factor(substr(dt,1,4))) %>% filter(Year=="2003")

## scenario B --> isolating the effect of leatherback weightings (5 runs, weightings are the same for both algorithms) (run) #### 
oneB=read.csv("hindcast_ms/extract/extractions/run_B.1.csv") %>% mutate(weighting=-0.1)
twoB=read.csv("hindcast_ms/extract/extractions/run_B.2.csv") %>% mutate(weighting=-0.3)
threeB=read.csv("hindcast_ms/extract/extractions/run_B.3.csv") %>% mutate(weighting=-0.5)
fourB=read.csv("hindcast_ms/extract/extractions/run_B.4.csv") %>% mutate(weighting=-0.7)
fiveB=read.csv("hindcast_ms/extract/extractions/run_B.5.csv") %>% mutate(weighting=-0.9)

dataframelistB=list(oneB,twoB,threeB,fourB,fiveB)
dataframelistB=do.call("rbind",dataframelistB)
dataframelistB=dataframelistB %>% mutate(weighting=as.factor(weighting)) %>% mutate(EcoROMS_original_unscaled=rescale(EcoROMS_original_unscaled,to=c(-1,1))) %>% mutate(Year=as.factor(substr(dt,1,4))) %>% filter(Year=="2003")

# scenario C--> testing the ability to manage swordfish and leatherback equally (5 runs, weightings are the same for both algorithms) (run) ####
oneC=read.csv("hindcast_ms/extract/extractions/run_C.1.csv") %>% mutate(weighting="+/-0.1")
twoC=read.csv("hindcast_ms/extract/extractions/run_C.2.csv") %>% mutate(weighting="+/-0.3")
threeC=read.csv("hindcast_ms/extract/extractions/run_C.3.csv") %>% mutate(weighting="+/-0.5")
fourC=read.csv("hindcast_ms/extract/extractions/run_C.4.csv") %>% mutate(weighting="+/-0.7")
fiveC=read.csv("hindcast_ms/extract/extractions/run_C.5.csv") %>% mutate(weighting="+/-0.9")

dataframelistC=list(oneC,twoC,threeC,fourC,fiveC)
dataframelistC=do.call("rbind",dataframelistC)
dataframelistC=dataframelistC %>% mutate(weighting=as.factor(weighting)) %>% mutate(EcoROMS_original_unscaled=rescale(EcoROMS_original_unscaled,to=c(-1,1))) %>% mutate(Year=as.factor(substr(dt,1,4))) %>% filter(Year=="2003")

## A
A1=ggplot(dataframelist,aes(x=swor,y=EcoROMS_original_unscaled,group=weighting,color=weighting,shape=Year))+geom_point(aes(alpha=Year),size=1)+
  scale_alpha_manual("Year",values = c("1997"=.3,"2003"=1,"2005"=.3))+
  scale_color_manual("Weighting",values=c("0.1"="darkgoldenrod","0.3"="cornflowerblue","0.5"="coral1","0.7"="aquamarine4","0.9"="dimgray"))+
  scale_shape_manual("Year",values=c("1997"=3,"2003"=15,"2005"=4))+
  theme(text = element_text(size=5),axis.text = element_text(size=5),plot.title = element_text(hjust=0,size=5),legend.position=c(.1,.9),legend.justification = c(.9,.9),legend.key.size = unit(.5,'lines'))+
  theme(legend.background = element_blank(),legend.box.background = element_rect(color=NA),legend.margin=unit(0.3, "lines"))+
  #ggtitle("Relationship between EcoCast values and swordfish habitat suitability values under increasing swordfish weightings")+
  #ggtitle("Effect of increasing swordfish weighting on the relationship between EcoCast values and swordfish habitat suitability values")+
  ylab("EcoCast")+xlab("Swordfish habitat suitability")

A1

A2=ggplot(dataframelist,aes(x=swor,y=Marxan_raw,group=weighting,color=weighting,shape=Year))+geom_point(aes(alpha=Year),size=1)+stat_smooth(se=F)+
  scale_alpha_manual("Year",values = c("1997"=.3,"2003"=.6,"2005"=.3))+
  scale_color_manual("Weighting",values=c("0.1"="darkgoldenrod","0.3"="cornflowerblue","0.5"="coral1","0.7"="aquamarine4","0.9"="dimgray"))+
  scale_shape_manual("Year",values=c("1997"=3,"2003"=15,"2005"=4))+
  theme(text = element_text(size=5),axis.text = element_text(size=5),plot.title = element_text(hjust=0,size=5),legend.position=c(.1,.9),legend.justification = c(.9,.9),legend.key.size = unit(.5,'lines'))+
  theme(legend.background = element_blank(),legend.box.background = element_rect(color=NA),legend.margin=unit(0.3, "lines"))+
  #ggtitle("Effect of increasing swordfish weighting on the relationship between Marxan values and swordfish habitat suitability values")+
  ylab("Marxan")+xlab("Swordfish habitat suitability")+scale_y_continuous(limits = c(-1, 1))

A2
## B
B1=ggplot(dataframelistB,aes(x=lbst,y=EcoROMS_original_unscaled,group=weighting,color=weighting,shape=Year))+geom_point(aes(alpha=Year),size=1)+
  scale_alpha_manual("Year",values = c("1997"=.3,"2003"=.6,"2005"=.3))+
  scale_color_manual("Weighting",values=c("-0.1"="darkgoldenrod","-0.3"="cornflowerblue","-0.5"="coral1","-0.7"="aquamarine4","-0.9"="dimgray"))+
  scale_shape_manual("Year",values=c("1997"=3,"2003"=15,"2005"=4))+
  theme(text = element_text(size=5),axis.text = element_text(size=5),plot.title = element_text(hjust=0,size=5),legend.position=c(.1,.35),legend.justification = c(.9,.9),legend.key.size = unit(.5,'lines'))+
  theme(legend.background = element_blank(),legend.box.background = element_rect(colour = NA),legend.margin=unit(0.3, "lines"))+
  #ggtitle("Effect of decreasing leatherback weighting on the relationship between EcoCast values and leatherback habitat suitability values")+
  ylab("EcoCast")+xlab("Leatherback habitat suitability")

B2=ggplot(dataframelistB,aes(x=lbst,y=Marxan_raw,group=weighting,color=weighting,shape=Year))+geom_point(aes(alpha=Year),size=1)+stat_smooth(se=F)+
  scale_alpha_manual("Year",values = c("1997"=.3,"2003"=.6,"2005"=.3))+
  scale_color_manual("Weighting",values=c("-0.1"="darkgoldenrod","-0.3"="cornflowerblue","-0.5"="coral1","-0.7"="aquamarine4","-0.9"="dimgray"))+
  scale_shape_manual("Year",values=c("1997"=3,"2003"=15,"2005"=4))+
  theme(text = element_text(size=5),axis.text = element_text(size=5),plot.title = element_text(hjust=0,size=5),legend.position=c(.9,.9),legend.justification = c(.9,.9),legend.key.size = unit(.5,'lines'))+
  theme(legend.background = element_blank(),legend.box.background = element_rect(colour = NA),legend.margin=unit(0.3, "lines"))+
  #ggtitle("Effect of decreasing leatherback weighting on the relationship between Marxan values and leatherback habitat suitability values")+
  ylab("Marxan")+xlab("Leatherback habitat suitability")+scale_y_continuous(limits = c(-1, 0))

## C
C1=ggplot(dataframelistC,aes(x=swor,y=EcoROMS_original_unscaled,group=weighting,color=weighting,shape=Year))+geom_point(aes(alpha=Year),size=1)+stat_smooth(se=F)+
  scale_alpha_manual("Year",values = c("1997"=.3,"2003"=.6,"2005"=.3))+
  scale_color_manual("Weighting",values=c("+/-0.1"="darkgoldenrod","+/-0.3"="cornflowerblue","+/-0.5"="coral1","+/-0.7"="aquamarine4","+/-0.9"="dimgray"))+
  scale_shape_manual("Year",values=c("1997"=3,"2003"=15,"2005"=4))+
  theme(text = element_text(size=5),axis.text = element_text(size=5),plot.title = element_text(hjust=0,size=5),legend.position=c(.1,.9),legend.justification = c(.9,.9),legend.key.size = unit(.5,'lines'))+
  theme(legend.background = element_blank(),legend.box.background = element_rect(colour = NA),legend.margin=unit(0.3, "lines"))+
  #ggtitle("Effect of equal opposing swordfish/leatherback weightings on the relationship between EcoCast values and swordfish habitat suitability values")+
  ylab("EcoCast")+xlab("Swordfish habitat suitability")

C2=ggplot(dataframelistC,aes(x=swor,y=Marxan_raw,group=weighting,color=weighting,shape=Year))+geom_point(aes(alpha=Year),size=1)+stat_smooth(se=F)+
  scale_alpha_manual("Year",values = c("1997"=.3,"2003"=.6,"2005"=.3))+
  scale_color_manual("Weighting",values=c("+/-0.1"="darkgoldenrod","+/-0.3"="cornflowerblue","+/-0.5"="coral1","+/-0.7"="aquamarine4","+/-0.9"="dimgray"))+
  scale_shape_manual("Year",values=c("1997"=3,"2003"=15,"2005"=4))+
  theme(text = element_text(size=5),axis.text = element_text(size=5),plot.title = element_text(hjust=0,size=5),legend.position=c(.1,.9),legend.justification = c(.9,.9),legend.key.size = unit(.5,'lines'))+
  theme(legend.background = element_blank(),legend.box.background = element_rect(colour = NA),legend.margin=unit(0.3, "lines"))+
  #ggtitle("Effect of equal opposing swordfish/leatherback weightings between Marxan values and swordfish habitat suitability values")+
  ylab("Marxan")+xlab("Swordfish habitat suitability")+scale_y_continuous(limits = c(-1, 1))

C3=ggplot(dataframelistC,aes(x=lbst,y=EcoROMS_original_unscaled,group=weighting,color=weighting,shape=Year))+geom_point(aes(alpha=Year),size=1)+stat_smooth(se=F)+
  scale_alpha_manual("Year",values = c("1997"=.3,"2003"=.6,"2005"=.3))+
  scale_color_manual("Weighting",values=c("+/-0.1"="darkgoldenrod","+/-0.3"="cornflowerblue","+/-0.5"="coral1","+/-0.7"="aquamarine4","+/-0.9"="dimgray"))+
  scale_shape_manual("Year",values=c("1997"=3,"2003"=15,"2005"=4))+
  theme(text = element_text(size=5),axis.text = element_text(size=5),plot.title = element_text(hjust=0,size=5),legend.position=c(.1,.35),legend.justification = c(.9,.9),legend.key.size = unit(.5,'lines'))+
  theme(legend.background = element_blank(),legend.box.background = element_rect(colour = NA),legend.margin=unit(0.3, "lines"))+
  #ggtitle("Effect of equal opposing swordfish/leatherback weightings on the relationship between EcoCast values and leatherback habitat suitability values")+
  ylab("EcoCast")+xlab("Leatherback habitat suitability")

C4=ggplot(dataframelistC,aes(x=lbst,y=Marxan_raw,group=weighting,color=weighting,shape=Year))+geom_point(aes(alpha=Year),size=1)+stat_smooth(se=F)+
  scale_alpha_manual("Year",values = c("1997"=.3,"2003"=.6,"2005"=.3))+
  scale_color_manual("Weighting",values=c("+/-0.1"="darkgoldenrod","+/-0.3"="cornflowerblue","+/-0.5"="coral1","+/-0.7"="aquamarine4","+/-0.9"="dimgray"))+
  scale_shape_manual("Year",values=c("1997"=3,"2003"=15,"2005"=4))+
  theme(text = element_text(size=5),axis.text = element_text(size=5),plot.title = element_text(hjust=0,size=5),legend.position=c(.9,.9),legend.justification = c(.9,.9),legend.key.size = unit(.5,'lines'))+
  theme(legend.background = element_blank(),legend.box.background = element_rect(colour = NA),legend.margin=unit(0.3, "lines"))+
  #ggtitle("Effect of equal opposing swordfish/leatherback weightings between Marxan values and leatherback habitat suitability values")+
  ylab("Marxan")+xlab("Leatherback habitat suitability")+scale_y_continuous(limits = c(-1, 1))

png(paste0(plotdir_ms,"histograms5.png"),width=20, height=8, units="in", res=400)
par(ps=10)
par(cex=1)
par(mar=c(4,4,1,1))
# plot_grid(A1,A2,B1,B2,C1,C2,C3,C4,nrow=4,ncol=2)
plot_grid(A1,B1,C1,C3,A2,B2,C2,C4,nrow=2,ncol=4)
dev.off()

library(magick)
plotdir_ms="~/Dropbox/EcoEast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/hindcast_ms/summarize_ms/plots/"#;dir.create(plotdir_ms)

file=paste0(plotdir_ms,"histograms5.png")
template=paste0(plotdir_ms,"template.png")

hist=image_read(file)
template=image_read(template)
template2=image_scale(template, "8100")
#hist2=image_scale(hist, "970")
hist2=image_crop(hist,"+50-0") 

a=image_composite(template2,hist2,offset = "+200+240")
a
image_write(a,path = paste0(plotdir_ms,"histograms5.png"))