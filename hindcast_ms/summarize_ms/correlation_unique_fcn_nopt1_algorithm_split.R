### ecoroms options for managers ### xxx
## no EcoROMS original or marxan raw ###

source("load_functions.R")

library(ggalt)
library(plotly)
library(ggplot2)
library(scales)
library(fmsb)
library(DescTools)


correlations_unique_nopt1_algorithm_split=function(datadir,plotdir){
  weightings=read.csv("hindcast_ms/predict/weighting_scenarios.csv")

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
  b=dff %>% gather (variable, value,-c(algorithm,id,run,swor_inverse,lbst_inverse,casl_inverse,blsh_inverse,swor_blsh_casl,swor_blsh,swor2)) %>% .[complete.cases(.),] %>% dplyr::rename(Algorithm=algorithm)
  b$variable=factor(b$variable,levels=c("Leatherback","Swordfish","Blueshark","Sealion"))
  
  toMatch = c("EcoROMS_run_A.2","EcoROMS_run_A.3","EcoROMS_run_A.4","EcoROMS_run_A.5","EcoROMS_run_B.2","EcoROMS_run_B.3","EcoROMS_run_B.4","EcoROMS_run_B.5","EcoROMS_run_C.2","EcoROMS_run_C.3","EcoROMS_run_C.4","EcoROMS_run_C.5")
  
  ############ ----> marxan
  b=b %>% filter(Algorithm=="Marxan")
  
  b=b[order(b$swor_blsh_casl),]
  a=b$id %>% unique() %>% .[1:10]
  b=b %>% mutate(swor_blsh_casl=ifelse(id %in% a,1,0))
  
  b=b[order(b$swor_blsh),]
  a=b$id %>% unique() %>% .[1:10]
  b=b %>% mutate(swor_blsh=ifelse(id %in% a,1,0))
  
  b=b[order(b$swor2),]
  a=b$id %>% unique() %>% .[1:10]
  b=b %>% mutate(swor2=ifelse(id %in% a,1,0))
  
  b$Algorithm=gsub("_"," ",b$Algorithm)
  b=with(b, b[order(variable),])
  
  ## master
  aa=ggplot(b, aes(x = variable, y = value, group = id)) +   # group = id is important!
    geom_path(aes(color = Algorithm),
              alpha = 0.5,
              lineend = 'round', linejoin = 'round') +
    scale_y_continuous(name="Correlation [r]",breaks = seq(-1, 1, by = .1), expand = c(.01, .01)) +scale_x_discrete(name="Species",labels=c("Leatherback"="Leatherback","Swordfish"="Swordfish","Blueshark"="Blueshark","Sealion"="California Sea Lion"), expand = c(.01, .01))+
    scale_size(breaks = NULL, range = c(0, 100))+ggtitle("Comparison of species-algorithm correlations across runs")+
    scale_color_manual("Algorithm",values=c("EcoROMS"="cornflowerblue","Marxan"="aquamarine4"))+
    theme(text = element_text(size=5),axis.text = element_text(size=5),legend.position=c(.2,1),legend.justification = c(.9,.9),legend.key.size = unit(.5,'lines'),plot.title = element_text(hjust=0,size=5),plot.margin = margin(.3, 1, .3, .3, "cm"))+
    geom_hline(yintercept = 0)+geom_point(aes(x=1,y=-1),size=2)+geom_point(aes(x=2,y=1),size=2)+geom_point(aes(x=3,y=-1),size=2)+geom_point(aes(x=4,y=-1),size=2)
  
  
  aa
  
  c=b %>% filter(swor_blsh_casl==1)
  bb=ggplot(b, aes(x = variable, y = value, group = id)) +   # group = id is important!
    geom_path(alpha = 0.5,
              lineend = 'round', linejoin = 'round', color="gray87") +
    scale_y_continuous(name="Correlation [r]",breaks = seq(-1, 1, by = .1), expand = c(.01, .01)) +scale_x_discrete(name="Species",labels=c("Leatherback"="Leatherback","Swordfish"="Swordfish","Blueshark"="Blueshark","Sealion"="California Sea Lion"), expand = c(.01, .01))+
    scale_size(breaks = NULL, range = c(0, 100))+ggtitle("Top 10 runs if management objective is to equally maximize swordfish catch and avoidance of leatherback, blueshark and sea lion")+
    theme(text = element_text(size=5),axis.text = element_text(size=5),plot.title = element_text(hjust=0,size=5),plot.margin = margin(.3, 1, .3, .3, "cm"))+
    geom_vline(xintercept=c(2,3,4))
  
  bb=bb+
    geom_path(data=c,aes(x = variable, y = value, group = id,color = Algorithm))+
    scale_color_manual("Product",values=c("EcoROMS"="cornflowerblue","Marxan"="aquamarine4"))+
    guides(color=F)+
    geom_hline(yintercept = 0)+geom_point(aes(x=1,y=-1),size=2)+geom_point(aes(x=2,y=1),size=2)+geom_point(aes(x=3,y=-1),size=2)+geom_point(aes(x=4,y=-1),size=2)
  
  bb
  
  c=b %>% filter(swor_blsh==1)
  cc=ggplot(b, aes(x = variable, y = value, group = id)) +   # group = id is important!
    geom_path(alpha = 0.5,
              lineend = 'round', linejoin = 'round', color="gray87") +
    scale_y_continuous(name="Correlation [r]",breaks = seq(-1, 1, by = .1), expand = c(.01, .01)) +scale_x_discrete(name="Species",labels=c("Leatherback"="Leatherback","Swordfish"="Swordfish","Blueshark"="Blueshark","Sealion"="California Sea Lion"), expand = c(.01, .01))+
    scale_size(breaks = NULL, range = c(0, 100))+ggtitle("Top 10 runs if management objective is to equally maximize swordfish catch and leatherback and blueshark avoidance, with less emphasis on sea lion avoidance")+
    theme(text = element_text(size=5),axis.text = element_text(size=5),plot.title = element_text(hjust=0,size=5),plot.margin = margin(.3, 1, .3, .3, "cm"))+
    geom_vline(xintercept=c(2,3))
  
  cc=cc+
    geom_path(data=c,aes(x = variable, y = value, group = id,color = Algorithm))+
    scale_color_manual("Product",values=c("EcoROMS"="cornflowerblue","Marxan"="aquamarine4"))+
    guides(color=F)+
    geom_hline(yintercept = 0)+geom_point(aes(x=1,y=-1),size=2)+geom_point(aes(x=2,y=1),size=2)+geom_point(aes(x=3,y=-1),size=2)
  
  cc
  
  c=b %>% filter(swor2==1)
  dd=ggplot(b, aes(x = variable, y = value, group = id)) +   # group = id is important!
    geom_path(alpha = 0.5,
              lineend = 'round', linejoin = 'round', color="gray87") +
    scale_y_continuous(name="Correlation [r]",breaks = seq(-1, 1, by = .1), expand = c(.01, .01)) +scale_x_discrete(name="Species",labels=c("Leatherback"="Leatherback","Swordfish"="Swordfish","Blueshark"="Blueshark","Sealion"="California Sea Lion"), expand = c(.01, .01))+
    scale_size(breaks = NULL, range = c(0, 100))+ggtitle("Top 10 runs if management objective is to equally maximize swordfish catch and leatherback avoidance, with less emphasis on blueshark and sea lion avoidance")+
    theme(text = element_text(size=5),axis.text = element_text(size=5),plot.title = element_text(hjust=0,size=5),plot.margin = margin(.3, 1, .3, .3, "cm"))+
    geom_vline(xintercept=c(2))
  
  dd=dd+
    geom_path(data=c,aes(x = variable, y = value, group = id,color = Algorithm))+
    scale_color_manual("Product",values=c("EcoROMS"="cornflowerblue","Marxan"="aquamarine4"))+
    guides(color=F)+
    geom_hline(yintercept = 0)+geom_point(aes(x=1,y=-1),size=2)+geom_point(aes(x=2,y=1),size=2)
  
  dd

png(paste0(plotdir,"parellel_coordinate_plot_correlations_unique_nopt1_algorithm_split_M.png"),width=14, height=7, units="in", res=400)
par(ps=10)
par(cex=1)
par(mar=c(4,4,1,1))
print({plot_grid(aa,bb,cc,dd,nrow=2,ncol=2)})
dev.off()

#### table accompanying parallel coordinate plot ####
print("Making table accompanying parallel coordinate plot")

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

write.csv(c,paste0(plotdir,"parellel_coordinate_table_correlations_unique_nopt1_algorithm_split_M.csv"))

##### boxplot ####
print("Making boxplot")
c=c %>% select(-weighting)

c=c %>% gather(species,value,-c(Algorithm,run,best,sum,Rank))
c$best=as.factor(c$best)
d=c %>% dplyr::group_by(best,species) %>% summarise(mean=mean(value))

a=ggplot(data=c,aes(x=best,y=value,color=species))+geom_boxplot()
a=a+scale_x_discrete(labels=c("Objective 1","Objective 2","Objective 3"))+ylab("Correlation coefficient [R]")+xlab("Management objective")+
  scale_color_manual("Species",values=c("Leatherback"="darkgoldenrod","Swordfish"="cornflowerblue","Blueshark"="coral1","Sealion"="aquamarine4"))+
  geom_point(data=d,aes(x=best,y=mean,group=species),position = position_dodge(.75),color="black")+geom_text(data=d,aes(x=best,y=mean,group=species,label=round(mean,1)),position = position_dodge(.75),color="black",vjust=-1.5,hjust=1,size=2)+
  ggtitle(paste0("Comparison algorithm correlation with species habitat suitability for different runs"))+
  geom_hline(yintercept=0)+
  theme(text = element_text(size=5),axis.text = element_text(size=5),legend.key.size = unit(.5,'lines'),plot.title = element_text(hjust=0,size=5),axis.text.x = element_text(angle=45,hjust=1))
a


png(paste0(plotdir,"parellel_coordinate_plot_correlations_box_plot_unique_nopt1_algorithm_split_M.png"),width=7, height=3.5, units="in", res=400)
par(ps=10)
par(cex=1)
par(mar=c(4,4,1,1))
print({plot_grid(a)})
dev.off()

############ ----> ecocast
b=dff %>% gather (variable, value,-c(algorithm,id,run,swor_inverse,lbst_inverse,casl_inverse,blsh_inverse,swor_blsh_casl,swor_blsh,swor2)) %>% .[complete.cases(.),] %>% dplyr::rename(Algorithm=algorithm)
b$variable=factor(b$variable,levels=c("Leatherback","Swordfish","Blueshark","Sealion"))
b=b %>% filter(Algorithm=="EcoROMS")

b=b[order(b$swor_blsh_casl),]
a=b$id %>% unique() %>% .[-c(grep(paste(toMatch,collapse="|"),.,value=F))] %>% .[1:10]
b=b %>% mutate(swor_blsh_casl=ifelse(id %in% a,1,0))

b=b[order(b$swor_blsh),]
a=b$id %>% unique() %>% .[-c(grep(paste(toMatch,collapse="|"),.,value=F))] %>% .[1:10]
b=b %>% mutate(swor_blsh=ifelse(id %in% a,1,0))

b=b[order(b$swor2),]
a=b$id %>% unique() %>% .[-c(grep(paste(toMatch,collapse="|"),.,value=F))] %>% .[1:10]
b=b %>% mutate(swor2=ifelse(id %in% a,1,0))

b$Algorithm=gsub("_"," ",b$Algorithm)
b=with(b, b[order(variable),])

## master
aa=ggplot(b, aes(x = variable, y = value, group = id)) +   # group = id is important!
  geom_path(aes(color = Algorithm),
            alpha = 0.5,
            lineend = 'round', linejoin = 'round') +
  scale_y_continuous(name="Correlation [r]",breaks = seq(-1, 1, by = .1), expand = c(.01, .01)) +scale_x_discrete(name="Species",labels=c("Leatherback"="Leatherback","Swordfish"="Swordfish","Blueshark"="Blueshark","Sealion"="California Sea Lion"), expand = c(.01, .01))+
  scale_size(breaks = NULL, range = c(0, 100))+ggtitle("Comparison of species-algorithm correlations across runs")+
  scale_color_manual("Algorithm",values=c("EcoROMS"="cornflowerblue","Marxan"="aquamarine4"))+
  theme(text = element_text(size=5),axis.text = element_text(size=5),legend.position=c(.2,1),legend.justification = c(.9,.9),legend.key.size = unit(.5,'lines'),plot.title = element_text(hjust=0,size=5),plot.margin = margin(.3, 1, .3, .3, "cm"))+
  geom_hline(yintercept = 0)+geom_point(aes(x=1,y=-1),size=2)+geom_point(aes(x=2,y=1),size=2)+geom_point(aes(x=3,y=-1),size=2)+geom_point(aes(x=4,y=-1),size=2)


aa

c=b %>% filter(swor_blsh_casl==1)
bb=ggplot(b, aes(x = variable, y = value, group = id)) +   # group = id is important!
  geom_path(alpha = 0.5,
            lineend = 'round', linejoin = 'round', color="gray87") +
  scale_y_continuous(name="Correlation [r]",breaks = seq(-1, 1, by = .1), expand = c(.01, .01)) +scale_x_discrete(name="Species",labels=c("Leatherback"="Leatherback","Swordfish"="Swordfish","Blueshark"="Blueshark","Sealion"="California Sea Lion"), expand = c(.01, .01))+
  scale_size(breaks = NULL, range = c(0, 100))+ggtitle("Top 10 runs if management objective is to equally maximize swordfish catch and avoidance of leatherback, blueshark and sea lion")+
  theme(text = element_text(size=5),axis.text = element_text(size=5),plot.title = element_text(hjust=0,size=5),plot.margin = margin(.3, 1, .3, .3, "cm"))+
  geom_vline(xintercept=c(2,3,4))

bb=bb+
  geom_path(data=c,aes(x = variable, y = value, group = id,color = Algorithm))+
  scale_color_manual("Product",values=c("EcoROMS"="cornflowerblue","Marxan"="aquamarine4"))+
  guides(color=F)+
  geom_hline(yintercept = 0)+geom_point(aes(x=1,y=-1),size=2)+geom_point(aes(x=2,y=1),size=2)+geom_point(aes(x=3,y=-1),size=2)+geom_point(aes(x=4,y=-1),size=2)

bb

c=b %>% filter(swor_blsh==1)
cc=ggplot(b, aes(x = variable, y = value, group = id)) +   # group = id is important!
  geom_path(alpha = 0.5,
            lineend = 'round', linejoin = 'round', color="gray87") +
  scale_y_continuous(name="Correlation [r]",breaks = seq(-1, 1, by = .1), expand = c(.01, .01)) +scale_x_discrete(name="Species",labels=c("Leatherback"="Leatherback","Swordfish"="Swordfish","Blueshark"="Blueshark","Sealion"="California Sea Lion"), expand = c(.01, .01))+
  scale_size(breaks = NULL, range = c(0, 100))+ggtitle("Top 10 runs if management objective is to equally maximize swordfish catch and leatherback and blueshark avoidance, with less emphasis on sea lion avoidance")+
  theme(text = element_text(size=5),axis.text = element_text(size=5),plot.title = element_text(hjust=0,size=5),plot.margin = margin(.3, 1, .3, .3, "cm"))+
  geom_vline(xintercept=c(2,3))

cc=cc+
  geom_path(data=c,aes(x = variable, y = value, group = id,color = Algorithm))+
  scale_color_manual("Product",values=c("EcoROMS"="cornflowerblue","Marxan"="aquamarine4"))+
  guides(color=F)+
  geom_hline(yintercept = 0)+geom_point(aes(x=1,y=-1),size=2)+geom_point(aes(x=2,y=1),size=2)+geom_point(aes(x=3,y=-1),size=2)

cc

c=b %>% filter(swor2==1)
dd=ggplot(b, aes(x = variable, y = value, group = id)) +   # group = id is important!
  geom_path(alpha = 0.5,
            lineend = 'round', linejoin = 'round', color="gray87") +
  scale_y_continuous(name="Correlation [r]",breaks = seq(-1, 1, by = .1), expand = c(.01, .01)) +scale_x_discrete(name="Species",labels=c("Leatherback"="Leatherback","Swordfish"="Swordfish","Blueshark"="Blueshark","Sealion"="California Sea Lion"), expand = c(.01, .01))+
  scale_size(breaks = NULL, range = c(0, 100))+ggtitle("Top 10 runs if management objective is to equally maximize swordfish catch and leatherback avoidance, with less emphasis on blueshark and sea lion avoidance")+
  theme(text = element_text(size=5),axis.text = element_text(size=5),plot.title = element_text(hjust=0,size=5),plot.margin = margin(.3, 1, .3, .3, "cm"))+
  geom_vline(xintercept=c(2))

dd=dd+
  geom_path(data=c,aes(x = variable, y = value, group = id,color = Algorithm))+
  scale_color_manual("Product",values=c("EcoROMS"="cornflowerblue","Marxan"="aquamarine4"))+
  guides(color=F)+
  geom_hline(yintercept = 0)+geom_point(aes(x=1,y=-1),size=2)+geom_point(aes(x=2,y=1),size=2)

dd

png(paste0(plotdir,"parellel_coordinate_plot_correlations_unique_nopt1_algorithm_split_E.png"),width=14, height=7, units="in", res=400)
par(ps=10)
par(cex=1)
par(mar=c(4,4,1,1))
print({plot_grid(aa,bb,cc,dd,nrow=2,ncol=2)})
dev.off()

#### table accompanying parallel coordinate plot ####
print("Making table accompanying parallel coordinate plot")

b=dff %>% gather (variable, value,-c(algorithm,id,run,swor_inverse,lbst_inverse,casl_inverse,blsh_inverse,swor_blsh_casl,swor_blsh,swor2)) %>% .[complete.cases(.),] %>% dplyr::rename(Algorithm=algorithm)
b$variable=factor(b$variable,levels=c("Leatherback","Swordfish","Blueshark","Sealion"))

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

write.csv(c,paste0(plotdir,"parellel_coordinate_table_correlations_unique_nopt1_algorithm_split_E.csv"))

##### boxplot ####
print("Making boxplot")
c=c %>% select(-weighting)

c=c %>% gather(species,value,-c(Algorithm,run,best,sum,Rank))
c$best=as.factor(c$best)
d=c %>% dplyr::group_by(best,species) %>% summarise(mean=mean(value))

a=ggplot(data=c,aes(x=best,y=value,color=species))+geom_boxplot()
a=a+scale_x_discrete(labels=c("Objective 1","Objective 2","Objective 3"))+ylab("Correlation coefficient [R]")+xlab("Management objective")+
  scale_color_manual("Species",values=c("Leatherback"="darkgoldenrod","Swordfish"="cornflowerblue","Blueshark"="coral1","Sealion"="aquamarine4"))+
  geom_point(data=d,aes(x=best,y=mean,group=species),position = position_dodge(.75),color="black")+geom_text(data=d,aes(x=best,y=mean,group=species,label=round(mean,1)),position = position_dodge(.75),color="black",vjust=-1.5,hjust=1,size=2)+
  ggtitle(paste0("Comparison algorithm correlation with species habitat suitability for different runs"))+
  geom_hline(yintercept=0)+
  theme(text = element_text(size=5),axis.text = element_text(size=5),legend.key.size = unit(.5,'lines'),plot.title = element_text(hjust=0,size=5),axis.text.x = element_text(angle=45,hjust=1))
a


png(paste0(plotdir,"parellel_coordinate_plot_correlations_box_plot_unique_nopt1_algorithm_split_E.png"),width=7, height=3.5, units="in", res=400)
par(ps=10)
par(cex=1)
par(mar=c(4,4,1,1))
print({plot_grid(a)})
dev.off()

}

# ## demo
# plotdir="hindcast_ms/summarize_ms/plots/"
# datadir="hindcast_ms/extract/extractions/"
# correlations_unique(plotdir = plotdir,datadir = datadir)
