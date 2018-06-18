### figures for IMCC

source("load_functions.R")
source("hindcast_ms/summarize/algorithm_comparison.R")

plotdir="hindcast_ms/summarize/plots/"
csvdir="hindcast_ms/summarize/csvs/"
datadir="hindcast_ms/extract/extractions/"


#### B.5 with big legends (slide 12)####
weightings <-c(0,0,0,-0.9,0) #run B.5
run="B.5"
data=read.csv(paste0(datadir,"run_",run,".csv"))

catch=c(0,.1,.2,.3,.4,.5,.6,.7,.8,.9,1)
namesrisk<-c("Blue shark bycatch","Blue sharks","Sea lions","Leatherbacks","Swordfish")

## swordfish evaluation first
empty=data.frame(matrix(NA,nrow=11,ncol = 5))
colnames(empty)=c("availcatch","Marxan_raw","EcoROMS_original","Marxan_raw_unscaled","EcoROMS_original_unscaled")
for(i in 1:length(catch)){ 
  binA=data %>% dplyr::select(-c(X,lon,lat,dt,lbst,casl,blshobs,blshtrk))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw,EcoROMS_original_unscaled,Marxan_raw_unscaled)) %>% filter(suitability>=.5) %>% spread(species,suitability) %>% dplyr::select(EcoROMS_original,Marxan_raw,EcoROMS_original_unscaled,Marxan_raw_unscaled,swor) %>% .[complete.cases(.),]
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
  tablecaughtE=data %>% dplyr::select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw,Marxan_raw_unscaled,EcoROMS_original_unscaled)) %>% gather(product,product_value,-c(species,suitability)) %>% dplyr::filter(suitability>=.5) %>% dplyr::filter(product_value>empty$EcoROMS_original[i]) %>% 
    dplyr::filter(product=="EcoROMS_original")%>% group_by(species,product) %>% summarise(num_presences_caught=n()) 
  if(nrow(tablecaughtE)==0){tablecaughtE=tablecaughtE %>% ungroup() %>% add_row(species=c("lbst","swor"),product="EcorROMS_original",num_presences_caught=0) %>% group_by(species,product)}
  
  tablecaughtM=data %>% dplyr::select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw,Marxan_raw_unscaled,EcoROMS_original_unscaled)) %>% gather(product,product_value,-c(species,suitability)) %>% dplyr::filter(suitability>=.5) %>% dplyr::filter(product_value>empty$Marxan_raw[i]) %>%
    dplyr::filter(product=="Marxan_raw")%>% group_by(species,product) %>% summarise(num_presences_caught=n()) 
  if(nrow(tablecaughtM)==0){tablecaughtM=tablecaughtM %>% ungroup() %>% add_row(species=c("lbst","swor"),product="Marxan_raw",num_presences_caught=0) %>% group_by(species,product)}
  tablecaughtM=tablecaughtM %>% rbind(.,tablecaughtE)
  
  tablecaughtEuS=data %>% dplyr::select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw,Marxan_raw_unscaled,EcoROMS_original_unscaled)) %>% gather(product,product_value,-c(species,suitability)) %>% dplyr::filter(suitability>=.5) %>% dplyr::filter(product_value>empty$EcoROMS_original_unscaled[i]) %>%
    dplyr::filter(product=="EcoROMS_original_unscaled")%>% group_by(species,product) %>% summarise(num_presences_caught=n())  
  if(nrow(tablecaughtEuS)==0){tablecaughtEuS=tablecaughtEuS %>% ungroup() %>% add_row(species=c("lbst","swor"),product="EcoROMS_original_unscaled",num_presences_caught=0) %>% group_by(species,product)}
  tablecaughtEuS=tablecaughtEuS %>% rbind(.,tablecaughtM)
  
  tablecaughtMEuS=data %>% dplyr::select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw,Marxan_raw_unscaled,EcoROMS_original_unscaled)) %>% gather(product,product_value,-c(species,suitability)) %>% dplyr::filter(suitability>=.5) %>% dplyr::filter(product_value>empty$Marxan_raw_unscaled[i]) %>%
    dplyr::filter(product=="Marxan_raw_unscaled")%>% group_by(species,product) %>% summarise(num_presences_caught=n())  
  if(nrow(tablecaughtMEuS)==0){tablecaughtMEuS=tablecaughtMEuS %>% ungroup() %>% add_row(species=c("lbst","swor"),product="Marxan_raw_unscaled",num_presences_caught=0) %>% group_by(species,product)}
  tablecaughtMEuS=tablecaughtMEuS %>% rbind(.,tablecaughtEuS)
  
  tabletotal=data %>% dplyr::select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw,Marxan_raw_unscaled,EcoROMS_original_unscaled)) %>% gather(product,product_value,-c(species,suitability)) %>% dplyr::filter(suitability>=.5) %>%
    group_by(species,product) %>% summarise(num_presences=n()) %>% left_join(tablecaughtMEuS,.) %>% mutate(Percent_caught=num_presences_caught/num_presences*100) %>% dplyr::select(-c(num_presences,num_presences_caught)) %>% spread(species,Percent_caught) 
  
  if(("lbst"%in%colnames(tabletotal))==F){tabletotal$lbst=0}
  if(("lbst"%in%colnames(tabletotal))==F){tabletotal$lbst=0}
  
  tabletotal=tabletotal %>% dplyr::select(product,swor,lbst) %>% as.data.frame()
  tabletotal[is.na(tabletotal)]<-0
  
  master=rbind(master,tabletotal)
} ## find trade-offs at catch limits
master=master[complete.cases(master),]
master$limit_target="swordfish"
sworDat=master

## plot
subtitle=paste0(namesrisk[1],": ",weightings[1],", ",namesrisk[2],": ",weightings[2],", ",namesrisk[3],": ",weightings[3],", ",namesrisk[4],": ",weightings[4],", ",namesrisk[5],": ",weightings[5])
a=ggplot()+geom_line(data=sworDat %>% filter(product=="EcoROMS_original_unscaled"),aes(x=swor,y=lbst,color="EcoCast"),size=.5)+geom_point(data=sworDat %>% filter(product=="EcoROMS_original_unscaled"),aes(x=swor,y=lbst,color="EcoCast"))
a=a+geom_line(data=sworDat %>% filter(product=="Marxan_raw_unscaled"),aes(x=swor,y=lbst,color="Marxan"),size=.8,linetype=2)+geom_point(data=sworDat %>% filter(product=="Marxan_raw_unscaled"),aes(x=swor,y=lbst,color="Marxan"))
a=a+ggtitle(label = paste0("Trade-offs between swordfish availability and leatherback bycatch"),subtitle = subtitle)+labs(x="% of swordfish available to catch")+labs(y="% of leathbacks bycaught")+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"),axis.text = element_text(size=10))+ theme(text = element_text(size=10))
a=a+scale_color_manual("Algorithm",values=c("EcoCast"="#92a8d1","Marxan"="#f7cac9"))
a=a+theme(legend.title = element_text(size=10),legend.position=c(.4,.9),legend.justification = c(.9,.9))+theme(legend.background = element_blank())+theme(legend.text=element_text(size=10),legend.box.background = element_rect(colour = "black"))+ theme(legend.key=element_blank())+guides(color = guide_legend(override.aes = list(linetype = c("solid", "dashed"))))
a=a+scale_x_continuous(breaks=seq(0,100,by=10),expand = c(.03,.03))+scale_y_continuous(expand = c(.03,.03))
sworPlot=a


## leatherback evaluation second
empty=data.frame(matrix(NA,nrow=11,ncol = 5))
colnames(empty)=c("availcatch","Marxan_raw","EcoROMS_original","Marxan_raw_unscaled","EcoROMS_original_unscaled")
for(i in 1:length(catch)){ 
  binA=data %>% dplyr::select(-c(X,lon,lat,dt,swor,casl,blshobs,blshtrk))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw,EcoROMS_original_unscaled,Marxan_raw_unscaled)) %>% filter(suitability>=.5) %>% spread(species,suitability) %>% dplyr::select(EcoROMS_original,Marxan_raw,EcoROMS_original_unscaled,Marxan_raw_unscaled,lbst) %>% .[complete.cases(.),]
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
empty$limit_target="leatherback"
lbstThresh=empty

master=data.frame(product=NA,swor=NA,lbst=NA)
for(i in 1:nrow(empty)){
  tablecaughtE=data %>% dplyr::select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw,Marxan_raw_unscaled,EcoROMS_original_unscaled)) %>% gather(product,product_value,-c(species,suitability)) %>% dplyr::filter(suitability>=.5) %>% dplyr::filter(product_value>empty$EcoROMS_original[i]) %>% 
    dplyr::filter(product=="EcoROMS_original")%>% group_by(species,product) %>% summarise(num_presences_caught=n()) 
  if(nrow(tablecaughtE)==0){tablecaughtE=tablecaughtE %>% ungroup() %>% add_row(species=c("lbst","swor"),product="EcorROMS_original",num_presences_caught=0) %>% group_by(species,product)}
  
  tablecaughtM=data %>% dplyr::select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw,Marxan_raw_unscaled,EcoROMS_original_unscaled)) %>% gather(product,product_value,-c(species,suitability)) %>% dplyr::filter(suitability>=.5) %>% dplyr::filter(product_value>empty$Marxan_raw[i]) %>%
    dplyr::filter(product=="Marxan_raw")%>% group_by(species,product) %>% summarise(num_presences_caught=n()) 
  if(nrow(tablecaughtM)==0){tablecaughtM=tablecaughtM %>% ungroup() %>% add_row(species=c("lbst","swor"),product="Marxan_raw",num_presences_caught=0) %>% group_by(species,product)}
  tablecaughtM=tablecaughtM %>% rbind(.,tablecaughtE)
  
  tablecaughtEuS=data %>% dplyr::select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw,Marxan_raw_unscaled,EcoROMS_original_unscaled)) %>% gather(product,product_value,-c(species,suitability)) %>% dplyr::filter(suitability>=.5) %>% dplyr::filter(product_value>empty$EcoROMS_original_unscaled[i]) %>%
    dplyr::filter(product=="EcoROMS_original_unscaled")%>% group_by(species,product) %>% summarise(num_presences_caught=n())  
  if(nrow(tablecaughtEuS)==0){tablecaughtEuS=tablecaughtEuS %>% ungroup() %>% add_row(species=c("lbst","swor"),product="EcoROMS_original_unscaled",num_presences_caught=0) %>% group_by(species,product)}
  tablecaughtEuS=tablecaughtEuS %>% rbind(.,tablecaughtM)
  
  tablecaughtMEuS=data %>% dplyr::select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw,Marxan_raw_unscaled,EcoROMS_original_unscaled)) %>% gather(product,product_value,-c(species,suitability)) %>% dplyr::filter(suitability>=.5) %>% dplyr::filter(product_value>empty$Marxan_raw_unscaled[i]) %>%
    dplyr::filter(product=="Marxan_raw_unscaled")%>% group_by(species,product) %>% summarise(num_presences_caught=n())  
  if(nrow(tablecaughtMEuS)==0){tablecaughtMEuS=tablecaughtMEuS %>% ungroup() %>% add_row(species=c("lbst","swor"),product="Marxan_raw_unscaled",num_presences_caught=0) %>% group_by(species,product)}
  tablecaughtMEuS=tablecaughtMEuS %>% rbind(.,tablecaughtEuS)
  
  tabletotal=data %>% dplyr::select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw,Marxan_raw_unscaled,EcoROMS_original_unscaled)) %>% gather(product,product_value,-c(species,suitability)) %>% dplyr::filter(suitability>=.5) %>%
    group_by(species,product) %>% summarise(num_presences=n()) %>% left_join(tablecaughtMEuS,.) %>% mutate(Percent_caught=num_presences_caught/num_presences*100) %>% dplyr::select(-c(num_presences,num_presences_caught)) %>% spread(species,Percent_caught) 
  
  if(("lbst"%in%colnames(tabletotal))==F){tabletotal$lbst=0}
  if(("lbst"%in%colnames(tabletotal))==F){tabletotal$lbst=0}
  
  tabletotal=tabletotal %>% dplyr::select(product,swor,lbst) %>% as.data.frame()
  tabletotal[is.na(tabletotal)]<-0
  
  master=rbind(master,tabletotal)
} ## find trade-offs at catch limits
master=master[complete.cases(master),]
master$limit_target="leatherback"
lbstDat=master

## plot
subtitle=paste0(namesrisk[1],": ",weightings[1],", ",namesrisk[2],": ",weightings[2],", ",namesrisk[3],": ",weightings[3],", ",namesrisk[4],": ",weightings[4],", ",namesrisk[5],": ",weightings[5])
a=ggplot()+geom_line(data=lbstDat %>% filter(product=="EcoROMS_original_unscaled"),aes(x=lbst,y=swor,color="EcoCast"),size=.5)+geom_point(data=lbstDat %>% filter(product=="EcoROMS_original_unscaled"),aes(x=lbst,y=swor,color="EcoCast"))
a=a+geom_line(data=lbstDat %>% filter(product=="Marxan_raw_unscaled"),aes(x=lbst,y=swor,color="Marxan"),size=.8,linetype=2)+geom_point(data=lbstDat %>% filter(product=="Marxan_raw_unscaled"),aes(x=lbst,y=swor,color="Marxan"))
a=a+ggtitle(label = paste0("Trade-offs between leatherback bycatch limits swordfish availability"),subtitle = subtitle)+labs(x="% of allowable leatherback bycatch")+labs(y="% of swordfish available to catch")+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"),axis.text = element_text(size=10))+ theme(text = element_text(size=10))
a=a+scale_color_manual("Algorithm",values=c("EcoCast"="#92a8d1","Marxan"="#f7cac9"))
a=a+theme(legend.title = element_text(size=10),legend.position=c(.9,.3),legend.justification = c(.9,.9))+theme(legend.background = element_blank())+theme(legend.text=element_text(size=10),legend.box.background = element_rect(colour = "black"))+ theme(legend.key=element_blank())+guides(color = guide_legend(override.aes = list(linetype = c("solid","dashed"))))
a=a+scale_x_continuous(breaks=seq(0,100,by=10),expand = c(.03,.03))+scale_y_continuous(expand = c(.03,.03))
lbstPlot=a

png(paste0(plotdir,"IMCC_algorithm_comparison.png"),width=14, height=7, units="in", res=400)
par(ps=10)
par(mar=c(4,4,1,1))
par(cex=1)
plot_grid(sworPlot,lbstPlot,nrow=1,ncol=2)
dev.off()


#### best runs (slide 13) ####
library(ggalt)
library(plotly)
csvdir="hindcast_ms/summarize/csvs/"
plotdir="hindcast_ms/summarize/plots/"

file_list=list.files("/Users/heatherwelch/Dropbox/EcoEast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/hindcast_ms/summarize/csvs") %>% grep("availcatch_algorithm",.,value=T)
master=list()
for (file in file_list){
  a=read.csv(paste0("/Users/heatherwelch/Dropbox/EcoEast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/hindcast_ms/summarize/csvs/",file))
  name=gsub("_availcatch_algorithm_comparison.csv","",file)
  a$run=name
  assign(name,a)
  master[[name]]<-a
}

fullon=do.call("rbind",master)
df=fullon %>% dplyr::filter(limit_target=="swordfish")
df$product=gsub("EcorROMS","EcoROMS",df$product)
df$product_run=paste0(df$product,"_",df$run)
df$diff=df$swor-df$lbst
dfsub=df %>% filter(product_run=="EcoROMS_original_unscaled_D.3"|product_run=="EcoROMS_original_unscaled_B.5"|product_run=="EcoROMS_original_unscaled_D.1"|product_run=="EcoROMS_original_unscaled_D.4"|product_run=="Marxan_raw_unscaled_C.3"|product_run=="Marxan_raw_unscaled_E.1"|product_run=="Marxan_raw_unscaled_E.3"|product_run=="Marxan_raw_unscaled_B.3")
dfsub=dfsub %>% mutate(product=gsub("Marxan_raw_unscaled","Marxan",product)) %>% mutate(product=gsub("EcoROMS_original_unscaled","EcoCast",product))

a=ggplot(dfsub,aes(x=swor,y=lbst))+geom_point(aes(color=product))
a=a+scale_color_manual("Algorithm",values=c("EcoCast"="#92a8d1","Marxan"="#f7cac9"))
a=a+geom_line(data=filter(df,product_run=="EcoROMS_original_unscaled_D.3"),aes(x=swor,y=lbst))+geom_point(data=filter(df,product_run=="EcoROMS_original_unscaled_D.3"),aes(x=swor,y=lbst),size=2,fill="#92a8d1",pch=21,color="black")
a=a+scale_x_continuous(breaks=seq(0,100,by=10))
a=a+ggtitle(label = paste0("Trade-offs between swordfish availability and leatherback bycatch"))+labs(x="% of swordfish available to catch")+labs(y="% of leathbacks bycaught")+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"),axis.text = element_text(size=10))+ theme(text = element_text(size=10))
a=a+theme(legend.title = element_text(size=10),legend.position=c(.3,.9),legend.justification = c(.9,.9))+theme(legend.background = element_blank())+theme(legend.text=element_text(size=10),legend.box.background = element_rect(colour = "black"))+ theme(legend.key=element_blank())
a=a+theme(legend.key.size = unit(.9,'lines'))
a=a+geom_text(x=95,y=40,label="run D.3",size=2.5)
b=a


df=fullon %>% dplyr::filter(limit_target=="leatherback")
df$product=gsub("EcorROMS","EcoROMS",df$product)
df$product_run=paste0(df$product,"_",df$run)
df$diff=df$swor-df$lbst
dfsub=df %>% filter(product_run=="EcoROMS_original_unscaled_D.3"|product_run=="EcoROMS_original_unscaled_D.1"|product_run=="EcoROMS_original_unscaled_B.5"|product_run=="EcoROMS_original_unscaled_D.4"|product_run=="Marxan_raw_unscaled_C.3"|product_run=="Marxan_raw_unscaled_E.1"|product_run=="Marxan_raw_unscaled_D.4"|product_run=="Marxan_raw_unscaled_B.2")
dfsub=dfsub %>% mutate(product=gsub("Marxan_raw_unscaled","Marxan",product)) %>% mutate(product=gsub("EcoROMS_original_unscaled","EcoCast",product))

a=ggplot(dfsub,aes(x=lbst,y=swor))+geom_point(aes(color=product))+geom_line(aes(group=product_run,color=product),alpha=.4)
a=a+scale_color_manual("Algorithm",values=c("EcoCast"="#92a8d1","Marxan"="#f7cac9"))
a=a+geom_line(data=filter(df,product_run=="EcoROMS_original_unscaled_D.3"),aes(x=lbst,y=swor))+geom_point(data=filter(df,product_run=="EcoROMS_original_unscaled_D.3"),aes(x=lbst,y=swor),size=2,fill="#92a8d1",pch=21,color="black")
a=a+scale_x_continuous(breaks=seq(0,100,by=10))
a=a+ggtitle(label = paste0("Trade-offs between leatherback bycatch and swordfish availability"))+labs(x="% of leathbacks bycaught")+labs(y="% of swordfish available to catch")+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"),axis.text = element_text(size=10))+ theme(text = element_text(size=10))
a=a+theme(legend.title = element_text(size=10),legend.position=c(.9,.3),legend.justification = c(.9,.9))+theme(legend.background = element_blank())+theme(legend.text=element_text(size=10),legend.box.background = element_rect(colour = "black"))+ theme(legend.key=element_blank())
a=a+theme(legend.key.size = unit(.9,'lines'))
a=a+geom_text(x=10,y=90,label="run D.3",size=2.5)
a

png(paste0(plotdir,"IMCC_best_runs.png"),width=14, height=7, units="in", res=400)
par(ps=10)
par(mar=c(4,4,1,1))
par(cex=1)
plot_grid(b,a,nrow=1,ncol=2)
dev.off()


#### point cloud (slide who knows) ####
data=read.csv("hindcast_ms/extract/extractions/run_D.3.csv") 
data_thresh=read.csv("hindcast_ms/summarize/csvs/D.3_thresholds_algorithm_comparison.csv") %>% filter(limit_target=="leatherback")
weightings <-c(0,0,0,-0.7,0.1) #run D.3
run="D"

subtitle=paste0(namesrisk[2],": ",weightings[2],", ",namesrisk[3],": ",weightings[3],", ",namesrisk[4],": ",weightings[4],", ",namesrisk[5],": ",weightings[5])
a=ggplot()+geom_point(data=data,aes(x=swor,y=EcoROMS_original,color="Swordfish"),size=.5,shape=1)
a=a+geom_point(data=data,aes(x=lbst,y=EcoROMS_original,color="Leatherback"),size=.5,shape=1)
a=a+ggtitle(label = paste0("Relationship between leatherback and swordfish probability of presence and EcoCast"),subtitle = subtitle)+labs(x="Probability of presence")+labs(y=paste0("EcoCast prediction"))+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=10),axis.text = element_text(size=10),plot.title = element_text(size=10))
a=a+scale_color_manual("Species",values=c("Swordfish"="goldenrod","Leatherback"="chartreuse4"))
a=a+guides(fill=guide_legend(title="Species"))+theme(legend.title = element_text(size=10),legend.position=c(.99,.45),legend.justification = c(.9,.9))+theme(legend.background = element_blank())+theme(legend.text=element_text(size=6),legend.box.background = element_rect(colour = "black"))+ theme(legend.key=element_blank()) +guides(color=guide_legend(override.aes = list(shape=c(1,1))))
a

png(paste0(plotdir,"IMCC_point_cloud_D.3.png"),width=7, height=7, units="in", res=400)
par(ps=10)
par(mar=c(4,4,1,1))
par(cex=1)
a
dev.off()
