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
