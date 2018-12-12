## correlation plot showing correlations w changing weightings
## adapted from correaltion_plot_subset.R

datadir="./hindcast_ms/extract/extractions/"
plotdir_ms="./hindcast_ms/figures/plots/"#;dir.create(plotdir_ms)
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

master=fullon %>% mutate(blsh=(blshobs+blshtrk)/2) %>% select(-c(X,blshobs,blshtrk)) %>% select(-c(EcoROMS_original,Marxan_raw)) %>% rename(EcoROMS=EcoROMS_original_unscaled) %>% rename(Marxan=Marxan_raw_unscaled) %>% rename(Swordfish=swor) %>% rename(Leatherback=lbst) %>% rename(Sealion=casl) %>% rename(Blueshark=blsh)
b=master %>% filter(run=="run_M.2"|run=="run_C.3"|run=="run_M.4"|run=="run_M.5") %>%select(-Marxan) %>%  spread(run,EcoROMS) %>%rename(EcoCast_M.2=run_M.2)%>%rename(EcoCast_C.3=run_C.3)%>%rename(EcoCast_M.4=run_M.4)%>%rename(EcoCast_M.5=run_M.5)%>% select(-c(lat,lon,dt))
c=master %>% filter(run=="run_B.3"|run=="run_C.3"|run=="run_G.3"|run=="run_J.3") %>% select(-EcoROMS) %>%  spread(run,Marxan) %>% rename(Marxan_B.3=run_B.3)%>% rename(Marxan_C.3=run_C.3)%>% rename(Marxan_G.3=run_G.3)%>% rename(Marxan_J.3=run_J.3) %>% select(-c(lat,lon,dt))
a=cbind(b,c[,5:ncol(c)]) %>% .[complete.cases(.),] %>% .[,c(1:4,6,5,7:ncol(.))]
a=cor(a)
png(paste0(plotdir_ms,"figure5_changing_species_cor.png"),width=12, height=8, units="in", res=400)
par(ps=10)
corrplot(a, method="color",type="upper", 
         addCoef.col = "black",tl.col="black",mar=c(1,1,1,1),number.cex=1)
dev.off()

## trying with better names

b=master %>% filter(run=="run_M.2"|run=="run_C.3"|run=="run_M.4"|run=="run_M.5") %>%select(-Marxan) %>%  spread(run,EcoROMS) %>%rename("E: lbst (-1)"=run_M.2)%>%rename("E: lbst/swor (+/-.5)"=run_C.3)%>%rename("E: lbst/swor/blsh (+/-.33)"=run_M.4)%>%rename("E: lbst/swor/blsh/casl (+/-.25)"=run_M.5)%>% select(-c(lat,lon,dt))
c=master %>% filter(run=="run_B.3"|run=="run_C.3"|run=="run_G.3"|run=="run_J.3") %>% select(-EcoROMS) %>%  spread(run,Marxan) %>% rename("M: lbst (-.5)"=run_B.3)%>% rename("M: lbst/swor (+/-.5)"=run_C.3)%>% rename("M: lbst/swor/blsh (+/-.5)"=run_G.3)%>% rename("M: lbst/swor/blsh/casl (+/-.5)"=run_J.3) %>% select(-c(lat,lon,dt))
a=cbind(b,c[,5:ncol(c)]) %>% .[complete.cases(.),] %>% .[,c(1:4,6,5,7:ncol(.))]
 a=cor(a)
 png(paste0(plotdir_ms,"figure5_changing_species_cor.png"),width=12, height=8, units="in", res=400)
 par(ps=10)
corrplot(a, method="color",type="upper", 
         addCoef.col = "black",tl.col="black",number.cex=.7)
dev.off()


