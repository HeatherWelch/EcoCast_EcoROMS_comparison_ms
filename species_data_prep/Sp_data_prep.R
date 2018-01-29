#### code to prepare the EcoCast and EcoROMS species data for analysis
### 1. locate raw species data
### 2. associate EcoCast and EcoROMS extractions with species data
### 3. predict for each species at each raw data point (different script)
### 4. create Eco products under conditions of different species weightings (different script)

## raw observer species data: "~/Dropbox/Eco-ROMS/Species Data/Observer Data"
## "Catch_Life_1990-2017.csv"   = sealions (mammals)
## "Catch_SeaTurtle_1990-2017.csv"  = leatherbacks (turtles)
## "Catch_Spp_1990-2017.csv" = blsh and swor (not sealions not turtles)
## "SpList.csv" = species codes (why are some of these numbers?)
## "Catch_SeaTurtle_1990-2017.csv" = turtles
## species codes: casl: UO ;lbst: DC; swordfish and blsh, extract by name

## extracted observer species data
roms=read_rds("DGN_allSets_1990-2017_ROMSExtracted.rds")

##----->end output, csv of swor blsh casl lbst tripNumber_sets w associated ROMS data

library(tidyverse)

### 1. locate raw species data
casl=read.csv("Catch_Life_1990-2017.csv") %>% filter(SpCd=="UO")%>% mutate(SpCd=as.character(SpCd))
swor=read.csv("Catch_Spp_1990-2017.csv") %>% filter(ScientificName=="Xiphias gladius") %>% select(TripNumber_Set,SpCd,TotCat) %>% mutate(SpCd=as.character(SpCd))
blsh=read.csv("Catch_Spp_1990-2017.csv") %>% filter(ScientificName=="Prionace glauca") %>% select(TripNumber_Set,SpCd,TotCat)%>% mutate(SpCd=as.character(SpCd))
lbst=read.csv("Catch_SeaTurtle_1990-2017.csv") %>% filter(SpCd=="DC") %>% mutate(TripNumber_Set=paste0(TripNumber_Set))  %>% select(TripNumber_Set,SpCd) %>% mutate(TotCat=1)%>% mutate(SpCd=as.character(SpCd))

species=do.call("rbind",list(casl,swor,blsh,lbst)) %>% as.tibble() ### final species data frame, raw
write.csv(species,"/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/raw_data/observer_casl_swor_blsh_lbst_raw.csv")

### 2. associate EcoCast and EcoROMS extractions with species data
### ---------------------------------------> EcoROMS
species_roms=inner_join(species,roms,by="TripNumber_Set")
write.csv(species,"/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/raw_data/observer_casl_swor_blsh_lbst_roms.csv")

