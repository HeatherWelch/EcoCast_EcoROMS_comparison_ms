### r script to clean up Run A - misunderstood how the swordfish weighting works, really needs to get smaller because the swordfish values are inversed. so now the weightings will be subtracted from one
#e.g. lbst .3 means protect 30% of lbst habitat
#e.g. swor .3 means protect 70% of unsuitable habitat for swordfish
#e.g. swor .7 means protect 30% of unsuitable habitat for swordfish

## run A was already run with the weightings not reversed, copying and renaming now into /marxan_run_A
preddir="~/Dropbox/Eco-ROMS/EcoROMSruns/output/hindcast_ms/"
todir="~/Dropbox/Eco-ROMS/EcoROMSruns/output/hindcast_ms/marxan_run_A"

## copy

## scenario A--> isolating the effect of swordfish weightings (5 runs, weightings are the same for both algorithms) (running) #### 
## copy renamed files
M_weightings <-c(0,0,0,0,0.1)
a=list.files(paste0(preddir,"marxan"),full.names = T) %>% grep(paste0(M_weightings,collapse="_"),.,value=T) 
b=a %>% gsub("/Users/heatherwelch/Dropbox/Eco-ROMS/EcoROMSruns/output/hindcast_ms/marxan/","/Users/heatherwelch/Dropbox/Eco-ROMS/EcoROMSruns/output/hindcast_ms/marxan_run_A/",.) %>% gsub("_0_0_0_0_0.1_","_0_0_0_0_0.9_",.)
file.copy(a,b)

#.3 becomes .7
M_weightings <-c(0,0,0,0,0.3)
a=list.files(paste0(preddir,"marxan"),full.names = T) %>% grep(paste0(M_weightings,collapse="_"),.,value=T) 
b=a %>% gsub("/Users/heatherwelch/Dropbox/Eco-ROMS/EcoROMSruns/output/hindcast_ms/marxan/","/Users/heatherwelch/Dropbox/Eco-ROMS/EcoROMSruns/output/hindcast_ms/marxan_run_A/",.) %>%  gsub("_0_0_0_0_0.3_","_0_0_0_0_0.7_",.)
file.copy(a,b)

#.5 stays .5
M_weightings <-c(0,0,0,0,0.5)
a=list.files(paste0(preddir,"marxan"),full.names = T) %>% grep(paste0(M_weightings,collapse="_"),.,value=T) 
b=a %>% gsub("/Users/heatherwelch/Dropbox/Eco-ROMS/EcoROMSruns/output/hindcast_ms/marxan/","/Users/heatherwelch/Dropbox/Eco-ROMS/EcoROMSruns/output/hindcast_ms/marxan_run_A/",.)
file.copy(a,b)

#.7 becomes .3
M_weightings <-c(0,0,0,0,0.7)
a=list.files(paste0(preddir,"marxan"),full.names = T) %>% grep(paste0(M_weightings,collapse="_"),.,value=T) 
b=a %>% gsub("/Users/heatherwelch/Dropbox/Eco-ROMS/EcoROMSruns/output/hindcast_ms/marxan/","/Users/heatherwelch/Dropbox/Eco-ROMS/EcoROMSruns/output/hindcast_ms/marxan_run_A/",.) %>% gsub("_0_0_0_0_0.7_","_0_0_0_0_0.3_",.)
file.copy(a,b)

#.9 becomes .1
M_weightings <-c(0,0,0,0,0.9)
a=list.files(paste0(preddir,"marxan"),full.names = T) %>% grep(paste0(M_weightings,collapse="_"),.,value=T) 
b=a %>% gsub("/Users/heatherwelch/Dropbox/Eco-ROMS/EcoROMSruns/output/hindcast_ms/marxan/","/Users/heatherwelch/Dropbox/Eco-ROMS/EcoROMSruns/output/hindcast_ms/marxan_run_A/",.) %>% gsub("_0_0_0_0_0.9_","_0_0_0_0_0.1_",.)
file.copy(a,b)

# products=list(a,b,c,d,e,f,g,h,i,j) %>% unlist()
# lapply(products,function(x) file.copy(x,todir))
# 
# ## rename files
# 
# M_weightings <-c(0,0,0,0,0.1)
# fromA=list.files(todir,full.names = T) %>% grep(paste0(M_weightings,collapse="_"),.,value=T)
# toA=fromA %>% gsub("_0_0_0_0_0.1_","_0_0_0_0_0.9_",.)
# 
# M_weightings <-c(0,0,0,0,0.3)
# fromB=list.files(todir,full.names = T) %>% grep(paste0(M_weightings,collapse="_"),.,value=T)
# toB=fromA %>% gsub("_0_0_0_0_0.3_","_0_0_0_0_0.7_",.)
# 
# M_weightings <-c(0,0,0,0,0.7)
# fromC=list.files(todir,full.names = T) %>% grep(paste0(M_weightings,collapse="_"),.,value=T)
# toC=fromA %>% gsub("_0_0_0_0_0.7_","_0_0_0_0_0.3_",.)
# 
# M_weightings <-c(0,0,0,0,0.9)
# fromD=list.files(todir,full.names = T) %>% grep(paste0(M_weightings,collapse="_"),.,value=T)
# toD=fromA %>% gsub("_0_0_0_0_0.9_","_0_0_0_0_0.1_",.)

## repredicting raster for Run_A.Rmd

