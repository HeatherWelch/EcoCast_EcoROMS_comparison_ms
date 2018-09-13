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
df=df %>% mutate(blueshark=(blshobs+blshtrk)/2) %>% select(product,lbst,swor,blueshark,casl,run) %>% filter(lbst==0)
df=df %>% filter(lbst==0) %>% mutate(swor_inverse=100-swor)
#dff=df %>% mutate(multi=rowSums(.[,c(blueshark,casl,swor_inverse)]))
dff=df %>% mutate(swor_blsh_casl=blueshark+casl+swor_inverse) %>% mutate(swor_blsh=blueshark+swor_inverse) %>% mutate(swor2=swor)
#dff[order(dff$multi),]

dff$id=paste0(dff$product,"_",dff$run) %>% as.character()
b=dff %>% gather (variable, value,-c(product,id,run,swor_inverse,swor_blsh_casl,swor_blsh,swor2)) %>% .[complete.cases(.),]
b$variable=factor(b$variable,levels=c("lbst","swor","blueshark","casl"))

b=b[order(b$swor_blsh_casl),]
a=b$id %>% unique() %>% .[1:10] 
b=b %>% mutate(swor_blsh_casl=ifelse(id %in% a,1,0))

b=b[order(b$swor_blsh),]
a=b$id %>% unique() %>% .[1:10] 
b=b %>% mutate(swor_blsh=ifelse(id %in% a,1,0))

b=b[order(b$swor2),]
a=b$id %>% unique() %>% .[1:10] 
b=b %>% mutate(swor2=ifelse(id %in% a,1,0))
# 
# 
# 
# a=b$id %>% unique() %>% .[1:10] %>% as.data.frame() %>% rename(id3=".")
# c=b %>% left_join(.,a,by=c("id"="id3"))
# 
# b$swor_blsh_casl[1:40]=1
# b$swor_blsh_casl[41:length(b$swor_blsh_casl)]=0
# b$swor_blsh_casl=as.factor(b$swor_blsh_casl)

#y_levels=levels(factor(0:100))

## master
ggplot(b, aes(x = variable, y = value, group = id)) +   # group = id is important!
  geom_path(aes(color = product,linetype=product),
            alpha = 0.5,
            lineend = 'round', linejoin = 'round') +
  scale_y_continuous(name="% of species available to catch",breaks = seq(0, 100, by = 10), expand = c(0, 0)) +scale_x_discrete(name="Species",labels=c("lbst"="Leatherback","swor"="Swordfish","blueshark"="Blueshark","casl"="California Sea Lion"), expand = c(0, 0))+
  scale_size(breaks = NULL, range = c(0, 100))+ggtitle("Comparison of species catch availability between algorithms for 0% allowable leatherback bycatch")+
  scale_color_manual("product",values=c("EcoROMS_original"="darkgoldenrod","EcoROMS_original_unscaled"="cornflowerblue","Marxan_raw"="coral1","Marxan_raw_unscaled"="aquamarine4"))#+
  guides(color = guide_legend(override.aes = list(linetype = c("solid", "solid","dashed", "dashed"))))

ggplot(b, aes(x = variable, y = value, group = id)) +   # group = id is important!
  geom_path(aes(color = as.factor(swor_blsh_casl),linetype=product),
            alpha = 0.5,
            lineend = 'round', linejoin = 'round') +
  scale_y_continuous(name="% of species available to catch",breaks = seq(0, 100, by = 10), expand = c(0, 0)) +scale_x_discrete(name="Species",labels=c("lbst"="Leatherback","swor"="Swordfish","blueshark"="Blueshark","casl"="California Sea Lion"), expand = c(0, 0))+
  scale_size(breaks = NULL, range = c(0, 100))+ggtitle("Top 10 runs if objective is maximize swordfish catch and blueshark/sealion avoidance")+
  scale_color_manual("product",values=c("1"="blue","0"="grey"))

ggplot(b, aes(x = variable, y = value, group = id)) +   # group = id is important!
  geom_path(aes(color = as.factor(swor_blsh),linetype=product),
            alpha = 0.5,
            lineend = 'round', linejoin = 'round') +
  scale_y_continuous(name="% of species available to catch",breaks = seq(0, 100, by = 10), expand = c(0, 0)) +scale_x_discrete(name="Species",labels=c("lbst"="Leatherback","swor"="Swordfish","blueshark"="Blueshark","casl"="California Sea Lion"), expand = c(0, 0))+
  scale_size(breaks = NULL, range = c(0, 100))+ggtitle("Top 10 runs if objective is maximize swordfish catch and blueshark avoidance")+
  scale_color_manual("product",values=c("1"="blue","0"="grey"))

ggplot(b, aes(x = variable, y = value, group = id)) +   # group = id is important!
  geom_path(aes(color = as.factor(swor2),linetype=product),
            alpha = 0.5,
            lineend = 'round', linejoin = 'round') +
  scale_y_continuous(name="% of species available to catch",breaks = seq(0, 100, by = 10), expand = c(0, 0)) +scale_x_discrete(name="Species",labels=c("lbst"="Leatherback","swor"="Swordfish","blueshark"="Blueshark","casl"="California Sea Lion"), expand = c(0, 0))+
  scale_size(breaks = NULL, range = c(0, 100))+ggtitle("Comparison of species catch availability between algorithms for different thresholds of allowable leatherback bycatch")+
  scale_color_manual("product",values=c("1"="blue","0"="grey"))










## rectangular heatmaps

## swor
test=ggplot(df,mapping = aes(x=as.factor(lbst),y=run,fill=swor))+geom_tile()+facet_grid(~product)+scale_fill_gradient2(name="% of swordfish available to catch",low=muted("red"),mid="yellow", high=muted("darkgreen"), guide="colorbar",midpoint = 50)
test=test+xlab("% of allowable leatherback bycatch")+ylab("Species weightings run")
test=test+theme(strip.background = element_rect(colour="black", fill=NA),axis.text=element_text(size=10),text=element_text(size=10))
test

## blsh
df=df %>% mutate(blsh=(blshobs+blshtrk)/2) %>% select(-c(blshobs,blshtrk)) %>% mutate(id=1:nrow(.)) 
df$id=paste0(df$product,"_",df$run)
df$lbst=as.factor(df$lbst)

test=ggplot(df,mapping = aes(x=as.factor(lbst),y=run,fill=blsh))+geom_tile()+facet_grid(~product)+scale_fill_gradient2(name="% of blueshark available to bycatchcatch",low=muted("red"),mid="yellow", high=muted("darkgreen"), guide="colorbar",midpoint = 50)
test=test+xlab("% of allowable leatherback bycatch")+ylab("Species weightings run")
test=test+theme(strip.background = element_rect(colour="black", fill=NA),axis.text=element_text(size=10),text=element_text(size=10))
test

## casl
test=ggplot(df,mapping = aes(x=as.factor(lbst),y=run,fill=casl))+geom_tile()+facet_grid(~product)+scale_fill_gradient2(name="% of casl available to bycatch",low=muted("red"),mid="yellow", high=muted("darkgreen"), guide="colorbar",midpoint = 50)
test=test+xlab("% of allowable leatherback bycatch")+ylab("Species weightings run")
test=test+theme(strip.background = element_rect(colour="black", fill=NA),axis.text=element_text(size=10),text=element_text(size=10))
test


## circular heatmaps

## swor
test=ggplot(df,mapping = aes(x=run,y=as.factor(lbst),fill=swor))+geom_tile()+facet_grid(~product)+scale_fill_gradient2(name="% of swordfish available to catch",low=muted("red"),mid="yellow", high=muted("darkgreen"), guide="colorbar",midpoint = 50)
test=test+ylab("% of allowable leatherback bycatch")
test=test+theme(strip.background = element_rect(colour="black", fill=NA),axis.text=element_text(size=10),text=element_text(size=10))+coord_polar()
test

## casl
test=ggplot(df,mapping = aes(x=run,y=as.factor(lbst),fill=casl))+geom_tile()+facet_grid(~product)+scale_fill_gradient2(name="% of sea lion available to bycatch",low=muted("red"),mid="yellow", high=muted("darkgreen"), guide="colorbar",midpoint = 50)
test=test+ylab("% of allowable leatherback bycatch")
test=test+theme(strip.background = element_rect(colour="black", fill=NA),axis.text=element_text(size=10),text=element_text(size=10))+coord_polar()
test

## blsh
test=ggplot(df,mapping = aes(x=run,y=as.factor(lbst),fill=blsh))+geom_tile()+facet_grid(~product)+scale_fill_gradient2(name="% of blsh available to bycatch",low=muted("red"),mid="yellow", high=muted("darkgreen"), guide="colorbar",midpoint = 50)
test=test+ylab("% of allowable leatherback bycatch")
test=test+theme(strip.background = element_rect(colour="black", fill=NA),axis.text=element_text(size=10),text=element_text(size=10))+coord_polar()
test



# a=round(df$lbst, digits = -1) 
# head(a,20)
# head(df$lbst,20)

# b=df %>% mutate(id=1:1100) 
# c=b %>% select(lbst,swor,id) %>% spread(lbst,swor)
# b=df %>% spread(lbst,swor)
# a=data.matrix(df[,2:3])
# df$id=paste0(df$product,"_",df$run)
# df$lbst=as.factor(df$lbst)

#test=ggplot(df,mapping = aes(x=as.factor(lbst),y=id,fill=swor))+geom_tile()

#heatmap(df,Rowv = NA, Colv = NA)

test=ggplot(df,mapping = aes(x=as.factor(lbst),y=run,fill=swor))+geom_tile()+facet_grid(~product)+scale_fill_gradient2(name="% of swordfish available to catch",low=muted("red"),mid="yellow", high=muted("darkgreen"), guide="colorbar",midpoint = 50)
test=test+xlab("% of allowable leatherback bycatch")+ylab("Species weightings run")
test=test+theme(strip.background = element_rect(colour="black", fill=NA),axis.text=element_text(size=10),text=element_text(size=10))
test

df=df %>% filter(product=="EcoROMS_original")
test=ggplot(df,mapping = aes(x=run,y=as.factor(lbst),fill=swor))+geom_tile()+facet_grid(~product)+scale_fill_gradient2(name="% of swordfish available to catch",low=muted("red"),mid="yellow", high=muted("darkgreen"), guide="colorbar",midpoint = 50)
test=test+ylab("% of allowable leatherback bycatch")
test=test+theme(strip.background = element_rect(colour="black", fill=NA),axis.text=element_text(size=10),text=element_text(size=10))+coord_polar()
test

df=df %>% filter(product=="EcoROMS_original")
test=ggplot(df,mapping = aes(x=run,y=as.factor(lbst),fill=casl))+geom_tile()+facet_grid(~product)+scale_fill_gradient2(name="% of sea lion available to bycatch",low=muted("red"),mid="yellow", high=muted("darkgreen"), guide="colorbar",midpoint = 50)
test=test+ylab("% of allowable leatherback bycatch")
test=test+theme(strip.background = element_rect(colour="black", fill=NA),axis.text=element_text(size=10),text=element_text(size=10))+coord_polar()
test

## blsh
df=df %>% mutate(blsh=(blshobs+blshtrk)/2) %>% select(-c(blshobs,blshtrk)) %>% mutate(id=1:1100) 
df$id=paste0(df$product,"_",df$run)
df$lbst=as.factor(df$lbst)

test=ggplot(df,mapping = aes(x=as.factor(lbst),y=run,fill=blsh))+geom_tile()+facet_grid(~product)+scale_fill_gradient2(name="% of blueshark available to bycatchcatch",low=muted("red"),mid="yellow", high=muted("darkgreen"), guide="colorbar",midpoint = 50)
test=test+xlab("% of allowable leatherback bycatch")+ylab("Species weightings run")
test=test+theme(strip.background = element_rect(colour="black", fill=NA),axis.text=element_text(size=10),text=element_text(size=10))
test

## casl
test=ggplot(df,mapping = aes(x=as.factor(lbst),y=run,fill=casl))+geom_tile()+facet_grid(~product)+scale_fill_gradient2(name="% of casl available to bycatchcatch",low=muted("red"),mid="yellow", high=muted("darkgreen"), guide="colorbar",midpoint = 50)
test=test+xlab("% of allowable leatherback bycatch")+ylab("Species weightings run")
test=test+theme(strip.background = element_rect(colour="black", fill=NA),axis.text=element_text(size=10),text=element_text(size=10))
test

## rose plot
c
a$lbst=round(a$lbst, digits = -1)
a$ID=paste0(a$run,"_",a$lbst)
b=a %>% gather(species,value,-c(X,product,limit_target,run,ID))
ggplot(data=b,aes(x=run,y=value,fill=value))+geom_bar(stat="identity")+coord_polar()

c=b %>% mutate(run_sp=paste0(run,"_",species))
ggplot(data=c,aes(x=run_sp,y=value,fill=species))+geom_bar(stat="identity")+coord_polar()

ggplot(data=a,aes(x=lbst,y=swor,fill=run))+geom_bar(stat="identity")#+coord_polar()

a=fullon %>% filter(product=="EcoROMS_original")
a$lbst=round(a$lbst, digits = -1) %>% as.factor()
b=a %>% gather(species,value,-c(X,product,lbst,limit_target,run))
ggplot(data=b,aes(x=run,y=lbst,fill=lbst))+geom_bar(stat="identity")+facet_wrap(~species) #+coord_polar()

#area under the curve
AUC(fullon$lbst,fullon$swor,method = "spline")
plot(fullon$lbst,fullon$swor,type="l")
lines(fullon$lbst,fullon$swor,type="s",col="red")
