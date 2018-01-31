#### code to predict the EcoCast and EcoROMS species models at the locations/times of catch/bycatch events
### 3. predict for each species at each raw data point
### 4. create Eco products under conditions of different species weightings
### 5. make plots

source("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/load_functions.R")

## A. rasterRescale
Rescale<-function(r){
  r.min = min(r)
  r.max = max(r)
  r.scale <- ((r - r.min) / (r.max - r.min) - 0.5 ) * 2
  return(r.scale) #(r-rmin)/(rmax-rmin)
}

## A2. rasterRescale (-1 to r.max) ## this is for when swordfish = 0, we still rescale the min value to -1 to fit within app.R color range ##test
alt_Rescale=function(r){
  r.min = min(r)
  r.max = max(r)
  r.scale = -1+(0--1)*(r-r.min)/(r.max-r.min)
  return(r.scale)
}

### 3. predict for each species at each raw data point ####
## 1. read in species models
swor=readRDS("/Users/heatherwelch/Dropbox/Eco-ROMS/Model Outputs/Final EcoROMS models/SWOR.res1.tc3.lr03.10models.rds")
blsh_obs=readRDS("/Users/heatherwelch/Dropbox/Eco-ROMS/Model Outputs/Final EcoROMS models/BLSH_obs.res1.tc3.lr03.10models.rds")
blsh_trk=readRDS("/Users/heatherwelch/Dropbox/Eco-ROMS/Model Outputs/Final EcoROMS models/BLSH_trk.res1.tc3.lr05.10models.noLat.rds")
casl=readRDS("/Users/heatherwelch/Dropbox/Eco-ROMS/Model Outputs/Final EcoROMS models/casl.res1.tc4.lr.1.10models.rds")
lbst=readRDS("/Users/heatherwelch/Dropbox/Eco-ROMS/Model Outputs/Final EcoROMS models/LBST.res1.tc3.lr01.10models.rds")

## 1. read in species data
species=read.csv("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/raw_data/observer_casl_swor_blsh_lbst_roms.csv") %>% mutate(SpCd=as.factor(SpCd))

pred_fcn <- function(dataInput,model_object){
  ## Predict on model data using the best tree for predicting
  mod_pred10 <- lapply(model_object,FUN=predict.gbm,newdata=dataInput,n.trees=1000,type='response')
  mod_pred10s <- do.call(cbind,lapply(mod_pred10,data.frame,stringsAsFactors=FALSE))
  colnames(mod_pred10s) <- as.character(seq(1,10,by=1))
  meanPred <- apply(mod_pred10s,1,mean)
  return(meanPred)
}

species$swor=pred_fcn(species,swor)
species$blsh_obs=pred_fcn(species,blsh_obs)
species$blsh_trk=pred_fcn(species,blsh_trk)
species$casl=pred_fcn(species,casl)
species$lbst=pred_fcn(species,lbst)
write.csv(species,"/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/raw_data/species_predicted.csv")

### 4. create Eco products under conditions of different species weightings ####
namesrisk<-c("Blue shark bycatch","Blue sharks","Sea lions","Leatherbacks","Swordfish") ### order of weightings
species=read.csv("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/raw_data/species_predicted.csv")

eco_product=function(weightings,dataInput){
  colnam=paste0("eco_",paste0(weightings,collapse="_"))
  dataInput=mutate(dataInput,test=blsh_obs*weightings[1]+blsh_trk*weightings[2]+casl*weightings[3]+lbst*weightings[4]+swor*weightings[5])
  if(weightings[5]==0){dataInput$test=alt_Rescale(dataInput$test)}
  else(dataInput$test=Rescale(dataInput$test))
  names(dataInput)[names(dataInput)=="test"]<-colnam
  return(dataInput)
}

weightings<-c(-0.1,-0.1,-0.05,-0.9,0.9)  # testing the effect of swor weighting
species=eco_product(weightings = weightings,dataInput = species)

weightings<-c(-0.1,-0.1,-0.05,-0.9,.5)  # testing the effect of swor weighting
species=eco_product(weightings = weightings,dataInput = species)

weightings<-c(-0.1,-0.1,-0.05,-0.9,0)  # testing the effect of swor weighting
species=eco_product(weightings = weightings,dataInput = species)

weightings<-c(-1,-1,-1,-1,1)  # test raw weightings w sign-age
species=eco_product(weightings = weightings,dataInput = species)


### 5. make plots ####
species$sp_name=NA
species[species$SpCd=="UO","sp_name"]="CASL"
species[species$SpCd=="DC","sp_name"]="LBST"
species[species$SpCd=="91","sp_name"]="SWOR"
species[species$SpCd=="167","sp_name"]="BLSH"

### boxplots ####
weightings<-c(-0.1,-0.1,-0.05,-0.9,0.9)
col=paste0("^eco_",paste0(weightings,collapse="_"),"$")
index=NULL
index=grep(print(col),names(species))
subtitle=paste0(namesrisk[1],": ",weightings[1],", ",namesrisk[2],": ",weightings[2],", ",namesrisk[3],": ",weightings[3],", ",namesrisk[4],": ",weightings[4],", ",namesrisk[5],": ",weightings[5])
a=ggplot(data=species,aes(x=sp_name,y=species[,index]))+geom_boxplot()
a=a+ggtitle(label = "Weighted EcoROMS predictions at historical catch events",subtitle = subtitle)+labs(x="Species catch events")+labs(y="EcoROMS prediction")+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
png(paste0("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/box_",paste0(weightings,collapse="_"),".png"),width=5,height=5,units='in',res=400)
a
dev.off()

weightings<-c(-0.1,-0.1,-0.05,-0.9,.5)  # testing the effect of swor weighting
col=paste0("^eco_",paste0(weightings,collapse="_"),"$")
index=NULL
index=grep(print(col),names(species))
subtitle=paste0(namesrisk[1],": ",weightings[1],", ",namesrisk[2],": ",weightings[2],", ",namesrisk[3],": ",weightings[3],", ",namesrisk[4],": ",weightings[4],", ",namesrisk[5],": ",weightings[5])
a=ggplot(data=species,aes(x=sp_name,y=species[,index]))+geom_boxplot()
a=a+ggtitle(label = "Weighted EcoROMS predictions at historical catch events",subtitle = subtitle)+labs(x="Species catch events")+labs(y="EcoROMS prediction")+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
png(paste0("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/box_",paste0(weightings,collapse="_"),".png"),width=5,height=5,units='in',res=400)
a
dev.off()

weightings<-c(-0.1,-0.1,-0.05,-0.9,0)  # testing the effect of swor weighting
col=paste0("^eco_",paste0(weightings,collapse="_"),"$")
index=NULL
index=grep(print(col),names(species))
subtitle=paste0(namesrisk[1],": ",weightings[1],", ",namesrisk[2],": ",weightings[2],", ",namesrisk[3],": ",weightings[3],", ",namesrisk[4],": ",weightings[4],", ",namesrisk[5],": ",weightings[5])
a=ggplot(data=species,aes(x=sp_name,y=species[,index]))+geom_boxplot()
a=a+ggtitle(label = "Weighted EcoROMS predictions at historical catch events",subtitle = subtitle)+labs(x="Species catch events")+labs(y="EcoROMS prediction")+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
png(paste0("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/box_",paste0(weightings,collapse="_"),".png"),width=5,height=5,units='in',res=400)
a
dev.off()

weightings<-c(-1,-1,-1,-1,1)  # test raw weightings w sign-age
col=paste0("^eco_",paste0(weightings,collapse="_"),"$")
index=NULL
index=grep(print(col),names(species))
subtitle=paste0(namesrisk[1],": ",weightings[1],", ",namesrisk[2],": ",weightings[2],", ",namesrisk[3],": ",weightings[3],", ",namesrisk[4],": ",weightings[4],", ",namesrisk[5],": ",weightings[5])
a=ggplot(data=species,aes(x=sp_name,y=species[,index]))+geom_boxplot()
a=a+ggtitle(label = "Weighted EcoROMS predictions at historical catch events",subtitle = subtitle)+labs(x="Species catch events")+labs(y="EcoROMS prediction")+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
png(paste0("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/box_",paste0(weightings,collapse="_"),".png"),width=5,height=5,units='in',res=400)
a
dev.off()

### point clouds ####

sworDat=species[species$sp_name=="SWOR",]
caslDat=species[species$sp_name=="CASL",]
lbstDat=species[species$sp_name=="LBST",]
blshDat=species[species$sp_name=="BLSH",]

weightings<-c(-0.1,-0.1,-0.05,-0.9,0.9)
col=paste0("^eco_",paste0(weightings,collapse="_"),"$")
index=NULL
index=grep(print(col),names(species))
subtitle=paste0(namesrisk[1],": ",weightings[1],", ",namesrisk[2],": ",weightings[2],", ",namesrisk[3],": ",weightings[3],", ",namesrisk[4],": ",weightings[4],", ",namesrisk[5],": ",weightings[5])
a=ggplot()+geom_point(data=sworDat,aes(x=swor,y=sworDat[,index],color="SWOR"),size=.5,shape=1)
a=a+geom_point(data=blshDat,aes(x=blsh_obs,y=blshDat[,index],color="BLSH obs"),size=.5,shape=1)
a=a+geom_point(data=blshDat,aes(x=blsh_trk,y=blshDat[,index],color="BLSH trk"),size=.5,shape=1)
a=a+geom_point(data=lbstDat,aes(x=lbst,y=lbstDat[,index],color="LBST"),size=1.5,shape=15)
a=a+geom_point(data=caslDat,aes(x=casl,y=caslDat[,index],color="CASL"),size=1.5,shape=15)
a=a+ggtitle(label = "Relationship between species probability of presence and weighed EcoROMS predictions",subtitle = subtitle)+labs(x="Probability of presence")+labs(y="EcoROMS prediction")+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+scale_color_manual("",values=c("SWOR"="goldenrod","BLSH obs"="gray","BLSH trk"="gray47","LBST"="chartreuse4","CASL"="coral3"))
a=a+guides(fill=guide_legend(title="Species"))+theme(legend.title = element_text(size=6),legend.position=c(.99,.45),legend.justification = c(.9,.9))+theme(legend.background = element_blank())+theme(legend.text=element_text(size=6),legend.box.background = element_rect(colour = "black"))+ theme(legend.key=element_blank()) +guides(color=guide_legend(override.aes = list(shape=c(1,1,15,15,1))))

png(paste0("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/cloud_",paste0(weightings,collapse="_"),".png"),width=7,height=4,units='in',res=400)
a
dev.off()

weightings<-c(-0.1,-0.1,-0.05,-0.9,.5)  # testing the effect of swor weighting
col=paste0("^eco_",paste0(weightings,collapse="_"),"$")
index=NULL
index=grep(print(col),names(species))
subtitle=paste0(namesrisk[1],": ",weightings[1],", ",namesrisk[2],": ",weightings[2],", ",namesrisk[3],": ",weightings[3],", ",namesrisk[4],": ",weightings[4],", ",namesrisk[5],": ",weightings[5])
a=ggplot()+geom_point(data=sworDat,aes(x=swor,y=sworDat[,index],color="SWOR"),size=.5,shape=1)
a=a+geom_point(data=blshDat,aes(x=blsh_obs,y=blshDat[,index],color="BLSH obs"),size=.5,shape=1)
a=a+geom_point(data=blshDat,aes(x=blsh_trk,y=blshDat[,index],color="BLSH trk"),size=.5,shape=1)
a=a+geom_point(data=lbstDat,aes(x=lbst,y=lbstDat[,index],color="LBST"),size=1.5,shape=15)
a=a+geom_point(data=caslDat,aes(x=casl,y=caslDat[,index],color="CASL"),size=1.5,shape=15)
a=a+ggtitle(label = "Relationship between species probability of presence and weighed EcoROMS predictions",subtitle = subtitle)+labs(x="Probability of presence")+labs(y="EcoROMS prediction")+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+scale_color_manual("",values=c("SWOR"="goldenrod","BLSH obs"="gray","BLSH trk"="gray47","LBST"="chartreuse4","CASL"="coral3"))
a=a+guides(fill=guide_legend(title="Species"))+theme(legend.title = element_text(size=6),legend.position=c(.99,.45),legend.justification = c(.9,.9))+theme(legend.background = element_blank())+theme(legend.text=element_text(size=6),legend.box.background = element_rect(colour = "black"))+ theme(legend.key=element_blank()) +guides(color=guide_legend(override.aes = list(shape=c(1,1,15,15,1))))

png(paste0("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/cloud_",paste0(weightings,collapse="_"),".png"),width=7,height=4,units='in',res=400)
a
dev.off()

weightings<-c(-0.1,-0.1,-0.05,-0.9,0)  # testing the effect of swor weighting
col=paste0("^eco_",paste0(weightings,collapse="_"),"$")
index=NULL
index=grep(print(col),names(species))
subtitle=paste0(namesrisk[1],": ",weightings[1],", ",namesrisk[2],": ",weightings[2],", ",namesrisk[3],": ",weightings[3],", ",namesrisk[4],": ",weightings[4],", ",namesrisk[5],": ",weightings[5])
a=ggplot()+geom_point(data=sworDat,aes(x=swor,y=sworDat[,index],color="SWOR"),size=.5,shape=1)
a=a+geom_point(data=blshDat,aes(x=blsh_obs,y=blshDat[,index],color="BLSH obs"),size=.5,shape=1)
a=a+geom_point(data=blshDat,aes(x=blsh_trk,y=blshDat[,index],color="BLSH trk"),size=.5,shape=1)
a=a+geom_point(data=lbstDat,aes(x=lbst,y=lbstDat[,index],color="LBST"),size=1.5,shape=15)
a=a+geom_point(data=caslDat,aes(x=casl,y=caslDat[,index],color="CASL"),size=1.5,shape=15)
a=a+ggtitle(label = "Relationship between species probability of presence and weighed EcoROMS predictions",subtitle = subtitle)+labs(x="Probability of presence")+labs(y="EcoROMS prediction")+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+scale_color_manual("",values=c("SWOR"="goldenrod","BLSH obs"="gray","BLSH trk"="gray47","LBST"="chartreuse4","CASL"="coral3"))
a=a+guides(fill=guide_legend(title="Species"))+theme(legend.title = element_text(size=6),legend.position=c(.99,.45),legend.justification = c(.9,.9))+theme(legend.background = element_blank())+theme(legend.text=element_text(size=6),legend.box.background = element_rect(colour = "black"))+ theme(legend.key=element_blank()) +guides(color=guide_legend(override.aes = list(shape=c(1,1,15,15,1))))

png(paste0("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/cloud_",paste0(weightings,collapse="_"),".png"),width=7,height=4,units='in',res=400)
a
dev.off()

weightings<-c(-1,-1,-1,-1,1)  # test raw weightings w sign-age
col=paste0("^eco_",paste0(weightings,collapse="_"),"$")
index=NULL
index=grep(print(col),names(species))
subtitle=paste0(namesrisk[1],": ",weightings[1],", ",namesrisk[2],": ",weightings[2],", ",namesrisk[3],": ",weightings[3],", ",namesrisk[4],": ",weightings[4],", ",namesrisk[5],": ",weightings[5])
a=ggplot()+geom_point(data=sworDat,aes(x=swor,y=sworDat[,index],color="SWOR"),size=.5,shape=1)
a=a+geom_point(data=blshDat,aes(x=blsh_obs,y=blshDat[,index],color="BLSH obs"),size=.5,shape=1)
a=a+geom_point(data=blshDat,aes(x=blsh_trk,y=blshDat[,index],color="BLSH trk"),size=.5,shape=1)
a=a+geom_point(data=lbstDat,aes(x=lbst,y=lbstDat[,index],color="LBST"),size=1.5,shape=15)
a=a+geom_point(data=caslDat,aes(x=casl,y=caslDat[,index],color="CASL"),size=1.5,shape=15)
a=a+ggtitle(label = "Relationship between species probability of presence and weighed EcoROMS predictions",subtitle = subtitle)+labs(x="Probability of presence")+labs(y="EcoROMS prediction")+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+scale_color_manual("",values=c("SWOR"="goldenrod","BLSH obs"="gray","BLSH trk"="gray47","LBST"="chartreuse4","CASL"="coral3"))
a=a+guides(fill=guide_legend(title="Species"))+theme(legend.title = element_text(size=6),legend.position=c(.99,.45),legend.justification = c(.9,.9))+theme(legend.background = element_blank())+theme(legend.text=element_text(size=6),legend.box.background = element_rect(colour = "black"))+ theme(legend.key=element_blank()) +guides(color=guide_legend(override.aes = list(shape=c(1,1,15,15,1))))

png(paste0("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/cloud_",paste0(weightings,collapse="_"),".png"),width=7,height=4,units='in',res=400)
a
dev.off()



### histograms ####
weightings<-c(-0.1,-0.1,-0.05,-0.9,0.9)
col=paste0("^eco_",paste0(weightings,collapse="_"),"$")
index=NULL
index=grep(print(col),names(species))
a=hist(lbstDat[,index],breaks=c(-1,-.75,-.5,-.25,0,.25,.5,.75,1))
a$density=a$counts/sum(a$counts)*100
b=hist(sworDat[,index],breaks=c(-1,-.75,-.5,-.25,0,.25,.5,.75,1))
b$density=b$counts/sum(b$counts)*100
d=hist(caslDat[,index],breaks=c(-1,-.75,-.5,-.25,0,.25,.5,.75,1))
d$density=d$counts/sum(d$counts)*100
c=hist(blshDat[,index],breaks=c(-1,-.75,-.5,-.25,0,.25,.5,.75,1))
c$density=c$counts/sum(c$counts)*100

png(paste0("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/hist_",paste0(weightings,collapse="_"),".png"),width=7,height=5,units='in',res=400)
par(mfrow=c(2,2))
plot(b,col=rgb(0,0,1,0.3),freq=F,xlim=c(-1,1),ylim=c(0,60),main=paste0("Swordfish: ",weightings[5]),xlab="EcoROMS product threshold bins",ylab="Percent of bycatch events",cex.lab=.7,cex.axis=.7)
plot(a,col=rgb(1,0,0,0.3),xlim=c(-1,1),ylim=c(0,60),main=paste0("Leatherback: ",weightings[4]),xlab="EcoROMS product threshold bins",ylab="Percent of bycatch events",freq=F,cex.lab=.7,cex.axis=.7)
plot(c,col=rgb(0.5,0.5,0.5,0.3),xlim=c(-1,1),ylim=c(0,60),main=paste0("Blueshark obs & trk: ",weightings[1]),xlab="EcoROMS product threshold bins",ylab="Percent of bycatch events",freq=F,cex.lab=.7,cex.axis=.7)
plot(d,col=rgb(0,0.5,0,0.5),xlim=c(-1,1),ylim=c(0,60),main=paste0("Sea lion: ",weightings[3]),xlab="EcoROMS product threshold bins",ylab="Percent of bycatch events",freq=F,cex.lab=.7,cex.axis=.7)
dev.off()

weightings<-c(-0.1,-0.1,-0.05,-0.9,.5)  # testing the effect of swor weighting
col=paste0("^eco_",paste0(weightings,collapse="_"),"$")
index=NULL
index=grep(print(col),names(species))
a=hist(lbstDat[,index],breaks=c(-1,-.75,-.5,-.25,0,.25,.5,.75,1))
a$density=a$counts/sum(a$counts)*100
b=hist(sworDat[,index],breaks=c(-1,-.75,-.5,-.25,0,.25,.5,.75,1))
b$density=b$counts/sum(b$counts)*100
d=hist(caslDat[,index],breaks=c(-1,-.75,-.5,-.25,0,.25,.5,.75,1))
d$density=d$counts/sum(d$counts)*100
c=hist(blshDat[,index],breaks=c(-1,-.75,-.5,-.25,0,.25,.5,.75,1))
c$density=c$counts/sum(c$counts)*100

png(paste0("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/hist_",paste0(weightings,collapse="_"),".png"),width=7,height=5,units='in',res=400)
par(mfrow=c(2,2))
plot(b,col=rgb(0,0,1,0.3),freq=F,xlim=c(-1,1),ylim=c(0,60),main=paste0("Swordfish: ",weightings[5]),xlab="EcoROMS product threshold bins",ylab="Percent of bycatch events",cex.lab=.7,cex.axis=.7)
plot(a,col=rgb(1,0,0,0.3),xlim=c(-1,1),ylim=c(0,60),main=paste0("Leatherback: ",weightings[4]),xlab="EcoROMS product threshold bins",ylab="Percent of bycatch events",freq=F,cex.lab=.7,cex.axis=.7)
plot(c,col=rgb(0.5,0.5,0.5,0.3),xlim=c(-1,1),ylim=c(0,60),main=paste0("Blueshark obs & trk: ",weightings[1]),xlab="EcoROMS product threshold bins",ylab="Percent of bycatch events",freq=F,cex.lab=.7,cex.axis=.7)
plot(d,col=rgb(0,0.5,0,0.5),xlim=c(-1,1),ylim=c(0,60),main=paste0("Sea lion: ",weightings[3]),xlab="EcoROMS product threshold bins",ylab="Percent of bycatch events",freq=F,cex.lab=.7,cex.axis=.7)
dev.off()

weightings<-c(-0.1,-0.1,-0.05,-0.9,0)  # testing the effect of swor weighting
col=paste0("^eco_",paste0(weightings,collapse="_"),"$")
index=NULL
index=grep(print(col),names(species))
a=hist(lbstDat[,index],breaks=c(-1,-.75,-.5,-.25,0,.25,.5,.75,1))
a$density=a$counts/sum(a$counts)*100
b=hist(sworDat[,index],breaks=c(-1,-.75,-.5,-.25,0,.25,.5,.75,1))
b$density=b$counts/sum(b$counts)*100
d=hist(caslDat[,index],breaks=c(-1,-.75,-.5,-.25,0,.25,.5,.75,1))
d$density=d$counts/sum(d$counts)*100
c=hist(blshDat[,index],breaks=c(-1,-.75,-.5,-.25,0,.25,.5,.75,1))
c$density=c$counts/sum(c$counts)*100

png(paste0("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/hist_",paste0(weightings,collapse="_"),".png"),width=7,height=5,units='in',res=400)
par(mfrow=c(2,2))
plot(b,col=rgb(0,0,1,0.3),freq=F,xlim=c(-1,1),ylim=c(0,60),main=paste0("Swordfish: ",weightings[5]),xlab="EcoROMS product threshold bins",ylab="Percent of bycatch events",cex.lab=.7,cex.axis=.7)
plot(a,col=rgb(1,0,0,0.3),xlim=c(-1,1),ylim=c(0,60),main=paste0("Leatherback: ",weightings[4]),xlab="EcoROMS product threshold bins",ylab="Percent of bycatch events",freq=F,cex.lab=.7,cex.axis=.7)
plot(c,col=rgb(0.5,0.5,0.5,0.3),xlim=c(-1,1),ylim=c(0,60),main=paste0("Blueshark obs & trk: ",weightings[1]),xlab="EcoROMS product threshold bins",ylab="Percent of bycatch events",freq=F,cex.lab=.7,cex.axis=.7)
plot(d,col=rgb(0,0.5,0,0.5),xlim=c(-1,1),ylim=c(0,60),main=paste0("Sea lion: ",weightings[3]),xlab="EcoROMS product threshold bins",ylab="Percent of bycatch events",freq=F,cex.lab=.7,cex.axis=.7)
dev.off()

weightings<-c(-1,-1,-1,-1,1)  # test raw weightings w sign-age
col=paste0("^eco_",paste0(weightings,collapse="_"),"$")
index=NULL
index=grep(print(col),names(species))
a=hist(lbstDat[,index],breaks=c(-1,-.75,-.5,-.25,0,.25,.5,.75,1))
a$density=a$counts/sum(a$counts)*100
b=hist(sworDat[,index],breaks=c(-1,-.75,-.5,-.25,0,.25,.5,.75,1))
b$density=b$counts/sum(b$counts)*100
d=hist(caslDat[,index],breaks=c(-1,-.75,-.5,-.25,0,.25,.5,.75,1))
d$density=d$counts/sum(d$counts)*100
c=hist(blshDat[,index],breaks=c(-1,-.75,-.5,-.25,0,.25,.5,.75,1))
c$density=c$counts/sum(c$counts)*100

png(paste0("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/hist_",paste0(weightings,collapse="_"),".png"),width=7,height=5,units='in',res=400)
par(mfrow=c(2,2))
plot(b,col=rgb(0,0,1,0.3),freq=F,xlim=c(-1,1),ylim=c(0,60),main=paste0("Swordfish: ",weightings[5]),xlab="EcoROMS product threshold bins",ylab="Percent of bycatch events",cex.lab=.7,cex.axis=.7)
plot(a,col=rgb(1,0,0,0.3),xlim=c(-1,1),ylim=c(0,60),main=paste0("Leatherback: ",weightings[4]),xlab="EcoROMS product threshold bins",ylab="Percent of bycatch events",freq=F,cex.lab=.7,cex.axis=.7)
plot(c,col=rgb(0.5,0.5,0.5,0.3),xlim=c(-1,1),ylim=c(0,60),main=paste0("Blueshark obs & trk: ",weightings[1]),xlab="EcoROMS product threshold bins",ylab="Percent of bycatch events",freq=F,cex.lab=.7,cex.axis=.7)
plot(d,col=rgb(0,0.5,0,0.5),xlim=c(-1,1),ylim=c(0,60),main=paste0("Sea lion: ",weightings[3]),xlab="EcoROMS product threshold bins",ylab="Percent of bycatch events",freq=F,cex.lab=.7,cex.axis=.7)
dev.off()

### histogram tables ####
weightings<-c(-0.1,-0.1,-0.05,-0.9,0.9)
thresholds=c(-0.75,-0.50,-0.25,0.00,0.25,0.50,0.75) 
col=paste0("^eco_",paste0(weightings,collapse="_"),"$")
index=NULL
index=grep(print(col),names(species))
countslbst=list(sum(lbstDat[,index]>thresholds[1]),sum(lbstDat[,index]>thresholds[2]),sum(lbstDat[,index]>thresholds[3]),sum(lbstDat[,index]>thresholds[4]),sum(lbstDat[,index]>thresholds[5]),sum(lbstDat[,index]>thresholds[6]),sum(lbstDat[,index]>thresholds[7])) %>% unlist()
percentlbst=countslbst/nrow(lbstDat)*100
countsswor=list(sum(sworDat[,index]>thresholds[1]),sum(sworDat[,index]>thresholds[2]),sum(sworDat[,index]>thresholds[3]),sum(sworDat[,index]>thresholds[4]),sum(sworDat[,index]>thresholds[5]),sum(sworDat[,index]>thresholds[6]),sum(sworDat[,index]>thresholds[7])) %>% unlist()
percentswor=countsswor/nrow(sworDat)*100
countscasl=list(sum(caslDat[,index]>thresholds[1]),sum(caslDat[,index]>thresholds[2]),sum(caslDat[,index]>thresholds[3]),sum(caslDat[,index]>thresholds[4]),sum(caslDat[,index]>thresholds[5]),sum(caslDat[,index]>thresholds[6]),sum(caslDat[,index]>thresholds[7])) %>% unlist()
percentcasl=countscasl/nrow(caslDat)*100
countsblsh=list(sum(blshDat[,index]>thresholds[1]),sum(blshDat[,index]>thresholds[2]),sum(blshDat[,index]>thresholds[3]),sum(blshDat[,index]>thresholds[4]),sum(blshDat[,index]>thresholds[5]),sum(blshDat[,index]>thresholds[6]),sum(blshDat[,index]>thresholds[7])) %>% unlist()
percentblsh=countsblsh/nrow(blshDat)*100
empty=data.frame(matrix(NA,nrow=length(thresholds),ncol=10))
empty=data.frame(matrix(nrow=7))
empty$thresholds=thresholds
empty$weighting=paste0(weightings,collapse="_")
empty$lbst_counts=countslbst
empty$lbst_percent=percentlbst
empty$swor_counts=countsswor
empty$swor_percent=percentswor
empty$casl_counts=countscasl
empty$casl_percent=percentcasl
empty$blsh_counts=countsblsh
empty$blsh_percent=percentblsh
w1=empty

weightings<-c(-0.1,-0.1,-0.05,-0.9,.5)  # testing the effect of swor weighting
thresholds=c(-0.75,-0.50,-0.25,0.00,0.25,0.50,0.75) 
col=paste0("^eco_",paste0(weightings,collapse="_"),"$")
index=NULL
index=grep(print(col),names(species))
countslbst=list(sum(lbstDat[,index]>thresholds[1]),sum(lbstDat[,index]>thresholds[2]),sum(lbstDat[,index]>thresholds[3]),sum(lbstDat[,index]>thresholds[4]),sum(lbstDat[,index]>thresholds[5]),sum(lbstDat[,index]>thresholds[6]),sum(lbstDat[,index]>thresholds[7])) %>% unlist()
percentlbst=countslbst/nrow(lbstDat)*100
countsswor=list(sum(sworDat[,index]>thresholds[1]),sum(sworDat[,index]>thresholds[2]),sum(sworDat[,index]>thresholds[3]),sum(sworDat[,index]>thresholds[4]),sum(sworDat[,index]>thresholds[5]),sum(sworDat[,index]>thresholds[6]),sum(sworDat[,index]>thresholds[7])) %>% unlist()
percentswor=countsswor/nrow(sworDat)*100
countscasl=list(sum(caslDat[,index]>thresholds[1]),sum(caslDat[,index]>thresholds[2]),sum(caslDat[,index]>thresholds[3]),sum(caslDat[,index]>thresholds[4]),sum(caslDat[,index]>thresholds[5]),sum(caslDat[,index]>thresholds[6]),sum(caslDat[,index]>thresholds[7])) %>% unlist()
percentcasl=countscasl/nrow(caslDat)*100
countsblsh=list(sum(blshDat[,index]>thresholds[1]),sum(blshDat[,index]>thresholds[2]),sum(blshDat[,index]>thresholds[3]),sum(blshDat[,index]>thresholds[4]),sum(blshDat[,index]>thresholds[5]),sum(blshDat[,index]>thresholds[6]),sum(blshDat[,index]>thresholds[7])) %>% unlist()
percentblsh=countsblsh/nrow(blshDat)*100
empty=data.frame(matrix(NA,nrow=length(thresholds),ncol=10))
empty=data.frame(matrix(nrow=7))
empty$thresholds=thresholds
empty$weighting=paste0(weightings,collapse="_")
empty$lbst_counts=countslbst
empty$lbst_percent=percentlbst
empty$swor_counts=countsswor
empty$swor_percent=percentswor
empty$casl_counts=countscasl
empty$casl_percent=percentcasl
empty$blsh_counts=countsblsh
empty$blsh_percent=percentblsh
w2=empty

weightings<-c(-0.1,-0.1,-0.05,-0.9,0)  # testing the effect of swor weighting
thresholds=c(-0.75,-0.50,-0.25,0.00,0.25,0.50,0.75) 
col=paste0("^eco_",paste0(weightings,collapse="_"),"$")
index=NULL
index=grep(print(col),names(species))
countslbst=list(sum(lbstDat[,index]>thresholds[1]),sum(lbstDat[,index]>thresholds[2]),sum(lbstDat[,index]>thresholds[3]),sum(lbstDat[,index]>thresholds[4]),sum(lbstDat[,index]>thresholds[5]),sum(lbstDat[,index]>thresholds[6]),sum(lbstDat[,index]>thresholds[7])) %>% unlist()
percentlbst=countslbst/nrow(lbstDat)*100
countsswor=list(sum(sworDat[,index]>thresholds[1]),sum(sworDat[,index]>thresholds[2]),sum(sworDat[,index]>thresholds[3]),sum(sworDat[,index]>thresholds[4]),sum(sworDat[,index]>thresholds[5]),sum(sworDat[,index]>thresholds[6]),sum(sworDat[,index]>thresholds[7])) %>% unlist()
percentswor=countsswor/nrow(sworDat)*100
countscasl=list(sum(caslDat[,index]>thresholds[1]),sum(caslDat[,index]>thresholds[2]),sum(caslDat[,index]>thresholds[3]),sum(caslDat[,index]>thresholds[4]),sum(caslDat[,index]>thresholds[5]),sum(caslDat[,index]>thresholds[6]),sum(caslDat[,index]>thresholds[7])) %>% unlist()
percentcasl=countscasl/nrow(caslDat)*100
countsblsh=list(sum(blshDat[,index]>thresholds[1]),sum(blshDat[,index]>thresholds[2]),sum(blshDat[,index]>thresholds[3]),sum(blshDat[,index]>thresholds[4]),sum(blshDat[,index]>thresholds[5]),sum(blshDat[,index]>thresholds[6]),sum(blshDat[,index]>thresholds[7])) %>% unlist()
percentblsh=countsblsh/nrow(blshDat)*100
empty=data.frame(matrix(NA,nrow=length(thresholds),ncol=10))
empty=data.frame(matrix(nrow=7))
empty$thresholds=thresholds
empty$weighting=paste0(weightings,collapse="_")
empty$lbst_counts=countslbst
empty$lbst_percent=percentlbst
empty$swor_counts=countsswor
empty$swor_percent=percentswor
empty$casl_counts=countscasl
empty$casl_percent=percentcasl
empty$blsh_counts=countsblsh
empty$blsh_percent=percentblsh
w3=empty

weightings<-c(-1,-1,-1,-1,1)  # test raw weightings w sign-age
thresholds=c(-0.75,-0.50,-0.25,0.00,0.25,0.50,0.75) 
col=paste0("^eco_",paste0(weightings,collapse="_"),"$")
index=NULL
index=grep(print(col),names(species))
countslbst=list(sum(lbstDat[,index]>thresholds[1]),sum(lbstDat[,index]>thresholds[2]),sum(lbstDat[,index]>thresholds[3]),sum(lbstDat[,index]>thresholds[4]),sum(lbstDat[,index]>thresholds[5]),sum(lbstDat[,index]>thresholds[6]),sum(lbstDat[,index]>thresholds[7])) %>% unlist()
percentlbst=countslbst/nrow(lbstDat)*100
countsswor=list(sum(sworDat[,index]>thresholds[1]),sum(sworDat[,index]>thresholds[2]),sum(sworDat[,index]>thresholds[3]),sum(sworDat[,index]>thresholds[4]),sum(sworDat[,index]>thresholds[5]),sum(sworDat[,index]>thresholds[6]),sum(sworDat[,index]>thresholds[7])) %>% unlist()
percentswor=countsswor/nrow(sworDat)*100
countscasl=list(sum(caslDat[,index]>thresholds[1]),sum(caslDat[,index]>thresholds[2]),sum(caslDat[,index]>thresholds[3]),sum(caslDat[,index]>thresholds[4]),sum(caslDat[,index]>thresholds[5]),sum(caslDat[,index]>thresholds[6]),sum(caslDat[,index]>thresholds[7])) %>% unlist()
percentcasl=countscasl/nrow(caslDat)*100
countsblsh=list(sum(blshDat[,index]>thresholds[1]),sum(blshDat[,index]>thresholds[2]),sum(blshDat[,index]>thresholds[3]),sum(blshDat[,index]>thresholds[4]),sum(blshDat[,index]>thresholds[5]),sum(blshDat[,index]>thresholds[6]),sum(blshDat[,index]>thresholds[7])) %>% unlist()
percentblsh=countsblsh/nrow(blshDat)*100
empty=data.frame(matrix(NA,nrow=length(thresholds),ncol=10))
empty=data.frame(matrix(nrow=7))
empty$thresholds=thresholds
empty$weighting=paste0(weightings,collapse="_")
empty$lbst_counts=countslbst
empty$lbst_percent=percentlbst
empty$swor_counts=countsswor
empty$swor_percent=percentswor
empty$casl_counts=countscasl
empty$casl_percent=percentcasl
empty$blsh_counts=countsblsh
empty$blsh_percent=percentblsh
w4=empty

hist_table=do.call("rbind",list(w1,w2,w3,w4))
#write.csv(hist_table,"/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/hist_table.csv")

### histogram tables ratios ####
hist_table=read.csv("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/hist_table.csv")
new=hist_table %>% select(-ends_with("counts")) %>% mutate(lbstDIFF=lbst_percent-swor_percent)%>% mutate(caslDIFF=casl_percent-swor_percent)%>% mutate(blshDIFF=blsh_percent-swor_percent)
new=new[,3:ncol(new)]
new_gather=new %>% gather("Species","Percent",-weighting,-thresholds,-ends_with("DIFF"),-swor_percent) %>%select(-ends_with('DIFF')) %>% mutate(spp=gsub("_percent","",Species))   #%>% spread(weighting,Percent)

weightings<-c(-0.1,-0.1,-0.05,-0.9,0.9)
col=paste0(weightings,collapse="_")
subtitle=paste0(namesrisk[1],": ",weightings[1],", ",namesrisk[2],": ",weightings[2],", ",namesrisk[3],": ",weightings[3],", ",namesrisk[4],": ",weightings[4],", ",namesrisk[5],": ",weightings[5])
a=ggplot()+geom_point(data=new_gather[new$weighting==col,],aes(x=Percent,y=swor_percent,color=spp),shape=1)+geom_text(data=new_gather[new$weighting==col,],aes(x=Percent,y=swor_percent,label=thresholds),vjust=2,hjust=1,size=1.5)
a=a+ggtitle(label = "Avoided swordfish catch and bycatch at different EcoROMS thresholds",subtitle = subtitle)+labs(x="Avoided percent of bycatch")+labs(y="Avoided percent of swordfish catch")+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+guides(fill=guide_legend(title="Species"))+theme(legend.title = element_text(size=6),legend.position=c(.99,.45),legend.justification = c(.9,.9))+theme(legend.background = element_blank())+theme(legend.text=element_text(size=6),legend.box.background = element_rect(colour = "black"))+ theme(legend.key=element_blank())                                                                                                          
png(paste0("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/ratio_",paste0(weightings,collapse="_"),".png"),width=6,height=6,units='in',res=400)
a
dev.off()

weightings<-c(-0.1,-0.1,-0.05,-0.9,.5)  # testing the effect of swor weighting
col=paste0(weightings,collapse="_")
subtitle=paste0(namesrisk[1],": ",weightings[1],", ",namesrisk[2],": ",weightings[2],", ",namesrisk[3],": ",weightings[3],", ",namesrisk[4],": ",weightings[4],", ",namesrisk[5],": ",weightings[5])
a=ggplot()+geom_point(data=new_gather[new$weighting==col,],aes(x=Percent,y=swor_percent,color=spp),shape=1)+geom_text(data=new_gather[new$weighting==col,],aes(x=Percent,y=swor_percent,label=thresholds),vjust=2,hjust=1,size=1.5)
a=a+ggtitle(label = "Avoided swordfish catch and bycatch at different EcoROMS thresholds",subtitle = subtitle)+labs(x="Avoided percent of bycatch")+labs(y="Avoided percent of swordfish catch")+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+guides(fill=guide_legend(title="Species"))+theme(legend.title = element_text(size=6),legend.position=c(.99,.45),legend.justification = c(.9,.9))+theme(legend.background = element_blank())+theme(legend.text=element_text(size=6),legend.box.background = element_rect(colour = "black"))+ theme(legend.key=element_blank())                                                                                                          
png(paste0("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/ratio_",paste0(weightings,collapse="_"),".png"),width=6,height=6,units='in',res=400)
a
dev.off()


weightings<-c(-0.1,-0.1,-0.05,-0.9,0)  # testing the effect of swor weighting
col=paste0(weightings,collapse="_")
subtitle=paste0(namesrisk[1],": ",weightings[1],", ",namesrisk[2],": ",weightings[2],", ",namesrisk[3],": ",weightings[3],", ",namesrisk[4],": ",weightings[4],", ",namesrisk[5],": ",weightings[5])
a=ggplot()+geom_point(data=new_gather[new$weighting==col,],aes(x=Percent,y=swor_percent,color=spp),shape=1)+geom_text(data=new_gather[new$weighting==col,],aes(x=Percent,y=swor_percent,label=thresholds),vjust=2,hjust=1,size=1.5)
a=a+ggtitle(label = "Avoided swordfish catch and bycatch at different EcoROMS thresholds",subtitle = subtitle)+labs(x="Avoided percent of bycatch")+labs(y="Avoided percent of swordfish catch")+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+guides(fill=guide_legend(title="Species"))+theme(legend.title = element_text(size=6),legend.position=c(.99,.45),legend.justification = c(.9,.9))+theme(legend.background = element_blank())+theme(legend.text=element_text(size=6),legend.box.background = element_rect(colour = "black"))+ theme(legend.key=element_blank())                                                                                                          
png(paste0("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/ratio_",paste0(weightings,collapse="_"),".png"),width=6,height=6,units='in',res=400)
a
dev.off()


weightings<-c(-1,-1,-1,-1,1)  # test raw weightings w sign-age
col=paste0(weightings,collapse="_")
subtitle=paste0(namesrisk[1],": ",weightings[1],", ",namesrisk[2],": ",weightings[2],", ",namesrisk[3],": ",weightings[3],", ",namesrisk[4],": ",weightings[4],", ",namesrisk[5],": ",weightings[5])
a=ggplot()+geom_point(data=new_gather[new$weighting==col,],aes(x=Percent,y=swor_percent,color=spp),shape=1)+geom_text(data=new_gather[new$weighting==col,],aes(x=Percent,y=swor_percent,label=thresholds),vjust=2,hjust=1,size=1.5)
a=a+ggtitle(label = "Avoided swordfish catch and bycatch at different EcoROMS thresholds",subtitle = subtitle)+labs(x="Avoided percent of bycatch")+labs(y="Avoided percent of swordfish catch")+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+guides(fill=guide_legend(title="Species"))+theme(legend.title = element_text(size=6),legend.position=c(.99,.45),legend.justification = c(.9,.9))+theme(legend.background = element_blank())+theme(legend.text=element_text(size=6),legend.box.background = element_rect(colour = "black"))+ theme(legend.key=element_blank())                                                                                                          
png(paste0("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/ratio_",paste0(weightings,collapse="_"),".png"),width=6,height=6,units='in',res=400)
a
dev.off()
