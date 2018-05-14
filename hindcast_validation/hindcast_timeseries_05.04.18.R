## script to hindcast the temporal variability of hindcasts
## testing the ratio of lbst:swor at different weightings and different catch limits and different algorithms
## weightings: run 4, run 5, run 6, also 7, 8, 9
## catch limits: lbst @ 10,20,30,40,50,60,80, 90; swor 

## --------------------------------------------------------------------------------------------> ecoroms vs marxan ####
run4_random=read.csv("raw_data/species_predict_05.01.18_random_run4.csv") %>% .[1:1698,]
run5_random=read.csv("raw_data/species_predict_05.01.18_random_run5.csv") %>% .[1:1698,]
run6_random=read.csv("raw_data/species_predict_05.01.18_random_run6.csv") %>% .[1:1698,]

## -----------------------------------------------------> set limits for available swordfish catch
sworcatch=c(.1,.2,.3,.4,.5,.6,.7,.8,.9)
#empty4=data.frame(availcatch=NA,Marxan_raw=NA,EcoROMS=NA)
empty=data.frame(matrix(NA,nrow=9,ncol = 3))
colnames(empty)=c("availcatch","Marxan_raw","EcoROMS_original")

#### run 4 ####
data=run4_random
for(i in 1:length(sworcatch)){
binA=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% filter(suitability>=.5) %>% spread(species,suitability) %>% select(EcoROMS_original,Marxan_raw,swor) %>% .[complete.cases(.),]
binM=quantile(binA$Marxan_raw,(1-sworcatch[i]),na.rm = T) %>% as.data.frame() %>% .[,1]
binE=quantile(binA$EcoROMS_original,(1-sworcatch[i]),na.rm = T) %>% as.data.frame() %>% .[,1]
print(binM)
print(binE)
empty$availcatch[i]=sworcatch[i]
empty$Marxan_raw[i]=binM
empty$EcoROMS_original[i]=binE
}

master=data.frame(product=NA,swor=NA,lbst=NA)
for(i in 1:nrow(empty)){
tablecaughtE=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=.5) %>% filter(product_value>=empty$EcoROMS_original[i]) %>% 
  filter(product=="EcoROMS_original")%>% group_by(species,product) %>% summarise(num_presences_caught=n()) 

tablecaughtM=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=.5) %>% filter(product_value>=empty$Marxan_raw[i]) %>%
  filter(product=="Marxan_raw")%>% group_by(species,product) %>% summarise(num_presences_caught=n()) %>% rbind(.,tablecaughtE)

tabletotal=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=.5) %>%
  group_by(species,product) %>% summarise(num_presences=n()) %>% left_join(tablecaughtM,.) %>% mutate(Percent_caught=num_presences_caught/num_presences*100) %>% select(-c(num_presences,num_presences_caught)) %>% spread(species,Percent_caught) 
  
if(("lbst"%in%colnames(tabletotal))==F){tabletotal$lbst=0}

tabletotal=tabletotal %>% select(product,swor,lbst)
tabletotal[is.na(tabletotal)]<-0

master=rbind(master,tabletotal)
}

run4=master

#### run 5####
data=run5_random
for(i in 1:length(sworcatch)){
  binA=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% filter(suitability>=.5) %>% spread(species,suitability) %>% select(EcoROMS_original,Marxan_raw,swor) %>% .[complete.cases(.),]
  binM=quantile(binA$Marxan_raw,(1-sworcatch[i]),na.rm = T) %>% as.data.frame() %>% .[,1]
  binE=quantile(binA$EcoROMS_original,(1-sworcatch[i]),na.rm = T) %>% as.data.frame() %>% .[,1]
  print(binM)
  print(binE)
  empty$availcatch[i]=sworcatch[i]
  empty$Marxan_raw[i]=binM
  empty$EcoROMS_original[i]=binE
}

master=data.frame(product=NA,swor=NA,lbst=NA)
for(i in 1:nrow(empty)){
  tablecaughtE=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=.5) %>% filter(product_value>=empty$EcoROMS_original[i]) %>% 
    filter(product=="EcoROMS_original")%>% group_by(species,product) %>% summarise(num_presences_caught=n()) 
  
  tablecaughtM=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=.5) %>% filter(product_value>=empty$Marxan_raw[i]) %>%
    filter(product=="Marxan_raw")%>% group_by(species,product) %>% summarise(num_presences_caught=n()) %>% rbind(.,tablecaughtE)
  
  tabletotal=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=.5) %>%
    group_by(species,product) %>% summarise(num_presences=n()) %>% left_join(tablecaughtM,.) %>% mutate(Percent_caught=num_presences_caught/num_presences*100) %>% select(-c(num_presences,num_presences_caught)) %>% spread(species,Percent_caught) 
  
  if(("lbst"%in%colnames(tabletotal))==F){tabletotal$lbst=0}
  
  tabletotal=tabletotal %>% select(product,swor,lbst)
  tabletotal[is.na(tabletotal)]<-0
  
  master=rbind(master,tabletotal)
}

run5=master

#### run 6####
data=run6_random
for(i in 1:length(sworcatch)){
  binA=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% filter(suitability>=.5) %>% spread(species,suitability) %>% select(EcoROMS_original,Marxan_raw,swor) %>% .[complete.cases(.),]
  binM=quantile(binA$Marxan_raw,(1-sworcatch[i]),na.rm = T) %>% as.data.frame() %>% .[,1]
  binE=quantile(binA$EcoROMS_original,(1-sworcatch[i]),na.rm = T) %>% as.data.frame() %>% .[,1]
  print(binM)
  print(binE)
  empty$availcatch[i]=sworcatch[i]
  empty$Marxan_raw[i]=binM
  empty$EcoROMS_original[i]=binE
}

master=data.frame(product=NA,swor=NA,lbst=NA)
for(i in 1:nrow(empty)){
  tablecaughtE=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=.5) %>% filter(product_value>=empty$EcoROMS_original[i]) %>% 
    filter(product=="EcoROMS_original")%>% group_by(species,product) %>% summarise(num_presences_caught=n()) 
  
  tablecaughtM=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=.5) %>% filter(product_value>=empty$Marxan_raw[i]) %>%
    filter(product=="Marxan_raw")%>% group_by(species,product) %>% summarise(num_presences_caught=n()) %>% rbind(.,tablecaughtE)
  
  tabletotal=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=.5) %>%
    group_by(species,product) %>% summarise(num_presences=n()) %>% left_join(tablecaughtM,.) %>% mutate(Percent_caught=num_presences_caught/num_presences*100) %>% select(-c(num_presences,num_presences_caught)) %>% spread(species,Percent_caught) 
  
  if(("lbst"%in%colnames(tabletotal))==F){tabletotal$lbst=0}
  
  tabletotal=tabletotal %>% select(product,swor,lbst)
  tabletotal[is.na(tabletotal)]<-0
  
  master=rbind(master,tabletotal)
}

run6=master


### plot by swor limits ####
a=ggplot()+geom_line(data=run4 %>% filter(product=="EcoROMS_original"),aes(x=swor,y=lbst,color="EcoROMS-1"),size=.5)
a=a+geom_line(data=run4 %>% filter(product=="Marxan_raw"),aes(x=swor,y=lbst,color="Marxan-1"),size=.8,linetype=2)
a=a+geom_line(data=run5 %>% filter(product=="EcoROMS_original"),aes(x=swor,y=lbst,color="EcoROMS-2"),size=.5)
a=a+geom_line(data=run5 %>% filter(product=="Marxan_raw"),aes(x=swor,y=lbst,color="Marxan-2"),size=.8,linetype=2)
a=a+geom_line(data=run6 %>% filter(product=="EcoROMS_original"),aes(x=swor,y=lbst,color="EcoROMS-3"),size=.5)
a=a+geom_line(data=run6 %>% filter(product=="Marxan_raw"),aes(x=swor,y=lbst,color="Marxan-3"),size=.8,linetype=2)
a=a+ggtitle(label = paste0("Trade-offs between swordfish availability and loggerhead bycatch"),subtitle = "Algorithm thresholds are set by defining % of swordfish available to catch (iterated at 10-90%)")+labs(x="% of swordfish available to catch")+labs(y="% of leathbacks bycaught")+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+scale_color_manual("Algorithm - run",values=c("EcoROMS-1"="goldenrod","Marxan-1"="goldenrod","EcoROMS-2"="gray47","Marxan-2"="gray47","EcoROMS-3"="coral3","Marxan-3"="coral3"))
a=a+theme(legend.title = element_text(size=8),legend.position=c(.2,.9),legend.justification = c(.9,.9))+theme(legend.background = element_blank())+theme(legend.text=element_text(size=8),legend.box.background = element_rect(colour = "black"))+ theme(legend.key=element_blank())+guides(color = guide_legend(override.aes = list(linetype = c("solid", "solid","solid", "dashed","dashed", "dashed"))))
a=a+scale_x_continuous(breaks=seq(0,100,by=10),expand = c(.03,.03))+scale_y_continuous(expand = c(.03,.03))
a

png("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/figs/sworCatch456.png",width=7, height=5, units="in", res=400)
par(ps=10)
par(mar=c(4,4,1,1))
par(cex=1)
a
dev.off()

## -----------------------------------------------------> set limits for allowable leatherback bycatch
sworcatch=c(.1,.2,.3,.4,.5,.6,.7,.8,.9)
#empty4=data.frame(availcatch=NA,Marxan_raw=NA,EcoROMS=NA)
empty=data.frame(matrix(NA,nrow=9,ncol = 3))
colnames(empty)=c("avoided","Marxan_raw","EcoROMS_original")

#### run 4 ####
data=run4_random
for(i in 1:length(sworcatch)){
  binA=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% filter(suitability>=.5) %>% spread(species,suitability) %>% select(EcoROMS_original,Marxan_raw,lbst) %>% .[complete.cases(.),]
  binM=quantile(binA$Marxan_raw,(sworcatch[i]),na.rm = T) %>% as.data.frame() %>% .[,1]
  binE=quantile(binA$EcoROMS_original,(sworcatch[i]),na.rm = T) %>% as.data.frame() %>% .[,1]
  print(binM)
  print(binE)
  empty$avoided[i]=sworcatch[i]
  empty$Marxan_raw[i]=binM
  empty$EcoROMS_original[i]=binE
}

master=data.frame(product=NA,swor=NA,lbst=NA)
for(i in 1:nrow(empty)){
  tablecaughtE=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=.5) %>% filter(product_value>=empty$EcoROMS_original[i]) %>% 
    filter(product=="EcoROMS_original")%>% group_by(species,product) %>% summarise(num_presences_caught=n()) 
  
  tablecaughtM=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=.5) %>% filter(product_value>=empty$Marxan_raw[i]) %>%
    filter(product=="Marxan_raw")%>% group_by(species,product) %>% summarise(num_presences_caught=n()) %>% rbind(.,tablecaughtE)
  
  tabletotal=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=.5) %>%
    group_by(species,product) %>% summarise(num_presences=n()) %>% left_join(tablecaughtM,.) %>% mutate(Percent_caught=num_presences_caught/num_presences*100) %>% select(-c(num_presences,num_presences_caught)) %>% spread(species,Percent_caught) 
  
  if(("lbst"%in%colnames(tabletotal))==F){tabletotal$lbst=0}
  
  tabletotal=tabletotal %>% select(product,swor,lbst)
  tabletotal[is.na(tabletotal)]<-0
  
  master=rbind(master,tabletotal)
}

run4=master

#### run 5####
data=run5_random
for(i in 1:length(sworcatch)){
  binA=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% filter(suitability>=.5) %>% spread(species,suitability) %>% select(EcoROMS_original,Marxan_raw,lbst) %>% .[complete.cases(.),]
  binM=quantile(binA$Marxan_raw,(sworcatch[i]),na.rm = T) %>% as.data.frame() %>% .[,1]
  binE=quantile(binA$EcoROMS_original,(sworcatch[i]),na.rm = T) %>% as.data.frame() %>% .[,1]
  print(binM)
  print(binE)
  empty$availcatch[i]=sworcatch[i]
  empty$Marxan_raw[i]=binM
  empty$EcoROMS_original[i]=binE
}

master=data.frame(product=NA,swor=NA,lbst=NA)
for(i in 1:nrow(empty)){
  tablecaughtE=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=.5) %>% filter(product_value>=empty$EcoROMS_original[i]) %>% 
    filter(product=="EcoROMS_original")%>% group_by(species,product) %>% summarise(num_presences_caught=n()) 
  
  tablecaughtM=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=.5) %>% filter(product_value>=empty$Marxan_raw[i]) %>%
    filter(product=="Marxan_raw")%>% group_by(species,product) %>% summarise(num_presences_caught=n()) %>% rbind(.,tablecaughtE)
  
  tabletotal=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=.5) %>%
    group_by(species,product) %>% summarise(num_presences=n()) %>% left_join(tablecaughtM,.) %>% mutate(Percent_caught=num_presences_caught/num_presences*100) %>% select(-c(num_presences,num_presences_caught)) %>% spread(species,Percent_caught) 
  
  if(("lbst"%in%colnames(tabletotal))==F){tabletotal$lbst=0}
  
  tabletotal=tabletotal %>% select(product,swor,lbst)
  tabletotal[is.na(tabletotal)]<-0
  
  master=rbind(master,tabletotal)
}

run5=master

#### run 6####
data=run6_random
for(i in 1:length(sworcatch)){
  binA=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% filter(suitability>=.5) %>% spread(species,suitability) %>% select(EcoROMS_original,Marxan_raw,lbst) %>% .[complete.cases(.),]
  binM=quantile(binA$Marxan_raw,(sworcatch[i]),na.rm = T) %>% as.data.frame() %>% .[,1]
  binE=quantile(binA$EcoROMS_original,(sworcatch[i]),na.rm = T) %>% as.data.frame() %>% .[,1]
  print(binM)
  print(binE)
  empty$availcatch[i]=sworcatch[i]
  empty$Marxan_raw[i]=binM
  empty$EcoROMS_original[i]=binE
}

master=data.frame(product=NA,swor=NA,lbst=NA)
for(i in 1:nrow(empty)){
  tablecaughtE=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=.5) %>% filter(product_value>=empty$EcoROMS_original[i]) %>% 
    filter(product=="EcoROMS_original")%>% group_by(species,product) %>% summarise(num_presences_caught=n()) 
  
  tablecaughtM=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=.5) %>% filter(product_value>=empty$Marxan_raw[i]) %>%
    filter(product=="Marxan_raw")%>% group_by(species,product) %>% summarise(num_presences_caught=n()) %>% rbind(.,tablecaughtE)
  
  tabletotal=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=.5) %>%
    group_by(species,product) %>% summarise(num_presences=n()) %>% left_join(tablecaughtM,.) %>% mutate(Percent_caught=num_presences_caught/num_presences*100) %>% select(-c(num_presences,num_presences_caught)) %>% spread(species,Percent_caught) 
  
  if(("lbst"%in%colnames(tabletotal))==F){tabletotal$lbst=0}
  
  tabletotal=tabletotal %>% select(product,swor,lbst)
  tabletotal[is.na(tabletotal)]<-0
  
  master=rbind(master,tabletotal)
}

run6=master



### plot by lbst limits ####
a=ggplot()+geom_line(data=run4 %>% filter(product=="EcoROMS_original"),aes(x=lbst,y=swor,color="EcoROMS-1"),size=.5)
a=a+geom_line(data=run4 %>% filter(product=="Marxan_raw"),aes(x=lbst,y=swor,color="Marxan-1"),size=.8,linetype=2)
a=a+geom_line(data=run5 %>% filter(product=="EcoROMS_original"),aes(x=lbst,y=swor,color="EcoROMS-2"),size=.5)
a=a+geom_line(data=run5 %>% filter(product=="Marxan_raw"),aes(x=lbst,y=swor,color="Marxan-2"),size=.8,linetype=2)
a=a+geom_line(data=run6 %>% filter(product=="EcoROMS_original"),aes(x=lbst,y=swor,color="EcoROMS-3"),size=.5)
a=a+geom_line(data=run6 %>% filter(product=="Marxan_raw"),aes(x=lbst,y=swor,color="Marxan-3"),size=.8,linetype=2)
a=a+ggtitle(label = paste0("Trade-offs between loggerhead bycatch limits swordfish availability"),subtitle = "Algorithm thresholds are set by defining % of allowable leatherback bycatch (iterated at 10-90%)")+labs(x="% of allowable leatherback bycatch")+labs(y="% of swordfish available to catch")+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+scale_color_manual("Algorithm - run",values=c("EcoROMS-1"="goldenrod","Marxan-1"="goldenrod","EcoROMS-2"="gray47","Marxan-2"="gray47","EcoROMS-3"="coral3","Marxan-3"="coral3"))
a=a+theme(legend.title = element_text(size=8),legend.position=c(.2,.9),legend.justification = c(.9,.9))+theme(legend.background = element_blank())+theme(legend.text=element_text(size=8),legend.box.background = element_rect(colour = "black"))+ theme(legend.key=element_blank())+guides(color = guide_legend(override.aes = list(linetype = c("solid", "solid","solid", "dashed","dashed", "dashed"))))
a=a+scale_x_continuous(breaks=seq(0,100,by=10),expand = c(.03,.03))+scale_y_continuous(expand = c(.03,.03))
a

png("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/figs/lbstCatch456.png",width=7, height=5, units="in", res=400)
par(ps=10)
par(mar=c(4,4,1,1))
par(cex=1)
a
dev.off()

## --------------------------------------------------------------------------------------------> ecoroms scaled vs unscaled (here called Marxan_raw for simplicity following above code)  ####
run4_random_scaling=read.csv("raw_data/species_predict_05.02.18_random_scaled_unscaled_run4.csv") %>% .[1:1698,] %>% rename(Marxan_raw=EcoROMS_original_unscaled)
run5_random_scaling=read.csv("raw_data/species_predict_05.02.18_random_scaled_unscaled_run5.csv") %>% .[1:1698,] %>% rename(Marxan_raw=EcoROMS_original_unscaled)
run6_random_scaling=read.csv("raw_data/species_predict_05.02.18_random_scaled_unscaled_run6.csv") %>% .[1:1698,] %>% rename(Marxan_raw=EcoROMS_original_unscaled)

## -----------------------------------------------------> set limits for available swordfish catch
sworcatch=c(.1,.2,.3,.4,.5,.6,.7,.8,.9)
#empty4=data.frame(availcatch=NA,Marxan_raw=NA,EcoROMS=NA)
empty=data.frame(matrix(NA,nrow=9,ncol = 3))
colnames(empty)=c("availcatch","Marxan_raw","EcoROMS_original")

#### run 4 ####
data=run4_random_scaling
for(i in 1:length(sworcatch)){
  binA=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% filter(suitability>=.5) %>% spread(species,suitability) %>% select(EcoROMS_original,Marxan_raw,swor) %>% .[complete.cases(.),]
  binM=quantile(binA$Marxan_raw,(1-sworcatch[i]),na.rm = T) %>% as.data.frame() %>% .[,1]
  binE=quantile(binA$EcoROMS_original,(1-sworcatch[i]),na.rm = T) %>% as.data.frame() %>% .[,1]
  print(binM)
  print(binE)
  empty$availcatch[i]=sworcatch[i]
  empty$Marxan_raw[i]=binM
  empty$EcoROMS_original[i]=binE
}

master=data.frame(product=NA,swor=NA,lbst=NA)
for(i in 1:nrow(empty)){
  tablecaughtE=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=.5) %>% filter(product_value>=empty$EcoROMS_original[i]) %>% 
    filter(product=="EcoROMS_original")%>% group_by(species,product) %>% summarise(num_presences_caught=n()) 
  
  tablecaughtM=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=.5) %>% filter(product_value>=empty$Marxan_raw[i]) %>%
    filter(product=="Marxan_raw")%>% group_by(species,product) %>% summarise(num_presences_caught=n()) %>% rbind(.,tablecaughtE)
  
  tabletotal=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=.5) %>%
    group_by(species,product) %>% summarise(num_presences=n()) %>% left_join(tablecaughtM,.) %>% mutate(Percent_caught=num_presences_caught/num_presences*100) %>% select(-c(num_presences,num_presences_caught)) %>% spread(species,Percent_caught) 
  
  if(("lbst"%in%colnames(tabletotal))==F){tabletotal$lbst=0}
  
  tabletotal=tabletotal %>% select(product,swor,lbst)
  tabletotal[is.na(tabletotal)]<-0
  
  master=rbind(master,tabletotal)
}

run4=master

#### run 5####
data=run5_random_scaling
for(i in 1:length(sworcatch)){
  binA=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% filter(suitability>=.5) %>% spread(species,suitability) %>% select(EcoROMS_original,Marxan_raw,swor) %>% .[complete.cases(.),]
  binM=quantile(binA$Marxan_raw,(1-sworcatch[i]),na.rm = T) %>% as.data.frame() %>% .[,1]
  binE=quantile(binA$EcoROMS_original,(1-sworcatch[i]),na.rm = T) %>% as.data.frame() %>% .[,1]
  print(binM)
  print(binE)
  empty$availcatch[i]=sworcatch[i]
  empty$Marxan_raw[i]=binM
  empty$EcoROMS_original[i]=binE
}

master=data.frame(product=NA,swor=NA,lbst=NA)
for(i in 1:nrow(empty)){
  tablecaughtE=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=.5) %>% filter(product_value>=empty$EcoROMS_original[i]) %>% 
    filter(product=="EcoROMS_original")%>% group_by(species,product) %>% summarise(num_presences_caught=n()) 
  
  tablecaughtM=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=.5) %>% filter(product_value>=empty$Marxan_raw[i]) %>%
    filter(product=="Marxan_raw")%>% group_by(species,product) %>% summarise(num_presences_caught=n()) %>% rbind(.,tablecaughtE)
  
  tabletotal=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=.5) %>%
    group_by(species,product) %>% summarise(num_presences=n()) %>% left_join(tablecaughtM,.) %>% mutate(Percent_caught=num_presences_caught/num_presences*100) %>% select(-c(num_presences,num_presences_caught)) %>% spread(species,Percent_caught) 
  
  if(("lbst"%in%colnames(tabletotal))==F){tabletotal$lbst=0}
  
  tabletotal=tabletotal %>% select(product,swor,lbst)
  tabletotal[is.na(tabletotal)]<-0
  
  master=rbind(master,tabletotal)
}

run5=master

#### run 6####
data=run6_random_scaling
for(i in 1:length(sworcatch)){
  binA=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% filter(suitability>=.5) %>% spread(species,suitability) %>% select(EcoROMS_original,Marxan_raw,swor) %>% .[complete.cases(.),]
  binM=quantile(binA$Marxan_raw,(1-sworcatch[i]),na.rm = T) %>% as.data.frame() %>% .[,1]
  binE=quantile(binA$EcoROMS_original,(1-sworcatch[i]),na.rm = T) %>% as.data.frame() %>% .[,1]
  print(binM)
  print(binE)
  empty$availcatch[i]=sworcatch[i]
  empty$Marxan_raw[i]=binM
  empty$EcoROMS_original[i]=binE
}

master=data.frame(product=NA,swor=NA,lbst=NA)
for(i in 1:nrow(empty)){
  tablecaughtE=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=.5) %>% filter(product_value>=empty$EcoROMS_original[i]) %>% 
    filter(product=="EcoROMS_original")%>% group_by(species,product) %>% summarise(num_presences_caught=n()) 
  
  tablecaughtM=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=.5) %>% filter(product_value>=empty$Marxan_raw[i]) %>%
    filter(product=="Marxan_raw")%>% group_by(species,product) %>% summarise(num_presences_caught=n()) %>% rbind(.,tablecaughtE)
  
  tabletotal=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=.5) %>%
    group_by(species,product) %>% summarise(num_presences=n()) %>% left_join(tablecaughtM,.) %>% mutate(Percent_caught=num_presences_caught/num_presences*100) %>% select(-c(num_presences,num_presences_caught)) %>% spread(species,Percent_caught) 
  
  if(("lbst"%in%colnames(tabletotal))==F){tabletotal$lbst=0}
  
  tabletotal=tabletotal %>% select(product,swor,lbst)
  tabletotal[is.na(tabletotal)]<-0
  
  master=rbind(master,tabletotal)
}

run6=master


### plot by swor limits ####
a=ggplot()+geom_line(data=run4 %>% filter(product=="EcoROMS_original"),aes(x=swor,y=lbst,color="EcoROMS-1"),size=.5)
a=a+geom_line(data=run4 %>% filter(product=="Marxan_raw"),aes(x=swor,y=lbst,color="EcoROMS unscaled-1"),size=.8,linetype=2)
a=a+geom_line(data=run5 %>% filter(product=="EcoROMS_original"),aes(x=swor,y=lbst,color="EcoROMS-2"),size=.5)
a=a+geom_line(data=run5 %>% filter(product=="Marxan_raw"),aes(x=swor,y=lbst,color="EcoROMS unscaled-2"),size=.8,linetype=2)
a=a+geom_line(data=run6 %>% filter(product=="EcoROMS_original"),aes(x=swor,y=lbst,color="EcoROMS-3"),size=.5)
a=a+geom_line(data=run6 %>% filter(product=="Marxan_raw"),aes(x=swor,y=lbst,color="EcoROMS unscaled-3"),size=.8,linetype=2)
a=a+ggtitle(label = paste0("Trade-offs between swordfish availability and loggerhead bycatch"),subtitle = "Algorithm thresholds are set by defining % of swordfish available to catch (iterated at 10-90%)")+labs(x="% of swordfish available to catch")+labs(y="% of leathbacks bycaught")+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+scale_color_manual("Algorithm - run",values=c("EcoROMS-1"="goldenrod","EcoROMS unscaled-1"="goldenrod","EcoROMS-2"="gray47","EcoROMS unscaled-2"="gray47","EcoROMS-3"="coral3","EcoROMS unscaled-3"="coral3"))
a=a+theme(legend.title = element_text(size=8),legend.position=c(.2,.9),legend.justification = c(.9,.9))+theme(legend.background = element_blank())+theme(legend.text=element_text(size=8),legend.box.background = element_rect(colour = "black"))+ theme(legend.key=element_blank())+guides(color = guide_legend(override.aes = list(linetype = c("dashed","dashed", "dashed","solid", "solid","solid"))))
a=a+scale_x_continuous(breaks=seq(0,100,by=10),expand = c(.03,.03))+scale_y_continuous(expand = c(.03,.03))
a

png("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/figs/sworCatch456_unscaled.png",width=7, height=5, units="in", res=400)
par(ps=10)
par(mar=c(4,4,1,1))
par(cex=1)
a
dev.off()

## -----------------------------------------------------> set limits for allowable leatherback bycatch
sworcatch=c(.1,.2,.3,.4,.5,.6,.7,.8,.9)
#empty4=data.frame(availcatch=NA,Marxan_raw=NA,EcoROMS=NA)
empty=data.frame(matrix(NA,nrow=9,ncol = 3))
colnames(empty)=c("avoided","Marxan_raw","EcoROMS_original")

#### run 4 ####
data=run4_random_scaling
for(i in 1:length(sworcatch)){
  binA=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% filter(suitability>=.5) %>% spread(species,suitability) %>% select(EcoROMS_original,Marxan_raw,lbst) %>% .[complete.cases(.),]
  binM=quantile(binA$Marxan_raw,(sworcatch[i]),na.rm = T) %>% as.data.frame() %>% .[,1]
  binE=quantile(binA$EcoROMS_original,(sworcatch[i]),na.rm = T) %>% as.data.frame() %>% .[,1]
  print(binM)
  print(binE)
  empty$avoided[i]=sworcatch[i]
  empty$Marxan_raw[i]=binM
  empty$EcoROMS_original[i]=binE
}

master=data.frame(product=NA,swor=NA,lbst=NA)
for(i in 1:nrow(empty)){
  tablecaughtE=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=.5) %>% filter(product_value>=empty$EcoROMS_original[i]) %>% 
    filter(product=="EcoROMS_original")%>% group_by(species,product) %>% summarise(num_presences_caught=n()) 
  
  tablecaughtM=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=.5) %>% filter(product_value>=empty$Marxan_raw[i]) %>%
    filter(product=="Marxan_raw")%>% group_by(species,product) %>% summarise(num_presences_caught=n()) %>% rbind(.,tablecaughtE)
  
  tabletotal=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=.5) %>%
    group_by(species,product) %>% summarise(num_presences=n()) %>% left_join(tablecaughtM,.) %>% mutate(Percent_caught=num_presences_caught/num_presences*100) %>% select(-c(num_presences,num_presences_caught)) %>% spread(species,Percent_caught) 
  
  if(("lbst"%in%colnames(tabletotal))==F){tabletotal$lbst=0}
  
  tabletotal=tabletotal %>% select(product,swor,lbst)
  tabletotal[is.na(tabletotal)]<-0
  
  master=rbind(master,tabletotal)
}

run4=master

#### run 5####
data=run5_random_scaling
for(i in 1:length(sworcatch)){
  binA=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% filter(suitability>=.5) %>% spread(species,suitability) %>% select(EcoROMS_original,Marxan_raw,lbst) %>% .[complete.cases(.),]
  binM=quantile(binA$Marxan_raw,(sworcatch[i]),na.rm = T) %>% as.data.frame() %>% .[,1]
  binE=quantile(binA$EcoROMS_original,(sworcatch[i]),na.rm = T) %>% as.data.frame() %>% .[,1]
  print(binM)
  print(binE)
  empty$availcatch[i]=sworcatch[i]
  empty$Marxan_raw[i]=binM
  empty$EcoROMS_original[i]=binE
}

master=data.frame(product=NA,swor=NA,lbst=NA)
for(i in 1:nrow(empty)){
  tablecaughtE=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=.5) %>% filter(product_value>=empty$EcoROMS_original[i]) %>% 
    filter(product=="EcoROMS_original")%>% group_by(species,product) %>% summarise(num_presences_caught=n()) 
  
  tablecaughtM=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=.5) %>% filter(product_value>=empty$Marxan_raw[i]) %>%
    filter(product=="Marxan_raw")%>% group_by(species,product) %>% summarise(num_presences_caught=n()) %>% rbind(.,tablecaughtE)
  
  tabletotal=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=.5) %>%
    group_by(species,product) %>% summarise(num_presences=n()) %>% left_join(tablecaughtM,.) %>% mutate(Percent_caught=num_presences_caught/num_presences*100) %>% select(-c(num_presences,num_presences_caught)) %>% spread(species,Percent_caught) 
  
  if(("lbst"%in%colnames(tabletotal))==F){tabletotal$lbst=0}
  
  tabletotal=tabletotal %>% select(product,swor,lbst)
  tabletotal[is.na(tabletotal)]<-0
  
  master=rbind(master,tabletotal)
}

run5=master

#### run 6####
data=run6_random_scaling
for(i in 1:length(sworcatch)){
  binA=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% filter(suitability>=.5) %>% spread(species,suitability) %>% select(EcoROMS_original,Marxan_raw,lbst) %>% .[complete.cases(.),]
  binM=quantile(binA$Marxan_raw,(sworcatch[i]),na.rm = T) %>% as.data.frame() %>% .[,1]
  binE=quantile(binA$EcoROMS_original,(sworcatch[i]),na.rm = T) %>% as.data.frame() %>% .[,1]
  print(binM)
  print(binE)
  empty$availcatch[i]=sworcatch[i]
  empty$Marxan_raw[i]=binM
  empty$EcoROMS_original[i]=binE
}

master=data.frame(product=NA,swor=NA,lbst=NA)
for(i in 1:nrow(empty)){
  tablecaughtE=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=.5) %>% filter(product_value>=empty$EcoROMS_original[i]) %>% 
    filter(product=="EcoROMS_original")%>% group_by(species,product) %>% summarise(num_presences_caught=n()) 
  
  tablecaughtM=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=.5) %>% filter(product_value>=empty$Marxan_raw[i]) %>%
    filter(product=="Marxan_raw")%>% group_by(species,product) %>% summarise(num_presences_caught=n()) %>% rbind(.,tablecaughtE)
  
  tabletotal=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=.5) %>%
    group_by(species,product) %>% summarise(num_presences=n()) %>% left_join(tablecaughtM,.) %>% mutate(Percent_caught=num_presences_caught/num_presences*100) %>% select(-c(num_presences,num_presences_caught)) %>% spread(species,Percent_caught) 
  
  if(("lbst"%in%colnames(tabletotal))==F){tabletotal$lbst=0}
  
  tabletotal=tabletotal %>% select(product,swor,lbst)
  tabletotal[is.na(tabletotal)]<-0
  
  master=rbind(master,tabletotal)
}

run6=master



### plot by lbst limits ####
a=ggplot()+geom_line(data=run4 %>% filter(product=="EcoROMS_original"),aes(x=lbst,y=swor,color="EcoROMS-1"),size=.5)
a=a+geom_line(data=run4 %>% filter(product=="Marxan_raw"),aes(x=lbst,y=swor,color="EcoROMS unscaled-1"),size=.8,linetype=2)
a=a+geom_line(data=run5 %>% filter(product=="EcoROMS_original"),aes(x=lbst,y=swor,color="EcoROMS-2"),size=.5)
a=a+geom_line(data=run5 %>% filter(product=="Marxan_raw"),aes(x=lbst,y=swor,color="EcoROMS unscaled-2"),size=.8,linetype=2)
a=a+geom_line(data=run6 %>% filter(product=="EcoROMS_original"),aes(x=lbst,y=swor,color="EcoROMS-3"),size=.5)
a=a+geom_line(data=run6 %>% filter(product=="Marxan_raw"),aes(x=lbst,y=swor,color="EcoROMS unscaled-3"),size=.8,linetype=2)
a=a+ggtitle(label = paste0("Trade-offs between loggerhead bycatch limits swordfish availability"),subtitle = "Algorithm thresholds are set by defining % of allowable leatherback bycatch (iterated at 10-90%)")+labs(x="% of allowable leatherback bycatch")+labs(y="% of swordfish available to catch")+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+scale_color_manual("Algorithm - run",values=c("EcoROMS-1"="goldenrod","EcoROMS unscaled-1"="goldenrod","EcoROMS-2"="gray47","EcoROMS unscaled-2"="gray47","EcoROMS-3"="coral3","EcoROMS unscaled-3"="coral3"))
a=a+theme(legend.title = element_text(size=8),legend.position=c(.2,.9),legend.justification = c(.9,.9))+theme(legend.background = element_blank())+theme(legend.text=element_text(size=8),legend.box.background = element_rect(colour = "black"))+ theme(legend.key=element_blank())+guides(color = guide_legend(override.aes = list(linetype = c("dashed","dashed", "dashed","solid", "solid","solid"))))
a=a+scale_x_continuous(breaks=seq(0,100,by=10),expand = c(.03,.03))+scale_y_continuous(expand = c(.03,.03))
a

png("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/figs/lbstCatch456_unscaled.png",width=7, height=5, units="in", res=400)
par(ps=10)
par(mar=c(4,4,1,1))
par(cex=1)
a
dev.off()


## --------------------------------------------------------------------------------------------> ecoroms unscaled vs marxan scaled ####
run4_random=read.csv("raw_data/species_predict_05.04.18_random_scaled_unscaled_marxan_run4.csv") %>% select(-EcoROMS_original) %>% rename(EcoROMS_original=EcoROMS_original_unscaled)
run5_random=read.csv("raw_data/species_predict_05.04.18_random_scaled_unscaled_marxan_run5.csv") %>% select(-EcoROMS_original) %>% rename(EcoROMS_original=EcoROMS_original_unscaled)
run6_random=read.csv("raw_data/species_predict_05.04.18_random_scaled_unscaled_marxan_run6.csv") %>% select(-EcoROMS_original) %>% rename(EcoROMS_original=EcoROMS_original_unscaled)

## -----------------------------------------------------> set limits for available swordfish catch
sworcatch=c(.1,.2,.3,.4,.5,.6,.7,.8,.9)
#empty4=data.frame(availcatch=NA,Marxan_raw=NA,EcoROMS=NA)
empty=data.frame(matrix(NA,nrow=9,ncol = 3))
colnames(empty)=c("availcatch","Marxan_raw","EcoROMS_original")

#### run 4 ####
data=run4_random
for(i in 1:length(sworcatch)){
  binA=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% filter(suitability>=.5) %>% spread(species,suitability) %>% select(EcoROMS_original,Marxan_raw,swor) %>% .[complete.cases(.),]
  binM=quantile(binA$Marxan_raw,(1-sworcatch[i]),na.rm = T) %>% as.data.frame() %>% .[,1]
  binE=quantile(binA$EcoROMS_original,(1-sworcatch[i]),na.rm = T) %>% as.data.frame() %>% .[,1]
  print(binM)
  print(binE)
  empty$availcatch[i]=sworcatch[i]
  empty$Marxan_raw[i]=binM
  empty$EcoROMS_original[i]=binE
}

master=data.frame(product=NA,swor=NA,lbst=NA)
for(i in 1:nrow(empty)){
  tablecaughtE=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=.5) %>% filter(product_value>=empty$EcoROMS_original[i]) %>% 
    filter(product=="EcoROMS_original")%>% group_by(species,product) %>% summarise(num_presences_caught=n()) 
  
  tablecaughtM=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=.5) %>% filter(product_value>=empty$Marxan_raw[i]) %>%
    filter(product=="Marxan_raw")%>% group_by(species,product) %>% summarise(num_presences_caught=n()) %>% rbind(.,tablecaughtE)
  
  tabletotal=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=.5) %>%
    group_by(species,product) %>% summarise(num_presences=n()) %>% left_join(tablecaughtM,.) %>% mutate(Percent_caught=num_presences_caught/num_presences*100) %>% select(-c(num_presences,num_presences_caught)) %>% spread(species,Percent_caught) 
  
  if(("lbst"%in%colnames(tabletotal))==F){tabletotal$lbst=0}
  
  tabletotal=tabletotal %>% select(product,swor,lbst)
  tabletotal[is.na(tabletotal)]<-0
  
  master=rbind(master,tabletotal)
}

run4=master

#### run 5####
data=run5_random
for(i in 1:length(sworcatch)){
  binA=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% filter(suitability>=.5) %>% spread(species,suitability) %>% select(EcoROMS_original,Marxan_raw,swor) %>% .[complete.cases(.),]
  binM=quantile(binA$Marxan_raw,(1-sworcatch[i]),na.rm = T) %>% as.data.frame() %>% .[,1]
  binE=quantile(binA$EcoROMS_original,(1-sworcatch[i]),na.rm = T) %>% as.data.frame() %>% .[,1]
  print(binM)
  print(binE)
  empty$availcatch[i]=sworcatch[i]
  empty$Marxan_raw[i]=binM
  empty$EcoROMS_original[i]=binE
}

master=data.frame(product=NA,swor=NA,lbst=NA)
for(i in 1:nrow(empty)){
  tablecaughtE=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=.5) %>% filter(product_value>=empty$EcoROMS_original[i]) %>% 
    filter(product=="EcoROMS_original")%>% group_by(species,product) %>% summarise(num_presences_caught=n()) 
  
  tablecaughtM=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=.5) %>% filter(product_value>=empty$Marxan_raw[i]) %>%
    filter(product=="Marxan_raw")%>% group_by(species,product) %>% summarise(num_presences_caught=n()) %>% rbind(.,tablecaughtE)
  
  tabletotal=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=.5) %>%
    group_by(species,product) %>% summarise(num_presences=n()) %>% left_join(tablecaughtM,.) %>% mutate(Percent_caught=num_presences_caught/num_presences*100) %>% select(-c(num_presences,num_presences_caught)) %>% spread(species,Percent_caught) 
  
  if(("lbst"%in%colnames(tabletotal))==F){tabletotal$lbst=0}
  
  tabletotal=tabletotal %>% select(product,swor,lbst)
  tabletotal[is.na(tabletotal)]<-0
  
  master=rbind(master,tabletotal)
}

run5=master

#### run 6####
data=run6_random
for(i in 1:length(sworcatch)){
  binA=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% filter(suitability>=.5) %>% spread(species,suitability) %>% select(EcoROMS_original,Marxan_raw,swor) %>% .[complete.cases(.),]
  binM=quantile(binA$Marxan_raw,(1-sworcatch[i]),na.rm = T) %>% as.data.frame() %>% .[,1]
  binE=quantile(binA$EcoROMS_original,(1-sworcatch[i]),na.rm = T) %>% as.data.frame() %>% .[,1]
  print(binM)
  print(binE)
  empty$availcatch[i]=sworcatch[i]
  empty$Marxan_raw[i]=binM
  empty$EcoROMS_original[i]=binE
}

master=data.frame(product=NA,swor=NA,lbst=NA)
for(i in 1:nrow(empty)){
  tablecaughtE=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=.5) %>% filter(product_value>=empty$EcoROMS_original[i]) %>% 
    filter(product=="EcoROMS_original")%>% group_by(species,product) %>% summarise(num_presences_caught=n()) 
  
  tablecaughtM=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=.5) %>% filter(product_value>=empty$Marxan_raw[i]) %>%
    filter(product=="Marxan_raw")%>% group_by(species,product) %>% summarise(num_presences_caught=n()) %>% rbind(.,tablecaughtE)
  
  tabletotal=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=.5) %>%
    group_by(species,product) %>% summarise(num_presences=n()) %>% left_join(tablecaughtM,.) %>% mutate(Percent_caught=num_presences_caught/num_presences*100) %>% select(-c(num_presences,num_presences_caught)) %>% spread(species,Percent_caught) 
  
  if(("lbst"%in%colnames(tabletotal))==F){tabletotal$lbst=0}
  
  tabletotal=tabletotal %>% select(product,swor,lbst)
  tabletotal[is.na(tabletotal)]<-0
  
  master=rbind(master,tabletotal)
}

run6=master


### plot by swor limits ####
a=ggplot()+geom_line(data=run4 %>% filter(product=="EcoROMS_original"),aes(x=swor,y=lbst,color="EcoROMS_unscaled-1"),size=.5)
a=a+geom_line(data=run4 %>% filter(product=="Marxan_raw"),aes(x=swor,y=lbst,color="Marxan-1"),size=.8,linetype=2)
a=a+geom_line(data=run5 %>% filter(product=="EcoROMS_original"),aes(x=swor,y=lbst,color="EcoROMS_unscaled-2"),size=.5)
a=a+geom_line(data=run5 %>% filter(product=="Marxan_raw"),aes(x=swor,y=lbst,color="Marxan-2"),size=.8,linetype=2)
a=a+geom_line(data=run6 %>% filter(product=="EcoROMS_original"),aes(x=swor,y=lbst,color="EcoROMS_unscaled-3"),size=.5)
a=a+geom_line(data=run6 %>% filter(product=="Marxan_raw"),aes(x=swor,y=lbst,color="Marxan-3"),size=.8,linetype=2)
a=a+ggtitle(label = paste0("Trade-offs between swordfish availability and loggerhead bycatch"),subtitle = "Algorithm thresholds are set by defining % of swordfish available to catch (iterated at 10-90%)")+labs(x="% of swordfish available to catch")+labs(y="% of leathbacks bycaught")+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+scale_color_manual("Algorithm - run",values=c("EcoROMS_unscaled-1"="goldenrod","Marxan-1"="goldenrod","EcoROMS_unscaled-2"="gray47","Marxan-2"="gray47","EcoROMS_unscaled-3"="coral3","Marxan-3"="coral3"))
a=a+theme(legend.title = element_text(size=8),legend.position=c(.2,.9),legend.justification = c(.9,.9))+theme(legend.background = element_blank())+theme(legend.text=element_text(size=8),legend.box.background = element_rect(colour = "black"))+ theme(legend.key=element_blank())+guides(color = guide_legend(override.aes = list(linetype = c("solid", "solid","solid", "dashed","dashed", "dashed"))))
a=a+scale_x_continuous(breaks=seq(0,100,by=10),expand = c(.03,.03))+scale_y_continuous(expand = c(.03,.03))
a

png("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/figs/sworCatch456_MvsEunscaled.png",width=7, height=5, units="in", res=400)
par(ps=10)
par(mar=c(4,4,1,1))
par(cex=1)
a
dev.off()

## -----------------------------------------------------> set limits for allowable leatherback bycatch
sworcatch=c(.1,.2,.3,.4,.5,.6,.7,.8,.9)
#empty4=data.frame(availcatch=NA,Marxan_raw=NA,EcoROMS=NA)
empty=data.frame(matrix(NA,nrow=9,ncol = 3))
colnames(empty)=c("avoided","Marxan_raw","EcoROMS_original")

#### run 4 ####
data=run4_random
for(i in 1:length(sworcatch)){
  binA=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% filter(suitability>=.5) %>% spread(species,suitability) %>% select(EcoROMS_original,Marxan_raw,lbst) %>% .[complete.cases(.),]
  binM=quantile(binA$Marxan_raw,(sworcatch[i]),na.rm = T) %>% as.data.frame() %>% .[,1]
  binE=quantile(binA$EcoROMS_original,(sworcatch[i]),na.rm = T) %>% as.data.frame() %>% .[,1]
  print(binM)
  print(binE)
  empty$avoided[i]=sworcatch[i]
  empty$Marxan_raw[i]=binM
  empty$EcoROMS_original[i]=binE
}

master=data.frame(product=NA,swor=NA,lbst=NA)
for(i in 1:nrow(empty)){
  tablecaughtE=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=.5) %>% filter(product_value>=empty$EcoROMS_original[i]) %>% 
    filter(product=="EcoROMS_original")%>% group_by(species,product) %>% summarise(num_presences_caught=n()) 
  
  tablecaughtM=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=.5) %>% filter(product_value>=empty$Marxan_raw[i]) %>%
    filter(product=="Marxan_raw")%>% group_by(species,product) %>% summarise(num_presences_caught=n()) %>% rbind(.,tablecaughtE)
  
  tabletotal=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=.5) %>%
    group_by(species,product) %>% summarise(num_presences=n()) %>% left_join(tablecaughtM,.) %>% mutate(Percent_caught=num_presences_caught/num_presences*100) %>% select(-c(num_presences,num_presences_caught)) %>% spread(species,Percent_caught) 
  
  if(("lbst"%in%colnames(tabletotal))==F){tabletotal$lbst=0}
  
  tabletotal=tabletotal %>% select(product,swor,lbst)
  tabletotal[is.na(tabletotal)]<-0
  
  master=rbind(master,tabletotal)
}

run4=master

#### run 5####
data=run5_random
for(i in 1:length(sworcatch)){
  binA=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% filter(suitability>=.5) %>% spread(species,suitability) %>% select(EcoROMS_original,Marxan_raw,lbst) %>% .[complete.cases(.),]
  binM=quantile(binA$Marxan_raw,(sworcatch[i]),na.rm = T) %>% as.data.frame() %>% .[,1]
  binE=quantile(binA$EcoROMS_original,(sworcatch[i]),na.rm = T) %>% as.data.frame() %>% .[,1]
  print(binM)
  print(binE)
  empty$availcatch[i]=sworcatch[i]
  empty$Marxan_raw[i]=binM
  empty$EcoROMS_original[i]=binE
}

master=data.frame(product=NA,swor=NA,lbst=NA)
for(i in 1:nrow(empty)){
  tablecaughtE=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=.5) %>% filter(product_value>=empty$EcoROMS_original[i]) %>% 
    filter(product=="EcoROMS_original")%>% group_by(species,product) %>% summarise(num_presences_caught=n()) 
  
  tablecaughtM=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=.5) %>% filter(product_value>=empty$Marxan_raw[i]) %>%
    filter(product=="Marxan_raw")%>% group_by(species,product) %>% summarise(num_presences_caught=n()) %>% rbind(.,tablecaughtE)
  
  tabletotal=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=.5) %>%
    group_by(species,product) %>% summarise(num_presences=n()) %>% left_join(tablecaughtM,.) %>% mutate(Percent_caught=num_presences_caught/num_presences*100) %>% select(-c(num_presences,num_presences_caught)) %>% spread(species,Percent_caught) 
  
  if(("lbst"%in%colnames(tabletotal))==F){tabletotal$lbst=0}
  
  tabletotal=tabletotal %>% select(product,swor,lbst)
  tabletotal[is.na(tabletotal)]<-0
  
  master=rbind(master,tabletotal)
}

run5=master

#### run 6####
data=run6_random
for(i in 1:length(sworcatch)){
  binA=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% filter(suitability>=.5) %>% spread(species,suitability) %>% select(EcoROMS_original,Marxan_raw,lbst) %>% .[complete.cases(.),]
  binM=quantile(binA$Marxan_raw,(sworcatch[i]),na.rm = T) %>% as.data.frame() %>% .[,1]
  binE=quantile(binA$EcoROMS_original,(sworcatch[i]),na.rm = T) %>% as.data.frame() %>% .[,1]
  print(binM)
  print(binE)
  empty$availcatch[i]=sworcatch[i]
  empty$Marxan_raw[i]=binM
  empty$EcoROMS_original[i]=binE
}

master=data.frame(product=NA,swor=NA,lbst=NA)
for(i in 1:nrow(empty)){
  tablecaughtE=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=.5) %>% filter(product_value>=empty$EcoROMS_original[i]) %>% 
    filter(product=="EcoROMS_original")%>% group_by(species,product) %>% summarise(num_presences_caught=n()) 
  
  tablecaughtM=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=.5) %>% filter(product_value>=empty$Marxan_raw[i]) %>%
    filter(product=="Marxan_raw")%>% group_by(species,product) %>% summarise(num_presences_caught=n()) %>% rbind(.,tablecaughtE)
  
  tabletotal=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=.5) %>%
    group_by(species,product) %>% summarise(num_presences=n()) %>% left_join(tablecaughtM,.) %>% mutate(Percent_caught=num_presences_caught/num_presences*100) %>% select(-c(num_presences,num_presences_caught)) %>% spread(species,Percent_caught) 
  
  if(("lbst"%in%colnames(tabletotal))==F){tabletotal$lbst=0}
  
  tabletotal=tabletotal %>% select(product,swor,lbst)
  tabletotal[is.na(tabletotal)]<-0
  
  master=rbind(master,tabletotal)
}

run6=master



### plot by lbst limits ####
a=ggplot()+geom_line(data=run4 %>% filter(product=="EcoROMS_original"),aes(x=lbst,y=swor,color="EcoROMS_unscaled-1"),size=.5)
a=a+geom_line(data=run4 %>% filter(product=="Marxan_raw"),aes(x=lbst,y=swor,color="Marxan-1"),size=.8,linetype=2)
a=a+geom_line(data=run5 %>% filter(product=="EcoROMS_original"),aes(x=lbst,y=swor,color="EcoROMS_unscaled-2"),size=.5)
a=a+geom_line(data=run5 %>% filter(product=="Marxan_raw"),aes(x=lbst,y=swor,color="Marxan-2"),size=.8,linetype=2)
a=a+geom_line(data=run6 %>% filter(product=="EcoROMS_original"),aes(x=lbst,y=swor,color="EcoROMS_unscaled-3"),size=.5)
a=a+geom_line(data=run6 %>% filter(product=="Marxan_raw"),aes(x=lbst,y=swor,color="Marxan-3"),size=.8,linetype=2)
a=a+ggtitle(label = paste0("Trade-offs between loggerhead bycatch limits swordfish availability"),subtitle = "Algorithm thresholds are set by defining % of allowable leatherback bycatch (iterated at 10-90%)")+labs(x="% of allowable leatherback bycatch")+labs(y="% of swordfish available to catch")+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+scale_color_manual("Algorithm - run",values=c("EcoROMS_unscaled-1"="goldenrod","Marxan-1"="goldenrod","EcoROMS_unscaled-2"="gray47","Marxan-2"="gray47","EcoROMS_unscaled-3"="coral3","Marxan-3"="coral3"))
a=a+theme(legend.title = element_text(size=8),legend.position=c(.25,.9),legend.justification = c(.9,.9))+theme(legend.background = element_blank())+theme(legend.text=element_text(size=8),legend.box.background = element_rect(colour = "black"))+ theme(legend.key=element_blank())+guides(color = guide_legend(override.aes = list(linetype = c("solid", "solid","solid", "dashed","dashed", "dashed"))))
a=a+scale_x_continuous(breaks=seq(0,100,by=10),expand = c(.03,.03))+scale_y_continuous(expand = c(.03,.03))
a

png("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/figs/lbstCatch456MvsEunscaled.png",width=7, height=5, units="in", res=400)
par(ps=10)
par(mar=c(4,4,1,1))
par(cex=1)
a
dev.off()


## --------------------------------------------------------------------------------------------------------------> RUNS 78&9
## --------------------------------------------------------------------------------------------> ecoroms vs marxan ####
run7_random=read.csv("raw_data/species_predict_05.10.18_random_scaled_unscaled_run7.csv") %>% select(-c(EcoROMS_original_unscaled,Marxan_raw_unscaled))
run8_random=read.csv("raw_data/species_predict_05.10.18_random_scaled_unscaled_run8.csv") #%>% select(-c(EcoROMS_original_unscaled,Marxan_raw_unscaled))
run9_random=read.csv("raw_data/species_predict_05.10.18_random_scaled_unscaled_run9.csv") #%>% select(-c(EcoROMS_original_unscaled,Marxan_raw_unscaled))

## -----------------------------------------------------> set limits for available swordfish catch
sworcatch=c(.1,.2,.3,.4,.5,.6,.7,.8,.9)
#empty4=data.frame(availcatch=NA,Marxan_raw=NA,EcoROMS=NA)
empty=data.frame(matrix(NA,nrow=9,ncol = 3))
colnames(empty)=c("availcatch","Marxan_raw","EcoROMS_original")

#### run 7 ####
data=run7_random
for(i in 1:length(sworcatch)){
  binA=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% filter(suitability>=.5) %>% spread(species,suitability) %>% select(EcoROMS_original,Marxan_raw,swor) %>% .[complete.cases(.),]
  binM=quantile(binA$Marxan_raw,(1-sworcatch[i]),na.rm = T) %>% as.data.frame() %>% .[,1]
  binE=quantile(binA$EcoROMS_original,(1-sworcatch[i]),na.rm = T) %>% as.data.frame() %>% .[,1]
  print(binM)
  print(binE)
  empty$availcatch[i]=sworcatch[i]
  empty$Marxan_raw[i]=binM
  empty$EcoROMS_original[i]=binE
}

master=data.frame(product=NA,swor=NA,lbst=NA)
for(i in 1:nrow(empty)){
  tablecaughtE=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=.5) %>% filter(product_value>=empty$EcoROMS_original[i]) %>% 
    filter(product=="EcoROMS_original")%>% group_by(species,product) %>% summarise(num_presences_caught=n()) 
  
  tablecaughtM=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=.5) %>% filter(product_value>=empty$Marxan_raw[i]) %>%
    filter(product=="Marxan_raw")%>% group_by(species,product) %>% summarise(num_presences_caught=n()) %>% rbind(.,tablecaughtE)
  
  tabletotal=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=.5) %>%
    group_by(species,product) %>% summarise(num_presences=n()) %>% left_join(tablecaughtM,.) %>% mutate(Percent_caught=num_presences_caught/num_presences*100) %>% select(-c(num_presences,num_presences_caught)) %>% spread(species,Percent_caught) 
  
  if(("lbst"%in%colnames(tabletotal))==F){tabletotal$lbst=0}
  
  tabletotal=tabletotal %>% select(product,swor,lbst)
  tabletotal[is.na(tabletotal)]<-0
  
  master=rbind(master,tabletotal)
}

run4=master

#### run 8####
data=run8_random
for(i in 1:length(sworcatch)){
  binA=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% filter(suitability>=.5) %>% spread(species,suitability) %>% select(EcoROMS_original,Marxan_raw,swor) %>% .[complete.cases(.),]
  binM=quantile(binA$Marxan_raw,(1-sworcatch[i]),na.rm = T) %>% as.data.frame() %>% .[,1]
  binE=quantile(binA$EcoROMS_original,(1-sworcatch[i]),na.rm = T) %>% as.data.frame() %>% .[,1]
  print(binM)
  print(binE)
  empty$availcatch[i]=sworcatch[i]
  empty$Marxan_raw[i]=binM
  empty$EcoROMS_original[i]=binE
}

master=data.frame(product=NA,swor=NA,lbst=NA)
for(i in 1:nrow(empty)){
  tablecaughtE=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=.5) %>% filter(product_value>=empty$EcoROMS_original[i]) %>% 
    filter(product=="EcoROMS_original")%>% group_by(species,product) %>% summarise(num_presences_caught=n()) 
  
  tablecaughtM=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=.5) %>% filter(product_value>=empty$Marxan_raw[i]) %>%
    filter(product=="Marxan_raw")%>% group_by(species,product) %>% summarise(num_presences_caught=n()) %>% rbind(.,tablecaughtE)
  
  tabletotal=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=.5) %>%
    group_by(species,product) %>% summarise(num_presences=n()) %>% left_join(tablecaughtM,.) %>% mutate(Percent_caught=num_presences_caught/num_presences*100) %>% select(-c(num_presences,num_presences_caught)) %>% spread(species,Percent_caught) 
  
  if(("lbst"%in%colnames(tabletotal))==F){tabletotal$lbst=0}
  
  tabletotal=tabletotal %>% select(product,swor,lbst)
  tabletotal[is.na(tabletotal)]<-0
  
  master=rbind(master,tabletotal)
}

run5=master

#### run 9####
data=run9_random
for(i in 1:length(sworcatch)){
  binA=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% filter(suitability>=.5) %>% spread(species,suitability) %>% select(EcoROMS_original,Marxan_raw,swor) %>% .[complete.cases(.),]
  binM=quantile(binA$Marxan_raw,(1-sworcatch[i]),na.rm = T) %>% as.data.frame() %>% .[,1]
  binE=quantile(binA$EcoROMS_original,(1-sworcatch[i]),na.rm = T) %>% as.data.frame() %>% .[,1]
  print(binM)
  print(binE)
  empty$availcatch[i]=sworcatch[i]
  empty$Marxan_raw[i]=binM
  empty$EcoROMS_original[i]=binE
}

master=data.frame(product=NA,swor=NA,lbst=NA)
for(i in 1:nrow(empty)){
  tablecaughtE=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=.5) %>% filter(product_value>=empty$EcoROMS_original[i]) %>% 
    filter(product=="EcoROMS_original")%>% group_by(species,product) %>% summarise(num_presences_caught=n()) 
  
  tablecaughtM=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=.5) %>% filter(product_value>=empty$Marxan_raw[i]) %>%
    filter(product=="Marxan_raw")%>% group_by(species,product) %>% summarise(num_presences_caught=n()) %>% rbind(.,tablecaughtE)
  
  tabletotal=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=.5) %>%
    group_by(species,product) %>% summarise(num_presences=n()) %>% left_join(tablecaughtM,.) %>% mutate(Percent_caught=num_presences_caught/num_presences*100) %>% select(-c(num_presences,num_presences_caught)) %>% spread(species,Percent_caught) 
  
  if(("lbst"%in%colnames(tabletotal))==F){tabletotal$lbst=0}
  
  tabletotal=tabletotal %>% select(product,swor,lbst)
  tabletotal[is.na(tabletotal)]<-0
  
  master=rbind(master,tabletotal)
}

run6=master


### plot by swor limits ####
a=ggplot()+geom_line(data=run4 %>% filter(product=="EcoROMS_original"),aes(x=swor,y=lbst,color="EcoROMS-1"),size=.5)
a=a+geom_line(data=run4 %>% filter(product=="Marxan_raw"),aes(x=swor,y=lbst,color="Marxan-1"),size=.8,linetype=2)
a=a+geom_line(data=run5 %>% filter(product=="EcoROMS_original"),aes(x=swor,y=lbst,color="EcoROMS-2"),size=.5)
a=a+geom_line(data=run5 %>% filter(product=="Marxan_raw"),aes(x=swor,y=lbst,color="Marxan-2"),size=.8,linetype=2)
a=a+geom_line(data=run6 %>% filter(product=="EcoROMS_original"),aes(x=swor,y=lbst,color="EcoROMS-3"),size=.5)
a=a+geom_line(data=run6 %>% filter(product=="Marxan_raw"),aes(x=swor,y=lbst,color="Marxan-3"),size=.8,linetype=2)
a=a+ggtitle(label = paste0("Trade-offs between swordfish availability and loggerhead bycatch"),subtitle = "Algorithm thresholds are set by defining % of swordfish available to catch (iterated at 10-90%)")+labs(x="% of swordfish available to catch")+labs(y="% of leathbacks bycaught")+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+scale_color_manual("Algorithm - run",values=c("EcoROMS-1"="goldenrod","Marxan-1"="goldenrod","EcoROMS-2"="gray47","Marxan-2"="gray47","EcoROMS-3"="coral3","Marxan-3"="coral3"))
a=a+theme(legend.title = element_text(size=8),legend.position=c(.2,.9),legend.justification = c(.9,.9))+theme(legend.background = element_blank())+theme(legend.text=element_text(size=8),legend.box.background = element_rect(colour = "black"))+ theme(legend.key=element_blank())+guides(color = guide_legend(override.aes = list(linetype = c("solid", "solid","solid", "dashed","dashed", "dashed"))))
a=a+scale_x_continuous(breaks=seq(0,100,by=10),expand = c(.03,.03))+scale_y_continuous(expand = c(.03,.03))
a

png("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/figs/sworCatch456.png",width=7, height=5, units="in", res=400)
par(ps=10)
par(mar=c(4,4,1,1))
par(cex=1)
a
dev.off()

## -----------------------------------------------------> set limits for allowable leatherback bycatch
sworcatch=c(.1,.2,.3,.4,.5,.6,.7,.8,.9)
#empty4=data.frame(availcatch=NA,Marxan_raw=NA,EcoROMS=NA)
empty=data.frame(matrix(NA,nrow=9,ncol = 3))
colnames(empty)=c("avoided","Marxan_raw","EcoROMS_original")

#### run 7 ####
data=run7_random
for(i in 1:length(sworcatch)){
  binA=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% filter(suitability>=.5) %>% spread(species,suitability) %>% select(EcoROMS_original,Marxan_raw,lbst) %>% .[complete.cases(.),]
  binM=quantile(binA$Marxan_raw,(sworcatch[i]),na.rm = T) %>% as.data.frame() %>% .[,1]
  binE=quantile(binA$EcoROMS_original,(sworcatch[i]),na.rm = T) %>% as.data.frame() %>% .[,1]
  print(binM)
  print(binE)
  empty$avoided[i]=sworcatch[i]
  empty$Marxan_raw[i]=binM
  empty$EcoROMS_original[i]=binE
}

master=data.frame(product=NA,swor=NA,lbst=NA)
for(i in 1:nrow(empty)){
  tablecaughtE=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=.5) %>% filter(product_value>=empty$EcoROMS_original[i]) %>% 
    filter(product=="EcoROMS_original")%>% group_by(species,product) %>% summarise(num_presences_caught=n()) 
  
  tablecaughtM=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=.5) %>% filter(product_value>=empty$Marxan_raw[i]) %>%
    filter(product=="Marxan_raw")%>% group_by(species,product) %>% summarise(num_presences_caught=n()) %>% rbind(.,tablecaughtE)
  
  tabletotal=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=.5) %>%
    group_by(species,product) %>% summarise(num_presences=n()) %>% left_join(tablecaughtM,.) %>% mutate(Percent_caught=num_presences_caught/num_presences*100) %>% select(-c(num_presences,num_presences_caught)) %>% spread(species,Percent_caught) 
  
  if(("lbst"%in%colnames(tabletotal))==F){tabletotal$lbst=0}
  
  tabletotal=tabletotal %>% select(product,swor,lbst)
  tabletotal[is.na(tabletotal)]<-0
  
  master=rbind(master,tabletotal)
}

run4=master

#### run 8####
data=run8_random
for(i in 1:length(sworcatch)){
  binA=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% filter(suitability>=.5) %>% spread(species,suitability) %>% select(EcoROMS_original,Marxan_raw,lbst) %>% .[complete.cases(.),]
  binM=quantile(binA$Marxan_raw,(sworcatch[i]),na.rm = T) %>% as.data.frame() %>% .[,1]
  binE=quantile(binA$EcoROMS_original,(sworcatch[i]),na.rm = T) %>% as.data.frame() %>% .[,1]
  print(binM)
  print(binE)
  empty$availcatch[i]=sworcatch[i]
  empty$Marxan_raw[i]=binM
  empty$EcoROMS_original[i]=binE
}

master=data.frame(product=NA,swor=NA,lbst=NA)
for(i in 1:nrow(empty)){
  tablecaughtE=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=.5) %>% filter(product_value>=empty$EcoROMS_original[i]) %>% 
    filter(product=="EcoROMS_original")%>% group_by(species,product) %>% summarise(num_presences_caught=n()) 
  
  tablecaughtM=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=.5) %>% filter(product_value>=empty$Marxan_raw[i]) %>%
    filter(product=="Marxan_raw")%>% group_by(species,product) %>% summarise(num_presences_caught=n()) %>% rbind(.,tablecaughtE)
  
  tabletotal=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=.5) %>%
    group_by(species,product) %>% summarise(num_presences=n()) %>% left_join(tablecaughtM,.) %>% mutate(Percent_caught=num_presences_caught/num_presences*100) %>% select(-c(num_presences,num_presences_caught)) %>% spread(species,Percent_caught) 
  
  if(("lbst"%in%colnames(tabletotal))==F){tabletotal$lbst=0}
  
  tabletotal=tabletotal %>% select(product,swor,lbst)
  tabletotal[is.na(tabletotal)]<-0
  
  master=rbind(master,tabletotal)
}

run5=master

#### run 9####
data=run9_random
for(i in 1:length(sworcatch)){
  binA=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% filter(suitability>=.5) %>% spread(species,suitability) %>% select(EcoROMS_original,Marxan_raw,lbst) %>% .[complete.cases(.),]
  binM=quantile(binA$Marxan_raw,(sworcatch[i]),na.rm = T) %>% as.data.frame() %>% .[,1]
  binE=quantile(binA$EcoROMS_original,(sworcatch[i]),na.rm = T) %>% as.data.frame() %>% .[,1]
  print(binM)
  print(binE)
  empty$availcatch[i]=sworcatch[i]
  empty$Marxan_raw[i]=binM
  empty$EcoROMS_original[i]=binE
}

master=data.frame(product=NA,swor=NA,lbst=NA)
for(i in 1:nrow(empty)){
  tablecaughtE=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=.5) %>% filter(product_value>=empty$EcoROMS_original[i]) %>% 
    filter(product=="EcoROMS_original")%>% group_by(species,product) %>% summarise(num_presences_caught=n()) 
  
  tablecaughtM=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=.5) %>% filter(product_value>=empty$Marxan_raw[i]) %>%
    filter(product=="Marxan_raw")%>% group_by(species,product) %>% summarise(num_presences_caught=n()) %>% rbind(.,tablecaughtE)
  
  tabletotal=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=.5) %>%
    group_by(species,product) %>% summarise(num_presences=n()) %>% left_join(tablecaughtM,.) %>% mutate(Percent_caught=num_presences_caught/num_presences*100) %>% select(-c(num_presences,num_presences_caught)) %>% spread(species,Percent_caught) 
  
  if(("lbst"%in%colnames(tabletotal))==F){tabletotal$lbst=0}
  
  tabletotal=tabletotal %>% select(product,swor,lbst)
  tabletotal[is.na(tabletotal)]<-0
  
  master=rbind(master,tabletotal)
}

run6=master



### plot by lbst limits ####
a=ggplot()+geom_line(data=run4 %>% filter(product=="EcoROMS_original"),aes(x=lbst,y=swor,color="EcoROMS-1"),size=.5)
a=a+geom_line(data=run4 %>% filter(product=="Marxan_raw"),aes(x=lbst,y=swor,color="Marxan-1"),size=.8,linetype=2)
a=a+geom_line(data=run5 %>% filter(product=="EcoROMS_original"),aes(x=lbst,y=swor,color="EcoROMS-2"),size=.5)
a=a+geom_line(data=run5 %>% filter(product=="Marxan_raw"),aes(x=lbst,y=swor,color="Marxan-2"),size=.8,linetype=2)
a=a+geom_line(data=run6 %>% filter(product=="EcoROMS_original"),aes(x=lbst,y=swor,color="EcoROMS-3"),size=.5)
a=a+geom_line(data=run6 %>% filter(product=="Marxan_raw"),aes(x=lbst,y=swor,color="Marxan-3"),size=.8,linetype=2)
a=a+ggtitle(label = paste0("Trade-offs between loggerhead bycatch limits swordfish availability"),subtitle = "Algorithm thresholds are set by defining % of allowable leatherback bycatch (iterated at 10-90%)")+labs(x="% of allowable leatherback bycatch")+labs(y="% of swordfish available to catch")+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+scale_color_manual("Algorithm - run",values=c("EcoROMS-1"="goldenrod","Marxan-1"="goldenrod","EcoROMS-2"="gray47","Marxan-2"="gray47","EcoROMS-3"="coral3","Marxan-3"="coral3"))
a=a+theme(legend.title = element_text(size=8),legend.position=c(.2,.9),legend.justification = c(.9,.9))+theme(legend.background = element_blank())+theme(legend.text=element_text(size=8),legend.box.background = element_rect(colour = "black"))+ theme(legend.key=element_blank())+guides(color = guide_legend(override.aes = list(linetype = c("solid", "solid","solid", "dashed","dashed", "dashed"))))
a=a+scale_x_continuous(breaks=seq(0,100,by=10),expand = c(.03,.03))+scale_y_continuous(expand = c(.03,.03))
a

png("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/figs/lbstCatch456.png",width=7, height=5, units="in", res=400)
par(ps=10)
par(mar=c(4,4,1,1))
par(cex=1)
a
dev.off()
