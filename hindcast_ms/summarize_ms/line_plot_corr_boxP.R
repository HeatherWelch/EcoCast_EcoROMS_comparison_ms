### grabs c from end of line_plot_corr.R

datadir="hindcast_ms/extract/extractions/"
plotdir_ms="~/Dropbox/EcoEast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/hindcast_ms/summarize_ms/plots/"#;dir.create(plotdir_ms)
library(scales)
library(fmsb)
source("load_functions.R")

c=c %>% gather(species,value,-c(Algorithm,run,id,best,best_value,id2,sum))
c$best=as.factor(c$best)

a=ggplot(data=c,aes(x=best,y=value,color=species))+geom_boxplot()
a=a+scale_x_discrete(labels=c("Obj 1","Obj 2","Obj 3"))+ylab("Correlation coefficient [R]")+xlab("Management objective")+
  scale_color_manual("Species",values=c("Leatherback"="darkgoldenrod","Swordfish"="cornflowerblue","Blueshark"="coral1","Sealion"="aquamarine4"))+
  geom_hline(yintercept=0)+
  theme(text = element_text(size=5),axis.text = element_text(size=5),legend.key.size = unit(.5,'lines'),plot.title = element_text(hjust=0,size=5))
a

png(paste0(plotdir_ms,"parellel_coordinate_plot_correlations_box_plot.png"),width=7, height=3.5, units="in", res=400)
par(ps=10)
par(cex=1)
par(mar=c(4,4,1,1))
plot_grid(a)
dev.off()
