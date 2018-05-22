### function to look at the effect of weightings / algorithms on species presences histograms

histograms=function(plotdir,run,weighting_delta,species_delta,species_delta_short){
  
  ##--------> histogram ####
  
  dataframelist=list(one,two,three,four,five)
  dataframelist=do.call("rbind",dataframelist)
  
  png(paste0(plotdir,run,"_histogram.png"),width=14, height=15, units="in", res=400)
  par(mfrow=c(5,4))
  
  lowL=dataframelist %>% dplyr::filter(weighting==weighting_delta[1]) %>% dplyr::filter(lbst>.5)
  lowS=dataframelist %>% dplyr::filter(weighting==weighting_delta[1]) %>% dplyr::filter(swor>.5)
  hist(lowL$EcoROMS_original,col=rgb(1,0,0,0.5),xlim=c(-1,1),ylim=c(0,500),main=paste0("EcoROMS_original (",species_delta," = ",weighting_delta[1],")"),xlab="Algorithm values at presences",breaks=10)
  hist(lowS$EcoROMS_original,col=rgb(0,0,1,0.5),add=T,breaks=10)
  legend("topright", c("lbst", "swor"), col=c(rgb(1,0,0,0.5), rgb(0,0,1,0.5)), lwd=8,cex=.5)
  
  hist(lowL$EcoROMS_original_unscaled,col=rgb(1,0,0,0.5),xlim=c(-1,1),ylim=c(0,500),main=paste0("EcoROMS_original_unscaled (",species_delta," = ",weighting_delta[1],")"),xlab="Algorithm values at presences",breaks=10)
  hist(lowS$EcoROMS_original_unscaled,col=rgb(0,0,1,0.5),add=T,breaks=10)
  legend("topright", c("lbst", "swor"), col=c(rgb(1,0,0,0.5), rgb(0,0,1,0.5)), lwd=8,cex=.5)
  
  hist(lowL$Marxan_raw,col=rgb(1,0,0,0.5),xlim=c(-1,1),ylim=c(0,500),main=paste0("Marxan_raw (",species_delta," = ",weighting_delta[1],")"),xlab="Algorithm values at presences",breaks=10)
  hist(lowS$Marxan_raw,col=rgb(0,0,1,0.5),add=T,breaks=10)
  legend("topright", c("lbst", "swor"), col=c(rgb(1,0,0,0.5), rgb(0,0,1,0.5)), lwd=8,cex=.5)
  
  hist(lowL$Marxan_raw_unscaled,col=rgb(1,0,0,0.5),xlim=c(-1000,0),ylim=c(0,500),main=paste0("Marxan_raw_unscaled (",species_delta," = ",weighting_delta[1],")"),xlab="Algorithm values at presences",breaks=10)
  hist(lowS$Marxan_raw_unscaled,col=rgb(0,0,1,0.5),add=T,breaks=10)
  legend("topright", c("lbst", "swor"), col=c(rgb(1,0,0,0.5), rgb(0,0,1,0.5)), lwd=8,cex=.5)
  
  
  lowL=dataframelist %>% dplyr::filter(weighting==weighting_delta[2]) %>% dplyr::filter(lbst>.5)
  lowS=dataframelist %>% dplyr::filter(weighting==weighting_delta[2]) %>% dplyr::filter(swor>.5)
  hist(lowL$EcoROMS_original,col=rgb(1,0,0,0.5),xlim=c(-1,1),ylim=c(0,500),main=paste0("EcoROMS_original (",species_delta," = ",weighting_delta[2],")"),xlab="Algorithm values at presences",breaks=10)
  hist(lowS$EcoROMS_original,col=rgb(0,0,1,0.5),add=T,breaks=10)
  legend("topright", c("lbst", "swor"), col=c(rgb(1,0,0,0.5), rgb(0,0,1,0.5)), lwd=8,cex=.5)
  
  hist(lowL$EcoROMS_original_unscaled,col=rgb(1,0,0,0.5),xlim=c(-1,1),ylim=c(0,500),main=paste0("EcoROMS_original_unscaled (",species_delta," = ",weighting_delta[2],")"),xlab="Algorithm values at presences",breaks=10)
  hist(lowS$EcoROMS_original_unscaled,col=rgb(0,0,1,0.5),add=T,breaks=10)
  legend("topright", c("lbst", "swor"), col=c(rgb(1,0,0,0.5), rgb(0,0,1,0.5)), lwd=8,cex=.5)
  
  hist(lowL$Marxan_raw,col=rgb(1,0,0,0.5),xlim=c(-1,1),ylim=c(0,500),main=paste0("Marxan_raw (",species_delta," = ",weighting_delta[2],")"),xlab="Algorithm values at presences",breaks=10)
  hist(lowS$Marxan_raw,col=rgb(0,0,1,0.5),add=T,breaks=10)
  legend("topright", c("lbst", "swor"), col=c(rgb(1,0,0,0.5), rgb(0,0,1,0.5)), lwd=8,cex=.5)
  
  hist(lowL$Marxan_raw_unscaled,col=rgb(1,0,0,0.5),xlim=c(-1000,0),ylim=c(0,500),main=paste0("Marxan_raw_unscaled (",species_delta," = ",weighting_delta[2],")"),xlab="Algorithm values at presences",breaks=10)
  hist(lowS$Marxan_raw_unscaled,col=rgb(0,0,1,0.5),add=T,breaks=10)
  legend("topright", c("lbst", "swor"), col=c(rgb(1,0,0,0.5), rgb(0,0,1,0.5)), lwd=8,cex=.5)
  
  
  lowL=dataframelist %>% dplyr::filter(weighting==weighting_delta[3]) %>% dplyr::filter(lbst>.5)
  lowS=dataframelist %>% dplyr::filter(weighting==weighting_delta[3]) %>% dplyr::filter(swor>.5)
  hist(lowL$EcoROMS_original,col=rgb(1,0,0,0.5),xlim=c(-1,1),ylim=c(0,500),main=paste0("EcoROMS_original (",species_delta," = ",weighting_delta[3],")"),xlab="Algorithm values at presences",breaks=10)
  hist(lowS$EcoROMS_original,col=rgb(0,0,1,0.5),add=T,breaks=10)
  legend("topright", c("lbst", "swor"), col=c(rgb(1,0,0,0.5), rgb(0,0,1,0.5)), lwd=8,cex=.5)
  
  hist(lowL$EcoROMS_original_unscaled,col=rgb(1,0,0,0.5),xlim=c(-1,1),ylim=c(0,500),main=paste0("EcoROMS_original_unscaled (",species_delta," = ",weighting_delta[3],")"),xlab="Algorithm values at presences",breaks=10)
  hist(lowS$EcoROMS_original_unscaled,col=rgb(0,0,1,0.5),add=T,breaks=10)
  legend("topright", c("lbst", "swor"), col=c(rgb(1,0,0,0.5), rgb(0,0,1,0.5)), lwd=8,cex=.5)
  
  hist(lowL$Marxan_raw,col=rgb(1,0,0,0.5),xlim=c(-1,1),ylim=c(0,500),main=paste0("Marxan_raw (",species_delta," = ",weighting_delta[3],")"),xlab="Algorithm values at presences",breaks=10)
  hist(lowS$Marxan_raw,col=rgb(0,0,1,0.5),add=T,breaks=10)
  legend("topright", c("lbst", "swor"), col=c(rgb(1,0,0,0.5), rgb(0,0,1,0.5)), lwd=8,cex=.5)
  
  hist(lowL$Marxan_raw_unscaled,col=rgb(1,0,0,0.5),xlim=c(-1000,0),ylim=c(0,500),main=paste0("Marxan_raw_unscaled (",species_delta," = ",weighting_delta[3],")"),xlab="Algorithm values at presences",breaks=10)
  hist(lowS$Marxan_raw_unscaled,col=rgb(0,0,1,0.5),add=T,breaks=10)
  legend("topright", c("lbst", "swor"), col=c(rgb(1,0,0,0.5), rgb(0,0,1,0.5)), lwd=8,cex=.5)
  
  
  lowL=dataframelist %>% dplyr::filter(weighting==weighting_delta[4]) %>% dplyr::filter(lbst>.5)
  lowS=dataframelist %>% dplyr::filter(weighting==weighting_delta[4]) %>% dplyr::filter(swor>.5)
  hist(lowL$EcoROMS_original,col=rgb(1,0,0,0.5),xlim=c(-1,1),ylim=c(0,500),main=paste0("EcoROMS_original (",species_delta," = ",weighting_delta[4],")"),xlab="Algorithm values at presences",breaks=10)
  hist(lowS$EcoROMS_original,col=rgb(0,0,1,0.5),add=T,breaks=10)
  legend("topright", c("lbst", "swor"), col=c(rgb(1,0,0,0.5), rgb(0,0,1,0.5)), lwd=8,cex=.5)
  
  hist(lowL$EcoROMS_original_unscaled,col=rgb(1,0,0,0.5),xlim=c(-1,1),ylim=c(0,500),main=paste0("EcoROMS_original_unscaled (",species_delta," = ",weighting_delta[4],")"),xlab="Algorithm values at presences",breaks=10)
  hist(lowS$EcoROMS_original_unscaled,col=rgb(0,0,1,0.5),add=T,breaks=10)
  legend("topright", c("lbst", "swor"), col=c(rgb(1,0,0,0.5), rgb(0,0,1,0.5)), lwd=8,cex=.5)
  
  hist(lowL$Marxan_raw,col=rgb(1,0,0,0.5),xlim=c(-1,1),ylim=c(0,500),main=paste0("Marxan_raw (",species_delta," = ",weighting_delta[4],")"),xlab="Algorithm values at presences",breaks=10)
  hist(lowS$Marxan_raw,col=rgb(0,0,1,0.5),add=T,breaks=10)
  legend("topright", c("lbst", "swor"), col=c(rgb(1,0,0,0.5), rgb(0,0,1,0.5)), lwd=8,cex=.5)
  
  hist(lowL$Marxan_raw_unscaled,col=rgb(1,0,0,0.5),xlim=c(-1000,0),ylim=c(0,500),main=paste0("Marxan_raw_unscaled (",species_delta," = ",weighting_delta[4],")"),xlab="Algorithm values at presences",breaks=10)
  hist(lowS$Marxan_raw_unscaled,col=rgb(0,0,1,0.5),add=T,breaks=10)
  legend("topright", c("lbst", "swor"), col=c(rgb(1,0,0,0.5), rgb(0,0,1,0.5)), lwd=8,cex=.5)
  
  
  lowL=dataframelist %>% dplyr::filter(weighting==weighting_delta[5]) %>% dplyr::filter(lbst>.5)
  lowS=dataframelist %>% dplyr::filter(weighting==weighting_delta[5]) %>% dplyr::filter(swor>.5)
  hist(lowL$EcoROMS_original,col=rgb(1,0,0,0.5),xlim=c(-1,1),ylim=c(0,500),main=paste0("EcoROMS_original (",species_delta," = ",weighting_delta[5],")"),xlab="Algorithm values at presences",breaks=10)
  hist(lowS$EcoROMS_original,col=rgb(0,0,1,0.5),add=T,breaks=10)
  legend("topright", c("lbst", "swor"), col=c(rgb(1,0,0,0.5), rgb(0,0,1,0.5)), lwd=8,cex=.5)
  
  hist(lowL$EcoROMS_original_unscaled,col=rgb(1,0,0,0.5),xlim=c(-1,1),ylim=c(0,500),main=paste0("EcoROMS_original_unscaled (",species_delta," = ",weighting_delta[5],")"),xlab="Algorithm values at presences",breaks=10)
  hist(lowS$EcoROMS_original_unscaled,col=rgb(0,0,1,0.5),add=T,breaks=10)
  legend("topright", c("lbst", "swor"), col=c(rgb(1,0,0,0.5), rgb(0,0,1,0.5)), lwd=8,cex=.5)
  
  hist(lowL$Marxan_raw,col=rgb(1,0,0,0.5),xlim=c(-1,1),ylim=c(0,500),main=paste0("Marxan_raw (",species_delta," = ",weighting_delta[5],")"),xlab="Algorithm values at presences",breaks=10)
  hist(lowS$Marxan_raw,col=rgb(0,0,1,0.5),add=T,breaks=10)
  legend("topright", c("lbst", "swor"), col=c(rgb(1,0,0,0.5), rgb(0,0,1,0.5)), lwd=8,cex=.5)
  
  hist(lowL$Marxan_raw_unscaled,col=rgb(1,0,0,0.5),xlim=c(-1000,0),ylim=c(0,500),main=paste0("Marxan_raw_unscaled (",species_delta," = ",weighting_delta[5],")"),xlab="Algorithm values at presences",breaks=10)
  hist(lowS$Marxan_raw_unscaled,col=rgb(0,0,1,0.5),add=T,breaks=10)
  legend("topright", c("lbst", "swor"), col=c(rgb(1,0,0,0.5), rgb(0,0,1,0.5)), lwd=8,cex=.5)
  
  dev.off()
  
  ##--------> ECDF ####
  index=grep(species_delta_short,colnames(dataframelist))
  lowS1=dataframelist %>% dplyr::filter(weighting==weighting_delta[1]) %>% dplyr::filter(.[,index]>.5)
  lowS2=dataframelist %>% dplyr::filter(weighting==weighting_delta[2]) %>% dplyr::filter(.[,index]>.5)
  lowS3=dataframelist %>% dplyr::filter(weighting==weighting_delta[3]) %>% dplyr::filter(.[,index]>.5)
  lowS4=dataframelist %>% dplyr::filter(weighting==weighting_delta[4]) %>% dplyr::filter(.[,index]>.5)
  lowS5=dataframelist %>% dplyr::filter(weighting==weighting_delta[5]) %>% dplyr::filter(.[,index]>.5)
  
  png(paste0(plotdir,run,"_EcoROMS_original_ECDF.png"),width=7, height=7, units="in", res=400)
  plot(ecdf(lowS1$EcoROMS_original), col='red', ylab='Cumulative Distribution Function', xlab=paste0("Algorithm value at ",species_delta_short," presences"),main=paste0("Effect of ",species_delta_short," weighting - EcoROMS_original"))
  lines(ecdf(lowS2$EcoROMS_original), col='blue')
  lines(ecdf(lowS3$EcoROMS_original), col='green')
  lines(ecdf(lowS4$EcoROMS_original), col='yellow')
  lines(ecdf(lowS5$EcoROMS_original), col='black')
  legend('topleft', c(paste0(species_delta_short," = ",weighting_delta[1]),paste0(species_delta_short," = ",weighting_delta[2]),paste0(species_delta_short," = ",weighting_delta[3]),paste0(species_delta_short," = ",weighting_delta[4]),paste0(species_delta_short," = ",weighting_delta[5])), lty=1, col=c('red','blue','green','yellow','black'))
  dev.off()
  
  png(paste0(plotdir,run,"_EcoROMS_original_unscaled_ECDF.png"),width=7, height=7, units="in", res=400)
  plot(ecdf(lowS1$EcoROMS_original_unscaled), col='red', ylab='Cumulative Distribution Function', xlab=paste0("Algorithm value at ",species_delta_short," presences"),main=paste0("Effect of ",species_delta_short," weighting - EcoROMS_original_unscaled"))
  lines(ecdf(lowS2$EcoROMS_original_unscaled), col='blue')
  lines(ecdf(lowS3$EcoROMS_original_unscaled), col='green')
  lines(ecdf(lowS4$EcoROMS_original_unscaled), col='yellow')
  lines(ecdf(lowS5$EcoROMS_original_unscaled), col='black')
  legend('topleft', c(paste0(species_delta_short," = ",weighting_delta[1]),paste0(species_delta_short," = ",weighting_delta[2]),paste0(species_delta_short," = ",weighting_delta[3]),paste0(species_delta_short," = ",weighting_delta[4]),paste0(species_delta_short," = ",weighting_delta[5])), lty=1, col=c('red','blue','green','yellow','black'))
  dev.off()
  
  png(paste0(plotdir,run,"_Marxan_raw_ECDF.png"),width=7, height=7, units="in", res=400)
  plot(ecdf(lowS1$Marxan_raw), col='red', ylab='Cumulative Distribution Function', xlab=paste0("Algorithm value at ",species_delta_short," presences"),main=paste0("Effect of ",species_delta_short," weighting - Marxan_raw"))
  lines(ecdf(lowS2$Marxan_raw), col='blue')
  lines(ecdf(lowS3$Marxan_raw), col='green')
  lines(ecdf(lowS4$Marxan_raw), col='yellow')
  lines(ecdf(lowS5$Marxan_raw), col='black')
  legend('topleft', c(paste0(species_delta_short," = ",weighting_delta[1]),paste0(species_delta_short," = ",weighting_delta[2]),paste0(species_delta_short," = ",weighting_delta[3]),paste0(species_delta_short," = ",weighting_delta[4]),paste0(species_delta_short," = ",weighting_delta[5])), lty=1, col=c('red','blue','green','yellow','black'))
  dev.off()
  
  png(paste0(plotdir,run,"_Marxan_raw_unscaled_ECDF.png"),width=7, height=7, units="in", res=400)
  plot(ecdf(lowS1$Marxan_raw_unscaled), col='red', ylab='Cumulative Distribution Function', xlab=paste0("Algorithm value at ",species_delta_short," presences"),main=paste0("Effect of ",species_delta_short," weighting - Marxan_raw_unscaled"))
  lines(ecdf(lowS2$Marxan_raw_unscaled), col='blue')
  lines(ecdf(lowS3$Marxan_raw_unscaled), col='green')
  lines(ecdf(lowS4$Marxan_raw_unscaled), col='yellow')
  lines(ecdf(lowS5$Marxan_raw_unscaled), col='black')
  legend('topleft', c(paste0(species_delta_short," = ",weighting_delta[1]),paste0(species_delta_short," = ",weighting_delta[2]),paste0(species_delta_short," = ",weighting_delta[3]),paste0(species_delta_short," = ",weighting_delta[4]),paste0(species_delta_short," = ",weighting_delta[5])), lty=1, col=c('red','blue','green','yellow','black'))
  dev.off()

  
}

# #demo
# source("load_functions.R")
# 
# one=read.csv("hindcast_ms/extract/extractions/run_A.1.csv") %>% mutate(weighting=.1)
# two=read.csv("hindcast_ms/extract/extractions/run_A.2.csv") %>% mutate(weighting=.3)
# three=read.csv("hindcast_ms/extract/extractions/run_A.3.csv") %>% mutate(weighting=.5)
# four=read.csv("hindcast_ms/extract/extractions/run_A.4.csv") %>% mutate(weighting=.7)
# five=read.csv("hindcast_ms/extract/extractions/run_A.5.csv") %>% mutate(weighting=.9)
# 
# plotdir="~/Dropbox/EcoEast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/hindcast_ms/summarize/plots/"
# run="A"
# weighting_delta=c(.1,.3,.5,.7,.9)
# species_delta="swordfish"
# species_delta_short="swor"
# 
# histograms(plotdir = plotdir,weighting_delta = weighting_delta,species_delta = species_delta,run=run,species_delta_short)