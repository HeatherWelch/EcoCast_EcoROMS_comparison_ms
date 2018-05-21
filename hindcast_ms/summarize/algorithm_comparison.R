## script to hindcast the effect of algorithm x weighting on available catch

agorithm_comparison=function(data,weightings,outdir,run){
  catch=c(0,.1,.2,.3,.4,.5,.6,.7,.8,.9,1)
  namesrisk<-c("Blue shark bycatch","Blue sharks","Sea lions","Leatherbacks","Swordfish")
  
  ## swordfish evaluation first
  empty=data.frame(matrix(NA,nrow=11,ncol = 5))
  colnames(empty)=c("availcatch","Marxan_raw","EcoROMS_original","Marxan_raw_unscaled","EcoROMS_original_unscaled")
  for(i in 1:length(catch)){ 
    binA=data %>% dplyr::select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw,EcoROMS_original_unscaled,Marxan_raw_unscaled)) %>% filter(suitability>=.5) %>% spread(species,suitability) %>% dplyr::select(EcoROMS_original,Marxan_raw,EcoROMS_original_unscaled,Marxan_raw_unscaled,swor) %>% .[complete.cases(.),]
    binM=quantile(binA$Marxan_raw,(1-catch[i]),na.rm = T) %>% as.data.frame() %>% .[,1]
    binE=quantile(binA$EcoROMS_original,(1-catch[i]),na.rm = T) %>% as.data.frame() %>% .[,1]
    binMnS=quantile(binA$Marxan_raw_unscaled,(1-catch[i]),na.rm = T) %>% as.data.frame() %>% .[,1]
    binEnS=quantile(binA$EcoROMS_original_unscaled,(1-catch[i]),na.rm = T) %>% as.data.frame() %>% .[,1]
    print(binM)
    print(binE)
    print(binMnS)
    print(binEnS)
    empty$availcatch[i]=catch[i]
    empty$Marxan_raw[i]=binM
    empty$EcoROMS_original[i]=binE
    empty$Marxan_raw_unscaled[i]=binMnS
    empty$EcoROMS_original_unscaled[i]=binEnS
  } ## find break points
  empty$limit_target="swordfish"
  sworThresh=empty
  
  master=data.frame(product=NA,swor=NA,lbst=NA)
  for(i in 1:nrow(empty)){
    tablecaughtE=data %>% dplyr::select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw,Marxan_raw_unscaled,EcoROMS_original_unscaled)) %>% gather(product,product_value,-c(species,suitability)) %>% dplyr::filter(suitability>=.5) %>% dplyr::filter(product_value<=empty$EcoROMS_original[i]) %>% 
      dplyr::filter(product=="EcoROMS_original")%>% group_by(species,product) %>% summarise(num_presences_caught=n()) 
    
    tablecaughtM=data %>% dplyr::select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw,Marxan_raw_unscaled,EcoROMS_original_unscaled)) %>% gather(product,product_value,-c(species,suitability)) %>% dplyr::filter(suitability>=.5) %>% dplyr::filter(product_value<=empty$Marxan_raw[i]) %>%
      dplyr::filter(product=="Marxan_raw")%>% group_by(species,product) %>% summarise(num_presences_caught=n())  %>% rbind(.,tablecaughtE)
    
    tablecaughtEuS=data %>% dplyr::select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw,Marxan_raw_unscaled,EcoROMS_original_unscaled)) %>% gather(product,product_value,-c(species,suitability)) %>% dplyr::filter(suitability>=.5) %>% dplyr::filter(product_value<=empty$EcoROMS_original_unscaled[i]) %>%
      dplyr::filter(product=="EcoROMS_original_unscaled")%>% group_by(species,product) %>% summarise(num_presences_caught=n())  %>% rbind(.,tablecaughtM)
    
    tablecaughtMEuS=data %>% dplyr::select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw,Marxan_raw_unscaled,EcoROMS_original_unscaled)) %>% gather(product,product_value,-c(species,suitability)) %>% dplyr::filter(suitability>=.5) %>% dplyr::filter(product_value<=empty$Marxan_raw_unscaled[i]) %>%
      dplyr::filter(product=="Marxan_raw_unscaled")%>% group_by(species,product) %>% summarise(num_presences_caught=n())  %>% rbind(.,tablecaughtEuS)
    
    tabletotal=data %>% dplyr::select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw,Marxan_raw_unscaled,EcoROMS_original_unscaled)) %>% gather(product,product_value,-c(species,suitability)) %>% dplyr::filter(suitability>=.5) %>%
      group_by(species,product) %>% summarise(num_presences=n()) %>% left_join(tablecaughtMEuS,.) %>% mutate(Percent_caught=num_presences_caught/num_presences*100) %>% dplyr::select(-c(num_presences,num_presences_caught)) %>% spread(species,Percent_caught) 
    
    if(("lbst"%in%colnames(tabletotal))==F){tabletotal$lbst=0}
    if(("lbst"%in%colnames(tabletotal))==F){tabletotal$lbst=0}
    
    tabletotal=tabletotal %>% dplyr::select(product,swor,lbst)
    tabletotal[is.na(tabletotal)]<-0
    
    master=rbind(master,tabletotal)
  } ## find trade-offs at catch limits
  master=master[complete.cases(master),]
  master$limit_target="swordfish"
  sworDat=master
  
  ## plot ####
  subtitle=paste0(namesrisk[1],": ",weightings[1],", ",namesrisk[2],": ",weightings[2],", ",namesrisk[3],": ",weightings[3],", ",namesrisk[4],": ",weightings[4],", ",namesrisk[5],": ",weightings[5])
  a=ggplot()+geom_line(data=sworDat %>% filter(product=="EcoROMS_original"),aes(x=swor,y=lbst,color="EcoROMS_original"),size=.5)+geom_point(data=sworDat %>% filter(product=="EcoROMS_original"),aes(x=swor,y=lbst,color="EcoROMS_original"))
  a=a+geom_line(data=sworDat %>% filter(product=="Marxan_raw"),aes(x=swor,y=lbst,color="Marxan_raw"),size=.8,linetype=2)+geom_point(data=sworDat %>% filter(product=="Marxan_raw"),aes(x=swor,y=lbst,color="Marxan_raw"))
  a=a+geom_line(data=sworDat %>% filter(product=="EcoROMS_original_unscaled"),aes(x=swor,y=lbst,color="EcoROMS_original_unscaled"),size=.5)+geom_point(data=sworDat %>% filter(product=="EcoROMS_original_unscaled"),aes(x=swor,y=lbst,color="EcoROMS_original_unscaled"))
  a=a+geom_line(data=sworDat %>% filter(product=="Marxan_raw_unscaled"),aes(x=swor,y=lbst,color="Marxan_raw_unscaled"),size=.8,linetype=2)+geom_point(data=sworDat %>% filter(product=="Marxan_raw_unscaled"),aes(x=swor,y=lbst,color="Marxan_raw_unscaled"))
  a=a+ggtitle(label = paste0("Trade-offs between swordfish availability and leatherback bycatch"),subtitle = subtitle)+labs(x="% of swordfish available to catch")+labs(y="% of leathbacks bycaught")+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"),axis.text = element_text(size=8))+ theme(text = element_text(size=8))
  a=a+scale_color_manual("Algorithm",values=c("EcoROMS_original"="#034f84","Marxan_raw"="#f7786b","EcoROMS_original_unscaled"="#92a8d1","Marxan_raw_unscaled"="#f7cac9"))
  a=a+theme(legend.title = element_text(size=8),legend.position=c(.3,.9),legend.justification = c(.9,.9))+theme(legend.background = element_blank())+theme(legend.text=element_text(size=8),legend.box.background = element_rect(colour = "black"))+ theme(legend.key=element_blank())+guides(color = guide_legend(override.aes = list(linetype = c("solid", "solid","dashed", "dashed"))))
  a=a+scale_x_continuous(breaks=seq(0,100,by=10),expand = c(.03,.03))+scale_y_continuous(expand = c(.03,.03))
  sworPlot=a
  #####
  
  ## leatherback evaluation second
  empty=data.frame(matrix(NA,nrow=11,ncol = 5))
  colnames(empty)=c("availcatch","Marxan_raw","EcoROMS_original","Marxan_raw_unscaled","EcoROMS_original_unscaled")
  for(i in 1:length(catch)){ 
    binA=data %>% dplyr::select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw,EcoROMS_original_unscaled,Marxan_raw_unscaled)) %>% filter(suitability>=.5) %>% spread(species,suitability) %>% dplyr::select(EcoROMS_original,Marxan_raw,EcoROMS_original_unscaled,Marxan_raw_unscaled,lbst) %>% .[complete.cases(.),]
    binM=quantile(binA$Marxan_raw,(catch[i]),na.rm = T) %>% as.data.frame() %>% .[,1]
    binE=quantile(binA$EcoROMS_original,(catch[i]),na.rm = T) %>% as.data.frame() %>% .[,1]
    binMnS=quantile(binA$Marxan_raw_unscaled,(catch[i]),na.rm = T) %>% as.data.frame() %>% .[,1]
    binEnS=quantile(binA$EcoROMS_original_unscaled,(catch[i]),na.rm = T) %>% as.data.frame() %>% .[,1]
    print(binM)
    print(binE)
    print(binMnS)
    print(binEnS)
    empty$availcatch[i]=catch[i]
    empty$Marxan_raw[i]=binM
    empty$EcoROMS_original[i]=binE
    empty$Marxan_raw_unscaled[i]=binMnS
    empty$EcoROMS_original_unscaled[i]=binEnS
  } ## find break points
  empty$limit_target="leatherback"
  lbstThresh=empty
  
  master=data.frame(product=NA,swor=NA,lbst=NA)
  for(i in 1:nrow(empty)){
    tablecaughtE=data %>% dplyr::select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw,Marxan_raw_unscaled,EcoROMS_original_unscaled)) %>% gather(product,product_value,-c(species,suitability)) %>% dplyr::filter(suitability>=.5) %>% dplyr::filter(product_value<=empty$EcoROMS_original[i]) %>% 
      dplyr::filter(product=="EcoROMS_original")%>% group_by(species,product) %>% summarise(num_presences_caught=n()) 
    
    tablecaughtM=data %>% dplyr::select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw,Marxan_raw_unscaled,EcoROMS_original_unscaled)) %>% gather(product,product_value,-c(species,suitability)) %>% dplyr::filter(suitability>=.5) %>% dplyr::filter(product_value<=empty$Marxan_raw[i]) %>%
      dplyr::filter(product=="Marxan_raw")%>% group_by(species,product) %>% summarise(num_presences_caught=n())  %>% rbind(.,tablecaughtE)
    
    tablecaughtEuS=data %>% dplyr::select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw,Marxan_raw_unscaled,EcoROMS_original_unscaled)) %>% gather(product,product_value,-c(species,suitability)) %>% dplyr::filter(suitability>=.5) %>% dplyr::filter(product_value<=empty$EcoROMS_original_unscaled[i]) %>%
      dplyr::filter(product=="EcoROMS_original_unscaled")%>% group_by(species,product) %>% summarise(num_presences_caught=n())  %>% rbind(.,tablecaughtM)
    
    tablecaughtMEuS=data %>% dplyr::select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw,Marxan_raw_unscaled,EcoROMS_original_unscaled)) %>% gather(product,product_value,-c(species,suitability)) %>% dplyr::filter(suitability>=.5) %>% dplyr::filter(product_value<=empty$Marxan_raw_unscaled[i]) %>%
      dplyr::filter(product=="Marxan_raw_unscaled")%>% group_by(species,product) %>% summarise(num_presences_caught=n())  %>% rbind(.,tablecaughtEuS)
    
    tabletotal=data %>% dplyr::select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw,Marxan_raw_unscaled,EcoROMS_original_unscaled)) %>% gather(product,product_value,-c(species,suitability)) %>% dplyr::filter(suitability>=.5) %>%
      group_by(species,product) %>% summarise(num_presences=n()) %>% left_join(tablecaughtMEuS,.) %>% mutate(Percent_caught=num_presences_caught/num_presences*100) %>% dplyr::select(-c(num_presences,num_presences_caught)) %>% spread(species,Percent_caught) 
    
    if(("lbst"%in%colnames(tabletotal))==F){tabletotal$lbst=0}
    if(("swor"%in%colnames(tabletotal))==F){tabletotal$swor=0}
    
    tabletotal=tabletotal %>% dplyr::select(product,swor,lbst)
    tabletotal[is.na(tabletotal)]<-0
    
    master=rbind(master,tabletotal)
  } ## find trade-offs at catch limits
  master=master[complete.cases(master),]
  master$limit_target="leatherback"
  lbstDat=master
  
  ## plot ####
  subtitle=paste0(namesrisk[1],": ",weightings[1],", ",namesrisk[2],": ",weightings[2],", ",namesrisk[3],": ",weightings[3],", ",namesrisk[4],": ",weightings[4],", ",namesrisk[5],": ",weightings[5])
  a=ggplot()+geom_line(data=lbstDat %>% filter(product=="EcoROMS_original"),aes(x=lbst,y=swor,color="EcoROMS_original"),size=.5)+geom_point(data=lbstDat %>% filter(product=="EcoROMS_original"),aes(x=lbst,y=swor,color="EcoROMS_original"))
  a=a+geom_line(data=lbstDat %>% filter(product=="Marxan_raw"),aes(x=lbst,y=swor,color="Marxan_raw"),size=.8,linetype=2)+geom_point(data=lbstDat %>% filter(product=="Marxan_raw"),aes(x=lbst,y=swor,color="Marxan_raw"))
  a=a+geom_line(data=lbstDat %>% filter(product=="EcoROMS_original_unscaled"),aes(x=lbst,y=swor,color="EcoROMS_original_unscaled"),size=.5)+geom_point(data=lbstDat %>% filter(product=="EcoROMS_original_unscaled"),aes(x=lbst,y=swor,color="EcoROMS_original_unscaled"))
  a=a+geom_line(data=lbstDat %>% filter(product=="Marxan_raw_unscaled"),aes(x=lbst,y=swor,color="Marxan_raw_unscaled"),size=.8,linetype=2)+geom_point(data=lbstDat %>% filter(product=="Marxan_raw_unscaled"),aes(x=lbst,y=swor,color="Marxan_raw_unscaled"))
  a=a+ggtitle(label = paste0("Trade-offs between leatherback bycatch limits swordfish availability"),subtitle = subtitle)+labs(x="% of allowable leatherback bycatch")+labs(y="% of swordfish available to catch")+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"),axis.text = element_text(size=8))+ theme(text = element_text(size=8))
  a=a+scale_color_manual("Algorithm",values=c("EcoROMS_original"="#034f84","Marxan_raw"="#f7786b","EcoROMS_original_unscaled"="#92a8d1","Marxan_raw_unscaled"="#f7cac9"))
  a=a+theme(legend.title = element_text(size=8),legend.position=c(.9,.3),legend.justification = c(.9,.9))+theme(legend.background = element_blank())+theme(legend.text=element_text(size=8),legend.box.background = element_rect(colour = "black"))+ theme(legend.key=element_blank())+guides(color = guide_legend(override.aes = list(linetype = c("solid", "solid","dashed", "dashed"))))
  a=a+scale_x_continuous(breaks=seq(0,100,by=10),expand = c(.03,.03))+scale_y_continuous(expand = c(.03,.03))
  lbstPlot=a
  #####
  
  ## write out
  master=rbind(lbstDat,sworDat)
  write.csv(master,paste0(csvdir,run,"_availcatch_algorithm_comparison.csv"),row.names = F)
  master=rbind(lbstThresh,sworThresh)
  write.csv(master,paste0(csvdir,run,"_thresholds_algorithm_comparison.csv"),row.names = F)
  
  png(paste0(plotdir,run,"_algorithm_comparison.png"),width=14, height=7, units="in", res=400)
  par(ps=10)
  par(mar=c(4,4,1,1))
  par(cex=1)
  print({ plot_grid(sworPlot,lbstPlot,nrow=1,ncol=2)})
  dev.off()
}

# #demo run
# data=read.csv("raw_data/species_predict_05.10.18_random_scaled_unscaled_run7.csv")
# weightings <-c(0,0,0,0,0.3)
# plotdir="~/Dropbox/EcoEast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/hindcast_ms/summarize/plots/"
# csvdir="~/Dropbox/EcoEast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/hindcast_ms/summarize/csvs/"
# run="beepboop3"
# 
# agorithm_comparison(data=data,weightings=weightings,run=run)