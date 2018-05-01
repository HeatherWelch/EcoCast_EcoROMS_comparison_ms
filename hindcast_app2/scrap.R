library(plotly)

run4_real=read.csv("data/species_predict_04.13.18_run4.csv")
run4_random=read.csv("data/species_predict_04.13.18_random_run4.csv") %>% .[1:1649,]
run5_real=read.csv("data/species_predict_04.24.18_run5.csv")
run5_random=read.csv("data/species_predict_04.24.18_random_run5.csv") %>% .[1:1649,]
run6_real=read.csv("data/species_predict_04.25.18_run6.csv")
run6_random=read.csv("data/species_predict_04.25.18_random_run6.csv") %>% .[1:1649,]

######### random ####
data=run4_random
ER_weightings<-c(-0.1,-0.1,-0.05,-2.5,.1)
M_weightings<-c(-0.1,-0.1,-0.05,-0.4,0.1)

algorithm="EcoROMS_original"
subtitle=paste0(namesrisk[1],": ",ER_weightings[1],", ",namesrisk[2],": ",ER_weightings[2],", ",namesrisk[3],": ",ER_weightings[3],", ",namesrisk[4],": ",ER_weightings[4],", ",namesrisk[5],": ",ER_weightings[5])
a=ggplot()+geom_point(data=data,aes(x=swor,y=lbst,color=EcoROMS_original),size=1,shape=1)+scale_color_gradientn(colours=rainbow(7),na.value = "transparent",
                                                                                                          breaks=c(-.5,0,.5),
                                                                                                          limits=c(-1,1))
a=a+ggtitle(label = paste0("Relationship between swor and lbst probability of presence and ",algorithm," predictions"),subtitle = subtitle)+labs(x="Swordfish probability of presence")+labs(y=paste0("Leatherback probability of presence"))+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+guides(fill=guide_legend(title="Species"))+theme(legend.title = element_text(size=6),legend.position=c(.99,.45),legend.justification = c(.9,.9))+theme(legend.background = element_blank())+theme(legend.text=element_text(size=6),legend.box.background = element_rect(colour = "black"))+ theme(legend.key=element_blank()) 
a

algorithm="Marxan_raw"
subtitle=paste0(namesrisk[1],": ",M_weightings[1],", ",namesrisk[2],": ",M_weightings[2],", ",namesrisk[3],": ",M_weightings[3],", ",namesrisk[4],": ",M_weightings[4],", ",namesrisk[5],": ",M_weightings[5])
a=ggplot()+geom_point(data=data,aes(x=swor,y=lbst,color=Marxan_raw),size=1,shape=1)+scale_color_gradientn(colours=rainbow(7),na.value = "transparent",
                                                                                                             breaks=c(-.5,0,.5),
                                                                                                             limits=c(-1,1))
a=a+ggtitle(label = paste0("Relationship between swor and lbst probability of presence and ",algorithm," predictions"),subtitle = subtitle)+labs(x="Swordfish probability of presence")+labs(y=paste0("Leatherback probability of presence"))+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+guides(fill=guide_legend(title="Species"))+theme(legend.title = element_text(size=6),legend.position=c(.99,.45),legend.justification = c(.9,.9))+theme(legend.background = element_blank())+theme(legend.text=element_text(size=6),legend.box.background = element_rect(colour = "black"))+ theme(legend.key=element_blank()) 
a
##

data=run5_random
ER_weightings<-c(-0.1,-0.1,-0.05,-2.5,1.5)
M_weightings<-c(-0.1,-0.1,-0.05,-0.4,0.2)

algorithm="EcoROMS_original"
subtitle=paste0(namesrisk[1],": ",ER_weightings[1],", ",namesrisk[2],": ",ER_weightings[2],", ",namesrisk[3],": ",ER_weightings[3],", ",namesrisk[4],": ",ER_weightings[4],", ",namesrisk[5],": ",ER_weightings[5])
a=ggplot()+geom_point(data=data,aes(x=swor,y=lbst,color=EcoROMS_original),size=1,shape=1)+scale_color_gradientn(colours=rainbow(7),na.value = "transparent",
                                                                                                                breaks=c(-.5,0,.5),
                                                                                                                limits=c(-1,1))
a=a+ggtitle(label = paste0("Relationship between swor and lbst probability of presence and ",algorithm," predictions"),subtitle = subtitle)+labs(x="Swordfish probability of presence")+labs(y=paste0("Leatherback probability of presence"))+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+guides(fill=guide_legend(title="Species"))+theme(legend.title = element_text(size=6),legend.position=c(.99,.45),legend.justification = c(.9,.9))+theme(legend.background = element_blank())+theme(legend.text=element_text(size=6),legend.box.background = element_rect(colour = "black"))+ theme(legend.key=element_blank()) 
a

algorithm="Marxan_raw"
subtitle=paste0(namesrisk[1],": ",M_weightings[1],", ",namesrisk[2],": ",M_weightings[2],", ",namesrisk[3],": ",M_weightings[3],", ",namesrisk[4],": ",M_weightings[4],", ",namesrisk[5],": ",M_weightings[5])
a=ggplot()+geom_point(data=data,aes(x=swor,y=lbst,color=Marxan_raw),size=1,shape=1)+scale_color_gradientn(colours=rainbow(7),na.value = "transparent",
                                                                                                          breaks=c(-.5,0,.5),
                                                                                                          limits=c(-1,1))
a=a+ggtitle(label = paste0("Relationship between swor and lbst probability of presence and ",algorithm," predictions"),subtitle = subtitle)+labs(x="Swordfish probability of presence")+labs(y=paste0("Leatherback probability of presence"))+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+guides(fill=guide_legend(title="Species"))+theme(legend.title = element_text(size=6),legend.position=c(.99,.45),legend.justification = c(.9,.9))+theme(legend.background = element_blank())+theme(legend.text=element_text(size=6),legend.box.background = element_rect(colour = "black"))+ theme(legend.key=element_blank()) 
a
##

data=run6_random
ER_weightings<-c(-0.1,-0.1,-0.05,-2.5,2.5)
M_weightings<-c(-0.1,-0.1,-0.05,-0.4,0.4)

algorithm="EcoROMS_original"
subtitle=paste0(namesrisk[1],": ",ER_weightings[1],", ",namesrisk[2],": ",ER_weightings[2],", ",namesrisk[3],": ",ER_weightings[3],", ",namesrisk[4],": ",ER_weightings[4],", ",namesrisk[5],": ",ER_weightings[5])
a=ggplot()+geom_point(data=data,aes(x=swor,y=lbst,color=EcoROMS_original),size=1,shape=1)+scale_color_gradientn(colours=rainbow(7),na.value = "transparent",
                                                                                                                breaks=c(-.5,0,.5),
                                                                                                                limits=c(-1,1))
a=a+ggtitle(label = paste0("Relationship between swor and lbst probability of presence and ",algorithm," predictions"),subtitle = subtitle)+labs(x="Swordfish probability of presence")+labs(y=paste0("Leatherback probability of presence"))+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+guides(fill=guide_legend(title="Species"))+theme(legend.title = element_text(size=6),legend.position=c(.99,.45),legend.justification = c(.9,.9))+theme(legend.background = element_blank())+theme(legend.text=element_text(size=6),legend.box.background = element_rect(colour = "black"))+ theme(legend.key=element_blank()) 
a

algorithm="Marxan_raw"
subtitle=paste0(namesrisk[1],": ",M_weightings[1],", ",namesrisk[2],": ",M_weightings[2],", ",namesrisk[3],": ",M_weightings[3],", ",namesrisk[4],": ",M_weightings[4],", ",namesrisk[5],": ",M_weightings[5])
a=ggplot()+geom_point(data=data,aes(x=swor,y=lbst,color=Marxan_raw),size=1,shape=1)+scale_color_gradientn(colours=rainbow(7),na.value = "transparent",
                                                                                                          breaks=c(-.5,0,.5),
                                                                                                          limits=c(-1,1))
a=a+ggtitle(label = paste0("Relationship between swor and lbst probability of presence and ",algorithm," predictions"),subtitle = subtitle)+labs(x="Swordfish probability of presence")+labs(y=paste0("Leatherback probability of presence"))+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+guides(fill=guide_legend(title="Species"))+theme(legend.title = element_text(size=6),legend.position=c(.99,.45),legend.justification = c(.9,.9))+theme(legend.background = element_blank())+theme(legend.text=element_text(size=6),legend.box.background = element_rect(colour = "black"))+ theme(legend.key=element_blank()) 
a
##

######### real ####
data=run4_real
sworDat=data[data$sp=="swor",]
lbstDat=data[data$sp=="lbst",]

ER_weightings<-c(-0.1,-0.1,-0.05,-2.5,.1)
M_weightings<-c(-0.1,-0.1,-0.05,-0.4,0.1)

algorithm="EcoROMS_original"
species="swordfish"
subtitle=paste0(namesrisk[1],": ",ER_weightings[1],", ",namesrisk[2],": ",ER_weightings[2],", ",namesrisk[3],": ",ER_weightings[3],", ",namesrisk[4],": ",ER_weightings[4],", ",namesrisk[5],": ",ER_weightings[5])
a=ggplot()+geom_point(data=sworDat,aes(x=swor,y=lbst,color=EcoROMS_original),size=1,shape=1)+scale_color_gradientn(colours=rainbow(7),na.value = "transparent",
                                                                                                                breaks=c(-.5,0,.5),
                                                                                                                limits=c(-1,1))
a=a+ggtitle(label = paste0("Relationship between swor and lbst probability of presence and ",algorithm," predictions: ",species," data"),subtitle = subtitle)+labs(x="Swordfish probability of presence")+labs(y=paste0("Leatherback probability of presence"))+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+guides(fill=guide_legend(title="Species"))+theme(legend.title = element_text(size=6),legend.position=c(.99,.45),legend.justification = c(.9,.9))+theme(legend.background = element_blank())+theme(legend.text=element_text(size=6),legend.box.background = element_rect(colour = "black"))+ theme(legend.key=element_blank()) 
a

algorithm="EcoROMS_original"
species="leatherback"
subtitle=paste0(namesrisk[1],": ",ER_weightings[1],", ",namesrisk[2],": ",ER_weightings[2],", ",namesrisk[3],": ",ER_weightings[3],", ",namesrisk[4],": ",ER_weightings[4],", ",namesrisk[5],": ",ER_weightings[5])
a=ggplot()+geom_point(data=lbstDat,aes(x=swor,y=lbst,color=EcoROMS_original),size=1,shape=1)+scale_color_gradientn(colours=rainbow(7),na.value = "transparent",
                                                                                                                   breaks=c(-.5,0,.5),
                                                                                                                   limits=c(-1,1))
a=a+ggtitle(label = paste0("Relationship between swor and lbst probability of presence and ",algorithm," predictions: ",species," data"),subtitle = subtitle)+labs(x="Swordfish probability of presence")+labs(y=paste0("Leatherback probability of presence"))+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+guides(fill=guide_legend(title="Species"))+theme(legend.title = element_text(size=6),legend.position=c(.99,.45),legend.justification = c(.9,.9))+theme(legend.background = element_blank())+theme(legend.text=element_text(size=6),legend.box.background = element_rect(colour = "black"))+ theme(legend.key=element_blank()) 
a

algorithm="Marxan_raw"
species="swordfish"
subtitle=paste0(namesrisk[1],": ",M_weightings[1],", ",namesrisk[2],": ",M_weightings[2],", ",namesrisk[3],": ",M_weightings[3],", ",namesrisk[4],": ",M_weightings[4],", ",namesrisk[5],": ",M_weightings[5])
a=ggplot()+geom_point(data=sworDat,aes(x=swor,y=lbst,color=Marxan_raw),size=1,shape=1)+scale_color_gradientn(colours=rainbow(7),na.value = "transparent",
                                                                                                          breaks=c(-.5,0,.5),
                                                                                                          limits=c(-1,1))
a=a+ggtitle(label = paste0("Relationship between swor and lbst probability of presence and ",algorithm," predictions: ",species," data"),subtitle = subtitle)+labs(x="Swordfish probability of presence")+labs(y=paste0("Leatherback probability of presence"))+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+guides(fill=guide_legend(title="Species"))+theme(legend.title = element_text(size=6),legend.position=c(.99,.45),legend.justification = c(.9,.9))+theme(legend.background = element_blank())+theme(legend.text=element_text(size=6),legend.box.background = element_rect(colour = "black"))+ theme(legend.key=element_blank()) 
a

algorithm="Marxan_raw"
species="leatherback"
subtitle=paste0(namesrisk[1],": ",M_weightings[1],", ",namesrisk[2],": ",M_weightings[2],", ",namesrisk[3],": ",M_weightings[3],", ",namesrisk[4],": ",M_weightings[4],", ",namesrisk[5],": ",M_weightings[5])
a=ggplot()+geom_point(data=lbstDat,aes(x=swor,y=lbst,color=Marxan_raw),size=1,shape=1)+scale_color_gradientn(colours=rainbow(7),na.value = "transparent",
                                                                                                             breaks=c(-.5,0,.5),
                                                                                                             limits=c(-1,1))
a=a+ggtitle(label = paste0("Relationship between swor and lbst probability of presence and ",algorithm," predictions: ",species," data"),subtitle = subtitle)+labs(x="Swordfish probability of presence")+labs(y=paste0("Leatherback probability of presence"))+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+guides(fill=guide_legend(title="Species"))+theme(legend.title = element_text(size=6),legend.position=c(.99,.45),legend.justification = c(.9,.9))+theme(legend.background = element_blank())+theme(legend.text=element_text(size=6),legend.box.background = element_rect(colour = "black"))+ theme(legend.key=element_blank()) 
a
##

data=run5_real
sworDat=data[data$sp=="swor",]
lbstDat=data[data$sp=="lbst",]
ER_weightings<-c(-0.1,-0.1,-0.05,-2.5,1.5)
M_weightings<-c(-0.1,-0.1,-0.05,-0.4,0.2)

algorithm="EcoROMS_original"
species="swordfish"
subtitle=paste0(namesrisk[1],": ",ER_weightings[1],", ",namesrisk[2],": ",ER_weightings[2],", ",namesrisk[3],": ",ER_weightings[3],", ",namesrisk[4],": ",ER_weightings[4],", ",namesrisk[5],": ",ER_weightings[5])
a=ggplot()+geom_point(data=sworDat,aes(x=swor,y=lbst,color=EcoROMS_original),size=1,shape=1)+scale_color_gradientn(colours=rainbow(7),na.value = "transparent",
                                                                                                                   breaks=c(-.5,0,.5),
                                                                                                                   limits=c(-1,1))
a=a+ggtitle(label = paste0("Relationship between swor and lbst probability of presence and ",algorithm," predictions: ",species," data"),subtitle = subtitle)+labs(x="Swordfish probability of presence")+labs(y=paste0("Leatherback probability of presence"))+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+guides(fill=guide_legend(title="Species"))+theme(legend.title = element_text(size=6),legend.position=c(.99,.45),legend.justification = c(.9,.9))+theme(legend.background = element_blank())+theme(legend.text=element_text(size=6),legend.box.background = element_rect(colour = "black"))+ theme(legend.key=element_blank()) 
a

algorithm="EcoROMS_original"
species="leatherback"
subtitle=paste0(namesrisk[1],": ",ER_weightings[1],", ",namesrisk[2],": ",ER_weightings[2],", ",namesrisk[3],": ",ER_weightings[3],", ",namesrisk[4],": ",ER_weightings[4],", ",namesrisk[5],": ",ER_weightings[5])
a=ggplot()+geom_point(data=lbstDat,aes(x=swor,y=lbst,color=EcoROMS_original),size=1,shape=1)+scale_color_gradientn(colours=rainbow(7),na.value = "transparent",
                                                                                                                   breaks=c(-.5,0,.5),
                                                                                                                   limits=c(-1,1))
a=a+ggtitle(label = paste0("Relationship between swor and lbst probability of presence and ",algorithm," predictions: ",species," data"),subtitle = subtitle)+labs(x="Swordfish probability of presence")+labs(y=paste0("Leatherback probability of presence"))+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+guides(fill=guide_legend(title="Species"))+theme(legend.title = element_text(size=6),legend.position=c(.99,.45),legend.justification = c(.9,.9))+theme(legend.background = element_blank())+theme(legend.text=element_text(size=6),legend.box.background = element_rect(colour = "black"))+ theme(legend.key=element_blank()) 
a

algorithm="Marxan_raw"
species="swordfish"
subtitle=paste0(namesrisk[1],": ",M_weightings[1],", ",namesrisk[2],": ",M_weightings[2],", ",namesrisk[3],": ",M_weightings[3],", ",namesrisk[4],": ",M_weightings[4],", ",namesrisk[5],": ",M_weightings[5])
a=ggplot()+geom_point(data=sworDat,aes(x=swor,y=lbst,color=Marxan_raw),size=1,shape=1)+scale_color_gradientn(colours=rainbow(7),na.value = "transparent",
                                                                                                             breaks=c(-.5,0,.5),
                                                                                                             limits=c(-1,1))
a=a+ggtitle(label = paste0("Relationship between swor and lbst probability of presence and ",algorithm," predictions: ",species," data"),subtitle = subtitle)+labs(x="Swordfish probability of presence")+labs(y=paste0("Leatherback probability of presence"))+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+guides(fill=guide_legend(title="Species"))+theme(legend.title = element_text(size=6),legend.position=c(.99,.45),legend.justification = c(.9,.9))+theme(legend.background = element_blank())+theme(legend.text=element_text(size=6),legend.box.background = element_rect(colour = "black"))+ theme(legend.key=element_blank()) 
a

algorithm="Marxan_raw"
species="leatherback"
subtitle=paste0(namesrisk[1],": ",M_weightings[1],", ",namesrisk[2],": ",M_weightings[2],", ",namesrisk[3],": ",M_weightings[3],", ",namesrisk[4],": ",M_weightings[4],", ",namesrisk[5],": ",M_weightings[5])
a=ggplot()+geom_point(data=lbstDat,aes(x=swor,y=lbst,color=Marxan_raw),size=1,shape=1)+scale_color_gradientn(colours=rainbow(7),na.value = "transparent",
                                                                                                             breaks=c(-.5,0,.5),
                                                                                                             limits=c(-1,1))
a=a+ggtitle(label = paste0("Relationship between swor and lbst probability of presence and ",algorithm," predictions: ",species," data"),subtitle = subtitle)+labs(x="Swordfish probability of presence")+labs(y=paste0("Leatherback probability of presence"))+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+guides(fill=guide_legend(title="Species"))+theme(legend.title = element_text(size=6),legend.position=c(.99,.45),legend.justification = c(.9,.9))+theme(legend.background = element_blank())+theme(legend.text=element_text(size=6),legend.box.background = element_rect(colour = "black"))+ theme(legend.key=element_blank()) 
a
##

data=run6_real
sworDat=data[data$sp=="swor",]
lbstDat=data[data$sp=="lbst",]
ER_weightings<-c(-0.1,-0.1,-0.05,-2.5,2.5)
M_weightings<-c(-0.1,-0.1,-0.05,-0.4,0.4)

algorithm="EcoROMS_original"
species="swordfish"
subtitle=paste0(namesrisk[1],": ",ER_weightings[1],", ",namesrisk[2],": ",ER_weightings[2],", ",namesrisk[3],": ",ER_weightings[3],", ",namesrisk[4],": ",ER_weightings[4],", ",namesrisk[5],": ",ER_weightings[5])
a=ggplot()+geom_point(data=sworDat,aes(x=swor,y=lbst,color=EcoROMS_original),size=1,shape=1)+scale_color_gradientn(colours=rainbow(7),na.value = "transparent",
                                                                                                                   breaks=c(-.5,0,.5),
                                                                                                                   limits=c(-1,1))
a=a+ggtitle(label = paste0("Relationship between swor and lbst probability of presence and ",algorithm," predictions: ",species," data"),subtitle = subtitle)+labs(x="Swordfish probability of presence")+labs(y=paste0("Leatherback probability of presence"))+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+guides(fill=guide_legend(title="Species"))+theme(legend.title = element_text(size=6),legend.position=c(.99,.45),legend.justification = c(.9,.9))+theme(legend.background = element_blank())+theme(legend.text=element_text(size=6),legend.box.background = element_rect(colour = "black"))+ theme(legend.key=element_blank()) 
a

algorithm="EcoROMS_original"
species="leatherback"
subtitle=paste0(namesrisk[1],": ",ER_weightings[1],", ",namesrisk[2],": ",ER_weightings[2],", ",namesrisk[3],": ",ER_weightings[3],", ",namesrisk[4],": ",ER_weightings[4],", ",namesrisk[5],": ",ER_weightings[5])
a=ggplot()+geom_point(data=lbstDat,aes(x=swor,y=lbst,color=EcoROMS_original),size=1,shape=1)+scale_color_gradientn(colours=rainbow(7),na.value = "transparent",
                                                                                                                   breaks=c(-.5,0,.5),
                                                                                                                   limits=c(-1,1))
a=a+ggtitle(label = paste0("Relationship between swor and lbst probability of presence and ",algorithm," predictions: ",species," data"),subtitle = subtitle)+labs(x="Swordfish probability of presence")+labs(y=paste0("Leatherback probability of presence"))+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+guides(fill=guide_legend(title="Species"))+theme(legend.title = element_text(size=6),legend.position=c(.99,.45),legend.justification = c(.9,.9))+theme(legend.background = element_blank())+theme(legend.text=element_text(size=6),legend.box.background = element_rect(colour = "black"))+ theme(legend.key=element_blank()) 
a

algorithm="Marxan_raw"
species="swordfish"
subtitle=paste0(namesrisk[1],": ",M_weightings[1],", ",namesrisk[2],": ",M_weightings[2],", ",namesrisk[3],": ",M_weightings[3],", ",namesrisk[4],": ",M_weightings[4],", ",namesrisk[5],": ",M_weightings[5])
a=ggplot()+geom_point(data=sworDat,aes(x=swor,y=lbst,color=Marxan_raw),size=1,shape=1)+scale_color_gradientn(colours=rainbow(7),na.value = "transparent",
                                                                                                             breaks=c(-.5,0,.5),
                                                                                                             limits=c(-1,1))
a=a+ggtitle(label = paste0("Relationship between swor and lbst probability of presence and ",algorithm," predictions: ",species," data"),subtitle = subtitle)+labs(x="Swordfish probability of presence")+labs(y=paste0("Leatherback probability of presence"))+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+guides(fill=guide_legend(title="Species"))+theme(legend.title = element_text(size=6),legend.position=c(.99,.45),legend.justification = c(.9,.9))+theme(legend.background = element_blank())+theme(legend.text=element_text(size=6),legend.box.background = element_rect(colour = "black"))+ theme(legend.key=element_blank()) 
a

algorithm="Marxan_raw"
species="leatherback"
subtitle=paste0(namesrisk[1],": ",M_weightings[1],", ",namesrisk[2],": ",M_weightings[2],", ",namesrisk[3],": ",M_weightings[3],", ",namesrisk[4],": ",M_weightings[4],", ",namesrisk[5],": ",M_weightings[5])
a=ggplot()+geom_point(data=lbstDat,aes(x=swor,y=lbst,color=Marxan_raw),size=1,shape=1)+scale_color_gradientn(colours=rainbow(7),na.value = "transparent",
                                                                                                             breaks=c(-.5,0,.5),
                                                                                                             limits=c(-1,1))
a=a+ggtitle(label = paste0("Relationship between swor and lbst probability of presence and ",algorithm," predictions: ",species," data"),subtitle = subtitle)+labs(x="Swordfish probability of presence")+labs(y=paste0("Leatherback probability of presence"))+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+guides(fill=guide_legend(title="Species"))+theme(legend.title = element_text(size=6),legend.position=c(.99,.45),legend.justification = c(.9,.9))+theme(legend.background = element_blank())+theme(legend.text=element_text(size=6),legend.box.background = element_rect(colour = "black"))+ theme(legend.key=element_blank()) 
a