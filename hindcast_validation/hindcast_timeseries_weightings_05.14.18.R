## script to hindcast the temporal variability of hindcasts - weightings
## testing the ratio of lbst:swor at different weightings and different catch limits and different algorithms
## weightings: run 4, run 5, run
## catch limits: lbst @ 10,30,50
### test

run4_random=read.csv("raw_data/species_predict_05.04.18_random_scaled_unscaled_marxan_run4.csv") %>% mutate(sworweighting=.1)
run5_random=read.csv("raw_data/species_predict_05.04.18_random_scaled_unscaled_marxan_run5.csv") %>% mutate(sworweighting=.2)
run6_random=read.csv("raw_data/species_predict_05.04.18_random_scaled_unscaled_marxan_run6.csv") %>% mutate(sworweighting=.4)
dataframelist=list(run4_random,run5_random,run6_random)

empty=data.frame(matrix(NA,nrow=18,ncol = 5))
colnames(empty)=c("avoided","Marxan_raw","EcoROMS_original","EcoROMS_original_unscaled","sworweighting")
lbstcatch=c(1,.9,.7,.5,.3,.1)
count=1

for(i in 1:length(lbstcatch)){
  for(ii in 1:length(dataframelist)){
  binA=dataframelist[[ii]] %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw,EcoROMS_original_unscaled)) %>% filter(suitability>=.5) %>% spread(species,suitability) %>% select(EcoROMS_original,EcoROMS_original_unscaled,Marxan_raw,lbst) %>% .[complete.cases(.),]
  binM=quantile(binA$Marxan_raw,(lbstcatch[i]),na.rm = T) %>% as.data.frame() %>% .[,1]
  binE=quantile(binA$EcoROMS_original,(lbstcatch[i]),na.rm = T) %>% as.data.frame() %>% .[,1]
  binEnS=quantile(binA$EcoROMS_original_unscaled,(lbstcatch[i]),na.rm = T) %>% as.data.frame() %>% .[,1]
  print(binM)
  print(binE)
  empty$avoided[count]=lbstcatch[i]
  empty$Marxan_raw[count]=binM
  empty$EcoROMS_original[count]=binE
  empty$EcoROMS_original_unscaled[count]=binEnS
  empty$sworweighting[count]=dataframelist[[ii]]$sworweighting[1]
  count=count+1
  print(count)
  }
}

dataframelist=do.call("rbind",dataframelist)
master=data.frame(product=NA,swor=NA,lbst=NA,sworweighting=NA)
for(i in 1:nrow(empty)){
  data=dataframelist %>% filter(sworweighting==empty$sworweighting[i])
  tablecaughtE=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw,EcoROMS_original_unscaled,sworweighting)) %>% gather(product,product_value,-c(species,suitability,sworweighting)) %>% filter(suitability>=.5) %>% filter(product_value>=empty$EcoROMS_original[i]) %>% 
    filter(product=="EcoROMS_original")%>% group_by(species,product) %>% summarise(num_presences_caught=n()) %>% mutate(sworweighting=empty$sworweighting[i])
  
  tablecaughtM=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw,EcoROMS_original_unscaled,sworweighting)) %>% gather(product,product_value,-c(species,suitability,sworweighting)) %>% filter(suitability>=.5) %>% filter(product_value>=empty$Marxan_raw[i]) %>%
    filter(product=="Marxan_raw")%>% group_by(species,product) %>% summarise(num_presences_caught=n()) %>% mutate(sworweighting=empty$sworweighting[i]) %>% rbind(.,tablecaughtE)
  
  tablecaughtEuS=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw,EcoROMS_original_unscaled,sworweighting)) %>% gather(product,product_value,-c(species,suitability,sworweighting)) %>% filter(suitability>=.5) %>% filter(product_value>=empty$EcoROMS_original_unscaled[i]) %>%
    filter(product=="EcoROMS_original_unscaled")%>% group_by(species,product) %>% summarise(num_presences_caught=n()) %>% mutate(sworweighting=empty$sworweighting[i]) %>% rbind(.,tablecaughtM)
  
  tabletotal=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw,EcoROMS_original_unscaled,sworweighting)) %>% gather(product,product_value,-c(species,suitability,sworweighting)) %>% filter(suitability>=.5) %>%
    group_by(species,product) %>% summarise(num_presences=n()) %>% left_join(tablecaughtEuS,.) %>% mutate(Percent_caught=num_presences_caught/num_presences*100) %>% select(-c(num_presences,num_presences_caught)) %>% spread(species,Percent_caught) 
  
  if(("lbst"%in%colnames(tabletotal))==F){tabletotal$lbst=0}
  
  tabletotal=tabletotal %>% select(product,swor,lbst,sworweighting)
  tabletotal[is.na(tabletotal)]<-0
  
  master=rbind(master,tabletotal) %>% .[complete.cases(.),]
  }

plotting=master %>% mutate(lbst=round(lbst),digits=1) %>% mutate(lbst=paste0(lbst,"% allowable leatherback bycatch")) %>% mutate(lbst=as.factor(lbst))

a=ggplot(plotting,aes(x=sworweighting,y=swor,group=product,color=product))+geom_line()+geom_point(size=.5) +facet_wrap(~lbst,nrow=1)
a=a+ggtitle(label = paste0("Effect of increasing swordfish weighting on swordfish availability under scenarios of allowable leatherback bycatch"),subtitle = "Algorithm thresholds are set by defining % of allowable leatherback bycatch (iterated at 0,10,30,50,70,90%)")+labs(x="Swordfish weighting")+labs(y="% of swordfish available to catch")
a=a+theme(panel.background = element_rect(fill=NA,color="black"),strip.background =element_rect(fill=NA))+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+theme(legend.title = element_text(size=5),legend.position=c(.13,.9),legend.justification = c(.9,.9))+theme(legend.background = element_blank())+theme(legend.text=element_text(size=5),legend.box.background = element_rect(colour = "black"))+theme(legend.key=element_blank())+theme(legend.key.size = unit(.5,'lines'))
a

png("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/figs/weighting_effect_runs456.png",width=10, height=5, units="in", res=400)
par(ps=10)
par(mar=c(4,4,1,1))
par(cex=1)
a
dev.off()

### histograms
png("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/figs/algorithmXweightings@swor.png",width=10, height=3, units="in", res=400)
par(mfrow=c(1,3))
low=dataframelist %>% filter(sworweighting==0.1) %>% filter(swor>.5)
hist(low$EcoROMS_original,col=rgb(1,0,0,0.5),xlim=c(-1,1),ylim=c(0,500),main="Swordfish weighting = .1",xlab="Algorithm values at swor presences")
hist(low$EcoROMS_original_unscaled,col=rgb(0,0,1,0.5),add=T)
hist(low$Marxan_raw,col=rgb(0.5,0.5,0.5,0.5),add=T)
legend("topright", c("EcoROMS_original", "EcoROMS_original_unscaled","Marxan_raw"), col=c(rgb(1,0,0,0.5), rgb(0,0,1,0.5),rgb(0.5,0.5,0.5,0.5)), lwd=8,cex=.5)

low=dataframelist %>% filter(sworweighting==0.2)%>% filter(swor>.5)
hist(low$EcoROMS_original,col=rgb(1,0,0,0.5),xlim=c(-1,1),ylim=c(0,500),main="Swordfish weighting = .2",xlab="Algorithm values at swor presences")
hist(low$EcoROMS_original_unscaled,col=rgb(0,0,1,0.5),add=T)
hist(low$Marxan_raw,col=rgb(0.5,0.5,0.5,0.5),add=T)
legend("topright", c("EcoROMS_original", "EcoROMS_original_unscaled","Marxan_raw"), col=c(rgb(1,0,0,0.5), rgb(0,0,1,0.5),rgb(0.5,0.5,0.5,0.5)), lwd=8,cex=.5)

low=dataframelist %>% filter(sworweighting==0.4)%>% filter(swor>.5)
hist(low$EcoROMS_original,col=rgb(1,0,0,0.5),xlim=c(-1,1),ylim=c(0,500),main="Swordfish weighting = .4",xlab="Algorithm values at swor presences")
hist(low$EcoROMS_original_unscaled,col=rgb(0,0,1,0.5),add=T)
hist(low$Marxan_raw,col=rgb(0.5,0.5,0.5,0.5),add=T)
legend("topright", c("EcoROMS_original", "EcoROMS_original_unscaled","Marxan_raw"), col=c(rgb(1,0,0,0.5), rgb(0,0,1,0.5),rgb(0.5,0.5,0.5,0.5)), lwd=8,cex=.5)
dev.off()

png("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/figs/weightingXalgorithm@swor.png",width=10, height=3, units="in", res=400)
par(mfrow=c(1,3))
low=dataframelist %>% filter(sworweighting==0.1) %>% filter(swor>.5)
mid=dataframelist %>% filter(sworweighting==0.2) %>% filter(swor>.5)
high=dataframelist %>% filter(sworweighting==0.4) %>% filter(swor>.5)
hist(low$EcoROMS_original,col=rgb(1,0,0,0.5),xlim=c(-1,1),ylim=c(0,500),main="EcoROMS_original",xlab="Algorithm values at swor presences")
hist(mid$EcoROMS_original,col=rgb(0,0,1,0.5),add=T)
hist(high$EcoROMS_original,col=rgb(0.5,0.5,0.5,0.5),add=T)
legend("topright", c("swor weighting =.1", "swor weighting =.2","swor weighting =.4"), col=c(rgb(1,0,0,0.5), rgb(0,0,1,0.5),rgb(0.5,0.5,0.5,0.5)), lwd=8,cex=.5)

hist(low$EcoROMS_original_unscaled,col=rgb(1,0,0,0.5),xlim=c(-1,1),ylim=c(0,500),main="EcoROMS_original_unscaled",xlab="Algorithm values at swor presences")
hist(mid$EcoROMS_original_unscaled,col=rgb(0,0,1,0.5),add=T)
hist(high$EcoROMS_original_unscaled,col=rgb(0.5,0.5,0.5,0.5),add=T)
legend("topright", c("swor weighting =.1", "swor weighting =.2","swor weighting =.4"), col=c(rgb(1,0,0,0.5), rgb(0,0,1,0.5),rgb(0.5,0.5,0.5,0.5)), lwd=8,cex=.5)

hist(low$Marxan_raw,col=rgb(1,0,0,0.5),xlim=c(-1,1),ylim=c(0,500),main="Marxan_raw",xlab="Algorithm values at swor presences")
hist(mid$Marxan_raw,col=rgb(0,0,1,0.5),add=T)
hist(high$Marxan_raw,col=rgb(0.5,0.5,0.5,0.5),add=T)
legend("topright", c("swor weighting =.1", "swor weighting =.2","swor weighting =.4"), col=c(rgb(1,0,0,0.5), rgb(0,0,1,0.5),rgb(0.5,0.5,0.5,0.5)), lwd=8,cex=.5)
dev.off()

# low=dataframelist %>% filter(sworweighting==0.1) 
# mid=dataframelist %>% filter(sworweighting==0.2) 
# high=dataframelist %>% filter(sworweighting==0.4) 
# hist(low$EcoROMS_original,col=rgb(1,0,0,0.5),xlim=c(-1,1),ylim=c(0,500),main="",xlab="Algorithm values")
# hist(mid$EcoROMS_original,col=rgb(0,0,1,0.5),add=T)
# hist(high$EcoROMS_original,col=rgb(0.5,0.5,0.5,0.5),add=T)

png("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/figs/weightingXalgorithm@lbst.png",width=10, height=3, units="in", res=400)
par(mfrow=c(1,3))
low=dataframelist %>% filter(sworweighting==0.1) %>% filter(lbst>.5)
mid=dataframelist %>% filter(sworweighting==0.2) %>% filter(lbst>.5)
high=dataframelist %>% filter(sworweighting==0.4) %>% filter(lbst>.5)
hist(low$EcoROMS_original,col=rgb(1,0,0,0.5),xlim=c(-1,1),ylim=c(0,200),main="EcoROMS_original",xlab="Algorithm values at lbst presences")
hist(mid$EcoROMS_original,col=rgb(0,0,1,0.5),add=T)
hist(high$EcoROMS_original,col=rgb(0.5,0.5,0.5,0.5),add=T)
legend("topright", c("swor weighting =.1", "swor weighting =.2","swor weighting =.4"), col=c(rgb(1,0,0,0.5), rgb(0,0,1,0.5),rgb(0.5,0.5,0.5,0.5)), lwd=8,cex=.5)

hist(low$EcoROMS_original_unscaled,col=rgb(1,0,0,0.5),xlim=c(-1,1),ylim=c(0,200),main="EcoROMS_original_unscaled",xlab="Algorithm values at lbst presences")
hist(mid$EcoROMS_original_unscaled,col=rgb(0,0,1,0.5),add=T)
hist(high$EcoROMS_original_unscaled,col=rgb(0.5,0.5,0.5,0.5),add=T)
legend("topright", c("swor weighting =.1", "swor weighting =.2","swor weighting =.4"), col=c(rgb(1,0,0,0.5), rgb(0,0,1,0.5),rgb(0.5,0.5,0.5,0.5)), lwd=8,cex=.5)

hist(low$Marxan_raw,col=rgb(1,0,0,0.5),xlim=c(-1,1),ylim=c(0,200),main="Marxan_raw",xlab="Algorithm values at lbst presences")
hist(mid$Marxan_raw,col=rgb(0,0,1,0.5),add=T)
hist(high$Marxan_raw,col=rgb(0.5,0.5,0.5,0.5),add=T)
legend("topright", c("swor weighting =.1", "swor weighting =.2","swor weighting =.4"), col=c(rgb(1,0,0,0.5), rgb(0,0,1,0.5),rgb(0.5,0.5,0.5,0.5)), lwd=8,cex=.5)
dev.off()

png("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/figs/weightingXalgorithmXlbstXswor.png",width=10, height=10, units="in", res=400)
par(mfrow=c(3,3))
lowL=dataframelist %>% filter(sworweighting==0.1) %>% filter(lbst>.5)
lowS=dataframelist %>% filter(sworweighting==0.1) %>% filter(swor>.5)
hist(lowL$EcoROMS_original,col=rgb(1,0,0,0.5),xlim=c(-1,1),ylim=c(0,400),main="EcoROMS_original (swor=.1)",xlab="Algorithm values at presences",breaks=10)
hist(lowS$EcoROMS_original,col=rgb(0,0,1,0.5),add=T,breaks=10)
legend("topright", c("lbst", "swor"), col=c(rgb(1,0,0,0.5), rgb(0,0,1,0.5)), lwd=8,cex=.5)

hist(lowL$EcoROMS_original_unscaled,col=rgb(1,0,0,0.5),xlim=c(-1,1),ylim=c(0,400),main="EcoROMS_original_unscaled (swor=.1)",xlab="Algorithm values at presences",breaks=10)
hist(lowS$EcoROMS_original_unscaled,col=rgb(0,0,1,0.5),add=T,breaks=10)
legend("topright", c("lbst", "swor"), col=c(rgb(1,0,0,0.5), rgb(0,0,1,0.5)), lwd=8,cex=.5)

hist(lowL$Marxan_raw,col=rgb(1,0,0,0.5),xlim=c(-1,1),ylim=c(0,400),main="Marxan_raw (swor=.1)",xlab="Algorithm values at presences",breaks=10)
hist(lowS$Marxan_raw,col=rgb(0,0,1,0.5),add=T,breaks=10)
legend("topright", c("lbst", "swor"), col=c(rgb(1,0,0,0.5), rgb(0,0,1,0.5)), lwd=8,cex=.5)

lowL=dataframelist %>% filter(sworweighting==0.2) %>% filter(lbst>.5)
lowS=dataframelist %>% filter(sworweighting==0.2) %>% filter(swor>.5)
hist(lowL$EcoROMS_original,col=rgb(1,0,0,0.5),xlim=c(-1,1),ylim=c(0,400),main="EcoROMS_original (swor=.2)",xlab="Algorithm values at presences",breaks=10)
hist(lowS$EcoROMS_original,col=rgb(0,0,1,0.5),add=T,breaks=10)
legend("topright", c("lbst", "swor"), col=c(rgb(1,0,0,0.5), rgb(0,0,1,0.5)), lwd=8,cex=.5)

hist(lowL$EcoROMS_original_unscaled,col=rgb(1,0,0,0.5),xlim=c(-1,1),ylim=c(0,400),main="EcoROMS_original_unscaled (swor=.2)",xlab="Algorithm values at presences",breaks=10)
hist(lowS$EcoROMS_original_unscaled,col=rgb(0,0,1,0.5),add=T,breaks=10)
legend("topright", c("lbst", "swor"), col=c(rgb(1,0,0,0.5), rgb(0,0,1,0.5)), lwd=8,cex=.5)

hist(lowL$Marxan_raw,col=rgb(1,0,0,0.5),xlim=c(-1,1),ylim=c(0,400),main="Marxan_raw (swor=.2)",xlab="Algorithm values at presences",breaks=10)
hist(lowS$Marxan_raw,col=rgb(0,0,1,0.5),add=T,breaks=10)
legend("topright", c("lbst", "swor"), col=c(rgb(1,0,0,0.5), rgb(0,0,1,0.5)), lwd=8,cex=.5)

lowL=dataframelist %>% filter(sworweighting==0.4) %>% filter(lbst>.5)
lowS=dataframelist %>% filter(sworweighting==0.4) %>% filter(swor>.5)
hist(lowL$EcoROMS_original,col=rgb(1,0,0,0.5),xlim=c(-1,1),ylim=c(0,400),main="EcoROMS_original (swor=.4)",xlab="Algorithm values at presences",breaks=10)
hist(lowS$EcoROMS_original,col=rgb(0,0,1,0.5),add=T,breaks=10)
legend("topright", c("lbst", "swor"), col=c(rgb(1,0,0,0.5), rgb(0,0,1,0.5)), lwd=8,cex=.5)

hist(lowL$EcoROMS_original_unscaled,col=rgb(1,0,0,0.5),xlim=c(-1,1),ylim=c(0,400),main="EcoROMS_original_unscaled (swor=.4)",xlab="Algorithm values at presences",breaks=10)
hist(lowS$EcoROMS_original_unscaled,col=rgb(0,0,1,0.5),add=T,breaks=10)
legend("topright", c("lbst", "swor"), col=c(rgb(1,0,0,0.5), rgb(0,0,1,0.5)), lwd=8,cex=.5)

hist(lowL$Marxan_raw,col=rgb(1,0,0,0.5),xlim=c(-1,1),ylim=c(0,400),main="Marxan_raw (swor=.4)",xlab="Algorithm values at presences",breaks=10)
hist(lowS$Marxan_raw,col=rgb(0,0,1,0.5),add=T,breaks=10)
legend("topright", c("lbst", "swor"), col=c(rgb(1,0,0,0.5), rgb(0,0,1,0.5)), lwd=8,cex=.5)
dev.off()

#### ecdf
#https://www.andata.at/en/software-blog-reader/why-we-love-the-cdf-and-do-not-like-histograms-that-much.html
png("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/figs/ECDF_EcoROMS_original.png",width=7, height=7, units="in", res=400)
lowS1=dataframelist %>% filter(sworweighting==0.1) %>% filter(swor>.5)
lowS2=dataframelist %>% filter(sworweighting==0.2) %>% filter(swor>.5)
lowS3=dataframelist %>% filter(sworweighting==0.4) %>% filter(swor>.5)
plot(ecdf(lowS1$EcoROMS_original), col='red', ylab='Cumulative Distribution Function', xlab="Algorithm value at swor presences",main='Effect of swor weighting - EcoROMS_original')
lines(ecdf(lowS2$EcoROMS_original), col='blue')
lines(ecdf(lowS3$EcoROMS_original), col='green')
legend('topleft', c('swor = .1','swor = .2','swor = .4'), lty=1, col=c('red','blue','green'))
dev.off()

png("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/figs/ECDF_EcoROMS_original_unscaled.png",width=7, height=7, units="in", res=400)
plot(ecdf(lowS1$EcoROMS_original_unscaled), col='red', ylab='Cumulative Distribution Function', xlab="Algorithm value at swor presences",main='Effect of swor weighting - EcoROMS_original_unscaled')
lines(ecdf(lowS2$EcoROMS_original_unscaled), col='blue')
lines(ecdf(lowS3$EcoROMS_original_unscaled), col='green')
legend('topleft', c('swor = .1','swor = .2','swor = .4'), lty=1, col=c('red','blue','green'))
dev.off()

png("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/figs/ECDF_Marxan_raw.png",width=7, height=7, units="in", res=400)
plot(ecdf(lowS1$Marxan_raw), col='red', ylab='Cumulative Distribution Function', xlab="Algorithm value at swor presences",main='Effect of swor weighting - Marxan_raw')
lines(ecdf(lowS2$Marxan_raw), col='blue')
lines(ecdf(lowS3$Marxan_raw), col='green')
legend('topleft', c('swor = .1','swor = .2','swor = .4'), lty=1, col=c('red','blue','green'))
dev.off()


