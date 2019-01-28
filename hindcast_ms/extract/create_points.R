### script to create master point (lat,lon,time) csv for common use in following extractions

path = "/Volumes/EcoCast_SeaGate/ERD_DOM/EcoCast_CodeArchive"
staticdir=paste0(path,"/static_variables/")
studyarea=readOGR(dsn=staticdir,layer="sa_square_coast3")
source("load_functions.R")

################## -------------------------------------------------> random data second

regular=spsample(studyarea,n=3000,type="regular")  ### wow dat was easy
datess1=sample(seq(as.Date('2005/08/01'), as.Date('2005/11/30'), by="day"), 1500,replace = T)
datess2=sample(seq(as.Date('1997/10/01'), as.Date('1997/11/30'), by="day"), 750,replace = T)
datess3=sample(seq(as.Date('2003/04/01'), as.Date('2003/04/30'), by="day"), 750,replace = T)
datess=c(datess,datess2,datess3)
species=regular@coords %>% as.tibble() %>% dplyr::select(lon=x1,lat=x2) %>% add_column(dt=datess[1:2976])

write.csv(species,"~/Dropbox/EcoEast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/hindcast_ms/extract/random_points.csv",row.names = F)


datess1=seq(as.Date('2005/08/01'), as.Date('2005/11/30'), by="day")
datess2=seq(as.Date('1997/10/01'), as.Date('1997/11/30'), by="day")
datess3=seq(as.Date('2003/04/01'), as.Date('2003/04/30'), by="day")
datess=c(datess1,datess2,datess3)
