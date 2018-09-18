## Figure 1: ECDF plots
#Q: How do the weightings affect output for each algorithms
## marxan_raw, ecoroms_original_unscaled

## scenario A--> isolating the effect of swordfish weightings (5 runs, weightings are the same for both algorithms) (run) #### 
one=read.csv("hindcast_ms/extract/extractions/run_A.1.csv") %>% mutate(weighting=.1)
two=read.csv("hindcast_ms/extract/extractions/run_A.2.csv") %>% mutate(weighting=.3)
three=read.csv("hindcast_ms/extract/extractions/run_A.3.csv") %>% mutate(weighting=.5)
four=read.csv("hindcast_ms/extract/extractions/run_A.4.csv") %>% mutate(weighting=.7)
five=read.csv("hindcast_ms/extract/extractions/run_A.5.csv") %>% mutate(weighting=.9)

dataframelist=list(one,two,three,four,five)
dataframelist=do.call("rbind",dataframelist)
dataframelist=dataframelist %>% mutate(weighting=as.factor(weighting)) %>% mutate(EcoROMS_original_unscaled=rescale(EcoROMS_original_unscaled,to=c(-1,1)))

## scenario B --> isolating the effect of leatherback weightings (5 runs, weightings are the same for both algorithms) (run) #### 
oneB=read.csv("hindcast_ms/extract/extractions/run_B.1.csv") %>% mutate(weighting=-0.1)
twoB=read.csv("hindcast_ms/extract/extractions/run_B.2.csv") %>% mutate(weighting=-0.3)
threeB=read.csv("hindcast_ms/extract/extractions/run_B.3.csv") %>% mutate(weighting=-0.5)
fourB=read.csv("hindcast_ms/extract/extractions/run_B.4.csv") %>% mutate(weighting=-0.7)
fiveB=read.csv("hindcast_ms/extract/extractions/run_B.5.csv") %>% mutate(weighting=-0.9)

dataframelistB=list(oneB,twoB,threeB,fourB,fiveB)
dataframelistB=do.call("rbind",dataframelistB)
dataframelistB=dataframelistB %>% mutate(weighting=as.factor(weighting)) %>% mutate(EcoROMS_original_unscaled=rescale(EcoROMS_original_unscaled,to=c(-1,1)))

# scenario C--> testing the ability to manage swordfish and leatherback equally (5 runs, weightings are the same for both algorithms) (run) ####
oneC=read.csv("hindcast_ms/extract/extractions/run_C.1.csv") %>% mutate(weighting="+/-0.1")
twoC=read.csv("hindcast_ms/extract/extractions/run_C.2.csv") %>% mutate(weighting="+/-0.3")
threeC=read.csv("hindcast_ms/extract/extractions/run_C.3.csv") %>% mutate(weighting="+/-0.5")
fourC=read.csv("hindcast_ms/extract/extractions/run_C.4.csv") %>% mutate(weighting="+/-0.7")
fiveC=read.csv("hindcast_ms/extract/extractions/run_C.5.csv") %>% mutate(weighting="+/-0.9")

dataframelistC=list(oneC,twoC,threeC,fourC,fiveC)
dataframelistC=do.call("rbind",dataframelistC)
dataframelistC=dataframelistC %>% mutate(weighting=as.factor(weighting)) %>% mutate(EcoROMS_original_unscaled=rescale(EcoROMS_original_unscaled,to=c(-1,1)))

## A
A1=ggplot(dataframelist,aes(x=swor,y=EcoROMS_original_unscaled,group=weighting,color=weighting))+geom_point(shape=1)+
  scale_color_manual("Weighting",values=c("0.1"="darkgoldenrod","0.3"="cornflowerblue","0.5"="coral1","0.7"="aquamarine4","0.9"="dimgray"))+
  theme(text = element_text(size=5),axis.text = element_text(size=5),plot.title = element_text(hjust=0,size=8),legend.position=c(.2,1),legend.justification = c(.9,.9),legend.key.size = unit(.5,'lines'))+
  #ggtitle("Relationship between EcoCast values and swordfish habitat suitability values under increasing swordfish weightings")+
  ggtitle("Effect of increasing swordfish weighting on the relationship between EcoCast values and swordfish habitat suitability values")+
  ylab("EcoCast")+xlab("Swordfish habitat suitability")

A2=ggplot(dataframelist,aes(x=swor,y=Marxan_raw,group=weighting,color=weighting))+geom_point(shape=1)+stat_smooth(se=F)+
  scale_color_manual("Weighting",values=c("0.1"="darkgoldenrod","0.3"="cornflowerblue","0.5"="coral1","0.7"="aquamarine4","0.9"="dimgray"))+
  theme(text = element_text(size=5),axis.text = element_text(size=5),plot.title = element_text(hjust=0,size=8),legend.position=c(.2,1),legend.justification = c(.9,.9),legend.key.size = unit(.5,'lines'))+
  ggtitle("Effect of increasing swordfish weighting on the relationship between Marxan values and swordfish habitat suitability values")+
  ylab("EcoCast")+xlab("Swordfish habitat suitability")+scale_y_continuous(limits = c(-1, 1))

## B
B1=ggplot(dataframelistB,aes(x=lbst,y=EcoROMS_original_unscaled,group=weighting,color=weighting))+geom_point(shape=1)+
  scale_color_manual("Weighting",values=c("-0.1"="darkgoldenrod","-0.3"="cornflowerblue","-0.5"="coral1","-0.7"="aquamarine4","-0.9"="dimgray"))+
  theme(text = element_text(size=5),axis.text = element_text(size=5),plot.title = element_text(hjust=0,size=8),legend.position=c(.2,.2),legend.justification = c(.9,.9),legend.key.size = unit(.5,'lines'))+
  ggtitle("Effect of decreasing leatherback weighting on the relationship between EcoCast values and leatherback habitat suitability values")+
  ylab("EcoCast")+xlab("Leatherback habitat suitability")

B2=ggplot(dataframelistB,aes(x=lbst,y=Marxan_raw,group=weighting,color=weighting))+geom_point(shape=1)+stat_smooth(se=F)+
  scale_color_manual("Weighting",values=c("-0.1"="darkgoldenrod","-0.3"="cornflowerblue","-0.5"="coral1","-0.7"="aquamarine4","-0.9"="dimgray"))+
  theme(text = element_text(size=5),axis.text = element_text(size=5),plot.title = element_text(hjust=0,size=8),legend.position=c(.8,1),legend.justification = c(.9,.9),legend.key.size = unit(.5,'lines'))+
  ggtitle("Effect of decreasing leatherback weighting on the relationship between Marxan values and leatherback habitat suitability values")+
  ylab("EcoCast")+xlab("Leatherback habitat suitability")+scale_y_continuous(limits = c(-1, 0))

## C
C1=ggplot(dataframelistC,aes(x=swor,y=EcoROMS_original_unscaled,group=weighting,color=weighting))+geom_point(shape=1)+stat_smooth(se=F)+
  scale_color_manual("Weighting",values=c("+/-0.1"="darkgoldenrod","+/-0.3"="cornflowerblue","+/-0.5"="coral1","+/-0.7"="aquamarine4","+/-0.9"="dimgray"))+
  theme(text = element_text(size=5),axis.text = element_text(size=5),plot.title = element_text(hjust=0,size=8),legend.position=c(.2,1),legend.justification = c(.9,.9),legend.key.size = unit(.5,'lines'))+
  ggtitle("Effect of equal opposing swordfish/leatherback weightings on the relationship between EcoCast values and swordfish habitat suitability values")+
  ylab("EcoCast")+xlab("Swordfish habitat suitability")

C2=ggplot(dataframelistC,aes(x=swor,y=Marxan_raw,group=weighting,color=weighting))+geom_point(shape=1)+stat_smooth(se=F)+
  scale_color_manual("Weighting",values=c("+/-0.1"="darkgoldenrod","+/-0.3"="cornflowerblue","+/-0.5"="coral1","+/-0.7"="aquamarine4","+/-0.9"="dimgray"))+
  theme(text = element_text(size=5),axis.text = element_text(size=5),plot.title = element_text(hjust=0,size=8),legend.position=c(.2,1),legend.justification = c(.9,.9),legend.key.size = unit(.5,'lines'))+
  theme(legend.background = element_blank(),legend.box.background = element_rect(colour = "black"))+
  ggtitle("Effect of equal opposing swordfish/leatherback weightings between Marxan values and swordfish habitat suitability values")+
  ylab("EcoCast")+xlab("Swordfish habitat suitability")+scale_y_continuous(limits = c(-1, 1))

C3=ggplot(dataframelistC,aes(x=lbst,y=EcoROMS_original_unscaled,group=weighting,color=weighting))+geom_point(shape=1)+stat_smooth(se=F)+
  scale_color_manual("Weighting",values=c("+/-0.1"="darkgoldenrod","+/-0.3"="cornflowerblue","+/-0.5"="coral1","+/-0.7"="aquamarine4","+/-0.9"="dimgray"))+
  theme(text = element_text(size=5),axis.text = element_text(size=5),plot.title = element_text(hjust=0,size=8),legend.position=c(.2,.2),legend.justification = c(.9,.9),legend.key.size = unit(.5,'lines'))+
  ggtitle("Effect of equal opposing swordfish/leatherback weightings on the relationship between EcoCast values and leatherback habitat suitability values")+
  ylab("EcoCast")+xlab("Leatherback habitat suitability")

C4=ggplot(dataframelistC,aes(x=lbst,y=Marxan_raw,group=weighting,color=weighting))+geom_point(shape=1)+stat_smooth(se=F)+
  scale_color_manual("Weighting",values=c("+/-0.1"="darkgoldenrod","+/-0.3"="cornflowerblue","+/-0.5"="coral1","+/-0.7"="aquamarine4","+/-0.9"="dimgray"))+
  theme(text = element_text(size=5),axis.text = element_text(size=5),plot.title = element_text(hjust=0,size=8),legend.position=c(.8,1),legend.justification = c(.9,.9),legend.key.size = unit(.5,'lines'))+
  theme(legend.background = element_blank(),legend.box.background = element_rect(colour = "black"))+
  ggtitle("Effect of equal opposing swordfish/leatherback weightings between Marxan values and leatherback habitat suitability values")+
  ylab("EcoCast")+xlab("Leatherback habitat suitability")+scale_y_continuous(limits = c(-1, 1))

png(paste0(plotdir,"hist_text.png"),width=10, height=16, units="in", res=400)
par(ps=10)
par(cex=1)
par(mar=c(4,4,1,1))
plot_grid(A1,A2,B1,B2,C1,C2,C3,C4,nrow=4,ncol=2)
dev.off()

