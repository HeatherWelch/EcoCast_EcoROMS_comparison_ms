mardir="/Users/heatherwelch/Dropbox/Eco-ROMS/EcoROMSruns/output/hindcast_ms/marxan"
ecodir="/Users/heatherwelch/Dropbox/Eco-ROMS/EcoROMSruns/output/hindcast_ms/mean"
outdir="/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/hindcast_ms/figures/plots/"

get_date=as.Date("1997-10-01")

### recoloring swordfish
SworCols=colorRampPalette(c("white","cyan","blue"))
col=SworCols(255)

mar=list.files(mardir,pattern = "marxan_0_0_0_0_0.5_1997-10-01_raw_unscaled.grd",full.names = T) %>% raster()
png(paste0(outdir,"marxan_0_0_0_0_0.5_",get_date,".png"),width=960,height=1100,units='px',pointsize=20)
zlimits=c(mar@data@min,mar@data@max)
par(mar=c(3,3,.5,.5),las=1,font=2)
image.plot(mar, col=col, ylab="", xlab="", xlim=c(-130,-115.5),ylim=c(30,47),zlim=zlimits)
maps::map('worldHires',add=TRUE,col=grey(0.7),fill=TRUE)
text(-122,46,get_date,adj=c(0,0),cex=2) 
box()
dev.off() # closes device

eco=list.files(ecodir,pattern = "EcoROMS_original_unscaled_0_0_0_0_1_1997-10-01_mean.grd",full.names = T) %>% raster()
png(paste0(outdir,"ecocast_0_0_0_0_1_",get_date,".png"),width=960,height=1100,units='px',pointsize=20)
zlimits=c(eco@data@min,eco@data@max)
par(mar=c(3,3,.5,.5),las=1,font=2)
image.plot(eco, col=col, ylab="", xlab="", xlim=c(-130,-115.5),ylim=c(30,47),zlim=zlimits)
maps::map('worldHires',add=TRUE,col=grey(0.7),fill=TRUE)
text(-122,46,get_date,adj=c(0,0),cex=2) 
box()
dev.off() # closes device

### writing out other plots without grey boxes to cover metadata
EcoCols=colorRampPalette(c("red","orange","white","cyan","blue"))
byCols=colorRampPalette(c("red","orange","white"))
col=byCols(255)

mar=list.files(mardir,pattern = "marxan_0_0_0_-0.5_0_1997-10-01_raw_unscaled.grd",full.names = T) %>% raster()
png(paste0(outdir,"marxan_0_0_0_-0.5_0_",get_date,".png"),width=960,height=1100,units='px',pointsize=20)
zlimits=c(mar@data@min,mar@data@max)
par(mar=c(3,3,.5,.5),las=1,font=2)
image.plot(mar, col=col, ylab="", xlab="", xlim=c(-130,-115.5),ylim=c(30,47),zlim=zlimits)
maps::map('worldHires',add=TRUE,col=grey(0.7),fill=TRUE)
text(-122,46,get_date,adj=c(0,0),cex=2) 
box()
dev.off() # closes device

col=EcoCols(255)

mar=list.files(mardir,pattern = "marxan_0_0_0_-0.5_0.5_1997-10-01_raw_unscaled.grd",full.names = T) %>% raster()
png(paste0(outdir,"marxan_0_0_0_-0.5_0.5_",get_date,".png"),width=960,height=1100,units='px',pointsize=20)
zlimits=c(mar@data@min,mar@data@max)
par(mar=c(3,3,.5,.5),las=1,font=2)
image.plot(mar, col=col, ylab="", xlab="", xlim=c(-130,-115.5),ylim=c(30,47),zlim=zlimits)
maps::map('worldHires',add=TRUE,col=grey(0.7),fill=TRUE)
text(-122,46,get_date,adj=c(0,0),cex=2) 
box()
dev.off() # closes device

mar=list.files(mardir,pattern = "marxan_-0.25_-0.25_0_-0.5_0.5_1997-10-01_raw_unscaled.grd",full.names = T) %>% raster()
png(paste0(outdir,"marxan_-0.25_-0.25_0_-0.5_0.5_",get_date,".png"),width=960,height=1100,units='px',pointsize=20)
zlimits=c(mar@data@min,mar@data@max)
par(mar=c(3,3,.5,.5),las=1,font=2)
image.plot(mar, col=col, ylab="", xlab="", xlim=c(-130,-115.5),ylim=c(30,47),zlim=zlimits)
maps::map('worldHires',add=TRUE,col=grey(0.7),fill=TRUE)
text(-122,46,get_date,adj=c(0,0),cex=2) 
box()
dev.off() # closes device

mar=list.files(mardir,pattern = "marxan_-0.25_-0.25_-0.5_-0.5_0.5_1997-10-01_raw_unscaled.grd",full.names = T) %>% raster()
png(paste0(outdir,"marxan_-0.25_-0.25_-0.5_-0.5_0.5_",get_date,".png"),width=960,height=1100,units='px',pointsize=20)
zlimits=c(mar@data@min,mar@data@max)
par(mar=c(3,3,.5,.5),las=1,font=2)
image.plot(mar, col=col, ylab="", xlab="", xlim=c(-130,-115.5),ylim=c(30,47),zlim=zlimits)
maps::map('worldHires',add=TRUE,col=grey(0.7),fill=TRUE)
text(-122,46,get_date,adj=c(0,0),cex=2) 
box()
dev.off() # closes device

#### ECOCAST
col=byCols(255)

eco=list.files(ecodir,pattern = "EcoROMS_original_unscaled_0_0_0_-1_0_1997-10-01_mean.grd",full.names = T) %>% raster()
png(paste0(outdir,"ecocast_0_0_0_-1_0_",get_date,".png"),width=960,height=1100,units='px',pointsize=20)
zlimits=c(eco@data@min,eco@data@max)
par(mar=c(3,3,.5,.5),las=1,font=2)
image.plot(eco, col=col, ylab="", xlab="", xlim=c(-130,-115.5),ylim=c(30,47),zlim=zlimits)
maps::map('worldHires',add=TRUE,col=grey(0.7),fill=TRUE)
text(-122,46,get_date,adj=c(0,0),cex=2) 
box()
dev.off() # closes device

col=EcoCols(255)

eco=list.files(ecodir,pattern = "EcoROMS_original_unscaled_0_0_0_-0.5_0.5_1997-10-01_mean.grd",full.names = T) %>% raster()
png(paste0(outdir,"ecocast_0_0_0_-0.5_0.5_",get_date,".png"),width=960,height=1100,units='px',pointsize=20)
zlimits=c(eco@data@min,eco@data@max)
par(mar=c(3,3,.5,.5),las=1,font=2)
image.plot(eco, col=col, ylab="", xlab="", xlim=c(-130,-115.5),ylim=c(30,47),zlim=zlimits)
maps::map('worldHires',add=TRUE,col=grey(0.7),fill=TRUE)
text(-122,46,get_date,adj=c(0,0),cex=2) 
box()
dev.off() # closes device

eco=list.files(ecodir,pattern = "EcoROMS_original_unscaled_-0.16_-0.16_0_-0.33_0.33_1997-10-01_mean.grd",full.names = T) %>% raster()
png(paste0(outdir,"ecocast_-0.16_-0.16_0_-0.33_0.33_",get_date,".png"),width=960,height=1100,units='px',pointsize=20)
zlimits=c(eco@data@min,eco@data@max)
par(mar=c(3,3,.5,.5),las=1,font=2)
image.plot(eco, col=col, ylab="", xlab="", xlim=c(-130,-115.5),ylim=c(30,47),zlim=zlimits)
maps::map('worldHires',add=TRUE,col=grey(0.7),fill=TRUE)
text(-122,46,get_date,adj=c(0,0),cex=2) 
box()
dev.off() # closes device

eco=list.files(ecodir,pattern = "EcoROMS_original_unscaled_-0.125_-0.125_-0.25_-0.25_0.25_1997-10-01_mean.grd",full.names = T) %>% raster()
png(paste0(outdir,"ecocast_-0.125_-0.125_-0.25_-0.25_0.25_",get_date,".png"),width=960,height=1100,units='px',pointsize=20)
zlimits=c(eco@data@min,eco@data@max)
par(mar=c(3,3,.5,.5),las=1,font=2)
image.plot(eco, col=col, ylab="", xlab="", xlim=c(-130,-115.5),ylim=c(30,47),zlim=zlimits)
maps::map('worldHires',add=TRUE,col=grey(0.7),fill=TRUE)
text(-122,46,get_date,adj=c(0,0),cex=2) 
box()
dev.off() # closes device
