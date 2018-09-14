### ecoroms options for managers ###

source("load_functions.R")

plotdir="hindcast_ms/summarize/plots/"
csvdir="hindcast_ms/summarize/csvs/"
datadir="hindcast_ms/extract/extractions/"

library(ggalt)
library(plotly)
library(ggplot2)
library(scales)
library(DescTools)
csvdir="hindcast_ms/summarize/csvs/"
plotdir="hindcast_ms/summarize/plots/"

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
df=df %>% mutate(blueshark=(blshobs+blshtrk)/2) %>% select(product,lbst,swor,blueshark,casl,run) %>% filter(lbst==10)
df=df %>% filter(lbst==10) %>% mutate(swor_inverse=100-swor)
#dff=df %>% mutate(multi=rowSums(.[,c(blueshark,casl,swor_inverse)]))
dff=df %>% mutate(swor_blsh_casl=blueshark+casl+swor_inverse) %>% mutate(swor_blsh=blueshark+swor_inverse) %>% mutate(swor2=swor)
#dff[order(dff$multi),]

dff$id=paste0(dff$product,"_",dff$run) %>% as.character()
b=dff %>% gather (variable, value,-c(product,id,run,swor_inverse,swor_blsh_casl,swor_blsh,swor2)) %>% .[complete.cases(.),] %>% dplyr::rename(Product=product)
b$variable=factor(b$variable,levels=c("lbst","swor","blueshark","casl"))

b=b[order(b$swor_blsh_casl),]
a=b$id %>% unique() %>% .[1:10] 
b=b %>% mutate(swor_blsh_casl=ifelse(id %in% a,1,0))

b=b[order(b$swor_blsh),]
a=b$id %>% unique() %>% .[1:10] 
b=b %>% mutate(swor_blsh=ifelse(id %in% a,1,0))

b=b[order(-b$swor2),]
a=b$id %>% unique() %>% .[1:10] 
b=b %>% mutate(swor2=ifelse(id %in% a,1,0))

b$Product=gsub("_"," ",b$Product)

## master
aa=ggplot(b, aes(x = variable, y = value, group = id)) +   # group = id is important!
  geom_path(aes(color = Product,linetype=Product),
            alpha = 0.5,
            lineend = 'round', linejoin = 'round') +
  scale_y_continuous(name="% of species available to catch",breaks = seq(0, 100, by = 10), expand = c(0, 0)) +scale_x_discrete(name="Species",labels=c("lbst"="Leatherback","swor"="Swordfish","blueshark"="Blueshark","casl"="California Sea Lion"), expand = c(0, 0))+
  scale_size(breaks = NULL, range = c(0, 100))+ggtitle("Comparison of species catch availability between runs for 0% allowable leatherback bycatch")+
  scale_color_manual("Product",values=c("EcoROMS original"="darkgoldenrod","EcoROMS original unscaled"="cornflowerblue","Marxan raw"="coral1","Marxan raw unscaled"="aquamarine4"))+
  theme(text = element_text(size=5),axis.text = element_text(size=5),legend.position=c(.2,1),legend.justification = c(.9,.9),legend.key.size = unit(.5,'lines'),plot.title = element_text(hjust=0,size=8),plot.margin = margin(.3, 1, .3, .3, "cm"))+
  scale_linetype_manual("Product",values=c("EcoROMS original"="solid","EcoROMS original unscaled"="dotted","Marxan raw"="dotdash","Marxan raw unscaled"="dashed"))

aa

c=b %>% filter(swor_blsh_casl==1)
bb=ggplot(b, aes(x = variable, y = value, group = id)) +   # group = id is important!
  geom_path(aes(color = as.factor(swor_blsh_casl),linetype=Product,size=as.factor(b$swor_blsh_casl)),
            alpha = 0.5,
            lineend = 'round', linejoin = 'round') +
  scale_y_continuous(name="% of species available to catch",breaks = seq(0, 100, by = 10), expand = c(0, 0)) +scale_x_discrete(name="Species",labels=c("lbst"="Leatherback","swor"="Swordfish","blueshark"="Blueshark","casl"="California Sea Lion"), expand = c(0, 0))+
  scale_size(breaks = NULL, range = c(0, 100))+ggtitle("Top 10 runs if objective is to maximize swordfish catch and blueshark/sealion avoidance")+
  scale_color_manual("Product",values=c("1"="black","0"="gray87"))+guides(size="legend",color="none")+
  theme(text = element_text(size=5),axis.text = element_text(size=5),legend.position=c(.2,1),legend.justification = c(.9,.9),legend.key.size = unit(.5,'lines'),plot.title = element_text(hjust=0,size=8),plot.margin = margin(.3, 1, .3, .3, "cm"))+
  geom_vline(xintercept=c(2,3,4))+scale_size_manual("a",values=c("1"=1,"0"=.5))+guides(size=F)+
  scale_linetype_manual("Product",values=c("EcoROMS original"="solid","EcoROMS original unscaled"="dotted","Marxan raw"="dotdash","Marxan raw unscaled"="dashed"))

bb

cc=ggplot(b, aes(x = variable, y = value, group = id)) +   # group = id is important!
  geom_path(aes(color = as.factor(swor_blsh),linetype=Product,size=as.factor(b$swor_blsh)),
            alpha = 0.5,
            lineend = 'round', linejoin = 'round') +
  scale_y_continuous(name="% of species available to catch",breaks = seq(0, 100, by = 10), expand = c(0, 0)) +scale_x_discrete(name="Species",labels=c("lbst"="Leatherback","swor"="Swordfish","blueshark"="Blueshark","casl"="California Sea Lion"), expand = c(0, 0))+
  scale_size(breaks = NULL, range = c(0, 100))+ggtitle("Top 10 runs if objective is to maximize swordfish catch and blueshark avoidance")+
  scale_color_manual("Product",values=c("1"="black","0"="gray87"))+guides(size="legend",color="none")+
  theme(text = element_text(size=5),axis.text = element_text(size=5),legend.position=c(.2,1),legend.justification = c(.9,.9),legend.key.size = unit(.5,'lines'),plot.title = element_text(hjust=0,size=8),plot.margin = margin(.3, 1, .3, .3, "cm"))+
  geom_vline(xintercept=c(2,3))+scale_size_manual("a",values=c("1"=1,"0"=.5))+guides(size=F)+
  scale_linetype_manual("Product",values=c("EcoROMS original"="solid","EcoROMS original unscaled"="dotted","Marxan raw"="dotdash","Marxan raw unscaled"="dashed"))

cc

dd=ggplot(b, aes(x = variable, y = value, group = id)) +   # group = id is important!
  geom_path(aes(color = as.factor(swor2),linetype=Product,size=as.factor(b$swor2)),
            alpha = 0.5,
            lineend = 'round', linejoin = 'round') +
  scale_y_continuous(name="% of species available to catch",breaks = seq(0, 100, by = 10), expand = c(0, 0)) +scale_x_discrete(name="Species",labels=c("lbst"="Leatherback","swor"="Swordfish","blueshark"="Blueshark","casl"="California Sea Lion"), expand = c(0, 0))+
  scale_size(breaks = NULL, range = c(0, 100))+ggtitle("Top 10 runs if objective is to maximize swordfish catch")+
  scale_color_manual("Product",values=c("1"="black","0"="gray87"))+guides(size="legend",color="none")+
  theme(text = element_text(size=5),axis.text = element_text(size=5),legend.position=c(.2,1),legend.justification = c(.9,.9),legend.key.size = unit(.5,'lines'),plot.title = element_text(hjust=0,size=8),plot.margin = margin(.3, 1, .3, .3, "cm"))+
  geom_vline(xintercept=c(2))+scale_size_manual("a",values=c("1"=1,"0"=.5))+guides(size=F)+
  scale_linetype_manual("Product",values=c("EcoROMS original"="solid","EcoROMS original unscaled"="dotted","Marxan raw"="dotdash","Marxan raw unscaled"="dashed"))

dd

png(paste0(plotdir,"parellel_coordinate_plot.png"),width=14, height=7, units="in", res=400)
par(ps=10)
par(cex=1)
par(mar=c(4,4,1,1))
plot_grid(aa,bb,cc,dd,nrow=2,ncol=2)
dev.off()








