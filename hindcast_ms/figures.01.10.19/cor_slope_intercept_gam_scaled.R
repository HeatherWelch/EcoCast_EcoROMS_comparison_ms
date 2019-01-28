### calculating correlation, slope, intercept for each run (tool output/species input)
library(tidyverse)
library(mgcv)

weightings=read.csv("hindcast_ms/predict/weighting_scenarios.csv")
datadir="hindcast_ms/extract/extractions/"
plotdir="hindcast_ms/figures.01.10.19/plots/"
library(BBmisc)

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
master=fullon %>% as.data.frame()%>% mutate(blsh=(blshobs+blshtrk)/2) %>% select(-c(X,lon,lat,blshobs,blshtrk)) %>% select(-c(EcoROMS_original_unscaled,Marxan_raw_unscaled)) %>% rename(EcoROMS=EcoROMS_original) %>% rename(Marxan=Marxan_raw) %>% rename(Swordfish=swor) %>% rename(Leatherback=lbst) %>% rename(Sealion=casl) %>% rename(Blueshark=blsh)
detachPackage("bindrcpp")
#master=master %>% mutate(y_m=strtrim(dt,7)) %>% mutate(EcoROMS=normalize(EcoROMS,method="range",range=c(0,1)))%>% mutate(Marxan=normalize(Marxan,method="range",range=c(0,1)))
master=master %>% mutate(y_m=strtrim(dt,7)) %>% mutate(EcoROMS=rescale(EcoROMS,to=c(0,1))) %>% mutate(Marxan=rescale(Marxan,to=c(0,1)))


runs=as.factor(master$run) %>% unique() %>% as.character
empty=data.frame(Swordfish=NA,Leatherback=NA,Sealion=NA,Blueshark=NA,algorithm=NA,run=NA,stat=NA)
for(i in 1:length(runs)){
  runn=runs[i]
  print(runn)
  #a=master %>% dplyr::filter(run==runn) %>% select(-c(run,dt,y_m)) %>% cor() %>% .[1:2,3:6] %>% as.data.frame() %>% mutate(algorithm=c("EcoROMS","Marxan")) %>% mutate(run=runn) %>% mutate(stat="Cor")
  b=master %>% filter(run==runn) %>% select(-c(run,dt,y_m))
  c= apply(b[,3:6],2,function(x)lm(Marxan~x,b)$coefficients) %>% as.data.frame() %>% mutate(algorithm="Marxan")%>% mutate(run=runn) %>% mutate(stat=c("Intercept","Slope"))
  d= apply(b[,3:6],2,function(x)lm(EcoROMS~x,b)$coefficients) %>% as.data.frame() %>% mutate(algorithm="EcoROMS")%>% mutate(run=runn) %>% mutate(stat=c("Intercept","Slope"))
  e=apply(b[,3:6],2,function(x)gam(b$Marxan~s(x))) %>% lapply(.,function(x)summary(x)$r.sq)%>% as.data.frame()%>% mutate(algorithm="Marxan")%>% mutate(run=runn) %>% mutate(stat=c("rsq"))
  f=apply(b[,3:6],2,function(x)gam(b$Marxan~s(x))) %>% lapply(.,function(x)summary(x)$edf)%>% as.data.frame()%>% mutate(algorithm="Marxan")%>% mutate(run=runn) %>% mutate(stat=c("edf"))
  g=apply(b[,3:6],2,function(x)gam(b$EcoROMS~s(x))) %>% lapply(.,function(x)summary(x)$r.sq)%>% as.data.frame()%>% mutate(algorithm="EcoROMS")%>% mutate(run=runn) %>% mutate(stat=c("rsq"))
  h=apply(b[,3:6],2,function(x)gam(b$EcoROMS~s(x))) %>% lapply(.,function(x)summary(x)$edf)%>% as.data.frame()%>% mutate(algorithm="EcoROMS")%>% mutate(run=runn) %>% mutate(stat=c("edf"))
  empty=do.call("rbind",list(empty,c,d,e,f,g,h))
}

# e=apply(b[,3:6],2,function(x)gam(b$Marxan~s(x))) %>% lapply(.,function(x)summary(x)$r.sq)%>% as.data.frame()%>% mutate(algorithm="Marxan")%>% mutate(run=runn) %>% mutate(stat=c("rsq"))
# f=apply(b[,3:6],2,function(x)gam(b$Marxan~s(x),method="REML")) #%>% lapply(.,function(x)summary(x)$edf)%>% as.data.frame()%>% mutate(algorithm="Marxan")%>% mutate(run=runn) %>% mutate(stat=c("edf"))
#  g=apply(b[,3:6],2,function(x)gam(b$EcoROMS~s(x,bs="cr"),method="REML")) #%>% lapply(.,function(x)summary(x)$r.sq)%>% as.data.frame()%>% mutate(algorithm="EcoROMS")%>% mutate(run=runn) %>% mutate(stat=c("rsq"))
# h=apply(b[,3:6],2,function(x)gam(b$EcoROMS~s(x))) %>% lapply(.,function(x)summary(x)$edf)%>% as.data.frame()%>% mutate(algorithm="EcoROMS")%>% mutate(run=runn) %>% mutate(stat=c("edf"))

b=empty %>% filter(run=="run_C.3"|run=="run_E.1"|run=="run_D.4") %>%filter(algorithm!="Marxan") 
eco=b[order(b$stat,b$Leatherback),]%>% mutate(Leatherback=round(Leatherback,2)) %>% mutate(fig="fig2")

#b=empty %>% filter(run=="run_B.2"|run=="run_B.3"|run=="run_B.4"|run=="run_C.3"|run=="run_E.1"|run=="run_D.4") %>%filter(algorithm!="EcoROMS") 
b=empty %>% filter(run=="run_C.3"|run=="run_E.1"|run=="run_D.4") %>%filter(algorithm!="EcoROMS") 
mar=b[order(b$stat,b$Leatherback),] %>% mutate(Leatherback=round(Leatherback,2))%>% mutate(fig="fig2")
mar

b=empty %>% filter(run=="run_B.3"|run=="run_C.3"|run=="run_G.3"|run=="run_J.3") %>%filter(algorithm!="EcoROMS") 
mar_sp=b[order(b$stat,b$Leatherback),] %>% mutate(Leatherback=round(Leatherback,2))%>% mutate(fig="fig4")
mar_sp

b=empty %>% filter(run=="run_M.2"|run=="run_C.3"|run=="run_M.4"|run=="run_M.5") %>%filter(algorithm!="Marxan") 
eco_sp=b[order(b$stat,b$Leatherback),] %>% mutate(Leatherback=round(Leatherback,2))%>% mutate(fig="fig4")
eco_sp

big_guy=do.call("rbind",list(eco,mar,mar_sp,eco_sp)) %>% mutate(run=gsub("run_","",run))
d=left_join(big_guy,weightings,by="run") %>% mutate(Swordfish=round(Swordfish,2))%>% mutate(Blueshark=round(Blueshark,2))%>% mutate(Sealion=round(Sealion,2))
d=d[,c(2,1,4,3,5:ncol(d))]

a=d %>% filter(fig=="fig2") %>% mutate(weighting=gsub("0,0,0,","t",weighting))%>% mutate(weighting=gsub(",","/",weighting))
master=d %>% filter(fig=="fig4") %>% mutate(weighting=as.character(weighting))

master <- within(master, weighting[run == 'B.3'] <- 'One-species')
master <- within(master, weighting[run == 'C.3'] <- 'Two-species')
master <- within(master, weighting[run == 'G.3'] <- 'Three-species')
master <- within(master, weighting[run == 'J.3'] <- 'Four-species') 
master <- within(master, weighting[run == 'M.2'] <- 'One-species')
master <- within(master, weighting[run == 'M.4'] <- 'Three-species')
master <- within(master, weighting[run == 'M.5'] <- 'Four-species')

d=rbind(a,master)

write.csv(d,paste0(plotdir,"cor_slope_intercept_gam_scaled.csv"))

##### testing out new method to determine best
# ##### this is for inter-species correaltions only ####
# #1. greatest difference in correlations between swor and bycatch
# #2. greatest slopes per species
# #3. greatest y intercepts per species
# Mar=empty %>% filter(algorithm=="Marxan") ## D.3, best for cor and slope
# 
# #1. greatest difference in correlations between swor and bycatch
# a=Mar[complete.cases(Mar),] %>% filter(stat=="Cor")%>% filter(!(algorithm=="Marxan"&run=="run_M.5"))%>% filter(!(algorithm=="Marxan"&run=="run_M.4"))%>% filter(!(algorithm=="Marxan"&run=="run_M.3"))%>% filter(!(algorithm=="Marxan"&run=="run_M.2"))%>% filter(!(algorithm=="Marxan"&run=="run_M.1"))%>% filter(run!="run_A.5")%>% filter(run!="run_A.4")%>% filter(run!="run_A.3")%>% filter(run!="run_A.2")%>% filter(run!="run_A.1")
# df=a %>% mutate(bycatch=rowMeans(.[,2:4])) %>% mutate(eval=Swordfish-bycatch)
# bb=df[order(-df$eval),]
# blank=bb %>% mutate(M_cor=1:nrow(bb))
# 
# #2. greatest slopes per species
# a=Mar[complete.cases(Mar),] %>% filter(stat=="Slope")%>% filter(!(algorithm=="Marxan"&run=="run_M.5"))%>% filter(!(algorithm=="Marxan"&run=="run_M.4"))%>% filter(!(run=="run_M.3"))%>% filter(!(algorithm=="Marxan"&run=="run_M.2"))%>% filter(!(algorithm=="Marxan"&run=="run_M.1"))
# df=a %>% filter(Swordfish>0) %>% filter(Leatherback<0)%>% filter(Blueshark<0)%>% filter(Sealion<0)
# df=df %>% mutate(bycatch=rowMeans(.[,2:4])) %>% mutate(eval=Swordfish-bycatch)
# bb=df[order(-df$eval),]%>% mutate(M_slope=1:nrow(df)) %>% select(run,10)
# blank=left_join(blank,bb)
# 
# #3. greatest y intercepts per species
# a=Mar[complete.cases(Mar),] %>% filter(stat=="Intercept")%>% filter(!(algorithm=="Marxan"&run=="run_M.5"))%>% filter(!(algorithm=="Marxan"&run=="run_M.4"))%>% filter(!(run=="run_M.3"))%>% filter(!(algorithm=="Marxan"&run=="run_M.2"))%>% filter(!(algorithm=="Marxan"&run=="run_M.1"))
# df=a %>% mutate(bycatch=rowMeans(.[,2:4])) %>% mutate(eval=bycatch-Swordfish)
# bb=df[order(-df$eval),]%>% mutate(M_int=1:nrow(df)) %>% select(run,10)
# blank=left_join(blank,bb)
# blank[order(blank$M_int),]
# 
# 
# Mar=empty %>% filter(algorithm=="EcoROMS") ## ## J.6, best for cor and, 2nd for slope
# 
# #1. greatest difference in correlations between swor and bycatch
# a=Mar[complete.cases(Mar),] %>% filter(stat=="Cor")%>% filter(!(algorithm=="Marxan"&run=="run_M.5"))%>% filter(!(algorithm=="Marxan"&run=="run_M.4"))%>% filter(!(algorithm=="Marxan"&run=="run_M.3"))%>% filter(!(algorithm=="Marxan"&run=="run_M.2"))%>% filter(!(algorithm=="Marxan"&run=="run_M.1"))%>% filter(run!="run_A.5")%>% filter(run!="run_A.4")%>% filter(run!="run_A.3")%>% filter(run!="run_A.2")%>% filter(run!="run_A.1")
# df=a %>% mutate(bycatch=rowMeans(.[,2:4])) %>% mutate(eval=Swordfish-bycatch)
# bb=df[order(-df$eval),]
# blank=bb %>% mutate(M_cor=1:nrow(bb))
# 
# #2. greatest slopes per species
# a=Mar[complete.cases(Mar),] %>% filter(stat=="Slope")%>% filter(!(algorithm=="Marxan"&run=="run_M.5"))%>% filter(!(algorithm=="Marxan"&run=="run_M.4"))%>% filter(!(run=="run_M.3"))%>% filter(!(algorithm=="Marxan"&run=="run_M.2"))%>% filter(!(algorithm=="Marxan"&run=="run_M.1"))
# df=a %>% filter(Swordfish>0) %>% filter(Leatherback<0)%>% filter(Blueshark<0)%>% filter(Sealion<0)
# df=df %>% mutate(bycatch=rowMeans(.[,2:4])) %>% mutate(eval=Swordfish-bycatch)
# bb=df[order(-df$eval),]%>% mutate(M_slope=1:nrow(df)) %>% select(run,10)
# blank=left_join(blank,bb)
# 
# #3. greatest y intercepts per species
# a=Mar[complete.cases(Mar),] %>% filter(stat=="Intercept")%>% filter(!(algorithm=="Marxan"&run=="run_M.5"))%>% filter(!(algorithm=="Marxan"&run=="run_M.4"))%>% filter(!(run=="run_M.3"))%>% filter(!(algorithm=="Marxan"&run=="run_M.2"))%>% filter(!(algorithm=="Marxan"&run=="run_M.1"))
# df=a %>% mutate(bycatch=rowMeans(.[,2:4])) %>% mutate(eval=bycatch-Swordfish)
# bb=df[order(-df$eval),]%>% mutate(M_int=1:nrow(df)) %>% select(run,10)
# blank=left_join(blank,bb)
# blank[order(blank$M_cor),]
# 
# 
# ##### this is for inter-species correaltions and oceanstate effects ####
# runs=as.factor(master$run) %>% unique() %>% as.character
# master=master%>% mutate(y_m=strtrim(y_m,4))
# master$temp="warm"
# master <- within(master, temp[y_m == '2003'] <- 'cold')
# times=master$temp %>% unique()
# empty=data.frame(Swordfish=NA,Leatherback=NA,Sealion=NA,Blueshark=NA,algorithm=NA,run=NA,stat=NA,time=NA)
# for(i in 1:length(runs)){
#   for (ii in 1:length(times)){
#   runn=runs[i]
#   timess=times[ii]
#   a=master %>% filter(run==runn)%>% filter(temp==timess) %>% select(-c(run,dt,y_m,temp)) %>% cor() %>% .[1:2,3:6] %>% as.data.frame() %>% mutate(algorithm=c("EcoROMS","Marxan")) %>% mutate(run=runn) %>% mutate(stat="Cor")%>% mutate(time=timess)
#   b=master %>% filter(run==runn)%>% filter(temp==timess) %>% select(-c(run,dt,y_m,temp))
#   c= apply(b[,3:6],2,function(x)lm(Marxan~x,b)$coefficients) %>% as.data.frame() %>% mutate(algorithm="Marxan")%>% mutate(run=runn) %>% mutate(stat=c("Intercept","Slope")) %>% mutate(time=timess)
#   d= apply(b[,3:6],2,function(x)lm(EcoROMS~x,b)$coefficients) %>% as.data.frame() %>% mutate(algorithm="EcoROMS")%>% mutate(run=runn) %>% mutate(stat=c("Intercept","Slope"))%>% mutate(time=timess)
#   empty=do.call("rbind",list(empty,a,c,d))
#   }}
# 
# ### Mar Warm
# Mar=empty %>% filter(algorithm=="Marxan"&time=="warm") ## k.3 3rd cor, 1st slope, 9th intercept
# 
# #1. greatest difference in correlations between swor and bycatch
# a=Mar[complete.cases(Mar),] %>% filter(stat=="Cor")%>% filter(!(algorithm=="Marxan"&run=="run_M.5"))%>% filter(!(algorithm=="Marxan"&run=="run_M.4"))%>% filter(!(algorithm=="Marxan"&run=="run_M.3"))%>% filter(!(algorithm=="Marxan"&run=="run_M.2"))%>% filter(!(algorithm=="Marxan"&run=="run_M.1"))%>% filter(run!="run_A.5")%>% filter(run!="run_A.4")%>% filter(run!="run_A.3")%>% filter(run!="run_A.2")%>% filter(run!="run_A.1")
# df=a %>% mutate(bycatch=rowMeans(.[,2:4])) %>% mutate(eval=Swordfish-bycatch)
# bb=df[order(-df$eval),]
# blank=bb %>% mutate(M_cor=1:nrow(bb))
# 
# #2. greatest slopes per species
# a=Mar[complete.cases(Mar),] %>% filter(stat=="Slope")%>% filter(!(algorithm=="Marxan"&run=="run_M.5"))%>% filter(!(algorithm=="Marxan"&run=="run_M.4"))%>% filter(!(run=="run_M.3"))%>% filter(!(algorithm=="Marxan"&run=="run_M.2"))%>% filter(!(algorithm=="Marxan"&run=="run_M.1"))
# df=a %>% filter(Swordfish>0) %>% filter(Leatherback<0)%>% filter(Blueshark<0)%>% filter(Sealion<0)
# df=df %>% mutate(bycatch=rowMeans(.[,2:4])) %>% mutate(eval=Swordfish-bycatch)
# bb=df[order(-df$eval),]%>% mutate(M_slope=1:nrow(df)) %>% select(run,11)
# blank=left_join(blank,bb)
# 
# #3. greatest y intercepts per species
# a=Mar[complete.cases(Mar),] %>% filter(stat=="Intercept")%>% filter(!(algorithm=="Marxan"&run=="run_M.5"))%>% filter(!(algorithm=="Marxan"&run=="run_M.4"))%>% filter(!(run=="run_M.3"))%>% filter(!(algorithm=="Marxan"&run=="run_M.2"))%>% filter(!(algorithm=="Marxan"&run=="run_M.1"))
# df=a %>% mutate(bycatch=rowMeans(.[,2:4])) %>% mutate(eval=bycatch-Swordfish)
# bb=df[order(-df$eval),]%>% mutate(M_int=1:nrow(df)) %>% select(run,11)
# blank=left_join(blank,bb)
# blank[order(blank$M_cor),]
# 
# ### Mar cold
# Mar=empty %>% filter(algorithm=="Marxan"&time=="cold") ## L.2, 3rd cor, 7th int
# 
# #1. greatest difference in correlations between swor and bycatch
# a=Mar[complete.cases(Mar),] %>% filter(stat=="Cor")%>% filter(!(algorithm=="Marxan"&run=="run_M.5"))%>% filter(!(algorithm=="Marxan"&run=="run_M.4"))%>% filter(!(algorithm=="Marxan"&run=="run_M.3"))%>% filter(!(algorithm=="Marxan"&run=="run_M.2"))%>% filter(!(algorithm=="Marxan"&run=="run_M.1"))%>% filter(run!="run_A.5")%>% filter(run!="run_A.4")%>% filter(run!="run_A.3")%>% filter(run!="run_A.2")%>% filter(run!="run_A.1")
# df=a %>% mutate(bycatch=rowMeans(.[,2:4])) %>% mutate(eval=Swordfish-bycatch)
# bb=df[order(-df$eval),]
# blank=bb %>% mutate(M_cor=1:nrow(bb))
# 
# #2. greatest slopes per species
# a=Mar[complete.cases(Mar),] %>% filter(stat=="Slope")%>% filter(!(algorithm=="Marxan"&run=="run_M.5"))%>% filter(!(algorithm=="Marxan"&run=="run_M.4"))%>% filter(!(run=="run_M.3"))%>% filter(!(algorithm=="Marxan"&run=="run_M.2"))%>% filter(!(algorithm=="Marxan"&run=="run_M.1"))
# df=a %>% filter(Swordfish>0) %>% filter(Leatherback<0)%>% filter(Blueshark<0)%>% filter(Sealion<0)
# df=df %>% mutate(bycatch=rowMeans(.[,2:4])) %>% mutate(eval=Swordfish-bycatch)
# bb=df[order(-df$eval),]%>% mutate(M_slope=1:nrow(df)) %>% select(run,11)
# blank=left_join(blank,bb)
# 
# #3. greatest y intercepts per species
# a=Mar[complete.cases(Mar),] %>% filter(stat=="Intercept")%>% filter(!(algorithm=="Marxan"&run=="run_M.5"))%>% filter(!(algorithm=="Marxan"&run=="run_M.4"))%>% filter(!(run=="run_M.3"))%>% filter(!(algorithm=="Marxan"&run=="run_M.2"))%>% filter(!(algorithm=="Marxan"&run=="run_M.1"))
# df=a %>% mutate(bycatch=rowMeans(.[,2:4])) %>% mutate(eval=bycatch-Swordfish)
# bb=df[order(-df$eval),]%>% mutate(M_int=1:nrow(df)) %>% select(run,11)
# blank=left_join(blank,bb)
# blank[order(blank$M_cor),]
# 
# ### eco warm
# Mar=empty %>% filter(algorithm=="EcoROMS"&time=="warm") ## J.6, 1 cor, 5th int, 4th slope
# 
# #1. greatest difference in correlations between swor and bycatch
# a=Mar[complete.cases(Mar),] %>% filter(stat=="Cor")%>% filter(!(algorithm=="Marxan"&run=="run_M.5"))%>% filter(!(algorithm=="Marxan"&run=="run_M.4"))%>% filter(!(algorithm=="Marxan"&run=="run_M.3"))%>% filter(!(algorithm=="Marxan"&run=="run_M.2"))%>% filter(!(algorithm=="Marxan"&run=="run_M.1"))%>% filter(run!="run_A.5")%>% filter(run!="run_A.4")%>% filter(run!="run_A.3")%>% filter(run!="run_A.2")%>% filter(run!="run_A.1")
# df=a %>% mutate(bycatch=rowMeans(.[,2:4])) %>% mutate(eval=Swordfish-bycatch)
# bb=df[order(-df$eval),]
# blank=bb %>% mutate(M_cor=1:nrow(bb))
# 
# #2. greatest slopes per species
# a=Mar[complete.cases(Mar),] %>% filter(stat=="Slope")%>% filter(!(algorithm=="Marxan"&run=="run_M.5"))%>% filter(!(algorithm=="Marxan"&run=="run_M.4"))%>% filter(!(run=="run_M.3"))%>% filter(!(algorithm=="Marxan"&run=="run_M.2"))%>% filter(!(algorithm=="Marxan"&run=="run_M.1"))
# df=a %>% filter(Swordfish>0) %>% filter(Leatherback<0)%>% filter(Blueshark<0)%>% filter(Sealion<0)
# df=df %>% mutate(bycatch=rowMeans(.[,2:4])) %>% mutate(eval=Swordfish-bycatch)
# bb=df[order(-df$eval),]%>% mutate(M_slope=1:nrow(df)) %>% select(run,11)
# blank=left_join(blank,bb)
# 
# #3. greatest y intercepts per species
# a=Mar[complete.cases(Mar),] %>% filter(stat=="Intercept")%>% filter(!(algorithm=="Marxan"&run=="run_M.5"))%>% filter(!(algorithm=="Marxan"&run=="run_M.4"))%>% filter(!(run=="run_M.3"))%>% filter(!(algorithm=="Marxan"&run=="run_M.2"))%>% filter(!(algorithm=="Marxan"&run=="run_M.1"))
# df=a %>% mutate(bycatch=rowMeans(.[,2:4])) %>% mutate(eval=bycatch-Swordfish)
# bb=df[order(-df$eval),]%>% mutate(M_int=1:nrow(df)) %>% select(run,11)
# blank=left_join(blank,bb)
# blank[order(blank$M_cor),]
# 
# 
# ### eco cold
# Mar=empty %>% filter(algorithm=="EcoROMS"&time=="cold") ## J.6, 1 cor, 5th int, 4th slope
# 
# #1. greatest difference in correlations between swor and bycatch
# a=Mar[complete.cases(Mar),] %>% filter(stat=="Cor")%>% filter(!(algorithm=="Marxan"&run=="run_M.5"))%>% filter(!(algorithm=="Marxan"&run=="run_M.4"))%>% filter(!(algorithm=="Marxan"&run=="run_M.3"))%>% filter(!(algorithm=="Marxan"&run=="run_M.2"))%>% filter(!(algorithm=="Marxan"&run=="run_M.1"))%>% filter(run!="run_A.5")%>% filter(run!="run_A.4")%>% filter(run!="run_A.3")%>% filter(run!="run_A.2")%>% filter(run!="run_A.1")
# df=a %>% mutate(bycatch=rowMeans(.[,2:4])) %>% mutate(eval=Swordfish-bycatch)
# bb=df[order(-df$eval),]
# blank=bb %>% mutate(M_cor=1:nrow(bb))
# 
# #2. greatest slopes per species
# a=Mar[complete.cases(Mar),] %>% filter(stat=="Slope")%>% filter(!(algorithm=="Marxan"&run=="run_M.5"))%>% filter(!(algorithm=="Marxan"&run=="run_M.4"))%>% filter(!(run=="run_M.3"))%>% filter(!(algorithm=="Marxan"&run=="run_M.2"))%>% filter(!(algorithm=="Marxan"&run=="run_M.1"))
# df=a %>% filter(Swordfish>0) %>% filter(Leatherback<0)%>% filter(Blueshark<0)%>% filter(Sealion<0)
# df=df %>% mutate(bycatch=rowMeans(.[,2:4])) %>% mutate(eval=Swordfish-bycatch)
# bb=df[order(-df$eval),]%>% mutate(M_slope=1:nrow(df)) %>% select(run,11)
# blank=left_join(blank,bb)
# 
# #3. greatest y intercepts per species
# a=Mar[complete.cases(Mar),] %>% filter(stat=="Intercept")%>% filter(!(algorithm=="Marxan"&run=="run_M.5"))%>% filter(!(algorithm=="Marxan"&run=="run_M.4"))%>% filter(!(run=="run_M.3"))%>% filter(!(algorithm=="Marxan"&run=="run_M.2"))%>% filter(!(algorithm=="Marxan"&run=="run_M.1"))
# df=a %>% mutate(bycatch=rowMeans(.[,2:4])) %>% mutate(eval=bycatch-Swordfish)
# bb=df[order(-df$eval),]%>% mutate(M_int=1:nrow(df)) %>% select(run,11)
# blank=left_join(blank,bb)
# blank[order(blank$M_int),]
# 
# 
