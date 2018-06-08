csvdir="hindcast_ms/summarize/csvs/"
plotdir="hindcast_ms/summarize/plots/"
library(plotly)
run="A-C"

file_list=list.files(csvdir,pattern = "availcatch_algorithm")
master=list()
for (file in file_list){
  a=read.csv(paste0(csvdir,file))
  name=gsub("_availcatch_algorithm_comparison.csv","",file)
  a$run=name
  assign(name,a)
  master[[name]]<-a
}

fullon=do.call("rbind",master)
df=fullon %>% filter(limit_target=="swordfish")
df$product=gsub("EcorROMS","EcoROMS",df$product)

colorCount=length(unique(df$run))
getPalette = colorRampPalette(brewer.pal(11, "Spectral"))
mycolors=c(brewer.pal("Greens",n=5),brewer.pal("Blues",n=5),brewer.pal("Reds",n=5))

a=ggplot(df,aes(x=swor,y=lbst,group=run,color=run))+geom_line()+geom_point(size=.5) +facet_wrap(~product,nrow=1)
a=a+ggtitle(label = "Trade-offs between swordfish availability and leatherback bycatch for each algorithm and run")+labs(x=paste0("% of swordfish available to catch"))+labs(y="% of leathbacks bycaught")
a=a+theme(panel.background = element_rect(fill=NA,color="black"),strip.background =element_rect(fill=NA))+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8),axis.text = element_text(size=8),plot.title = element_text(hjust = 0,size = 9))
a=a+scale_color_manual(values=mycolors)
a=a+theme(legend.title = element_text(size=5),legend.position=c(.13,.9),legend.justification = c(.9,.9))+theme(legend.background = element_blank())+theme(legend.text=element_text(size=8),legend.box.background = element_rect(colour = "black"))+theme(legend.key=element_blank())+theme(legend.key.size = unit(.9,'lines'))
b=a
#a=ggplotly(a)

df2=fullon %>% filter(limit_target=="leatherback")
df2$product=gsub("EcorROMS","EcoROMS",df$product)

a=ggplot(df2,aes(x=lbst,y=swor,group=run,color=run))+geom_line()+geom_point(size=.5) +facet_wrap(~product,nrow=1)
a=a+ggtitle(label = "Trade-offs between leatherback bycatch and swordfish availability for each algorithm and run")+labs(x=paste0("% of leathbacks bycaught"))+labs(y="% of swordfish available to catch")
a=a+theme(panel.background = element_rect(fill=NA,color="black"),strip.background =element_rect(fill=NA))+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8),axis.text = element_text(size=8),plot.title = element_text(hjust = 0,size = 9))
a=a+scale_color_manual(values=mycolors)
a=a+theme(legend.title = element_text(size=5),legend.position=c(.9,.4),legend.justification = c(.9,.9))+theme(legend.background = element_blank())+theme(legend.text=element_text(size=8),legend.box.background = element_rect(colour = "black"))+theme(legend.key=element_blank())+theme(legend.key.size = unit(.9,'lines'))


png(paste0(plotdir,run,"_weightingsXalgorithm.png"),width=12, height=12, units="in", res=400)
par(ps=10)
par(mar=c(4,4,1,1))
par(cex=1)
plot_grid(b,a,nrow=2,ncol=1)
dev.off()
