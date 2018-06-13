library(ggalt)
library(plotly)
csvdir="hindcast_ms/summarize/csvs/"
plotdir="hindcast_ms/summarize/plots/"
run="A-D"

file_list=list.files("/Users/heatherwelch/Dropbox/EcoEast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/hindcast_ms/summarize/csvs") %>% grep("availcatch_algorithm",.,value=T)
master=list()
for (file in file_list){
  a=read.csv(paste0("/Users/heatherwelch/Dropbox/EcoEast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/hindcast_ms/summarize/csvs/",file))
  name=gsub("_availcatch_algorithm_comparison.csv","",file)
  a$run=name
  assign(name,a)
  master[[name]]<-a
}

fullon=do.call("rbind",master)
df=fullon %>% dplyr::filter(limit_target=="swordfish")
df$product=gsub("EcorROMS","EcoROMS",df$product)
df$product_run=paste0(df$product,"_",df$run)
df$diff=df$swor-df$lbst
sub10=df %>% filter(swor>5&swor<15)
sub10=arrange(sub10,desc(diff))
sub10$product_run=factor(sub10$product_run,levels=unique(sub10$product_run))
sub10=sub10 %>% mutate(lbst=lbst/100) %>% mutate(swor=swor/100) %>% mutate(diff=diff/100)


a=ggplot(df,aes(x=swor,y=lbst))+geom_point(aes(color=product))
a=a+scale_color_manual("Algorithm",values=c("EcoROMS_original"="#034f84","EcoROMS_original_unscaled"="#92a8d1","Marxan_raw"="#f7786b","Marxan_raw_unscaled"="#f7cac9"))
a=a+geom_line(data=filter(df,product_run=="EcoROMS_original_unscaled_D.3"),aes(x=swor,y=lbst))+geom_point(data=filter(df,product_run=="EcoROMS_original_unscaled_D.3"),aes(x=swor,y=lbst),size=2,fill="#92a8d1",pch=21,color="black")
a=a+scale_x_continuous(breaks=seq(0,100,by=10))
a=a+ggtitle(label = paste0("Trade-offs between swordfish availability and leatherback bycatch"))+labs(x="% of swordfish available to catch")+labs(y="% of leathbacks bycaught")+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"),axis.text = element_text(size=8))+ theme(text = element_text(size=8))
a=a+theme(legend.title = element_text(size=8),legend.position=c(.3,.9),legend.justification = c(.9,.9))+theme(legend.background = element_blank())+theme(legend.text=element_text(size=8),legend.box.background = element_rect(colour = "black"))+ theme(legend.key=element_blank())
a=a+theme(legend.key.size = unit(.9,'lines'))
a=a+geom_text(x=95,y=40,label="run D.3",size=2.5)
a

df=fullon %>% dplyr::filter(limit_target=="leatherback")
df$product=gsub("EcorROMS","EcoROMS",df$product)
df$product_run=paste0(df$product,"_",df$run)
df$diff=df$swor-df$lbst

a=ggplot(df,aes(x=lbst,y=swor))+geom_point(aes(color=product))
a=a+scale_color_manual("Algorithm",values=c("EcoROMS_original"="#034f84","EcoROMS_original_unscaled"="#92a8d1","Marxan_raw"="#f7786b","Marxan_raw_unscaled"="#f7cac9"))
a=a+geom_line(data=filter(df,product_run=="EcoROMS_original_unscaled_D.3"),aes(x=lbst,y=swor))+geom_point(data=filter(df,product_run=="EcoROMS_original_unscaled_D.3"),aes(x=lbst,y=swor),size=2,fill="#92a8d1",pch=21,color="black")
a=a+scale_x_continuous(breaks=seq(0,100,by=10))
a=a+ggtitle(label = paste0("Trade-offs between leatherback bycatch and swordfish availability"))+labs(x="% of leathbacks bycaught")+labs(y="% of swordfish available to catch")+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"),axis.text = element_text(size=8))+ theme(text = element_text(size=8))
a=a+theme(legend.title = element_text(size=8),legend.position=c(.9,.3),legend.justification = c(.9,.9))+theme(legend.background = element_blank())+theme(legend.text=element_text(size=8),legend.box.background = element_rect(colour = "black"))+ theme(legend.key=element_blank())
a=a+theme(legend.key.size = unit(.9,'lines'))
a=a+geom_text(x=10,y=95,label="run D.3",size=2.5)
a

fullon=do.call("rbind",master)
df=fullon %>% dplyr::filter(limit_target=="swordfish")
df$product=gsub("EcorROMS","EcoROMS",df$product)
df$product_run=paste0(df$product,"_",df$run)
df$diff=df$swor-df$lbst
sub10=df %>% filter(swor>55&swor<65) %>% filter(product=="Marxan_raw_unscaled")
sub10=df %>% filter(swor>55&swor<65) %>% filter(product=="Marxan_raw")
sub10=df %>% filter(swor>55&swor<65) %>% filter(product=="EcoROMS_original_unscaled")
sub10=df %>% filter(swor>55&swor<65) %>% filter(product=="EcoROMS_original")
arrange(sub10,desc(diff))
dfsub=df %>% filter(product_run=="EcoROMS_original_unscaled_D.3"|product_run=="EcoROMS_original_unscaled_B.5"|product_run=="EcoROMS_original_unscaled_D.1"|product_run=="EcoROMS_original_unscaled_D.4"|product_run=="EcoROMS_original_D.3"|product_run=="EcoROMS_original_B.5"|product_run=="EcoROMS_original_D.1"|product_run=="EcoROMS_original_D.4"|product_run=="Marxan_raw_unscaled_C.3"|product_run=="Marxan_raw_unscaled_E.1"|product_run=="Marxan_raw_unscaled_E.3"|product_run=="Marxan_raw_unscaled_B.3"|product_run=="Marxan_raw_C.3"|product_run=="Marxan_raw_E.1"|product_run=="Marxan_raw_B.3"|product_run=="Marxan_raw_E.2")

a=ggplot(dfsub,aes(x=swor,y=lbst))+geom_point(aes(color=product))
a=a+scale_color_manual("Algorithm",values=c("EcoROMS_original"="#034f84","EcoROMS_original_unscaled"="#92a8d1","Marxan_raw"="#f7786b","Marxan_raw_unscaled"="#f7cac9"))
a=a+geom_line(data=filter(df,product_run=="EcoROMS_original_unscaled_D.3"),aes(x=swor,y=lbst))+geom_point(data=filter(df,product_run=="EcoROMS_original_unscaled_D.3"),aes(x=swor,y=lbst),size=2,fill="#92a8d1",pch=21,color="black")
a=a+scale_x_continuous(breaks=seq(0,100,by=10))
a=a+ggtitle(label = paste0("Trade-offs between swordfish availability and leatherback bycatch"))+labs(x="% of swordfish available to catch")+labs(y="% of leathbacks bycaught")+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"),axis.text = element_text(size=8))+ theme(text = element_text(size=8))
a=a+theme(legend.title = element_text(size=8),legend.position=c(.3,.9),legend.justification = c(.9,.9))+theme(legend.background = element_blank())+theme(legend.text=element_text(size=8),legend.box.background = element_rect(colour = "black"))+ theme(legend.key=element_blank())
a=a+theme(legend.key.size = unit(.9,'lines'))
a=a+geom_text(x=95,y=40,label="run D.3",size=2.5)
b=a


df=fullon %>% dplyr::filter(limit_target=="leatherback")
df$product=gsub("EcorROMS","EcoROMS",df$product)
df$product_run=paste0(df$product,"_",df$run)
df$diff=df$swor-df$lbst
sub10=df %>% filter(lbst>15&lbst<25) %>% filter(product=="Marxan_raw_unscaled")
sub10=df %>% filter(lbst>15&lbst<25) %>% filter(product=="Marxan_raw")
sub10=df %>% filter(lbst>15&lbst<25) %>% filter(product=="EcoROMS_original_unscaled")
sub10=df %>% filter(lbst>15&lbst<25) %>% filter(product=="EcoROMS_original")
arrange(sub10,desc(diff))
dfsub=df %>% filter(product_run=="EcoROMS_original_unscaled_D.3"|product_run=="EcoROMS_original_unscaled_D.1"|product_run=="EcoROMS_original_unscaled_B.5"|product_run=="EcoROMS_original_unscaled_D.4"|product_run=="EcoROMS_original_B.5"|product_run=="EcoROMS_original_D.3"|product_run=="EcoROMS_original_D.1"|product_run=="EcoROMS_original_D.4"|product_run=="Marxan_raw_unscaled_C.3"|product_run=="Marxan_raw_unscaled_E.1"|product_run=="Marxan_raw_unscaled_D.4"|product_run=="Marxan_raw_unscaled_B.2"|product_run=="Marxan_raw_E.1"|product_run=="Marxan_raw_C.3"|product_run=="Marxan_raw_D.4"|product_run=="Marxan_raw_B.2")

a=ggplot(dfsub,aes(x=lbst,y=swor))+geom_point(aes(color=product))
a=a+scale_color_manual("Algorithm",values=c("EcoROMS_original"="#034f84","EcoROMS_original_unscaled"="#92a8d1","Marxan_raw"="#f7786b","Marxan_raw_unscaled"="#f7cac9"))
a=a+geom_line(data=filter(df,product_run=="EcoROMS_original_unscaled_D.3"),aes(x=lbst,y=swor))+geom_point(data=filter(df,product_run=="EcoROMS_original_unscaled_D.3"),aes(x=lbst,y=swor),size=2,fill="#92a8d1",pch=21,color="black")
a=a+scale_x_continuous(breaks=seq(0,100,by=10))
a=a+ggtitle(label = paste0("Trade-offs between leatherback bycatch and swordfish availability"))+labs(x="% of leathbacks bycaught")+labs(y="% of swordfish available to catch")+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"),axis.text = element_text(size=8))+ theme(text = element_text(size=8))
a=a+theme(legend.title = element_text(size=8),legend.position=c(.9,.3),legend.justification = c(.9,.9))+theme(legend.background = element_blank())+theme(legend.text=element_text(size=8),legend.box.background = element_rect(colour = "black"))+ theme(legend.key=element_blank())
a=a+theme(legend.key.size = unit(.9,'lines'))
a=a+geom_text(x=10,y=90,label="run D.3",size=2.5)
a

png(paste0(plotdir,"best_runs.png"),width=14, height=7, units="in", res=400)
par(ps=10)
par(mar=c(4,4,1,1))
par(cex=1)
plot_grid(b,a,nrow=1,ncol=2)
dev.off()


a=ggplotly(a)

a=ggplot(sub10,aes(x=swor,xend=lbst,y=product_run,color=product))+geom_dumbbell(dot_guide=T,size=0.75)#+geom_segment(aes(x=swor,xend=lbst,yend=product_run),linetype=product)
a=a+scale_y_discrete(labels=sub10$run,name="Run")+scale_x_continuous(label=scales::percent,name=NULL)+labs(subtitle="Percent change of available leatherback at 10% available swordfish")
a=a+scale_color_manual("product",values=c("EcoROMS_original"="#034f84","EcoROMS_original_unscaled"="#92a8d1","Marxan_raw"="#f7786b","Marxan_raw_unscaled"="#f7cac9"))
a=a+guides(color = guide_legend(override.aes = list(linetype = c("solid", "solid","solid", "solid"))))#+scale_linetype_manual(c("solid", "solid","dashed", "dashed"))
#a=a+geom_rect(aes(xmin=11,xmax=12,ymin=-Inf,ymax=-Inf),fill="#efefe3")
a

sub10=df %>% filter(swor>25&swor<35)
sub10=arrange(sub10,desc(diff))
sub10$product_run=factor(sub10$product_run,levels=unique(sub10$product_run))
sub10=sub10 %>% mutate(lbst=lbst/100) %>% mutate(swor=swor/100) %>% mutate(diff=diff/100)

a=ggplot(sub10,aes(x=swor,xend=lbst,y=product_run,color=product))+geom_dumbbell(size=0.75)#+geom_segment(aes(x=swor,xend=lbst,yend=product_run),linetype=product)
a=a+scale_y_discrete(labels=sub10$run,name="Run")+scale_x_continuous(label=scales::percent,name=NULL)+labs(subtitle="Percent change of available leatherback at 30% available swordfish")
a=a+scale_color_manual("product",values=c("EcoROMS_original"="#034f84","EcoROMS_original_unscaled"="#92a8d1","Marxan_raw"="#f7786b","Marxan_raw_unscaled"="#f7cac9"))
a=a+guides(color = guide_legend(override.aes = list(linetype = c("solid", "solid","solid", "solid"))))#+scale_linetype_manual(c("solid", "solid","dashed", "dashed"))
#a=a+geom_rect(aes(xmin=11,xmax=12,ymin=-Inf,ymax=-Inf),fill="#efefe3")
a

sub10=df %>% filter(swor>45&swor<55)
sub10=arrange(sub10,desc(diff))
sub10$product_run=factor(sub10$product_run,levels=unique(sub10$product_run))
sub10=sub10 %>% mutate(lbst=lbst/100) %>% mutate(swor=swor/100) %>% mutate(diff=diff/100)

a=ggplot(sub10,aes(x=swor,xend=lbst,y=product_run,color=product))+geom_dumbbell(size=0.75)#+geom_segment(aes(x=swor,xend=lbst,yend=product_run),linetype=product)
a=a+scale_y_discrete(labels=sub10$run,name="Run")+scale_x_continuous(label=scales::percent,name=NULL)+labs(subtitle="Percent change of available leatherback at 50% available swordfish")
a=a+scale_color_manual("product",values=c("EcoROMS_original"="#034f84","EcoROMS_original_unscaled"="#92a8d1","Marxan_raw"="#f7786b","Marxan_raw_unscaled"="#f7cac9"))
a=a+guides(color = guide_legend(override.aes = list(linetype = c("solid", "solid","solid", "solid"))))#+scale_linetype_manual(c("solid", "solid","dashed", "dashed"))
#a=a+geom_rect(aes(xmin=11,xmax=12,ymin=-Inf,ymax=-Inf),fill="#efefe3")
a

sub10=df %>% filter(swor>65&swor<75)
sub10=arrange(sub10,desc(diff))
sub10$product_run=factor(sub10$product_run,levels=unique(sub10$product_run))
sub10=sub10 %>% mutate(lbst=lbst/100) %>% mutate(swor=swor/100) %>% mutate(diff=diff/100)

a=ggplot(sub10,aes(x=swor,xend=lbst,y=product_run,color=product))+geom_dumbbell(size=0.75)#+geom_segment(aes(x=swor,xend=lbst,yend=product_run),linetype=product)
a=a+scale_y_discrete(labels=sub10$run,name="Run")+scale_x_continuous(label=scales::percent,name=NULL)+labs(subtitle="Percent change of available leatherback at 60% available swordfish")
a=a+scale_color_manual("product",values=c("EcoROMS_original"="#034f84","EcoROMS_original_unscaled"="#92a8d1","Marxan_raw"="#f7786b","Marxan_raw_unscaled"="#f7cac9"))
a=a+guides(color = guide_legend(override.aes = list(linetype = c("solid", "solid","solid", "solid"))))#+scale_linetype_manual(c("solid", "solid","dashed", "dashed"))
#a=a+geom_rect(aes(xmin=11,xmax=12,ymin=-Inf,ymax=-Inf),fill="#efefe3")
a

##### leatherbacks




df=fullon %>% dplyr::filter(limit_target=="leatherback")
df$product=gsub("EcorROMS","EcoROMS",df$product)
df$product_run=paste0(df$product,"_",df$run)
df$diff=df$swor-df$lbst
sub10=df %>% filter(lbst>5&lbst<15)
sub10=arrange(sub10,desc(diff))
sub10$product_run=factor(sub10$product_run,levels=unique(sub10$product_run))
sub10=sub10 %>% mutate(lbst=lbst/100) %>% mutate(swor=swor/100) %>% mutate(diff=diff/100)


a=ggplot(sub10,aes(x=lbst,xend=swor,y=product_run,color=product))+geom_dumbbell(size=0.75)#+geom_segment(aes(x=swor,xend=lbst,yend=product_run),linetype=product)
a=a+scale_y_discrete(labels=sub10$run,name="Run")+scale_x_continuous(label=scales::percent,name=NULL)+labs(subtitle="Percent change of available swordfish at 10% leatherback risk")
a=a+scale_color_manual("product",values=c("EcoROMS_original"="#034f84","EcoROMS_original_unscaled"="#92a8d1","Marxan_raw"="#f7786b","Marxan_raw_unscaled"="#f7cac9"))
a=a+guides(color = guide_legend(override.aes = list(linetype = c("solid", "solid","solid", "solid"))))#+scale_linetype_manual(c("solid", "solid","dashed", "dashed"))
#a=a+geom_rect(aes(xmin=11,xmax=12,ymin=-Inf,ymax=-Inf),fill="#efefe3")
a

df$diff=df$swor-df$lbst
sub10=df %>% filter(lbst>25&lbst<35)
sub10=arrange(sub10,desc(diff))
sub10$product_run=factor(sub10$product_run,levels=unique(sub10$product_run))
sub10=sub10 %>% mutate(lbst=lbst/100) %>% mutate(swor=swor/100) %>% mutate(diff=diff/100)


a=ggplot(sub10,aes(x=lbst,xend=swor,y=product_run,color=product))+geom_dumbbell(size=0.75)#+geom_segment(aes(x=swor,xend=lbst,yend=product_run),linetype=product)
a=a+scale_y_discrete(labels=sub10$run,name="Run")+scale_x_continuous(label=scales::percent,name=NULL)+labs(subtitle="Percent change of available swordfish at 30% leatherback risk")
a=a+scale_color_manual("product",values=c("EcoROMS_original"="#034f84","EcoROMS_original_unscaled"="#92a8d1","Marxan_raw"="#f7786b","Marxan_raw_unscaled"="#f7cac9"))
a=a+guides(color = guide_legend(override.aes = list(linetype = c("solid", "solid","solid", "solid"))))#+scale_linetype_manual(c("solid", "solid","dashed", "dashed"))
#a=a+geom_rect(aes(xmin=11,xmax=12,ymin=-Inf,ymax=-Inf),fill="#efefe3")
a

df$diff=df$swor-df$lbst
sub10=df %>% filter(lbst>45&lbst<55)
sub10=arrange(sub10,desc(diff))
sub10$product_run=factor(sub10$product_run,levels=unique(sub10$product_run))
sub10=sub10 %>% mutate(lbst=lbst/100) %>% mutate(swor=swor/100) %>% mutate(diff=diff/100)


a=ggplot(sub10,aes(x=lbst,xend=swor,y=product_run,color=product))+geom_dumbbell(size=0.75)#+geom_segment(aes(x=swor,xend=lbst,yend=product_run),linetype=product)
a=a+scale_y_discrete(labels=sub10$run,name="Run")+scale_x_continuous(label=scales::percent,name=NULL)+labs(subtitle="Percent change of available swordfish at 50% leatherback risk")
a=a+scale_color_manual("product",values=c("EcoROMS_original"="#034f84","EcoROMS_original_unscaled"="#92a8d1","Marxan_raw"="#f7786b","Marxan_raw_unscaled"="#f7cac9"))
a=a+guides(color = guide_legend(override.aes = list(linetype = c("solid", "solid","solid", "solid"))))#+scale_linetype_manual(c("solid", "solid","dashed", "dashed"))
#a=a+geom_rect(aes(xmin=11,xmax=12,ymin=-Inf,ymax=-Inf),fill="#efefe3")
a

# df$diff=df$swor-df$lbst
# sub10=df %>% filter(lbst>65&lbst<75)
# sub10=arrange(sub10,desc(diff))
# sub10$product_run=factor(sub10$product_run,levels=unique(sub10$product_run))
# sub10=sub10 %>% mutate(lbst=lbst/100) %>% mutate(swor=swor/100) %>% mutate(diff=diff/100)
# 
# a=ggplot(sub10,aes(x=lbst,xend=swor,y=product_run,color=product))+geom_dumbbell(size=0.75)#+geom_segment(aes(x=swor,xend=lbst,yend=product_run),linetype=product)
# a=a+scale_y_discrete(labels=sub10$run,name="Run")+scale_x_continuous(label=scales::percent,name=NULL)+labs(subtitle="Percent change of available swordfish at 70% leatherback risk")
# a=a+scale_color_manual("product",values=c("EcoROMS_original"="#034f84","EcoROMS_original_unscaled"="#92a8d1","Marxan_raw"="#f7786b","Marxan_raw_unscaled"="#f7cac9"))
# a=a+guides(color = guide_legend(override.aes = list(linetype = c("solid", "solid","solid", "solid"))))#+scale_linetype_manual(c("solid", "solid","dashed", "dashed"))
# #a=a+geom_rect(aes(xmin=11,xmax=12,ymin=-Inf,ymax=-Inf),fill="#efefe3")
# a

