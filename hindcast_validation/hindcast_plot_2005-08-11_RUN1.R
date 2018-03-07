# step 4. extract all values at all points for hindcast analysis

### ---------------------------- >  RUN 1: GENERIC WEIGHTINGS
namesrisk<-c("Blue shark bycatch","Blue sharks","Sea lions","Leatherbacks","Swordfish")
ER_weightings<-c(-0.1,-0.1,-0.05,-0.9,0.9)
M_weightings<-c(-0.1,-0.1,-0.05,-0.2,0.1)

## load function
source("hindcast_validation/extract_function.R")


##### a. strip observer and tracking data down to date, lat, long, sp_name #####
species=read.csv("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/raw_data/observer_casl_swor_blsh_lbst_roms_2005_08_10.csv") %>% dplyr::select(c("SpCd","dt","lat","lon"))
species$sp_name=NA
species[species$SpCd=="UO","sp_name"]="CASL"
species[species$SpCd=="DC","sp_name"]="LBST"
species[species$SpCd=="91","sp_name"]="SWOR"
species[species$SpCd=="167","sp_name"]="BLSH"

tracking=read.csv("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/raw_data/trk_casl_blsh_lbst_roms_2005_08_10.csv") %>% dplyr::select(c("sp_name","dt","lat","lon"))

#### observer first ####
##### c. run extracto (ecoroms) ####
ecoroms=list.files("~/Dropbox/Eco-ROMS/EcoROMSruns/output/mean",pattern=".grd",full.names = T) %>% grep(paste0(ER_weightings,collapse="_"),.,value=T) #%>% grep("_2005-",.,value=T)
a=extracto_raster(pts=species,algorithm="EcoROMS",solution_list = ecoroms,weightings = ER_weightings)

##### c. run extracto (marxan) ####
marxan_raw=list.files("~/Dropbox/Eco-ROMS/EcoROMSruns/output/marxan",pattern=".grd",full.names = T) %>% grep(paste0(M_weightings,collapse="_"),.,value=T) %>% grep("_raw",.,value=T)
marxan_mosaic=list.files("~/Dropbox/Eco-ROMS/EcoROMSruns/output/marxan",pattern=".grd",full.names = T) %>% grep(paste0(M_weightings,collapse="_"),.,value=T) %>% grep("_mosaic.grd$",.,value=T)
marxan_mosaic01=list.files("~/Dropbox/Eco-ROMS/EcoROMSruns/output/marxan",pattern=".grd",full.names = T) %>% grep(paste0(M_weightings,collapse="_"),.,value=T) %>% grep("_mosaic01.grd$",.,value=T)

a=extracto_raster(pts=a,algorithm="Marxan_raw",solution_list = marxan_raw,weightings = M_weightings)
a=extracto_raster(pts=a,algorithm="Marxan_mosaic",solution_list = marxan_mosaic,weightings = M_weightings)
obs=extracto_raster(pts=a,algorithm="Marxan_mosaic01",solution_list = marxan_mosaic01,weightings = M_weightings) %>% dplyr::select(-SpCd)

## tracking second ####
#### c. run extracto (ecoroms) ####
a=extracto_raster(pts=tracking,algorithm="EcoROMS",solution_list = ecoroms,weightings = ER_weightings)

##### c. run extracto (marxan) ####
a=extracto_raster(pts=a,algorithm="Marxan_raw",solution_list = marxan_raw,weightings = M_weightings)
a=extracto_raster(pts=a,algorithm="Marxan_mosaic",solution_list = marxan_mosaic,weightings = M_weightings)
trk=extracto_raster(pts=a,algorithm="Marxan_mosaic01",solution_list = marxan_mosaic01,weightings = M_weightings)

##### d. make some plots ####
master=rbind(obs,trk)
#write.csv(master,"/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/raw_data/species_predict_2005_08_10_run1.csv")
master=read.csv("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/raw_data/species_predict_2005_08_10_run1.csv")

### boxplots ####
algorithm="EcoROMS"
index=NULL
index=grep(print(algorithm),names(master))
subtitle=paste0(namesrisk[1],": ",ER_weightings[1],", ",namesrisk[2],": ",ER_weightings[2],", ",namesrisk[3],": ",ER_weightings[3],", ",namesrisk[4],": ",ER_weightings[4],", ",namesrisk[5],": ",ER_weightings[5])
a=ggplot(data=master,aes(x=sp_name,y=master[,index]))+geom_boxplot()
a=a+ggtitle(label = paste0("Weighted ", algorithm," predictions at obs & trk data from 2005"),subtitle = subtitle)+labs(x="Species catch events")+labs(y="EcoROMS prediction")+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
png(paste0("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/box_",paste0(ER_weightings,collapse="_"),"_",algorithm,".png"),width=5,height=5,units='in',res=400)
a
dev.off()

algorithm="Marxan_raw"
index=NULL
index=grep(print(algorithm),names(master))
subtitle=paste0(namesrisk[1],": ",M_weightings[1],", ",namesrisk[2],": ",M_weightings[2],", ",namesrisk[3],": ",M_weightings[3],", ",namesrisk[4],": ",M_weightings[4],", ",namesrisk[5],": ",M_weightings[5])
a=ggplot(data=master,aes(x=sp_name,y=master[,index]))+geom_boxplot()
a=a+ggtitle(label = paste0("Weighted ", algorithm," predictions at obs & trk data from 2005"),subtitle = subtitle)+labs(x="Species catch events")+labs(y="EcoROMS prediction")+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
png(paste0("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/box_",paste0(M_weightings,collapse="_"),"_",algorithm,".png"),width=5,height=5,units='in',res=400)
a
dev.off()

algorithm="^Marxan_mosaic$"
index=NULL
index=grep(print(algorithm),names(master))
subtitle=paste0(namesrisk[1],": ",M_weightings[1],", ",namesrisk[2],": ",M_weightings[2],", ",namesrisk[3],": ",M_weightings[3],", ",namesrisk[4],": ",M_weightings[4],", ",namesrisk[5],": ",M_weightings[5])
a=ggplot(data=master,aes(x=sp_name,y=master[,index]))+geom_boxplot()
a=a+ggtitle(label = paste0("Weighted ", algorithm," predictions at obs & trk data from 2005"),subtitle = subtitle)+labs(x="Species catch events")+labs(y="EcoROMS prediction")+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
png(paste0("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/box_",paste0(M_weightings,collapse="_"),"_",algorithm,".png"),width=5,height=5,units='in',res=400)
a
dev.off()

algorithm="^Marxan_mosaic01$"
index=NULL
index=grep(print(algorithm),names(master))
subtitle=paste0(namesrisk[1],": ",M_weightings[1],", ",namesrisk[2],": ",M_weightings[2],", ",namesrisk[3],": ",M_weightings[3],", ",namesrisk[4],": ",M_weightings[4],", ",namesrisk[5],": ",M_weightings[5])
a=ggplot(data=master,aes(x=sp_name,y=master[,index]))+geom_boxplot()
a=a+ggtitle(label = paste0("Weighted ", algorithm," predictions at obs & trk data from 2005"),subtitle = subtitle)+labs(x="Species catch events")+labs(y="EcoROMS prediction")+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
png(paste0("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/plots/box_",paste0(M_weightings,collapse="_"),"_",algorithm,".png"),width=5,height=5,units='in',res=400)
a
dev.off()
