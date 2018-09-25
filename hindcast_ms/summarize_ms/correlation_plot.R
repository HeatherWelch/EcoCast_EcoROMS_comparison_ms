## correlation plont

datadir="hindcast_ms/extract/extractions/"
plotdir_ms="~/Dropbox/EcoEast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/hindcast_ms/summarize_ms/plots/"#;dir.create(plotdir_ms)
library(corrplot)
library(ggradar)
library(scales)
library(fmsb)

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

# fit=lm(Marxan_raw~swor+lbst+casl+blshobs,data=fullon)
# fit=lm(EcoROMS_original~swor+lbst+casl+blshobs,data=fullon)
# 
# 
# df=fullon %>% dplyr::filter(limit_target=="leatherback")
# df$lbst=round(df$lbst, digits = -1)
# 
# a=fullon %>% gather(species,value,-c(X,lon,lat,dt,EcoROMS_original,EcoROMS_original_unscaled,Marxan_raw,Marxan_raw_unscaled,run))
# b=a %>% filter()
# pp=ggplot(a,aes(species,value))+geom_boxplot()
# pp
# 
# a=fullon %>% gather(species,value,-c(X,lon,lat,dt,run))
# b=a %>% filter()
# pp=ggplot(a,aes(species,value))+geom_boxplot()
# pp

master=fullon %>% mutate(blsh=(blshobs+blshtrk)/2) %>% select(-c(X,lon,lat,dt,blshobs,blshtrk)) %>% select(-c(EcoROMS_original,Marxan_raw)) %>% rename(EcoROMS=EcoROMS_original_unscaled) %>% rename(Marxan=Marxan_raw_unscaled) %>% rename(Swordfish=swor) %>% rename(Leatherback=lbst) %>% rename(Sealion=casl) %>% rename(Blueshark=blsh)
a.1=master %>% select(-run)
a.1=cor(a.1)
corrplot(a.1, method="color",type="upper", 
         addCoef.col = "black",tl.col="black",title="All runs")

b.1=master[grep("run_A",master$run),] %>% select(-run)
b.1=cor(b.1)
corrplot(b.1, method="color",type="upper", 
         addCoef.col = "black",tl.col="black",title="A runs, selecting for swordfish",mar=c(1,1,1.5,1))

c.1=master[grep("run_B",master$run),] %>% select(-run)
c.1=cor(c.1)
corrplot(c.1, method="color",type="upper", 
         addCoef.col = "black",tl.col="black",title="B runs, selecting for leatherback",mar=c(1,1,1.5,1))

d.1=master[grep("run_C",master$run),] %>% select(-run)
d.1=cor(d.1)
corrplot(d.1, method="color",type="upper", 
         addCoef.col = "black",tl.col="black",title="C runs, swor and leatherback equally",mar=c(1,1,1.5,1))

e.1=master[grep("run_D",master$run),] %>% select(-run)
e.12=master[grep("run_E",master$run),] %>% select(-run)
e.1=rbind(e.1,e.12)
e.1=cor(e.1)
corrplot(e.1, method="color",type="upper", 
         addCoef.col = "black",tl.col="black",title="D&E runs, max swor and lbst",mar=c(1,1,1.5,1))

f.1=master[grep("run_F",master$run),] %>% select(-run)
f.12=master[grep("run_G",master$run),] %>% select(-run)
f.13=master[grep("run_H",master$run),] %>% select(-run)
f.1=rbind(f.1,f.12,f.13)
f.1=cor(f.1)
corrplot(f.1, method="color",type="upper", 
         addCoef.col = "black",tl.col="black",title="F,G,&H runs, all species but casl",mar=c(1,1,1.5,1))

g.1=master[grep("run_I",master$run),] %>% select(-run)
g.12=master[grep("run_J",master$run),] %>% select(-run)
g.1=rbind(g.1,g.12)
g.1=cor(g.1)
corrplot(g.1, method="color",type="upper", 
         addCoef.col = "black",tl.col="black",title="I&J runs, all species",mar=c(1,1,1.5,1))

png(paste0(plotdir_ms,"correl_plots.png"),width=20, height=8, units="in", res=400)
par(ps=10)
par(mfrow = c(2, 4))
corrplot(a.1, method="color",type="upper", 
         addCoef.col = "black",tl.col="black",title="All runs",mar=c(1,1,1.5,1))

corrplot(b.1, method="color",type="upper", 
         addCoef.col = "black",tl.col="black",title="A runs, selecting for swordfish",mar=c(1,1,1.5,1))

corrplot(c.1, method="color",type="upper", 
         addCoef.col = "black",tl.col="black",title="B runs, selecting for leatherback",mar=c(1,1,1.5,1))

corrplot(d.1, method="color",type="upper", 
         addCoef.col = "black",tl.col="black",title="C runs, swor and leatherback equally",mar=c(1,1,1.5,1))

corrplot(e.1, method="color",type="upper", 
         addCoef.col = "black",tl.col="black",title="D&E runs, max swor and lbst",mar=c(1,1,1.5,1))

corrplot(f.1, method="color",type="upper", 
         addCoef.col = "black",tl.col="black",title="F,G,&H runs, all species but casl",mar=c(1,1,1.5,1))

corrplot(g.1, method="color",type="upper", 
         addCoef.col = "black",tl.col="black",title="I&J runs, all species",mar=c(1,1,1.5,1))
dev.off()

