### heatmap of ecoroms options for managers ###

source("load_functions.R")
source("hindcast_ms/summarize/algorithm_comparison.R")

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

# a=round(df$lbst, digits = -1) 
# head(a,20)
# head(df$lbst,20)

b=df %>% mutate(id=1:1100) 
c=b %>% select(lbst,swor,id) %>% spread(lbst,swor)
b=df %>% spread(lbst,swor)
a=data.matrix(df[,2:3])
df$id=paste0(df$product,"_",df$run)
df$lbst=as.factor(df$lbst)

#test=ggplot(df,mapping = aes(x=as.factor(lbst),y=id,fill=swor))+geom_tile()

#heatmap(df,Rowv = NA, Colv = NA)

test=ggplot(df,mapping = aes(x=as.factor(lbst),y=run,fill=swor))+geom_tile()+facet_grid(~product)+scale_fill_gradient2(name="% of swordfish available to catch",low=muted("red"),mid="yellow", high=muted("darkgreen"), guide="colorbar",midpoint = 50)
test=test+xlab("% of allowable leatherback bycatch")+ylab("Species weightings run")
test=test+theme(strip.background = element_rect(colour="black", fill=NA),axis.text=element_text(size=10),text=element_text(size=10))+coord_polar()
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
