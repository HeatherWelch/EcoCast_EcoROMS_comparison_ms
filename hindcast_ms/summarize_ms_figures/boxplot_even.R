### ecoroms options for managers ### xxx
## no EcoROMS original or marxan raw ###

source("load_functions.R")

library(ggalt)
library(plotly)
library(ggplot2)
library(scales)
library(fmsb)
library(DescTools)

  weightings=read.csv("hindcast_ms/predict/weighting_scenarios.csv")
  datadir="hindcast_ms/extract/extractions/"

  file_list=list.files(datadir) %>% grep("run",.,value=T)
  master=list()
  for (file in file_list){
    a=read.csv(paste0(datadir,file))
    name=gsub(".csv","",file)
    a$run=name
    assign(name,a)
    master[[name]]<-a
  }

  fullon=do.call("rbind",master)
  master=fullon %>% as.data.frame()%>% mutate(blsh=(blshobs+blshtrk)/2) %>% select(-c(X,lon,lat,dt,blshobs,blshtrk)) %>% select(-c(EcoROMS_original,Marxan_raw)) %>% rename(EcoROMS=EcoROMS_original_unscaled) %>% rename(Marxan=Marxan_raw_unscaled) %>% rename(Swordfish=swor) %>% rename(Leatherback=lbst) %>% rename(Sealion=casl) %>% rename(Blueshark=blsh)
  detachPackage("bindrcpp")
  
  runs=as.factor(master$run) %>% unique() %>% as.character()
  empty=data.frame(Swordfish=NA,Leatherback=NA,Sealion=NA,Blueshark=NA,algorithm=NA,run=NA)
  for(i in 1:length(runs)){
    runn=runs[i]
    a=master %>% filter(run==runn) %>% select(-run) %>% cor() %>% .[1:2,3:6] %>% as.data.frame() %>% mutate(algorithm=c("EcoROMS","Marxan")) %>% mutate(run=runn)
    empty=rbind(empty,a)
  }
  
  
  df=empty %>% mutate(swor_inverse=1-Swordfish) %>%  mutate(lbst_inverse=Leatherback+1) %>%  mutate(casl_inverse=Sealion+1) %>%  mutate(blsh_inverse=Blueshark+1) 
  dff=df %>% mutate(swor_blsh_casl=blsh_inverse+casl_inverse+swor_inverse+lbst_inverse) %>% mutate(swor_blsh=lbst_inverse+blsh_inverse+swor_inverse) %>% mutate(swor2=lbst_inverse+swor_inverse)
  
  dff$id=paste0(dff$algorithm,"_",dff$run) %>% as.character()
  
  

############ ----> marxan
b=dff %>% gather (variable, value,-c(algorithm,id,run,swor_inverse,lbst_inverse,casl_inverse,blsh_inverse,swor_blsh_casl,swor_blsh,swor2)) %>% .[complete.cases(.),] %>% dplyr::rename(Algorithm=algorithm)
b$variable=factor(b$variable,levels=c("Leatherback","Swordfish","Blueshark","Sealion"))

b=b %>% filter(Algorithm=="Marxan")

b=b[order(b$swor_blsh_casl),]
a=b$id %>% unique() %>% .[1:10]
b=b %>% mutate(swor_blsh_casl_id=ifelse(id %in% a,1,0))

b=b[order(b$swor_blsh),]
a=b$id %>% unique() %>% .[1:10]
b=b %>% mutate(swor_blsh_id=ifelse(id %in% a,1,0))

b=b[order(b$swor2),]
a=b$id %>% unique() %>% .[1:10]
b=b %>% mutate(swor2_id=ifelse(id %in% a,1,0))

c=b %>% dplyr::select(-c(swor_inverse,swor_blsh_casl,swor_blsh,swor2))
c=c %>% gather(best,best_value,-c(Algorithm,run,variable,value,id))
c=c%>% filter(best_value==1)
c=c %>% spread(variable,value)
c=c %>% mutate(id2=paste(id,best,sep="_"))

c$sum=NA

c=c %>% mutate(sum=ifelse(best=="swor_blsh_casl_id",((1-Swordfish)+(Blueshark+1)+(Sealion+1)+(Leatherback+1)),sum))
c=c %>% mutate(sum=ifelse(best=="swor_blsh_id",((1-Swordfish)+(Blueshark+1)+(Leatherback+1)),sum))
c=c %>% mutate(sum=ifelse(best=="swor2_id",((1-Swordfish)+(Leatherback+1)),sum))

c=c %>% select(-c(id,best_value,id2))
c=c[with(c,order(best,sum)),]
c=c %>% mutate(Rank=rep(1:10,3)) %>% mutate(run=gsub("run_","",run))
c=left_join(c,weightings,by="run")
c=c %>% select(-weighting)

c=c %>% gather(species,value,-c(Algorithm,run,best,sum,Rank))
c$best=as.factor(c$best)
d=c %>% dplyr::group_by(best,species) %>% summarise(mean=mean(value))
marxan_best=c
marxan_means=d

############ ----> ecocast

b=dff %>% gather (variable, value,-c(algorithm,id,run,swor_inverse,lbst_inverse,casl_inverse,blsh_inverse,swor_blsh_casl,swor_blsh,swor2)) %>% .[complete.cases(.),] %>% dplyr::rename(Algorithm=algorithm)
b$variable=factor(b$variable,levels=c("Leatherback","Swordfish","Blueshark","Sealion"))
toMatch = c("EcoROMS_run_A.2","EcoROMS_run_A.3","EcoROMS_run_A.4","EcoROMS_run_A.5","EcoROMS_run_B.2","EcoROMS_run_B.3","EcoROMS_run_B.4","EcoROMS_run_B.5","EcoROMS_run_C.2","EcoROMS_run_C.3","EcoROMS_run_C.4","EcoROMS_run_C.5")

b=b[order(b$swor_blsh_casl),]
a=b$id %>% unique() %>% .[-c(grep(paste(toMatch,collapse="|"),.,value=F))] %>% .[1:10]
b=b %>% mutate(swor_blsh_casl_id=ifelse(id %in% a,1,0))

b=b[order(b$swor_blsh),]
a=b$id %>% unique() %>% .[-c(grep(paste(toMatch,collapse="|"),.,value=F))] %>% .[1:10]
b=b %>% mutate(swor_blsh_id=ifelse(id %in% a,1,0))

b=b[order(b$swor2),]
a=b$id %>% unique() %>% .[-c(grep(paste(toMatch,collapse="|"),.,value=F))] %>% .[1:10]
b=b %>% mutate(swor2_id=ifelse(id %in% a,1,0))

c=b %>% select(-c(swor_inverse,swor_blsh_casl,swor_blsh,swor2))
c=c %>% gather(best,best_value,-c(Algorithm,run,variable,value,id))
c=c%>% filter(best_value==1)
c=c %>% spread(variable,value)
c=c %>% mutate(id2=paste(id,best,sep="_"))

c$sum=NA

c=c %>% mutate(sum=ifelse(best=="swor_blsh_casl_id",((1-Swordfish)+(Blueshark+1)+(Sealion+1)+(Leatherback+1)),sum))
c=c %>% mutate(sum=ifelse(best=="swor_blsh_id",((1-Swordfish)+(Blueshark+1)+(Leatherback+1)),sum))
c=c %>% mutate(sum=ifelse(best=="swor2_id",((1-Swordfish)+(Leatherback+1)),sum))

c=c %>% select(-c(id,best_value,id2))
c=c[with(c,order(best,sum)),]
c=c %>% mutate(Rank=rep(1:10,3)) %>% mutate(run=gsub("run_","",run))
c=left_join(c,weightings,by="run")

c=c %>% select(-weighting)

c=c %>% gather(species,value,-c(Algorithm,run,best,sum,Rank))
c$best=as.factor(c$best)
d=c %>% dplyr::group_by(best,species) %>% summarise(mean=mean(value))
ecocast_best=c
ecocast_means=d

a=ggplot(data=ecocast_best,aes(x=best,y=value,color=species))+geom_boxplot()
a=a+scale_x_discrete(labels=c("Objective 1","Objective 2","Objective 3"))+ylab("Correlation coefficient [R]")+xlab("Management objective")+
  scale_color_manual("Species",values=c("Leatherback"="darkgoldenrod","Swordfish"="cornflowerblue","Blueshark"="coral1","Sealion"="aquamarine4"))+
  geom_point(data=ecocast_means,aes(x=best,y=mean,group=species),position = position_dodge(.75),color="black")+geom_text(data=ecocast_means,aes(x=best,y=mean,group=species,label=round(mean,2)),position = position_dodge(.75),color="black",vjust=-1.5,size=2)+
  ggtitle(paste0("A. EcoCast"))+
  geom_hline(yintercept=0)+ylim(-1,1)
a=a+ theme_bw()+theme(panel.border = element_blank(), panel.grid.major = element_blank(),
                      panel.grid.minor = element_blank(), axis.line = element_line(colour = "black"))
a=a+theme(text = element_text(size=7),axis.text = element_text(size=7),legend.key.size = unit(.5,'lines'),plot.title = element_text(hjust=0,size=7))
a=a+theme(legend.position=c(.15,.95),legend.justification = c(.9,.9),legend.background = element_blank(),legend.key=element_blank(),legend.box.background = element_rect(color="black"))
ecocast=a

a=ggplot(data=marxan_best,aes(x=best,y=value,color=species))+geom_boxplot()
a=a+scale_x_discrete(labels=c("Objective 1","Objective 2","Objective 3"))+ylab("Correlation coefficient [R]")+xlab("Management objective")+
  scale_color_manual("Species",values=c("Leatherback"="darkgoldenrod","Swordfish"="cornflowerblue","Blueshark"="coral1","Sealion"="aquamarine4"),guide="none")+
  geom_point(data=marxan_means,aes(x=best,y=mean,group=species),position = position_dodge(.75),color="black")+geom_text(data=marxan_means,aes(x=best,y=mean,group=species,label=round(mean,2)),position = position_dodge(.75),color="black",vjust=-1.5,size=2)+
  ggtitle(paste0("B. Marxan"))+
  geom_hline(yintercept=0)+ylim(-1,1)
a=a+ theme_bw()+theme(panel.border = element_blank(), panel.grid.major = element_blank(),
                      panel.grid.minor = element_blank(), axis.line = element_line(colour = "black"))
a=a+theme(text = element_text(size=7),axis.text = element_text(size=7),legend.key.size = unit(.5,'lines'),plot.title = element_text(hjust=0,size=7))
a=a+theme(legend.position=c(.15,.95),legend.justification = c(.9,.9),legend.background = element_blank(),legend.key=element_blank(),legend.box.background = element_rect(color="black"))
marxan=a


png("hindcast_ms/summarize_ms_figures/plots/boxplot.png",width=7, height=7, units="in", res=400)
par(ps=10)
par(cex=1)
par(mar=c(4,4,1,1))
plot_grid(ecocast, marxan,nrow=2)
dev.off()

ecocast_means$tool="EcoCast"
marxan_means$tool="Marxan"
means=rbind(ecocast_means,marxan_means)
h=means %>% mutate(inclusion="yes")
h <- within(h, inclusion[best == 'swor_blsh_id' & species == 'Sealion'] <- 'no')
h <- within(h, inclusion[best == 'swor2_id' & species == 'Sealion'] <- 'no')
h <- within(h, inclusion[best == 'swor2_id' & species == 'Blueshark'] <- 'no')
h=h %>% dplyr::filter(inclusion=="yes") %>% mutate(means2=abs(mean)) 
h[16,6]=-.171

means_calc=h %>% group_by(best,tool) %>% summarise(mean_best=mean(round(means2,2))) %>% mutate(means_round=round(mean_best,2))
newdata <- means_calc[order(means_calc$tool),] 
write.csv(newdata,"hindcast_ms/summarize_ms_figures/plots/boxplot_means.csv")
