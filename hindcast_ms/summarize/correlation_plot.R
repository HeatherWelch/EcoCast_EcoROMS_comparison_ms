## correlation plont

datadir="hindcast_ms/extract/extractions/"
library(corrplot)

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

a=fullon %>% mutate(blsh=(blshobs+blshtrk)/2) %>% select(-c(X,lon,lat,dt,run,blshobs,blshtrk)) %>% select(-c(EcoROMS_original,Marxan_raw))
b=cor(a)
corrplot(b, method="color",type="upper", 
         addCoef.col = "black")
