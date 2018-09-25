## radar chart based on correlations

datadir="hindcast_ms/extract/extractions/"
plotdir_ms="~/Dropbox/EcoEast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/hindcast_ms/summarize_ms/plots/"#;dir.create(plotdir_ms)
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
master=fullon %>% mutate(blsh=(blshobs+blshtrk)/2) %>% select(-c(X,lon,lat,dt,blshobs,blshtrk)) %>% select(-c(EcoROMS_original,Marxan_raw)) %>% rename(EcoROMS=EcoROMS_original_unscaled) %>% rename(Marxan=Marxan_raw_unscaled) %>% rename(Swordfish=swor) %>% rename(Leatherback=lbst) %>% rename(Sealion=casl) %>% rename(Blueshark=blsh)

b.1=master[grep("run_A",master$run),] %>% select(-run)
b.1=cor(b.1)

c.1=master[grep("run_B",master$run),] %>% select(-run)
c.1=cor(c.1)

d.1=master[grep("run_C",master$run),] %>% select(-run)
d.1=cor(d.1)

e.1=master[grep("run_D",master$run),] %>% select(-run)
e.12=master[grep("run_E",master$run),] %>% select(-run)
e.1=rbind(e.1,e.12)
e.1=cor(e.1)

f.1=master[grep("run_F",master$run),] %>% select(-run)
f.12=master[grep("run_G",master$run),] %>% select(-run)
f.13=master[grep("run_H",master$run),] %>% select(-run)
f.1=rbind(f.1,f.12,f.13)
f.1=cor(f.1)

g.1=master[grep("run_I",master$run),] %>% select(-run)
g.12=master[grep("run_J",master$run),] %>% select(-run)
g.1=rbind(g.1,g.12)
g.1=cor(g.1)

b.1=b.1 %>% as.data.frame() %>% dplyr::mutate(run="A's") %>% .[1:2,3:7] %>% mutate(algorithm=c("EcoROMS","Marxam"))
c.1=c.1 %>% as.data.frame() %>% dplyr::mutate(run="B's") %>% .[1:2,3:7] %>% mutate(algorithm=c("EcoROMS","Marxam"))
d.1=d.1 %>% as.data.frame() %>% dplyr::mutate(run="C's") %>% .[1:2,3:7] %>% mutate(algorithm=c("EcoROMS","Marxam"))
e.1=e.1 %>% as.data.frame() %>% dplyr::mutate(run="D&Es'") %>% .[1:2,3:7] %>% mutate(algorithm=c("EcoROMS","Marxam"))
f.1=f.1 %>% as.data.frame() %>% dplyr::mutate(run="FH&Hs'") %>% .[1:2,3:7] %>% mutate(algorithm=c("EcoROMS","Marxam"))
g.1=g.1 %>% as.data.frame() %>% dplyr::mutate(run="I&Js'") %>% .[1:2,3:7] %>% mutate(algorithm=c("EcoROMS","Marxam"))

master2=do.call("rbind",list(b.1,c.1,d.1,e.1,f.1,g.1))
master2=master2 %>% mutate(id=paste0(algorithm,"_",run))%>% mutate_at(c("Swordfish","Leatherback","Sealion","Blueshark"),funs(rescale)) 
rownames(master2)=master2$id

png(paste0(plotdir_ms,"radar_plots.png"),width=8, height=8, units="in", res=400)
par(ps=10)
radarchart(master2[,1:4],maxmin = F,cglty=0,plty=1:2,pcol = c("darkgoldenrod","darkgoldenrod","cornflowerblue","cornflowerblue","coral1","coral1","aquamarine4","aquamarine4","dimgray","dimgray","black","black"),title = "Algorithm/species correlations across run groups")
legend(x=0.8,y=1.3,legend=rownames(master2), bty = "n", col=c("darkgoldenrod","darkgoldenrod","cornflowerblue","cornflowerblue","coral1","coral1","aquamarine4","aquamarine4","dimgray","dimgray","black","black") , text.col = "grey", cex=.7, lty=1:2)
dev.off()