library(ggplot2)

run4_random_scaling=read.csv("hindcast_app2/data/species_predict_05.02.18_random_scaled_unscaled_run4.csv") %>% .[1:1698,]
run5_random_scaling=read.csv("hindcast_app2/data/species_predict_05.02.18_random_scaled_unscaled_run5.csv") %>% .[1:1698,]
run6_random_scaling=read.csv("hindcast_app2/data/species_predict_05.02.18_random_scaled_unscaled_run6.csv") %>% .[1:1698,]

namesrisk<-c("Blue shark bycatch","Blue sharks","Sea lions","Leatherbacks","Swordfish")

####------> run 4 
ER_weightings<-c(-0.1,-0.1,-0.05,-0.4,0.1)
data=run4_random_scaling
# aa=lm(EcoROMS_original_unscaled ~ EcoROMS_original,data = data)
# label=summary(aa)$r.squared %>% round(.,digits=3)
label=cor(data$EcoROMS_original_unscaled,data$EcoROMS_original,use="pairwise.complete.obs",method = "spearman") %>% round(.,digits=3)

subtitle=paste0(namesrisk[1],": ",ER_weightings[1],", ",namesrisk[2],": ",ER_weightings[2],", ",namesrisk[3],": ",ER_weightings[3],", ",namesrisk[4],": ",ER_weightings[4],", ",namesrisk[5],": ",ER_weightings[5])
a=ggplot()+geom_point(data=data,aes(x=EcoROMS_original,y=EcoROMS_original_unscaled),color="black",size=.5,shape=1)
a=a+geom_smooth(data=data,aes(x=EcoROMS_original,y=EcoROMS_original_unscaled),method = "lm",se=F,color="blue",formula = y~x)
a=a+annotate("text",x=-.5,y=.1,label=paste0("R= ",label))
a=a+ggtitle(label = paste0("Relationship between EcoROMS scaled (original) and unscaled"),subtitle = subtitle)+labs(x="EcoROMS_original")+labs(y="EcoROMS_original_unscaled")+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+theme(legend.position="none")
a

png("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/hindcast_app_metadata/run4_scaling.png",width=7, height=5, units="in", res=400)
par(ps=10)
par(mar=c(4,4,1,1))
par(cex=1)
a
dev.off()


####------> run 5 
ER_weightings<-c(-0.1,-0.1,-0.05,-0.4,0.2)
data=run5_random_scaling
# aa=lm(EcoROMS_original_unscaled ~ EcoROMS_original,data = data)
# label=summary(aa)$r.squared %>% round(.,digits=3)
label=cor(data$EcoROMS_original_unscaled,data$EcoROMS_original,use="pairwise.complete.obs",method = "spearman") %>% round(.,digits=3)

subtitle=paste0(namesrisk[1],": ",ER_weightings[1],", ",namesrisk[2],": ",ER_weightings[2],", ",namesrisk[3],": ",ER_weightings[3],", ",namesrisk[4],": ",ER_weightings[4],", ",namesrisk[5],": ",ER_weightings[5])
a=ggplot()+geom_point(data=data,aes(x=EcoROMS_original,y=EcoROMS_original_unscaled),color="black",size=.5,shape=1)
a=a+geom_smooth(data=data,aes(x=EcoROMS_original,y=EcoROMS_original_unscaled),method = "lm",se=F,color="blue",formula = y~x)
a=a+annotate("text",x=-.5,y=.1,label=paste0("R= ",label))
a=a+ggtitle(label = paste0("Relationship between EcoROMS scaled (original) and unscaled"),subtitle = subtitle)+labs(x="EcoROMS_original")+labs(y="EcoROMS_original_unscaled")+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+theme(legend.position="none")
a

png("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/hindcast_app_metadata/run5_scaling.png",width=7, height=5, units="in", res=400)
par(ps=10)
par(mar=c(4,4,1,1))
par(cex=1)
a
dev.off()

####------> run 6 
ER_weightings<-c(-0.1,-0.1,-0.05,-0.4,0.4)
data=run6_random_scaling
# aa=lm(EcoROMS_original_unscaled ~ EcoROMS_original,data = data)
# label=summary(aa)$r.squared %>% round(.,digits=3)
label=cor(data$EcoROMS_original_unscaled,data$EcoROMS_original,use="pairwise.complete.obs",method = "spearman") %>% round(.,digits=3)

subtitle=paste0(namesrisk[1],": ",ER_weightings[1],", ",namesrisk[2],": ",ER_weightings[2],", ",namesrisk[3],": ",ER_weightings[3],", ",namesrisk[4],": ",ER_weightings[4],", ",namesrisk[5],": ",ER_weightings[5])
a=ggplot()+geom_point(data=data,aes(x=EcoROMS_original,y=EcoROMS_original_unscaled),color="black",size=.5,shape=1)
a=a+geom_smooth(data=data,aes(x=EcoROMS_original,y=EcoROMS_original_unscaled),method = "lm",se=F,color="blue",formula = y~x)
a=a+annotate("text",x=-.5,y=.1,label=paste0("R= ",label))
a=a+ggtitle(label = paste0("Relationship between EcoROMS scaled (original) and unscaled"),subtitle = subtitle)+labs(x="EcoROMS_original")+labs(y="EcoROMS_original_unscaled")+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
a=a+theme(legend.position="none")
a

png("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/hindcast_app_metadata/run6_scaling.png",width=7, height=5, units="in", res=400)
par(ps=10)
par(mar=c(4,4,1,1))
par(cex=1)
a
dev.off()