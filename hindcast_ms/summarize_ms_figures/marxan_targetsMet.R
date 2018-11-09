### testing if Marxan was able to meet objectives

source("load_functions.R")
source("marxan/marxan_clean_04.10.18.R")

biofeats=c("blshobs","blshtrk_nolat","casl_noLat","lbst_nolat","swor")
cost="swor"
dailypreddir="~/Dropbox/Eco-ROMS/Model Prediction Plots/daily_predictions/"
namesrisk<-c("Blue shark bycatch","Blue sharks","Sea lions","Leatherbacks","Swordfish")

weightings<-c(-0.1,-0.1,-0.05,-0.4,0.2)
dates=list.files("~/Dropbox/Eco-ROMS/EcoROMSruns/output/hindcast/marxan",pattern=".grd") %>% grep("_raw",.,value=T) %>% grep(paste0(weightings,collapse="_"),.,value=T) %>% 
  gsub(paste0("marxan_nocost_",paste0(weightings,collapse="_"),"_"),"",.) %>% gsub("_raw.grd","",.)

weightings <-c(0,0,0,-0.5,0) #run B.3 ####
  get_date=dates[1]
  print(get_date)
  #scp_swor(get_date = get_date,biofeats = biofeats,cost=cost,dailypreddir = dailypreddir,weightings = weightings,namesrisk = namesrisk) step thru this
  B.3=results
  write_rds(B.3,"~/Dropbox/Eco-ROMS/EcoROMSruns/output/hindcast_ms/marxan_objects/B.3.rds")

weightings <-c(0,0,0,-0.5,0.5) #run C.3 ####
  get_date=dates[1]
  print(get_date)
    print(get_date)
    #scp_swor(get_date = get_date,biofeats = biofeats,cost=cost,dailypreddir = dailypreddir,weightings = weightings,namesrisk = namesrisk) step thru this
    C.3=results 
    write_rds(C.3,"~/Dropbox/Eco-ROMS/EcoROMSruns/output/hindcast_ms/marxan_objects/C.3.rds")
    
weightings <-c(-0.25,-0.25,0,-0.5,0.5) #run G.3 (C.3) ####
  get_date=dates[1]
  #scp_swor(get_date = get_date,biofeats = biofeats,cost=cost,dailypreddir = dailypreddir,weightings = weightings,namesrisk = namesrisk) step thru this
  G.3=results 
  write_rds(G.3,"~/Dropbox/Eco-ROMS/EcoROMSruns/output/hindcast_ms/marxan_objects/G.3.rds")
  
weightings <-c(-0.25,-0.25,-0.5,-0.5,0.5) #run J.3 (C.3) ####
  get_date=dates[1]
  #scp_swor(get_date = get_date,biofeats = biofeats,cost=cost,dailypreddir = dailypreddir,weightings = weightings,namesrisk = namesrisk) step thru this
  J.3=results 
  write_rds(J.3,"~/Dropbox/Eco-ROMS/EcoROMSruns/output/hindcast_ms/marxan_objects/J.3.rds")

  #####  
  head(targetsmet(B.3))
  head(targetsmet(C.3))
  head(targetsmet(G.3))
  head(targetsmet(J.3))
  
a=targetsmet(B.3)%>% as.data.frame() %>% select(V4) %>% colMeans() #%>% hist
b=targetsmet(C.3) %>% as.data.frame() %>% select(c(V4,V5)) %>% colMeans() #%>% hist
c=targetsmet(G.3) %>% as.data.frame() %>% select(c(V1,V2,V4,V5)) %>% colMeans() #%>% hist
d=targetsmet(J.3) %>% as.data.frame() %>% colMeans() #%>% hist
  
a=targetsmet(B.3)%>% as.data.frame()  %>% colMeans() #%>% hist
b=targetsmet(C.3) %>% as.data.frame()  %>% colMeans() #%>% hist
c=targetsmet(G.3) %>% as.data.frame()  %>% colMeans() #%>% hist
d=targetsmet(J.3) %>% as.data.frame() %>% colMeans() #%>% hist

## As ####
weightings <-c(0,0,0,0,0.1) #run A.1
get_date=dates[1]
print(get_date)
results=scp_swor_targetsMet(get_date = get_date,biofeats = biofeats,cost=cost,dailypreddir = dailypreddir,weightings = weightings,namesrisk = namesrisk) 
write_rds(results,"~/Dropbox/Eco-ROMS/EcoROMSruns/output/hindcast_ms/marxan_objects/A.1.rds")

weightings <-c(0,0,0,0,0.3) #run A.2
get_date=dates[1]
print(get_date)
results=scp_swor_targetsMet(get_date = get_date,biofeats = biofeats,cost=cost,dailypreddir = dailypreddir,weightings = weightings,namesrisk = namesrisk) 
write_rds(results,"~/Dropbox/Eco-ROMS/EcoROMSruns/output/hindcast_ms/marxan_objects/A.2.rds")

weightings <-c(0,0,0,0,0.5) #run A.3
get_date=dates[1]
print(get_date)
results=scp_swor_targetsMet(get_date = get_date,biofeats = biofeats,cost=cost,dailypreddir = dailypreddir,weightings = weightings,namesrisk = namesrisk) 
write_rds(results,"~/Dropbox/Eco-ROMS/EcoROMSruns/output/hindcast_ms/marxan_objects/A.3.rds")

weightings <-c(0,0,0,0,0.7) #run A.4
get_date=dates[1]
print(get_date)
results=scp_swor_targetsMet(get_date = get_date,biofeats = biofeats,cost=cost,dailypreddir = dailypreddir,weightings = weightings,namesrisk = namesrisk) 
write_rds(results,"~/Dropbox/Eco-ROMS/EcoROMSruns/output/hindcast_ms/marxan_objects/A.4.rds")

weightings <-c(0,0,0,0,0.9) #run A.5
get_date=dates[1]
print(get_date)
results=scp_swor_targetsMet(get_date = get_date,biofeats = biofeats,cost=cost,dailypreddir = dailypreddir,weightings = weightings,namesrisk = namesrisk) 
write_rds(results,"~/Dropbox/Eco-ROMS/EcoROMSruns/output/hindcast_ms/marxan_objects/A.5.rds")


## Bs ####
weightings <-c(0,0,0,-0.1,0) #run B.1
get_date=dates[1]
print(get_date)
results=scp_swor_targetsMet(get_date = get_date,biofeats = biofeats,cost=cost,dailypreddir = dailypreddir,weightings = weightings,namesrisk = namesrisk) 
write_rds(results,"~/Dropbox/Eco-ROMS/EcoROMSruns/output/hindcast_ms/marxan_objects/B.1.rds")

weightings <-c(0,0,0,-0.3,0) #run B.2
get_date=dates[1]
print(get_date)
results=scp_swor_targetsMet(get_date = get_date,biofeats = biofeats,cost=cost,dailypreddir = dailypreddir,weightings = weightings,namesrisk = namesrisk) 
write_rds(results,"~/Dropbox/Eco-ROMS/EcoROMSruns/output/hindcast_ms/marxan_objects/B.2.rds")

weightings <-c(0,0,0,-0.5,0) #run B.3
get_date=dates[1]
print(get_date)
results=scp_swor_targetsMet(get_date = get_date,biofeats = biofeats,cost=cost,dailypreddir = dailypreddir,weightings = weightings,namesrisk = namesrisk) 
write_rds(results,"~/Dropbox/Eco-ROMS/EcoROMSruns/output/hindcast_ms/marxan_objects/B.3.rds")

weightings <-c(0,0,0,-0.7,0) #run B.4
get_date=dates[1]
print(get_date)
results=scp_swor_targetsMet(get_date = get_date,biofeats = biofeats,cost=cost,dailypreddir = dailypreddir,weightings = weightings,namesrisk = namesrisk) 
write_rds(results,"~/Dropbox/Eco-ROMS/EcoROMSruns/output/hindcast_ms/marxan_objects/B.4.rds")

weightings <-c(0,0,0,-0.9,0) #run B.5
get_date=dates[1]
print(get_date)
results=scp_swor_targetsMet(get_date = get_date,biofeats = biofeats,cost=cost,dailypreddir = dailypreddir,weightings = weightings,namesrisk = namesrisk) 
write_rds(results,"~/Dropbox/Eco-ROMS/EcoROMSruns/output/hindcast_ms/marxan_objects/B.5.rds")


## Cs ####
weightings <-c(0,0,0,-0.1,0.1) #run C.1
get_date=dates[1]
print(get_date)
results=scp_swor_targetsMet(get_date = get_date,biofeats = biofeats,cost=cost,dailypreddir = dailypreddir,weightings = weightings,namesrisk = namesrisk) 
write_rds(results,"~/Dropbox/Eco-ROMS/EcoROMSruns/output/hindcast_ms/marxan_objects/C.1.rds")

weightings <-c(0,0,0,-0.3,0.3) #run C.2
get_date=dates[1]
print(get_date)
results=scp_swor_targetsMet(get_date = get_date,biofeats = biofeats,cost=cost,dailypreddir = dailypreddir,weightings = weightings,namesrisk = namesrisk) 
write_rds(results,"~/Dropbox/Eco-ROMS/EcoROMSruns/output/hindcast_ms/marxan_objects/C.2.rds")

weightings <-c(0,0,0,-0.5,0.5) #run C.3
get_date=dates[1]
print(get_date)
results=scp_swor_targetsMet(get_date = get_date,biofeats = biofeats,cost=cost,dailypreddir = dailypreddir,weightings = weightings,namesrisk = namesrisk) 
write_rds(results,"~/Dropbox/Eco-ROMS/EcoROMSruns/output/hindcast_ms/marxan_objects/C.3.rds")

weightings <-c(0,0,0,-0.7,0.7) #run C.4
get_date=dates[1]
print(get_date)
results=scp_swor_targetsMet(get_date = get_date,biofeats = biofeats,cost=cost,dailypreddir = dailypreddir,weightings = weightings,namesrisk = namesrisk) 
write_rds(results,"~/Dropbox/Eco-ROMS/EcoROMSruns/output/hindcast_ms/marxan_objects/C.4.rds")

weightings <-c(0,0,0,-0.9,0.9) #run C.5
get_date=dates[1]
print(get_date)
results=scp_swor_targetsMet(get_date = get_date,biofeats = biofeats,cost=cost,dailypreddir = dailypreddir,weightings = weightings,namesrisk = namesrisk) 
write_rds(results,"~/Dropbox/Eco-ROMS/EcoROMSruns/output/hindcast_ms/marxan_objects/C.5.rds")



####### CORRELATIONS
dailypreddir="~/Dropbox/Eco-ROMS/Model Prediction Plots/daily_predictions/"
speciesdirs=c("blshobs","blshtrk_nolat","casl_noLat","lbst_nolat","swor")
empty=data.frame(blshtrk=NA,blshobs=NA,casl=NA,lbst=NA,swor=NA,run=NA)

a=list.files("~/Dropbox/Eco-ROMS/EcoROMSruns/output/hindcast_ms/marxan_objects/")
for(file in a){
  name=gsub(".rds","",file)
  print(name)
  b=readRDS(file) 
  c=b%>% targetsmet() %>% as.data.frame() %>% colMeans() %>% as.character() %>% as.data.frame() %>% t() %>% as.data.frame() %>% dplyr::mutate(run=name)
  colnames(c)=c("blshtrk","blshobs","casl","lbst","swor","run")
  empty=rbind(empty,c)
}
