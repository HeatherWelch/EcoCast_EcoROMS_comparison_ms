### ecoroms options for managers ###
## no EcoROMS original or marxan raw ###

source("load_functions.R")

library(ggalt)
library(plotly)
library(ggplot2)
library(scales)
library(DescTools)


thresholds_unique=function(csvdir,plotdir,lbstRisk){
  weightings=read.csv("hindcast_ms/predict/weighting_scenarios.csv")

file_list=list.files(csvdir) %>% grep("availcatch_algorithm_comparison_multispecies",.,value=T)
master=list()
for (file in file_list){
  a=read.csv(paste0(csvdir,file))
  name=gsub("_availcatch_algorithm_comparison_multispecies.csv","",file)
  a$run=name
  assign(name,a)
  master[[name]]<-a
}

fullon=do.call("rbind",master)
df=fullon %>% dplyr::filter(limit_target=="leatherback")
df$lbst=round(df$lbst, digits = -1)
df=df %>% mutate(blueshark=(blshobs+blshtrk)/2) %>% select(product,lbst,swor,blueshark,casl,run) %>% filter(lbst==lbstRisk)
df=df %>% mutate(swor_inverse=100-swor)
dff=df %>% mutate(swor_blsh_casl=blueshark+casl+swor_inverse) %>% mutate(swor_blsh=blueshark+swor_inverse+(casl*.1)) %>% mutate(swor2=swor_inverse+(casl*.1)+(blueshark*.1))

dff$id=paste0(dff$product,"_",dff$run) %>% as.character()

#### parallel coordinate plot ###
print("Making parallell coordinate plot")

b=dff %>% gather (variable, value,-c(product,id,run,swor_inverse,swor_blsh_casl,swor_blsh,swor2)) %>% .[complete.cases(.),] %>% dplyr::rename(Product=product)
b$variable=factor(b$variable,levels=c("lbst","swor","blueshark","casl"))
b=b %>% filter(Product!="EcoROMS_original") %>% filter(Product!="Marxan_raw")

toMatch = c("EcoROMS_original_unscaled_A.2","EcoROMS_original_unscaled_A.3","EcoROMS_original_unscaled_A.4","EcoROMS_original_unscaled_A.5","EcoROMS_original_unscaled_B.2","EcoROMS_original_unscaled_B.3","EcoROMS_original_unscaled_B.4","EcoROMS_original_unscaled_B.5","EcoROMS_original_unscaled_C.2","EcoROMS_original_unscaled_C.3","EcoROMS_original_unscaled_C.4","EcoROMS_original_unscaled_C.5")

b=b[order(b$swor_blsh_casl),]
a=b$id %>% unique() %>% .[-c(grep(paste(toMatch,collapse="|"),.,value=F))] %>% .[1:10]
b=b %>% mutate(swor_blsh_casl=ifelse(id %in% a,1,0))

b=b[order(b$swor_blsh),]
a=b$id %>% unique() %>% .[-c(grep(paste(toMatch,collapse="|"),.,value=F))] %>% .[1:10]
b=b %>% mutate(swor_blsh=ifelse(id %in% a,1,0))

b=b[order(b$swor2),]
a=b$id %>% unique() %>% .[-c(grep(paste(toMatch,collapse="|"),.,value=F))] %>% .[1:10]
b=b %>% mutate(swor2=ifelse(id %in% a,1,0))

b$Product=gsub("_"," ",b$Product)


## master
aa=ggplot(b, aes(x = variable, y = value, group = id)) +   # group = id is important!
  geom_path(aes(color = Product),
            alpha = 0.5,
            lineend = 'round', linejoin = 'round') +
  scale_y_continuous(name="% of species available to catch",breaks = seq(0, 100, by = 10), expand = c(0, 0)) +scale_x_discrete(name="Species",labels=c("lbst"="Leatherback","swor"="Swordfish","blueshark"="Blueshark","casl"="California Sea Lion"), expand = c(0, 0))+
  scale_size(breaks = NULL, range = c(0, 100))+ggtitle(paste0("Comparison of species catch availability between runs for ",lbstRisk,"% or less allowable leatherback bycatch risk"))+
  scale_color_manual("Product",values=c("EcoROMS original unscaled"="cornflowerblue","Marxan raw unscaled"="aquamarine4"))+
  theme(text = element_text(size=5),axis.text = element_text(size=5),legend.position=c(.2,1),legend.justification = c(.9,.9),legend.key.size = unit(.5,'lines'),plot.title = element_text(hjust=0,size=5),plot.margin = margin(.3, 1, .3, .3, "cm"))
  

aa

c=b %>% filter(swor_blsh_casl==1)
bb=ggplot(b, aes(x = variable, y = value, group = id)) +   # group = id is important!
  geom_path(alpha = 0.5,
            lineend = 'round', linejoin = 'round', color="gray87") +
  scale_y_continuous(name="% of species available to catch",breaks = seq(0, 100, by = 10), expand = c(0, 0)) +scale_x_discrete(name="Species",labels=c("lbst"="Leatherback","swor"="Swordfish","blueshark"="Blueshark","casl"="California Sea Lion"), expand = c(0, 0))+
  scale_size(breaks = NULL, range = c(0, 100))+ggtitle("Top 10 runs if management objective is to equally maximize swordfish catch and avoidance of blueshark and sea lion")+
  theme(text = element_text(size=5),axis.text = element_text(size=5),plot.title = element_text(hjust=0,size=5),plot.margin = margin(.3, 1, .3, .3, "cm"))+
  geom_vline(xintercept=c(2,3,4))

bb=bb+
  geom_path(data=c,aes(x = variable, y = value, group = id,color = Product))+
  scale_color_manual("Product",values=c("EcoROMS original unscaled"="cornflowerblue","Marxan raw unscaled"="aquamarine4"))+
  guides(color=F)
  
bb

c=b %>% filter(swor_blsh==1)
cc=ggplot(b, aes(x = variable, y = value, group = id)) +   # group = id is important!
  geom_path(alpha = 0.5,
            lineend = 'round', linejoin = 'round', color="gray87") +
  scale_y_continuous(name="% of species available to catch",breaks = seq(0, 100, by = 10), expand = c(0, 0)) +scale_x_discrete(name="Species",labels=c("lbst"="Leatherback","swor"="Swordfish","blueshark"="Blueshark","casl"="California Sea Lion"), expand = c(0, 0))+
  scale_size(breaks = NULL, range = c(0, 100))+ggtitle("Top 10 runs if management objective is to equally maximize swordfish catch and blueshark avoidance, with less emphasis on sea lion avoidance")+
  theme(text = element_text(size=5),axis.text = element_text(size=5),plot.title = element_text(hjust=0,size=5),plot.margin = margin(.3, 1, .3, .3, "cm"))+
  geom_vline(xintercept=c(2,3))

cc=cc+
  geom_path(data=c,aes(x = variable, y = value, group = id,color = Product))+
  scale_color_manual("Product",values=c("EcoROMS original unscaled"="cornflowerblue","Marxan raw"="coral1","Marxan raw unscaled"="aquamarine4"))+
  guides(color=F)

cc

c=b %>% filter(swor2==1)
dd=ggplot(b, aes(x = variable, y = value, group = id)) +   # group = id is important!
  geom_path(alpha = 0.5,
            lineend = 'round', linejoin = 'round', color="gray87") +
  scale_y_continuous(name="% of species available to catch",breaks = seq(0, 100, by = 10), expand = c(0, 0)) +scale_x_discrete(name="Species",labels=c("lbst"="Leatherback","swor"="Swordfish","blueshark"="Blueshark","casl"="California Sea Lion"), expand = c(0, 0))+
  scale_size(breaks = NULL, range = c(0, 100))+ggtitle("Top 10 runs if management objective is to equally maximize swordfish catch, with less emphasis on blueshark and sea lion avoidance")+
  theme(text = element_text(size=5),axis.text = element_text(size=5),plot.title = element_text(hjust=0,size=5),plot.margin = margin(.3, 1, .3, .3, "cm"))+
  geom_vline(xintercept=c(2))

dd=dd+
  geom_path(data=c,aes(x = variable, y = value, group = id,color = Product))+
  scale_color_manual("Product",values=c("EcoROMS original unscaled"="cornflowerblue","Marxan raw unscaled"="aquamarine4"))+
  guides(color=F)

dd

png(paste0(plotdir,"parellel_coordinate_plot_thresholds_",lbstRisk,"_lbst_unique.png"),width=14, height=7, units="in", res=400)
par(ps=10)
par(cex=1)
par(mar=c(4,4,1,1))
print({plot_grid(aa,bb,cc,dd,nrow=2,ncol=2)})
dev.off()

#### table accompanying parallel coordinate plot ####
print("Making table accompanying parallel coordinate plot")

b=dff %>% gather (variable, value,-c(product,id,run,swor_inverse,swor_blsh_casl,swor_blsh,swor2)) %>% .[complete.cases(.),] %>% dplyr::rename(Product=product)
b$variable=factor(b$variable,levels=c("lbst","swor","blueshark","casl"))
b=b %>% filter(Product!="EcoROMS_original") %>% filter(Product!="Marxan_raw")

b=b[order(b$swor_blsh_casl),]
a=b$id %>% unique() %>% .[-c(grep(paste(toMatch,collapse="|"),.,value=F))] %>% .[1:10]
b=b %>% mutate(swor_blsh_casl_id=ifelse(id %in% a,1,0))

b=b[order(b$swor_blsh),]
a=b$id %>% unique() %>% .[-c(grep(paste(toMatch,collapse="|"),.,value=F))] %>% .[1:10]
b=b %>% mutate(swor_blsh_id=ifelse(id %in% a,1,0))

b=b[order(b$swor2),]
a=b$id %>% unique() %>% .[-c(grep(paste(toMatch,collapse="|"),.,value=F))] %>% .[1:10]
b=b %>% mutate(swor2_id=ifelse(id %in% a,1,0))

b$Product=gsub("_"," ",b$Product)
c=b %>% select(-c(swor_inverse,swor_blsh_casl,swor_blsh,swor2))
c=c %>% gather(best,best_value,-c(Product,run,variable,value,id))
c=c%>% filter(best_value==1)
c=c %>% spread(variable,value)
c=c %>% mutate(id2=paste(id,best,sep="_"))

c$sum=NA

c=c %>% mutate(sum=ifelse(best=="swor_blsh_casl_id",((100-swor)+blueshark+casl+lbst),sum))
c=c %>% mutate(sum=ifelse(best=="swor_blsh_id",((100-swor)+blueshark+lbst+(casl*.1)),sum))
c=c %>% mutate(sum=ifelse(best=="swor2_id",((100-swor)+lbst+(casl*.1)+(blueshark*.1)),sum))

c=c %>% select(-c(id,best_value,id2))
c=c[with(c,order(best,sum)),]
c=c %>% mutate(Rank=rep(1:10,3)) %>% rename(Algorithm=Product) %>% rename(Leatherback=lbst) %>% rename(Swordfish=swor) %>% rename(Blueshark=blueshark) %>% rename(Sealion=casl) 
c=left_join(c,weightings,by="run")

write.csv(c,paste0(plotdir,"parellel_coordinate_table_thresholds_",lbstRisk,"_lbst_unique.csv"))

##### boxplot ####
print("Making boxplot")
c=c %>% select(-weighting)

#c=c %>% gather(species,value,-c(Product,run,id,best,best_value,id2,sum))
c=c %>% gather(species,value,-c(Algorithm,run,best,sum,Rank))
c$best=as.factor(c$best)
d=c %>% dplyr::group_by(best,species) %>% summarise(mean=mean(value))

a=ggplot(data=c,aes(x=best,y=value,color=species))+geom_boxplot()
a=a+scale_x_discrete(labels=c("Objective 1","Objective 2","Objective 3"))+ylab("% of species available to catch")+xlab("Management objective")+
  scale_color_manual("Species",values=c("Leatherback"="darkgoldenrod","Swordfish"="cornflowerblue","Blueshark"="coral1","Sealion"="aquamarine4"))+
  geom_point(data=d,aes(x=best,y=mean,group=species),position = position_dodge(.75),color="black")+geom_text(data=d,aes(x=best,y=mean,group=species,label=round(mean,1)),position = position_dodge(.75),color="black",vjust=-1.5,hjust=1,size=2)+
  ggtitle(paste0("Comparison of species catch availability between runs for ",lbstRisk,"% or less allowable leatherback bycatch risk"))+
  theme(text = element_text(size=5),axis.text = element_text(size=5),legend.key.size = unit(.5,'lines'),plot.title = element_text(hjust=0,size=5),axis.text.x = element_text(angle=45,hjust=1))
a

png(paste0(plotdir,"parellel_coordinate_boxplot_thresholds_",lbstRisk,"_lbst_unique.png"),width=7, height=3.5, units="in", res=400)
par(ps=10)
par(cex=1)
par(mar=c(4,4,1,1))
print({a})
dev.off()

}

# ## demo
# plotdir="hindcast_ms/summarize_ms/plots/"
# csvdir="hindcast_ms/summarize/csvs/"
# lbstRisk=30 ## numeric value for allowable lbst bycatch risk
# thresholds_unique(lbstRisk=lbstRisk,plotdir = plotdir,csvdir = csvdir)
