install.packages("ggforce")
library(ggforce)
library(tidyverse)

a=read.csv("hindcast_ms/summarize_ms/plots/parellel_coordinate_table_correlations_unique_nopt1.csv")
b=a %>% separate(weighting, into=c("blsh1","blsh2","casl","lbst","swor"),sep=",")
c=b %>% gather(species,correlation,-c(X,Algorithm,run,best,sum,Rank,blsh1,blsh2,casl,lbst,swor))
c.1=c %>% select(-c(X,blsh1,blsh2,casl,lbst,swor))

d=b %>% mutate(blsh1=as.numeric(blsh1))%>% mutate(blsh2=as.numeric(blsh2)) %>% mutate(blsh=(blsh1+blsh2)) %>% select(-c(blsh1,blsh2,Leatherback,Swordfish,Blueshark,Sealion)) %>% rename(Blueshark=blsh) %>% rename(Sealion=casl) %>% rename(Leatherback=lbst) %>% rename(Swordfish=swor)
e=d %>% select(-c(X,Algorithm,sum,Rank)) %>% gather(species,weighting,-c(run,best))

f=left_join(c.1,e,by=c("run","best","species"))
g=f %>% group_by(best,species) %>% summarise(mean_cor=mean(correlation),sd_cor=sd(correlation),mean_weight=mean(as.numeric(weighting)),sd_weight=sd(weighting))
g$alpha=c(rep("in",6),"out","in","out","in","out","in") %>% as.factor()
h=f %>% mutate(inclusion="yes")
h <- within(h, inclusion[best == 'swor_blsh_id' & species == 'Sealion'] <- 'no')
h <- within(h, inclusion[best == 'swor2_id' & species == 'Sealion'] <- 'no')
h <- within(h, inclusion[best == 'swor2_id' & species == 'Blueshark'] <- 'no')

i=h %>% filter(inclusion=="yes") %>% mutate(weighting=as.numeric(weighting))
test=lm(correlation~weighting,i)
b = format(coef(test)[2], digits = 3)

a=ggplot(data = g)+geom_ellipsis(aes(x0=mean_weight,y0=mean_cor,a=sd_weight,b=sd_cor,angle=0,color=species,linetype=best,fill=alpha),alpha=.5)+geom_point(aes(x=mean_weight,y=mean_cor,color=species))+
  scale_color_manual("Species",values=c("Leatherback"="darkgoldenrod","Swordfish"="cornflowerblue","Blueshark"="coral1","Sealion"="aquamarine4"))+
  scale_fill_manual("",values=c("out"="grey","in"=NA),guide=F)+
  scale_linetype_manual("Objective",values=c("swor_blsh_casl_id"="solid","swor_blsh_id"="longdash","swor2_id"="dotted"),labels=c("swor_blsh_casl_id"="Objective 1","swor_blsh_id"="Objective 2","swor2_id"="Objective 3"))
a=a+ theme_bw()+theme(panel.border = element_blank(), panel.grid.major = element_blank(),
           panel.grid.minor = element_blank(), axis.line = element_line(colour = "black"))
a=a+stat_smooth(data=i,aes(x=weighting,y=correlation),se=F,method="lm",color="black",size=.5)+geom_text(x=.66,y=.6,label=paste0("slope: ",b),size=2)
a=a+ylab("Correlation between algorithm value and species habitat suitability [R]")+xlab("Species weightings")+ggtitle("Relationship between weightings and correlations for the three management objectives")+
  theme(legend.position=c(.2,.95),legend.justification = c(.9,.9),legend.margin=unit(0.3, "lines"))+theme(legend.background = element_blank(),legend.title = element_text(size=5))+theme(legend.text=element_text(size=5))+ theme(legend.key=element_blank())+theme(legend.key.size = unit(.6,'lines'))+
  theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(axis.text = element_text(size=5),axis.title = element_text(size=5),plot.title = element_text(size=5))
a=a+xlim(-.75,.8)
a

png(paste0(plotdir,"ellipse_unique_nopt1.png"),width=3.5, height=3.5, units="in", res=400)
par(ps=10)
par(cex=1)
par(mar=c(4,4,1,1))
a
dev.off()


test=lm(correlation~weighting,i)

