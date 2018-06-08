

data_cloud=function(data,data_thresh,data5,data5_thresh,run){

subtitle=paste0(namesrisk[1],": ",weightings[1],", ",namesrisk[2],": ",weightings[2],", ",namesrisk[3],": ",weightings[3],", ",namesrisk[4],": ",weightings[4],", ",namesrisk[5],": ",weightings[5])
a=ggplot()+geom_point(data=data,aes(x=swor,y=EcoROMS_original,color="SWOR"),size=.5,shape=1)
a=a+geom_point(data=data,aes(x=lbst,y=EcoROMS_original,color="LBST"),size=.5,shape=1)
a=a+geom_hline(yintercept = data_thresh$EcoROMS_original)+geom_text(aes(x=0,y=data_thresh$EcoROMS_original,label=data_thresh$availcatch,vjust=-.5),size=2)+geom_vline(xintercept = .5)
a=a+ggtitle(label = paste0("Relationship between lbst and swor probability of presence and EcoROMS_original"),subtitle = subtitle)+labs(x="Probability of presence")+labs(y=paste0("EcoROMS_original prediction"))+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=6),axis.text = element_text(size=6),plot.title = element_text(size=6))
a=a+scale_color_manual("Species",values=c("SWOR"="goldenrod","LBST"="chartreuse4"))
a=a+guides(fill=guide_legend(title="Species"))+theme(legend.title = element_text(size=6),legend.position=c(.99,.45),legend.justification = c(.9,.9))+theme(legend.background = element_blank())+theme(legend.text=element_text(size=6),legend.box.background = element_rect(colour = "black"))+ theme(legend.key=element_blank()) +guides(color=guide_legend(override.aes = list(shape=c(1,1))))


subtitle=paste0(namesrisk[1],": ",weightings5[1],", ",namesrisk[2],": ",weightings5[2],", ",namesrisk[3],": ",weightings5[3],", ",namesrisk[4],": ",weightings5[4],", ",namesrisk[5],": ",weightings5[5])
b=ggplot()+geom_point(data=data5,aes(x=swor,y=EcoROMS_original,color="SWOR"),size=.5,shape=1)
b=b+geom_point(data=data5,aes(x=lbst,y=EcoROMS_original,color="LBST"),size=.5,shape=1)
b=b+geom_hline(yintercept = data5_thresh$EcoROMS_original)+geom_text(aes(x=0,y=data5_thresh$EcoROMS_original,label=data5_thresh$availcatch,vjust=-.5),size=2)+geom_vline(xintercept = .5)
b=b+ggtitle(label = paste0("Relationship between lbst and swor probability of presence and EcoROMS_original"),subtitle = subtitle)+labs(x="Probability of presence")+labs(y=paste0("EcoROMS_original prediction"))+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=6),axis.text = element_text(size=6),plot.title = element_text(size=6))
b=b+scale_color_manual("Species",values=c("SWOR"="goldenrod","LBST"="chartreuse4"))
b=b+guides(fill=guide_legend(title="Species"))+theme(legend.title = element_text(size=6),legend.position=c(.99,.45),legend.justification = c(.9,.9))+theme(legend.background = element_blank())+theme(legend.text=element_text(size=6),legend.box.background = element_rect(colour = "black"))+ theme(legend.key=element_blank()) +guides(color=guide_legend(override.aes = list(shape=c(1,1))))


subtitle=paste0(namesrisk[1],": ",weightings[1],", ",namesrisk[2],": ",weightings[2],", ",namesrisk[3],": ",weightings[3],", ",namesrisk[4],": ",weightings[4],", ",namesrisk[5],": ",weightings[5])
c=ggplot()+geom_point(data=data,aes(x=swor,y=EcoROMS_original_unscaled,color="SWOR"),size=.5,shape=1)
c=c+geom_point(data=data,aes(x=lbst,y=EcoROMS_original_unscaled,color="LBST"),size=.5,shape=1)
c=c+geom_hline(yintercept = data_thresh$EcoROMS_original_unscaled)+geom_text(aes(x=0,y=data_thresh$EcoROMS_original_unscaled,label=data_thresh$availcatch,vjust=-.5),size=2)+geom_vline(xintercept = .5)
c=c+ggtitle(label = paste0("Relationship between lbst and swor probability of presence and EcoROMS_original_unscaled"),subtitle = subtitle)+labs(x="Probability of presence")+labs(y=paste0("EcoROMS_original_unscaled prediction"))+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=6),axis.text = element_text(size=6),plot.title = element_text(size=6))
c=c+scale_color_manual("Species",values=c("SWOR"="goldenrod","LBST"="chartreuse4"))
c=c+guides(fill=guide_legend(title="Species"))+theme(legend.title = element_text(size=6),legend.position=c(.99,.45),legend.justification = c(.9,.9))+theme(legend.background = element_blank())+theme(legend.text=element_text(size=6),legend.box.background = element_rect(colour = "black"))+ theme(legend.key=element_blank()) +guides(color=guide_legend(override.aes = list(shape=c(1,1))))


subtitle=paste0(namesrisk[1],": ",weightings5[1],", ",namesrisk[2],": ",weightings5[2],", ",namesrisk[3],": ",weightings5[3],", ",namesrisk[4],": ",weightings5[4],", ",namesrisk[5],": ",weightings5[5])
d=ggplot()+geom_point(data=data5,aes(x=swor,y=EcoROMS_original_unscaled,color="SWOR"),size=.5,shape=1)
d=d+geom_point(data=data5,aes(x=lbst,y=EcoROMS_original_unscaled,color="LBST"),size=.5,shape=1)
d=d+geom_hline(yintercept = data5_thresh$EcoROMS_original_unscaled)+geom_text(aes(x=0,y=data5_thresh$EcoROMS_original_unscaled,label=data5_thresh$availcatch,vjust=-.5),size=2)+geom_vline(xintercept = .5)
d=d+ggtitle(label = paste0("Relationship between lbst and swor probability of presence and EcoROMS_original_unscaled"),subtitle = subtitle)+labs(x="Probability of presence")+labs(y=paste0("EcoROMS_original_unscaled prediction"))+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=6),axis.text = element_text(size=6),plot.title = element_text(size=6))
d=d+scale_color_manual("Species",values=c("SWOR"="goldenrod","LBST"="chartreuse4"))
d=d+guides(fill=guide_legend(title="Species"))+theme(legend.title = element_text(size=6),legend.position=c(.99,.45),legend.justification = c(.9,.9))+theme(legend.background = element_blank())+theme(legend.text=element_text(size=6),legend.box.background = element_rect(colour = "black"))+ theme(legend.key=element_blank()) +guides(color=guide_legend(override.aes = list(shape=c(1,1))))


subtitle=paste0(namesrisk[1],": ",weightings[1],", ",namesrisk[2],": ",weightings[2],", ",namesrisk[3],": ",weightings[3],", ",namesrisk[4],": ",weightings[4],", ",namesrisk[5],": ",weightings[5])
e=ggplot()+geom_point(data=data,aes(x=swor,y=Marxan_raw,color="SWOR"),size=.5,shape=1)
e=e+geom_point(data=data,aes(x=lbst,y=Marxan_raw,color="LBST"),size=.5,shape=1)
e=e+geom_hline(yintercept = data_thresh$Marxan_raw)+geom_text(aes(x=0,y=data_thresh$Marxan_raw,label=data_thresh$availcatch,vjust=-.5),size=2)+geom_vline(xintercept = .5)
e=e+ggtitle(label = paste0("Relationship between lbst and swor probability of presence and Marxan_raw"),subtitle = subtitle)+labs(x="Probability of presence")+labs(y=paste0("Marxan_raw prediction"))+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=6),axis.text = element_text(size=6),plot.title = element_text(size=6))
e=e+scale_color_manual("Species",values=c("SWOR"="goldenrod","LBST"="chartreuse4"))
e=e+guides(fill=guide_legend(title="Species"))+theme(legend.title = element_text(size=6),legend.position=c(.99,.45),legend.justification = c(.9,.9))+theme(legend.background = element_blank())+theme(legend.text=element_text(size=6),legend.box.background = element_rect(colour = "black"))+ theme(legend.key=element_blank()) +guides(color=guide_legend(override.aes = list(shape=c(1,1))))


subtitle=paste0(namesrisk[1],": ",weightings5[1],", ",namesrisk[2],": ",weightings5[2],", ",namesrisk[3],": ",weightings5[3],", ",namesrisk[4],": ",weightings5[4],", ",namesrisk[5],": ",weightings5[5])
f=ggplot()+geom_point(data=data5,aes(x=swor,y=Marxan_raw,color="SWOR"),size=.5,shape=1)
f=f+geom_point(data=data5,aes(x=lbst,y=Marxan_raw,color="LBST"),size=.5,shape=1)
f=f+geom_hline(yintercept = data5_thresh$Marxan_raw)+geom_text(aes(x=0,y=data5_thresh$Marxan_raw,label=data5_thresh$availcatch,vjust=-.5),size=2)+geom_vline(xintercept = .5)
f=f+ggtitle(label = paste0("Relationship between lbst and swor probability of presence and Marxan_raw"),subtitle = subtitle)+labs(x="Probability of presence")+labs(y=paste0("Marxan_raw prediction"))+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=6),axis.text = element_text(size=6),plot.title = element_text(size=6))
f=f+scale_color_manual("Species",values=c("SWOR"="goldenrod","LBST"="chartreuse4"))
f=f+guides(fill=guide_legend(title="Species"))+theme(legend.title = element_text(size=6),legend.position=c(.99,.45),legend.justification = c(.9,.9))+theme(legend.background = element_blank())+theme(legend.text=element_text(size=6),legend.box.background = element_rect(colour = "black"))+ theme(legend.key=element_blank()) +guides(color=guide_legend(override.aes = list(shape=c(1,1))))


subtitle=paste0(namesrisk[1],": ",weightings[1],", ",namesrisk[2],": ",weightings[2],", ",namesrisk[3],": ",weightings[3],", ",namesrisk[4],": ",weightings[4],", ",namesrisk[5],": ",weightings[5])
g=ggplot()+geom_point(data=data,aes(x=swor,y=Marxan_raw_unscaled,color="SWOR"),size=.5,shape=1)
g=g+geom_point(data=data,aes(x=lbst,y=Marxan_raw_unscaled,color="LBST"),size=.5,shape=1)
g=g+geom_hline(yintercept = data_thresh$Marxan_raw_unscaled)+geom_text(aes(x=0,y=data_thresh$Marxan_raw_unscaled,label=data_thresh$availcatch,vjust=-.5),size=2)+geom_vline(xintercept = .5)
g=g+ggtitle(label = paste0("Relationship between lbst and swor probability of presence and Marxan_raw_unscaled"),subtitle = subtitle)+labs(x="Probability of presence")+labs(y=paste0("Marxan_raw_unscaled prediction"))+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=6),axis.text = element_text(size=6),plot.title = element_text(size=6))
g=g+scale_color_manual("Species",values=c("SWOR"="goldenrod","LBST"="chartreuse4"))
g=g+guides(fill=guide_legend(title="Species"))+theme(legend.title = element_text(size=6),legend.position=c(.99,.45),legend.justification = c(.9,.9))+theme(legend.background = element_blank())+theme(legend.text=element_text(size=6),legend.box.background = element_rect(colour = "black"))+ theme(legend.key=element_blank()) +guides(color=guide_legend(override.aes = list(shape=c(1,1))))


subtitle=paste0(namesrisk[1],": ",weightings5[1],", ",namesrisk[2],": ",weightings5[2],", ",namesrisk[3],": ",weightings5[3],", ",namesrisk[4],": ",weightings5[4],", ",namesrisk[5],": ",weightings5[5])
h=ggplot()+geom_point(data=data5,aes(x=swor,y=Marxan_raw_unscaled,color="SWOR"),size=.5,shape=1)
h=h+geom_point(data=data5,aes(x=lbst,y=Marxan_raw_unscaled,color="LBST"),size=.5,shape=1)
h=h+geom_hline(yintercept = data5_thresh$Marxan_raw_unscaled)+geom_text(aes(x=0,y=data5_thresh$Marxan_raw_unscaled,label=data5_thresh$availcatch,vjust=-.5),size=2)+geom_vline(xintercept = .5)
h=h+ggtitle(label = paste0("Relationship between lbst and swor probability of presence and Marxan_raw_unscaled"),subtitle = subtitle)+labs(x="Probability of presence")+labs(y=paste0("Marxan_raw_unscaled prediction"))+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=6),axis.text = element_text(size=6),plot.title = element_text(size=6))
h=h+scale_color_manual("Species",values=c("SWOR"="goldenrod","LBST"="chartreuse4"))
h=h+guides(fill=guide_legend(title="Species"))+theme(legend.title = element_text(size=6),legend.position=c(.99,.45),legend.justification = c(.9,.9))+theme(legend.background = element_blank())+theme(legend.text=element_text(size=6),legend.box.background = element_rect(colour = "black"))+ theme(legend.key=element_blank()) +guides(color=guide_legend(override.aes = list(shape=c(1,1))))


png(paste0(plotdir,run,"_point_cloud.png"),width=16, height=8, units="in", res=400)
par(ps=10)
par(mar=c(4,4,1,1))
par(cex=1)
print({ plot_grid(a,b,c,d,e,f,g,h,nrow=2,ncol=4)})
#plot_grid(a,b,c,d,e,f,g,h,nrow=2,ncol=4)
dev.off()

}

# #demo run
# source("load_functions.R")
# 
# plotdir="hindcast_ms/summarize/plots/"
# csvdir="hindcast_ms/summarize/csvs/"
# namesrisk<-c("Blue shark bycatch","Blue sharks","Sea lions","Leatherbacks","Swordfish")
# 
# ## scenario A--> isolating the effect of swordfish weightings (5 runs, weightings are the same for both algorithms) (run) #### 
# data=read.csv("hindcast_ms/extract/extractions/run_A.1.csv") 
# data_thresh=read.csv("hindcast_ms/summarize/csvs/A.1_thresholds_algorithm_comparison.csv") %>% filter(limit_target=="leatherback")
# data5=read.csv("hindcast_ms/extract/extractions/run_A.5.csv") 
# data5_thresh=read.csv("hindcast_ms/summarize/csvs/A.5_thresholds_algorithm_comparison.csv") %>% filter(limit_target=="leatherback")
# weightings <-c(0,0,0,0,0.1) #run A.1
# weightings5 <-c(0,0,0,0,0.5) #run A.5
# run="A"
# 
# data_cloud(data=data,data_thresh = data_thresh,data5 = data5,data5_thresh = data5_thresh,run = run)
