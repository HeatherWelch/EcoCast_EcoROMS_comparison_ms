csvdir="hindcast_ms/summarize/csvs/"

file_list=list.files(csvdir) %>% grep("availcatch_algorithm_comparison_multispecies",.,value=T)
master=list()
for (file in file_list){
  a=read.csv(paste0(csvdir,file))
  name=gsub("_availcatch_algorithm_comparison_multispecies.csv","",file)
  a$run=name
  assign(name,a)
  master[[name]]<-a
}

fullon=do.call("rbind",master)
df=fullon %>% dplyr::filter(limit_target=="leatherback")
df$lbst=round(df$lbst, digits = -1)

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



df=df %>% mutate(blueshark=(blshobs+blshtrk)/2) %>% select(product,lbst,swor,blueshark,casl,run) %>% filter(lbst==10)
#df$lbst=round(df$lbst, digits = -1)
df$id=paste0(df$product,"_",df$run)
b=df %>% gather (variable, value,-c(product,id,run)) %>% .[complete.cases(.),]
b$variable=factor(b$variable,levels=c("lbst","swor","blueshark","casl"))
y_levels=levels(factor(0:100))

ggplot(b, aes(x = variable, y = value, group = id)) +   # group = id is important!
  geom_path(aes( color = product),
            alpha = 0.5,
            lineend = 'round', linejoin = 'round') +
   scale_y_continuous(name="% of species available to catch",breaks = seq(0, 100, by = 10), expand = c(0, 0)) +scale_x_discrete(name="Species",labels=c("lbst"="Leatherback","swor"="Swordfish","blueshark"="Blueshark","casl"="California Sea Lion"), expand = c(0, 0))+
  scale_size(breaks = NULL, range = c(0, 100))+ggtitle("Comparison of species catch availability between algorithms for different thresholds of allowable leatherback bycatch")
summary(b$product)
