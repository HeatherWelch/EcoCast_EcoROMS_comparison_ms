## script to hindcast the effect of algorithm x weighting on available catch for all species

agorithm_comparison_multispecies=function(run,csvdir,datadir){
data=read.csv(paste0(datadir,"run_",run,".csv"))
empty=read.csv(paste0(csvdir,run,"_thresholds_algorithm_comparison.csv")) %>% filter(limit_target=="leatherback")

master=data.frame(product=NA,blshobs=NA,blshtrk=NA,casl=NA,lbst=NA,swor=NA)
for(i in 1:nrow(empty)){
  tablecaughtE=data %>% dplyr::select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw,Marxan_raw_unscaled,EcoROMS_original_unscaled)) %>% gather(product,product_value,-c(species,suitability)) %>% dplyr::filter(suitability>=.5) %>% dplyr::filter(product_value>empty$EcoROMS_original[i]) %>% 
    dplyr::filter(product=="EcoROMS_original")%>% group_by(species,product) %>% summarise(num_presences_caught=n()) 
  if(nrow(tablecaughtE)==0){tablecaughtE=tablecaughtE %>% ungroup() %>% add_row(species=c("lbst","swor"),product="EcorROMS_original",num_presences_caught=0) %>% group_by(species,product)}
  
  tablecaughtM=data %>% dplyr::select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw,Marxan_raw_unscaled,EcoROMS_original_unscaled)) %>% gather(product,product_value,-c(species,suitability)) %>% dplyr::filter(suitability>=.5) %>% dplyr::filter(product_value>empty$Marxan_raw[i]) %>%
    dplyr::filter(product=="Marxan_raw")%>% group_by(species,product) %>% summarise(num_presences_caught=n()) 
  if(nrow(tablecaughtM)==0){tablecaughtM=tablecaughtM %>% ungroup() %>% add_row(species=c("lbst","swor"),product="Marxan_raw",num_presences_caught=0) %>% group_by(species,product)}
  tablecaughtM=tablecaughtM %>% rbind(.,tablecaughtE)
  
  tablecaughtEuS=data %>% dplyr::select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw,Marxan_raw_unscaled,EcoROMS_original_unscaled)) %>% gather(product,product_value,-c(species,suitability)) %>% dplyr::filter(suitability>=.5) %>% dplyr::filter(product_value>empty$EcoROMS_original_unscaled[i]) %>%
    dplyr::filter(product=="EcoROMS_original_unscaled")%>% group_by(species,product) %>% summarise(num_presences_caught=n())  
  if(nrow(tablecaughtEuS)==0){tablecaughtEuS=tablecaughtEuS %>% ungroup() %>% add_row(species=c("lbst","swor"),product="EcoROMS_original_unscaled",num_presences_caught=0) %>% group_by(species,product)}
  tablecaughtEuS=tablecaughtEuS %>% rbind(.,tablecaughtM)
  
  tablecaughtMEuS=data %>% dplyr::select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw,Marxan_raw_unscaled,EcoROMS_original_unscaled)) %>% gather(product,product_value,-c(species,suitability)) %>% dplyr::filter(suitability>=.5) %>% dplyr::filter(product_value>empty$Marxan_raw_unscaled[i]) %>%
    dplyr::filter(product=="Marxan_raw_unscaled")%>% group_by(species,product) %>% summarise(num_presences_caught=n())  
  if(nrow(tablecaughtMEuS)==0){tablecaughtMEuS=tablecaughtMEuS %>% ungroup() %>% add_row(species=c("lbst","swor"),product="Marxan_raw_unscaled",num_presences_caught=0) %>% group_by(species,product)}
  tablecaughtMEuS=tablecaughtMEuS %>% rbind(.,tablecaughtEuS)
  
  tabletotal=data %>% dplyr::select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw,Marxan_raw_unscaled,EcoROMS_original_unscaled)) %>% gather(product,product_value,-c(species,suitability)) %>% dplyr::filter(suitability>=.5) %>%
    group_by(species,product) %>% summarise(num_presences=n()) %>% left_join(tablecaughtMEuS,.) %>% mutate(Percent_caught=num_presences_caught/num_presences*100) %>% dplyr::select(-c(num_presences,num_presences_caught)) %>% spread(species,Percent_caught) 
  
  if(("lbst"%in%colnames(tabletotal))==F){tabletotal$lbst=0}
  if(("swor"%in%colnames(tabletotal))==F){tabletotal$swor=0}
  if(("blshobs"%in%colnames(tabletotal))==F){tabletotal$blshobs=0}
  if(("blshtrk"%in%colnames(tabletotal))==F){tabletotal$blshtrk=0}
  if(("casl"%in%colnames(tabletotal))==F){tabletotal$casl=0}
  
  tabletotal=tabletotal %>% as.data.frame()
  tabletotal[is.na(tabletotal)]<-0
  
  master=rbind(master,tabletotal)
} ## find trade-offs at catch limits
master=master[complete.cases(master),]
master$limit_target="leatherback"

write.csv(master, paste0(csvdir,run,"_availcatch_algorithm_comparison_multispecies.csv"))
}

# a=plot_ly(data = master,x=~lbst,y=~blshobs,z=~swor,type="scatter3d", mode="markers", color=~product)
# 
# b=master %>% gather (variable, value,-product) %>% .[complete.cases(.),] %>% group_by(product)
# y_levels=levels(factor(0:100))
# ggplot(b, aes(x = variable, y = value, group = product)) +   # group = id is important!
#   geom_path(aes( color = product),
#             alpha = 0.5,
#             lineend = 'round', linejoin = 'round') #+
#   scale_y_discrete(limits = y_levels, expand = c(0, 0)) +
#   scale_size(breaks = NULL, range = c(0, 100))
# summary(b$product)
# 
# 
# 
# df=master %>% select(product,lbst,swor,blshobs,blshtrk,casl)
# df$lbst=round(df$lbst, digits = -1)
# df$id=paste0(df$product,"_",df$lbst)
# b=df %>% gather (variable, value,-c(product,id)) %>% .[complete.cases(.),]
# b$variable=factor(b$variable,levels=c("lbst","swor","blshobs","blshtrk","casl"))
# y_levels=levels(factor(0:100))
# 
# ggplot(b, aes(x = variable, y = value, group = id)) +   # group = id is important!
#   geom_path(aes( color = product),
#             alpha = 0.5,
#             lineend = 'round', linejoin = 'round') +
#    scale_y_continuous(name="% of species available to catch",breaks = seq(0, 100, by = 10), expand = c(0, 0)) +scale_x_discrete(name="Species",labels=c("lbst"="Leatherback","swor"="Swordfish","blshobs"="Blueshark, obs.","blshtrk"="Blueshark, track","casl"="California Sea Lion"), expand = c(0, 0))+
#   scale_size(breaks = NULL, range = c(0, 100))+ggtitle("Comparison of species catch availability between algorithms for different thresholds of allowable leatherback bycatch")
# summary(b$product)
