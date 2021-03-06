## Figure 2. Understanding the tools' responses to changing management priorities
#Q: How do the weightings affect output for each algorithms
## marxan_raw_unscaled, ecoroms_original_unscaled
## adapted from summarize_ms/histograms3.1.R

source("load_functions.R")
library(scales)
library(magick)
plotdir_ms="./hindcast_ms/figures/plots/"

## scenario A--> isolating the effect of swordfish weightings (5 runs, weightings are the same for both algorithms) (run) #### 
one=read.csv("hindcast_ms/extract/extractions/run_A.1.csv") %>% mutate(weighting=.1)
two=read.csv("hindcast_ms/extract/extractions/run_A.2.csv") %>% mutate(weighting=.3)
three=read.csv("hindcast_ms/extract/extractions/run_A.3.csv") %>% mutate(weighting=.5)
four=read.csv("hindcast_ms/extract/extractions/run_A.4.csv") %>% mutate(weighting=.7)
five=read.csv("hindcast_ms/extract/extractions/run_A.5.csv") %>% mutate(weighting=.9)

dataframelist=list(two,three,four)
dataframelist=do.call("rbind",dataframelist)
dataframelist=dataframelist %>% mutate(weighting=as.factor(weighting)) %>% mutate(Year=as.factor(substr(dt,1,4))) %>% mutate("Ocean_state"="Warm")
dataframelist <- within(dataframelist, Ocean_state[Year == '2003'] <- 'Cold')

## scenario B --> isolating the effect of leatherback weightings (5 runs, weightings are the same for both algorithms) (run) #### 
oneB=read.csv("hindcast_ms/extract/extractions/run_B.1.csv") %>% mutate(weighting=-0.1)
twoB=read.csv("hindcast_ms/extract/extractions/run_B.2.csv") %>% mutate(weighting=-0.3)
threeB=read.csv("hindcast_ms/extract/extractions/run_B.3.csv") %>% mutate(weighting=-0.5)
fourB=read.csv("hindcast_ms/extract/extractions/run_B.4.csv") %>% mutate(weighting=-0.7)
fiveB=read.csv("hindcast_ms/extract/extractions/run_B.5.csv") %>% mutate(weighting=-0.9)

dataframelistB=list(twoB,threeB,fourB)
dataframelistB=do.call("rbind",dataframelistB)
dataframelistB=dataframelistB %>% mutate(weighting=as.factor(weighting)) %>% mutate(Year=as.factor(substr(dt,1,4))) %>% mutate("Ocean_state"="Warm")
dataframelistB <- within(dataframelistB, Ocean_state[Year == '2003'] <- 'Cold')

# scenario C--> testing the ability to manage swordfish and leatherback equally (5 runs, weightings are the same for both algorithms) (run) ####
oneC=read.csv("hindcast_ms/extract/extractions/run_C.1.csv") %>% mutate(weighting="+/-0.1")
twoC=read.csv("hindcast_ms/extract/extractions/run_C.2.csv") %>% mutate(weighting="+/-0.3")
threeC=read.csv("hindcast_ms/extract/extractions/run_C.3.csv") %>% mutate(weighting="+/-0.5")
fourC=read.csv("hindcast_ms/extract/extractions/run_C.4.csv") %>% mutate(weighting="+/-0.7")
fiveC=read.csv("hindcast_ms/extract/extractions/run_C.5.csv") %>% mutate(weighting="+/-0.9")

dataframelistC=list(twoC,threeC,fourC)
dataframelistC=do.call("rbind",dataframelistC)
dataframelistC=dataframelistC %>% mutate(weighting=as.factor(weighting)) %>% mutate(Year=as.factor(substr(dt,1,4))) %>% mutate("Ocean_state"="Warm")
dataframelistC <- within(dataframelistC, Ocean_state[Year == '2003'] <- 'Cold')

# New EcoCast scenarios A & B & C (following Mikes suggestion that weightings need to add to one)
EcoA=read.csv("hindcast_ms/extract/extractions/run_M.1.csv") %>% mutate(weighting=1)%>% mutate(weighting=as.factor(weighting)) %>% mutate(Year=as.factor(substr(dt,1,4)))%>% mutate("Ocean_state"="Warm")
EcoA <- within(EcoA, Ocean_state[Year == '2003'] <- 'Cold')
EcoB=read.csv("hindcast_ms/extract/extractions/run_M.2.csv") %>% mutate(weighting=-1)%>% mutate(weighting=as.factor(weighting)) %>% mutate(Year=as.factor(substr(dt,1,4)))%>% mutate("Ocean_state"="Warm")
EcoB <- within(EcoB, Ocean_state[Year == '2003'] <- 'Cold')
EcoC=read.csv("hindcast_ms/extract/extractions/run_C.3.csv") %>% mutate(weighting="+/-0.5")%>% mutate(weighting=as.factor(weighting)) %>% mutate(Year=as.factor(substr(dt,1,4)))%>% mutate("Ocean_state"="Warm")
EcoC <- within(EcoC, Ocean_state[Year == '2003'] <- 'Cold')

EcoC.1=read.csv("hindcast_ms/extract/extractions/run_E.1.csv") %>% mutate(weighting="-0.3/0.7")%>% mutate(weighting=as.factor(weighting)) %>% mutate(Year=as.factor(substr(dt,1,4)))%>% mutate("Ocean_state"="Warm")
EcoC.1 <- within(EcoC.1, Ocean_state[Year == '2003'] <- 'Cold')
EcoC.2=read.csv("hindcast_ms/extract/extractions/run_D.4.csv") %>% mutate(weighting="-0.7/0.3")%>% mutate(weighting=as.factor(weighting)) %>% mutate(Year=as.factor(substr(dt,1,4)))%>% mutate("Ocean_state"="Warm")
EcoC.2 <- within(EcoC.2 , Ocean_state[Year == '2003'] <- 'Cold')
EcoC=do.call("rbind",list(EcoC, EcoC.1, EcoC.2))

## A
A1=ggplot(EcoA,aes(x=swor,y=EcoROMS_original_unscaled,group=weighting,color=weighting,shape=Ocean_state))+geom_point(aes(alpha=Ocean_state),size=1)+
  scale_alpha_manual("Ocean State",values = c("Warm"=.3,"Cold"=1))+
  scale_color_manual("Weighting",values=c("1"="black"))+
  scale_shape_manual("Ocean State",values=c("Warm"=3,"Cold"=15))+
  theme(text = element_text(size=5),axis.text = element_text(size=5),plot.title = element_text(hjust=0,size=5),legend.position=c(.1,.95),legend.justification = c(.9,.9),legend.key.size = unit(.5,'lines'))+
  theme(legend.background = element_blank(),legend.box.background = element_rect(color=NA),legend.margin=unit(0.3, "lines"))+
  #ggtitle("Relationship between EcoCast values and swordfish habitat suitability values under increasing swordfish weightings")+
  #ggtitle("Effect of increasing swordfish weighting on the relationship between EcoCast values and swordfish habitat suitability values")+
  ylab("EcoCast output")+xlab("Swordfish habitat suitability")+ylim(-1,1)

A1

A2=ggplot(dataframelist,aes(x=swor,y=Marxan_raw_unscaled,group=weighting,color=weighting,shape=Ocean_state))+geom_point(aes(alpha=Ocean_state,color=weighting),size=1)+stat_smooth(se=F,method = "gam",formula = y~s(x,bs = "cr"))+
  scale_alpha_manual("Ocean State",values = c("Warm"=.3,"Cold"=1))+
  scale_color_manual("Weighting",values=c("0.1"="darkgoldenrod","0.3"="cornflowerblue","0.5"="coral1","0.7"="aquamarine4","0.9"="dimgray"))+
  scale_shape_manual("Ocean State",values=c("Warm"=3,"Cold"=15))+
  theme(text = element_text(size=5),axis.text = element_text(size=5),plot.title = element_text(hjust=0,size=5),legend.position=c(.1,.95),legend.justification = c(.9,.9),legend.key.size = unit(.5,'lines'))+
  theme(legend.background = element_blank(),legend.box.background = element_rect(color=NA),legend.margin=unit(0.3, "lines"))+
  #ggtitle("Effect of increasing swordfish weighting on the relationship between Marxan values and swordfish habitat suitability values")+
  ylab("Marxan output")+xlab("Swordfish habitat suitability")+scale_y_continuous(limits = c(-1000, 0))

A2

## B
B1=ggplot(EcoB,aes(x=lbst,y=EcoROMS_original_unscaled,group=weighting,color=weighting,shape=Ocean_state))+geom_point(aes(alpha=Ocean_state),size=1)+
  scale_alpha_manual("Ocean State",values = c("Warm"=.3,"Cold"=1))+
  scale_color_manual("Weighting",values=c("-1"="black"))+
  scale_shape_manual("Ocean State",values=c("Warm"=3,"Cold"=15))+
  theme(text = element_text(size=5),axis.text = element_text(size=5),plot.title = element_text(hjust=0,size=5),legend.position=c(.1,.3),legend.justification = c(.9,.9),legend.key.size = unit(.5,'lines'))+
  theme(legend.background = element_blank(),legend.box.background = element_rect(colour = NA),legend.margin=unit(0.3, "lines"))+
  #ggtitle("Effect of decreasing leatherback weighting on the relationship between EcoCast values and leatherback habitat suitability values")+
  ylab("EcoCast output")+xlab("Leatherback habitat suitability")+ylim(-1,1)

B2=ggplot(dataframelistB,aes(x=lbst,y=Marxan_raw_unscaled,group=weighting,color=weighting,shape=Ocean_state))+geom_point(aes(alpha=Ocean_state),size=1)+stat_smooth(se=F,method = "gam",formula = y~s(x, bs = "cr"))+
  scale_alpha_manual("Ocean State",values = c("Warm"=.3,"Cold"=1))+
  scale_color_manual("Weighting",values=c("-0.1"="darkgoldenrod","-0.3"="cornflowerblue","-0.5"="coral1","-0.7"="aquamarine4","-0.9"="dimgray"))+
  scale_shape_manual("Ocean State",values=c("Warm"=3,"Cold"=15))+
  theme(text = element_text(size=5),axis.text = element_text(size=5),plot.title = element_text(hjust=0,size=5),legend.position=c(.1,.3),legend.justification = c(.9,.9),legend.key.size = unit(.5,'lines'))+
  theme(legend.background = element_blank(),legend.box.background = element_rect(colour = NA),legend.margin=unit(0.3, "lines"))+
  #ggtitle("Effect of decreasing leatherback weighting on the relationship between Marxan values and leatherback habitat suitability values")+
  ylab("Marxan output")+xlab("Leatherback habitat suitability")+scale_y_continuous(limits = c(-1000, 0))

B2

## C
C1=ggplot(EcoC,aes(x=swor,y=EcoROMS_original_unscaled,group=weighting,color=weighting,shape=Ocean_state))+geom_point(aes(alpha=Ocean_state),size=1)+stat_smooth(se=F,method = "gam",formula = y~s(x, bs="cr"))+
  scale_alpha_manual("Ocean State",values = c("Warm"=.3,"Cold"=1))+
  scale_color_manual("Weighting",values=c("+/-0.1"="darkgoldenrod","-0.3/0.7"="darkgoldenrod","+/-0.5"="coral1","-0.7/0.3"="dimgray","+/-0.9"="dimgray"))+
  scale_shape_manual("Ocean State",values=c("Warm"=3,"Cold"=15))+
  theme(text = element_text(size=5),axis.text = element_text(size=5),plot.title = element_text(hjust=0,size=5),legend.position=c(.1,.95),legend.justification = c(.9,.9),legend.key.size = unit(.5,'lines'))+
  theme(legend.background = element_blank(),legend.box.background = element_rect(colour = NA),legend.margin=unit(0.3, "lines"))+
  #ggtitle("Effect of equal opposing swordfish/leatherback weightings on the relationship between EcoCast values and swordfish habitat suitability values")+
  ylab("EcoCast output")+xlab("Swordfish habitat suitability")+ylim(-1,1)

C2=ggplot(EcoC,aes(x=swor,y=Marxan_raw_unscaled,group=weighting,color=weighting,shape=Ocean_state))+geom_point(aes(alpha=Ocean_state),size=1)+stat_smooth(se=F,method = "gam",formula = y~s(x, bs="cr"))+
  scale_alpha_manual("Ocean State",values = c("Warm"=.3,"Cold"=1))+
  scale_color_manual("Weighting",values=c("+/-0.1"="darkgoldenrod","-0.3/0.7"="darkgoldenrod","+/-0.5"="coral1","-0.7/0.3"="dimgray","+/-0.9"="dimgray"))+
  scale_shape_manual("Ocean State",values=c("Warm"=3,"Cold"=15))+
  theme(text = element_text(size=5),axis.text = element_text(size=5),plot.title = element_text(hjust=0,size=5),legend.position=c(.1,.95),legend.justification = c(.9,.9),legend.key.size = unit(.5,'lines'))+
  theme(legend.background = element_blank(),legend.box.background = element_rect(colour = NA),legend.margin=unit(0.3, "lines"))+
  #ggtitle("Effect of equal opposing swordfish/leatherback weightings between Marxan values and swordfish habitat suitability values")+
  ylab("Marxan output")+xlab("Swordfish habitat suitability")+scale_y_continuous(limits = c(-1000, 0))

C3=ggplot(EcoC,aes(x=lbst,y=EcoROMS_original_unscaled,group=weighting,color=weighting,shape=Ocean_state))+geom_point(aes(alpha=Ocean_state),size=1)+stat_smooth(se=F,method = "gam",formula = y~s(x, bs="cr"))+
  scale_alpha_manual("Ocean State",values = c("Warm"=.3,"Cold"=1))+
  scale_color_manual("Weighting",values=c("+/-0.1"="darkgoldenrod","-0.3/0.7"="darkgoldenrod","+/-0.5"="coral1","-0.7/0.3"="dimgray","+/-0.9"="dimgray"))+
  scale_shape_manual("Ocean State",values=c("Warm"=3,"Cold"=15))+
  theme(text = element_text(size=5),axis.text = element_text(size=5),plot.title = element_text(hjust=0,size=5),legend.position=c(.1,.3),legend.justification = c(.9,.9),legend.key.size = unit(.5,'lines'))+
  theme(legend.background = element_blank(),legend.box.background = element_rect(colour = NA),legend.margin=unit(0.3, "lines"))+
  #ggtitle("Effect of equal opposing swordfish/leatherback weightings on the relationship between EcoCast values and leatherback habitat suitability values")+
  ylab("EcoCast output")+xlab("Leatherback habitat suitability")+ylim(-1,1)

C3

C4=ggplot(EcoC,aes(x=lbst,y=Marxan_raw_unscaled,group=weighting,color=weighting,shape=Ocean_state))+geom_point(aes(alpha=Ocean_state),size=1)+stat_smooth(se=F,method = "gam",formula = y~s(x, bs="cr"))+
  scale_alpha_manual("Ocean State",values = c("Warm"=.3,"Cold"=1))+
  scale_color_manual("Weighting",values=c("+/-0.1"="darkgoldenrod","-0.3/0.7"="darkgoldenrod","+/-0.5"="coral1","-0.7/0.3"="dimgray","+/-0.9"="dimgray"))+
  scale_shape_manual("Ocean State",values=c("Warm"=3,"Cold"=15))+
  theme(text = element_text(size=5),axis.text = element_text(size=5),plot.title = element_text(hjust=0,size=5),legend.position=c(.95,.95),legend.justification = c(.9,.9),legend.key.size = unit(.5,'lines'))+
  theme(legend.background = element_blank(),legend.box.background = element_rect(colour = NA),legend.margin=unit(0.3, "lines"))+
  #ggtitle("Effect of equal opposing swordfish/leatherback weightings between Marxan values and leatherback habitat suitability values")+
  ylab("Marxan output")+xlab("Leatherback habitat suitability")+scale_y_continuous(limits = c(-1000, 0))

C4

png(paste0(plotdir_ms,"figure2_changing_weightings_temp_gam2.png"),width=20, height=8, units="in", res=400)
par(ps=10)
par(cex=1)
par(mar=c(4,4,1,1))
# plot_grid(A1,A2,B1,B2,C1,C2,C3,C4,nrow=4,ncol=2)
plot_grid(A1,B1,C1,C3,A2,B2,C2,C4,nrow=2,ncol=4)
dev.off()

library(magick)
templateDir="/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/hindcast_ms/summarize_ms/plots/"

file=paste0(plotdir_ms,"figure2_changing_weightings_temp_lm.png")
template=paste0(templateDir,"template.png")

hist=image_read(file)
template=image_read(template)
template2=image_scale(template, "8100")
#hist2=image_scale(hist, "970")
hist2=image_crop(hist,"+50-0") 

a=image_composite(template2,hist2,offset = "+200+240")
a
image_write(a,path = paste0(plotdir_ms,"figure2_changing_weightings_temp_lm.png"))

