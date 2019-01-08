## making giffs
library(magick)

marxdir="~/Dropbox/Eco-ROMS/EcoROMSruns/output/hindcast_ms/marxan/"
ecodir="~/Dropbox/Eco-ROMS/EcoROMSruns/output/hindcast_ms/mean/"
outdirM="/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/GIF_marxan"
outdirE="/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/GIF_ecocast"
outdirM_E="/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/GIF_ecocast_marxan";dir.create(outdirM_E)
weightings<-c(-0.1,-0.1,-0.05,-0.4,0.2)
dates=list.files("~/Dropbox/Eco-ROMS/EcoROMSruns/output/hindcast/marxan",pattern=".grd") %>% grep("_raw",.,value=T) %>% grep(paste0(weightings,collapse="_"),.,value=T) %>% 
  gsub(paste0("marxan_nocost_",paste0(weightings,collapse="_"),"_"),"",.) %>% gsub("_raw.grd","",.)

## step 1. redraw all files with appropriate markings; equal weighitngs, no sealion. M&E look the most similar ####
E_weightings<-c(-0.16,-0.16,0,-0.33,0.33) #run M.4
M_weightings<-c(-0.25,-0.25,0,-0.5,0.5) #run G.3 (C.3)

namesrisk<-c("Blue shark bycatch","Blue sharks","Sea lions","Leatherbacks","Swordfish")
Run_ecoroms_hindcast_ms=function(r,get_date,outdir,namesrisk,weightings,version,algorithm){ ### added to streamline hindcast validation
  
  ############ 1. load required functions
  
  ## A. rasterRescale
  rasterRescale<-function(r){
    r.min = cellStats(r, "min")
    r.max = cellStats(r, "max")
    r.scale <- ((r - r.min) / (r.max - r.min) - 0.5 ) * 2
    return(r.scale) #(r-rmin)/(rmax-rmin)
  }
  
  
  ## A2. rasterRescale (-1 to r.max) ## this is for when swordfish = 0, we still rescale the min value to -1 to fit within app.R color range ##test
  #http://stackoverflow.com/questions/12959371/how-to-scale-numbers-values
  alt_rasterRescale=function(r){
    r.min = cellStats(r, "min")
    r.max = cellStats(r, "max")
    r.scale <--1+(r.max--1)*(r-r.min)/(r.max-r.min)
    return(r.scale)
  }
  
  ## A2. rasterRescale (-1 to 0) 
  #http://stackoverflow.com/questions/12959371/how-to-scale-numbers-values
  alt_rasterRescale2=function(r){
    r.min = cellStats(r, "min")
    r.max = cellStats(r, "max")
    r.scale <--1+(0--1)*(r-r.min)/(r.max-r.min)
    return(r.scale)
  }
  
  ## A2. inverse rasterRescale  (0,1)
  inv_alt_rasterRescale=function(r){ ## (0,1)
    r.min = cellStats(r, "min")
    r.max = cellStats(r, "max")
    r.scale <- 0+(r-r.min)*((1-0)/(r.max-r.min))
    return(r.scale)
  }
  
  ## D. EcoCols
  EcoCols<-colorRampPalette(c("red","orange","white","cyan","blue"))
  ByCols<-colorRampPalette(c("red","orange","white"))
  SeCols<-colorRampPalette(c("coral3","cadetblue3","white","cadetblue3","coral3"))
  
  ## E. PlotEcoROMS
  PlotEcoROMS<-function(r,get_date,outdir,leg=TRUE,scalbar=FALSE,risk=weightings,spp=namesrisk,version="_V1",contourval=NA,addLCA=FALSE,addtext=TRUE,algorithm){
    
    ####### produce png - unscaled
    png(paste(outdir,"/",algorithm,"_",paste(risk,collapse="_"),'_',get_date,version,'.png',sep=''),width=960,height=1100,units='px',pointsize=20)
    par(mar=c(3,3,.5,.5),las=1,font=2)
    
    if (version=="_se") {
      zlimits<-c(-0.1,0.1)
      col=SeCols(255)}
    
    if(risk[5]!=0 && version=="_mean") {
      zlimits=c(r@data@min,r@data@max)
      col=EcoCols(255)
      #r1=rasterRescale(r)
    }
    
    if(risk[5]==0 && version=="_mean") {
      zlimits=c(r@data@min,r@data@max)
      col=ByCols(255)
      #r1<-alt_rasterRescale2(r)
    }
    
    if (leg) {
      image.plot(r,col=col,xlim=c(-130,-115),ylim=c(30,47),zlim=zlimits)
    } else {
      image(r,col=col,xlim=c(-130,-115),ylim=c(30,47),zlim=zlimits) ## PRESABS
    }
    if(scalbar) scalebar(110,type="bar", divs=2,below="kilometers")
    if(!is.na(contourval)) {
      SP <- rasterToPolygons(clump(clipLand(r)<(contourval)), dissolve=TRUE)
      plot(SP, add=TRUE)
    }
    if(addLCA) {
      pl <- rbind(c(-121,36.3064), c(-123.583,34.45), c(-129,34.45), c(-129,45), c(-121,45))
      pl <- SpatialPolygons(list(Polygons(list(Polygon(pl)), 1)))
      projection(pl) <- projstring
      plot(pl, border="dark grey", add=TRUE, lty=3, lwd=4)
    }
    
    blshW=risk[1]*2
    
    maps::map('worldHires',add=TRUE,col=grey(0.7),fill=TRUE)
    if (addtext) {
      text(-122,46,get_date,adj=c(0,0),cex=2) 
      text(-122,45,"Species weightings",adj=c(0,0),cex=1)
      #text(-122,45,paste(namesrisk[1],' weighting = ',risk[1],sep=''),adj=c(0,0),cex=.75)
      text(-122,44.5,paste(namesrisk[2],' weighting = ',blshW,sep=''),adj=c(0,0),cex=.75)
      text(-122,44,paste(namesrisk[3],' weighting = ',risk[3],sep=''),adj=c(0,0),cex=.75)
      text(-122,43.5,paste(namesrisk[4],' weighting = ',risk[4],sep=''),adj=c(0,0),cex=.75)
      text(-122,43,paste(namesrisk[5],' weighting = ',risk[5],sep=''),adj=c(0,0),cex=.75)
      text(-122,42,paste0(algorithm),adj=c(0,0),cex=1)
      
    }
    
    box()
    dev.off()
    
    
    ####### produce raster
    #writeRaster(r,filename=paste(wd,'/EcoROMS_original_unscaled_',paste(risk,collapse="_"),"_",get_date,version,'.grd',sep=''),overwrite=TRUE) 
    
  }
  
  PlotEcoROMS(r=r,get_date=get_date,outdir = outdir,risk=weightings,version="_mean",algorithm = algorithm) ## standard directory
}

## EcoCast
weightings <-c(-0.16,-0.16,0,-0.33,0.33) #run M.4
ecocast=list.files(ecodir,full.names = T) %>% grep(paste0(paste(weightings,collapse ="_")),.,value=T)%>% grep("unscaled",.,value=T) %>% grep(".grd",.,value=T) %>% .[18:232]
for(eco in ecocast){
  a=raster(eco)
  get_date=substr(eco,126,135)
  Run_ecoroms_hindcast_ms(r=a,get_date = get_date,outdir = outdirE,namesrisk = namesrisk,weightings=weightings,version="_mean",algorithm = "EcoCast" )
}

## Marxan
weightings<-c(-0.25,-0.25,0,-0.5,0.5) #run G.3 (C.3)
ecocast=list.files(marxdir,full.names = T) %>% grep(paste0(paste(weightings,collapse ="_")),.,value=T)%>% grep("unscaled",.,value=T) %>% grep(".grd",.,value=T) %>% .[18:232]
for(eco in ecocast){
  a=raster(eco)
  get_date=substr(eco,107,116)
  print(get_date)
  Run_ecoroms_hindcast_ms(r=a,get_date = get_date,outdir = outdirM,namesrisk = namesrisk,weightings=weightings,version="_mean",algorithm = "Marxan" )
}

## step 2. make GIFS ####
setwd(outdirE)
system('convert -delay 40 *.png ecocast.gif')

setwd(outdirM)
system('convert -delay 40 *.png marxan.gif')

## new idea, composite images
for(i in 1:215){
  name=list.files(outdirE)[i] %>% substr(.,34,43)
  name
a=list.files(outdirE,full.names = T)[i]
b=list.files(outdirM,full.names = T)[i]
e=image_read(a)
m=image_read(b)
img=c(e,m)
comp=image_append(img)
image_write(comp,path = paste0(outdirM_E,"/appended_",name,".png"))
}

setwd(outdirM_E)
system('convert -delay 40 *.png combo.gif')
