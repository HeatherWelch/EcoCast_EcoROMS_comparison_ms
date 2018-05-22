## function to compare effect of species weightings
library(gdata)

one=read.csv("hindcast_ms/extract/extractions/run_A.1.csv") %>% mutate(weighting=.1)
two=read.csv("hindcast_ms/extract/extractions/run_A.2.csv") %>% mutate(weighting=.3)
three=read.csv("hindcast_ms/extract/extractions/run_A.3.csv") %>% mutate(weighting=.5)
four=read.csv("hindcast_ms/extract/extractions/run_A.4.csv") %>% mutate(weighting=.7)
five=read.csv("hindcast_ms/extract/extractions/run_A.5.csv") %>% mutate(weighting=.9)

species_delta="swordfish"
weighting_delta=c(.1,.3,.5,.7,.9)
run="A"

plotdir="~/Dropbox/EcoEast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/hindcast_ms/summarize/plots/"
csvdir="~/Dropbox/EcoEast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/hindcast_ms/summarize/csvs/"

weightings_comparison(species_delta = species_delta,weighting_delta = weighting_delta,plotdir = plotdir,csvdir = csvdir,run=run)

weightings_comparison=function(species_delta,weighting_delta,plotdir,csvdir,run){
  dataframelist=list(one,two,three,four,five)
  
  empty=data.frame(matrix(NA,nrow=30,ncol = 6))
  colnames(empty)=c("avoided","Marxan_raw","Marxan_raw_unscaled","EcoROMS_original","EcoROMS_original_unscaled","weighting")
  catch=c(.9,.7,.5,.3,.1,0)
  count=1
    
  for(i in 1:length(catch)){
    for(ii in 1:length(dataframelist)){
      binA=dataframelist[[ii]] %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw,EcoROMS_original_unscaled,Marxan_raw_unscaled)) %>% dplyr::filter(suitability>=.5) %>% spread(species,suitability) %>% select(EcoROMS_original,EcoROMS_original_unscaled,Marxan_raw,Marxan_raw_unscaled,lbst) %>% .[complete.cases(.),]
      binM=quantile(binA$Marxan_raw,(catch[i]),na.rm = T) %>% as.data.frame() %>% .[,1]
      binE=quantile(binA$EcoROMS_original,(catch[i]),na.rm = T) %>% as.data.frame() %>% .[,1]
      binEnS=quantile(binA$EcoROMS_original_unscaled,(catch[i]),na.rm = T) %>% as.data.frame() %>% .[,1]
      binMnS=quantile(binA$Marxan_raw_unscaled,(catch[i]),na.rm = T) %>% as.data.frame() %>% .[,1]
      print(binM)
      print(binE)
      empty$avoided[count]=catch[i]
      empty$Marxan_raw[count]=binM
      empty$EcoROMS_original[count]=binE
      empty$EcoROMS_original_unscaled[count]=binEnS
      empty$Marxan_raw_unscaled[count]=binMnS
      empty$weighting[count]=dataframelist[[ii]]$weighting[1]
      count=count+1
      print(count)
    }
  }
  
  dataframelist=do.call("rbind",dataframelist)
  master=data.frame(product=NA,swor=NA,lbst=NA,weighting=NA)
  for(i in 1:nrow(empty)){
    data=dataframelist %>% dplyr::filter(weighting==empty$weighting[i])
    tablecaughtE=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw,EcoROMS_original_unscaled,Marxan_raw_unscaled,weighting)) %>% gather(product,product_value,-c(species,suitability,weighting)) %>% dplyr::filter(suitability>=.5) %>% dplyr::filter(product_value<=empty$EcoROMS_original[i]) %>% 
      dplyr::filter(product=="EcoROMS_original")%>% group_by(species,product) %>% summarise(num_presences_caught=n()) %>% mutate(weighting=empty$weighting[i])
    
    tablecaughtM=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw,EcoROMS_original_unscaled,Marxan_raw_unscaled,weighting)) %>% gather(product,product_value,-c(species,suitability,weighting)) %>% dplyr::filter(suitability>=.5) %>% dplyr::filter(product_value<=empty$Marxan_raw[i]) %>%
      dplyr::filter(product=="Marxan_raw")%>% group_by(species,product) %>% summarise(num_presences_caught=n()) %>% mutate(weighting=empty$weighting[i]) %>% rbind(.,tablecaughtE)
    
    tablecaughtEuS=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw,EcoROMS_original_unscaled,Marxan_raw_unscaled,weighting)) %>% gather(product,product_value,-c(species,suitability,weighting)) %>% dplyr::filter(suitability>=.5) %>% dplyr::filter(product_value<=empty$EcoROMS_original_unscaled[i]) %>%
      dplyr::filter(product=="EcoROMS_original_unscaled")%>% group_by(species,product) %>% summarise(num_presences_caught=n()) %>% mutate(weighting=empty$weighting[i]) %>% rbind(.,tablecaughtM)
    
    tablecaughtMuS=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw,EcoROMS_original_unscaled,Marxan_raw_unscaled,weighting)) %>% gather(product,product_value,-c(species,suitability,weighting)) %>% dplyr::filter(suitability>=.5) %>% dplyr::filter(product_value<=empty$Marxan_raw_unscaled[i]) %>%
      dplyr::filter(product=="Marxan_raw_unscaled")%>% group_by(species,product) %>% summarise(num_presences_caught=n()) %>% mutate(weighting=empty$weighting[i]) %>% rbind(.,tablecaughtEuS)
    
    tabletotal=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw,EcoROMS_original_unscaled,Marxan_raw_unscaled,weighting)) %>% gather(product,product_value,-c(species,suitability,weighting)) %>% dplyr::filter(suitability>=.5) %>%
      group_by(species,product) %>% summarise(num_presences=n()) %>% left_join(tablecaughtMuS,.) %>% mutate(Percent_caught=num_presences_caught/num_presences*100) %>% select(-c(num_presences,num_presences_caught)) %>% spread(species,Percent_caught) 
    
    if(("lbst"%in%colnames(tabletotal))==F){tabletotal$lbst=0}
    if(("swor"%in%colnames(tabletotal))==F){tabletotal$swor=0}
    
    tabletotal=tabletotal %>% select(product,swor,lbst,weighting)
    tabletotal[is.na(tabletotal)]<-0
    tabletotal$lbst=empty[i,1]*100
    
    master=rbind(master,tabletotal) %>% .[complete.cases(.),]
  }
  
  plotting=master %>% mutate(lbst=paste0(lbst,"% leatherback risk")) %>% mutate(lbst=as.factor(lbst)) #%>% mutate(lbst=reorder.factor(lbst,levels=c("10% LBST risk","30% LBST risk","50% LBST risk","70% LBST risk","90% LBST risk","100% LBST risk")))
  
  a=ggplot(plotting,aes(x=weighting,y=swor,group=product,color=product))+geom_line(aes(linetype=product))+geom_point(size=.5) +facet_wrap(~lbst,nrow=1)
  a=a+ggtitle(label = paste0("Effect of increasing ",species_delta," weighting on swordfish availability under scenarios of allowable leatherback bycatch risk"),subtitle = "Algorithm thresholds are set by defining % of allowable leatherback bycatch risk (iterated at 0,10,30,50,70,90%)")+labs(x=paste0(species_delta," weighting"))+labs(y="% of swordfish available to catch")
  a=a+scale_x_continuous(breaks=weighting_delta)
  a=a+theme(panel.background = element_rect(fill=NA,color="black"),strip.background =element_rect(fill=NA))+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8),axis.text = element_text(size=8),plot.title = element_text(hjust = 0,size = 9))
  a=a+scale_color_manual("Algorithm",values=c("EcoROMS_original"="#034f84","Marxan_raw"="#f7786b","EcoROMS_original_unscaled"="#92a8d1","Marxan_raw_unscaled"="#f7cac9"))+guides(color = guide_legend(override.aes = list(linetype = c("solid", "solid","dashed", "dashed"))))+scale_linetype_manual("Algorithm",values = c("solid", "solid","dashed", "dashed"))
  a=a+theme(legend.title = element_text(size=5),legend.position=c(.13,.9),legend.justification = c(.9,.9))+theme(legend.background = element_blank())+theme(legend.text=element_text(size=5),legend.box.background = element_rect(colour = "black"))+theme(legend.key=element_blank())+theme(legend.key.size = unit(.5,'lines'))
  a
  
  png(paste0(plotdir,run,"_weightings_comparison.png"),width=10, height=5, units="in", res=400)
  par(ps=10)
  par(mar=c(4,4,1,1))
  par(cex=1)
  print({a})
  dev.off()
  
  write.csv(plotting,paste0(csvdir,run,"_availcatch_weighting_comparison.csv"),row.names = F)
  write.csv(empty,paste0(csvdir,run,"_thresholds_weighting_comparison.csv"),row.names = F)
}
