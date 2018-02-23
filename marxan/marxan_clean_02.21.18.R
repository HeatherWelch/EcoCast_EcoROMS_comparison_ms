### cleaning up marxan script, making a function. follows marxan_trial_02.08.18.R
### 02/21/18

### load functions library(marxan) ####
library(marxan)
library(tidyverse)
source("load_functions.R")

# ------------------------------------------- > helper functions
vignette('quickstart', package='marxan')
vignette('tutorial', package='marxan')
vignette('classes', package='marxan')

# install.packages("marxan")
# if (!require('devtools'))
#   install.packages('devtools', repo='http://cran.rstudio.com', dep=TRUE)
# devtools::install_github('paleo13/marxan')
# #devtools::install_github('jeffreyhanson/marxan')

rasterRescale<-function(r){ ## -1,1
  r.min = cellStats(r, "min")
  r.max = cellStats(r, "max")
  r.scale <- ((r - r.min) / (r.max - r.min) - 0.5 ) * 2
  return(r.scale) #(r-rmin)/(rmax-rmin)
}

alt_rasterRescale=function(r){ ## -1 to native max
  r.min = cellStats(r, "min")
  r.max = cellStats(r, "max")
  r.scale <- -1+(r-r.min)*((0--1)/(r.max-r.min))
  return(r.scale)
}

#http://stackoverflow.com/questions/12959371/how-to-scale-numbers-values
alt_rasterRescale2=function(r){
  r.min = cellStats(r, "min")
  r.max = cellStats(r, "max")
  r.scale <--1+(0--1)*(r-r.min)/(r.max-r.min)
  return(r.scale)
}

inv_alt_rasterRescale=function(r){ ## 0,1
  r.min = cellStats(r, "min")
  r.max = cellStats(r, "max")
  r.scale <- 0+(r-r.min)*((1-0)/(r.max-r.min))
  return(r.scale)
}

make_png_marxan=function(r,get_date,outdir,type,weightings,namesrisk){ ### does what it says
  
  EcoCols<-colorRampPalette(c("red","orange","white","cyan","blue"))
  ByCols<-colorRampPalette(c("red","orange","white"))
  
  if(weightings[5]!=0){
    zlimits=c(-1,1)
    col=EcoCols(255)}
  
  if(weightings[5]==0){
    zlimits=c(-1,0)
    col=ByCols(255)}
  
  png(paste0(outdir,"marxan_",paste0(weightings,collapse = "_"),"_",get_date,"_",type,".png"),width=960,height=1100,units='px',pointsize=20)
  par(mar=c(3,3,.5,.5),las=1,font=2)
  
  image.plot(r, col=col, ylab="", xlab="", xlim=c(-130,-115.5),ylim=c(30,47),zlim=zlimits)
  maps::map('worldHires',add=TRUE,col=grey(0.7),fill=TRUE)
  text(-122,46,format(get_date,format="%b %d %Y"),adj=c(0,0),cex=2) 
  text(-122,45,"Species weightings",adj=c(0,0),cex=1)
  #text(-122,45,paste(namesrisk[1],' weighting = ',weightings[1],sep=''),adj=c(0,0),cex=.75)
  text(-122,44.5,paste(namesrisk[2],' weighting = ',weightings[2],sep=''),adj=c(0,0),cex=.75)
  text(-122,44,paste(namesrisk[3],' weighting = ',weightings[3],sep=''),adj=c(0,0),cex=.75)
  text(-122,43.5,paste(namesrisk[4],' weighting = ',weightings[4],sep=''),adj=c(0,0),cex=.75)
  text(-122,43,paste(namesrisk[5],' weighting = ',weightings[5],sep=''),adj=c(0,0),cex=.75)
  text(-122,42,paste0("Marxan (",type,")"),adj=c(0,0),cex=1)
  
  box()
  dev.off() # closes device
}

##### build marxan function

scp=function(get_date,biofeats,cost,dailypreddir,weightings,namesrisk){
  
  ## prepare biodiversity features and costs
  fullnames=lapply(biofeats,function(x)paste0(dailypreddir,x,"/",x,"_",get_date,"_mean.grd")) %>% stack() ## biodiversity features
  
  cost=paste0(dailypreddir,cost,"/",cost,"_",get_date,"_mean.grd") %>% raster()  ## costs
  a=rasterToPolygons(cost)
  a@data$id=1:nrow(a)
  a@data$cost=a@data$layer
  a@data$status=0L
  a@data=a@data[,2:4]
  
  ## format targets for conservation features
  targets=weightings[1:4]
  targets=unlist(lapply(targets,function(x)x*-1)) %>% lapply(.,function(x)x*100) %>% unlist() %>% lapply(.,function(x)paste0(x,"%")) %>% unlist()
  
  if(weightings[5]!=0){
  ## format targets for cost
  spf=(1-weightings[5])*10
  
  
  ## run marxan
  print("running marxan algorithm")
  results<-marxan(a, fullnames, targets=targets, spf=spf, NUMREPS=1000L, NCORES=2L, BLM=0, lengthFactor=1e-5)
  
  b=results@results@selections %>% as.matrix()
  c=b*1
  d=as.data.frame(c) %>% colSums()
  e=as.matrix(d) %>% as.data.frame()
  colnames(e)[1]="Freq"
  a$selection_freq=e$Freq
  aa=rasterize(a,cost,"selection_freq")
  
  print("writing out results")
  ## produce mgmt: rescale between -1 and 1, where -1= highly selected marxan pixels (e.g. most important for avoiding bycatch); 1=infrequently selected marxan pixels (e.g. least important for avoiding bycatch)
  bb=rasterRescale(aa)*-1
  writeRaster(bb,paste0(outdir,"marxan_",paste0(weightings,collapse = "_"),"_",get_date,"_raw"),overwrite=T)
  make_png_marxan(bb,get_date = get_date,outdir=outdir,type="raw",namesrisk = namesrisk,weightings = weightings)
  
  ## produce mgmt: remove marxan pixels selected in < 100 solutions,
  ## rescale between -1 and 0, where -1= highly selected marxan pixels (e.g. most important for avoiding bycatch); 0=infrequently selected marxan pixels (e.g. least important for avoiding bycatch)
  ## fill in removed areas w swordfish values (scaled between 0,1)
  cc=aa
  values(cc)[values(cc)<100]=NA 
  tt=cc*-1
  tt=alt_rasterRescale(tt)
  
  xx=mask(cost,tt,inverse=T) %>% inv_alt_rasterRescale()
  dd=cover(tt,xx)
  #ee=rasterRescale(dd) ###----------------> THINK ABOUT THIS!!! WHEN DO WE RESCALE?
  writeRaster(dd,paste0(outdir,"marxan_",paste0(weightings,collapse = "_"),"_",get_date,"_mosaic01"),overwrite=T)
  make_png_marxan(dd,get_date = get_date,outdir=outdir,type="mosaic01",namesrisk = namesrisk,weightings = weightings)
  
  ## produce mgmt: remove marxan pixels selected in < 100 solutions,
  ## rescale between -1 and 0, where -1= highly selected marxan pixels (e.g. most important for avoiding bycatch); 0=infrequently selected marxan pixels (e.g. least important for avoiding bycatch)
  ## fill in removed areas w swordfish values (unscaled)
  ## rescale whole thing between -1,1
  cc=aa
  values(cc)[values(cc)<100]=NA 
  tt=cc*-1
  tt=alt_rasterRescale(tt)
  
  xx=mask(cost,tt,inverse=T) 
  dd=cover(tt,xx)
  ee=rasterRescale(dd) ###----------------> THINK ABOUT THIS!!! WHEN DO WE RESCALE?
  writeRaster(ee,paste0(outdir,"marxan_",paste0(weightings,collapse = "_"),"_",get_date,"_mosaic"),overwrite=T)
  make_png_marxan(ee,get_date = get_date,outdir=outdir,type="mosaic",namesrisk = namesrisk,weightings = weightings)
  }
  if(weightings[5]==0){
    a$cost=1
    
    ## format targets for cost
    spf=10
    
    ## run marxan
    print("running marxan algorithm")
    results<-marxan(a, fullnames, targets=targets, spf=spf, NUMREPS=1000L, NCORES=2L, BLM=0, lengthFactor=1e-5)
    
    b=results@results@selections %>% as.matrix()
    c=b*1
    d=as.data.frame(c) %>% colSums()
    e=as.matrix(d) %>% as.data.frame()
    colnames(e)[1]="Freq"
    a$selection_freq=e$Freq
    aa=rasterize(a,cost,"selection_freq")
    
    print("writing out results")
    ## produce mgmt: rescale between -1 and 1, where -1= highly selected marxan pixels (e.g. most important for avoiding bycatch); 1=infrequently selected marxan pixels (e.g. least important for avoiding bycatch)
    bb=inv_alt_rasterRescale(aa)*-1
    writeRaster(bb,paste0(outdir,"marxan_",paste0(weightings,collapse = "_"),"_",get_date,"_raw"),overwrite=T)
    make_png_marxan(bb,get_date = get_date,outdir=outdir,type="raw",namesrisk = namesrisk,weightings = weightings)
    
  }
  
}

##### demo run ####
# get_date="2011-09-01"
# biofeats=c("blshobs","blshtrk_nolat","casl_noLat","lbst_nolat")
# cost="swor"
# dailypreddir="~/Dropbox/Eco-ROMS/Model Prediction Plots/daily_predictions/"
# namesrisk<-c("Blue shark bycatch","Blue sharks","Sea lions","Leatherbacks","Swordfish")
# weightings<-c(-0.1,-0.1,-0.05,-0.2,0.1)
# outdir="~/Dropbox/Eco-ROMS/EcoROMSruns/output/marxan/"
 scp(get_date = get_date,biofeats = biofeats,cost=cost,dailypreddir = dailypreddir,weightings = weightings,namesrisk = namesrisk)


 make_png_marxan_old=function(r,get_date,outdir,type,weightings,namesrisk){ ### does what it says, original function, scale bar on bottom + annotation
  
  png(paste0(outdir,"marxan_",paste0(weightings,collapse = "_"),"_",get_date,"_",type,".png"), width=5, height=7, units="in", res=400)
  par(ps=10) #settings before layout
  layout(matrix(c(1,2), nrow=2, ncol=1, byrow=TRUE), heights=c(4,1), widths=7)
  par(cex=1) # layout has the tendency change par()$cex, so this step is important for control
  
  par(mar=c(4,4,1,1)) # I usually set my margins before each plot
  pal <- colorRampPalette(c("red","orange","white","cyan","blue"))
  ncolors <- 100
  breaks <- seq(-1,1,,ncolors+1)
  image(r, col=pal(ncolors), breaks=breaks, ylab="", xlab="", xlim=c(-130,-115.5),ylim=c(30,47))
  maps::map('worldHires',add=TRUE,col=grey(0.7),fill=TRUE)
  mtext(paste0(namesrisk,collapse = ", "), side=1, line=1.8) 
  mtext(paste0(weightings,collapse = ", "), side=1, line=2.5) 
  
  box()
  
  par(mar=c(4,4,0,1)) # I usually set my margins before each plot
  levs <- breaks[-1] - diff(breaks)/2
  image(x=levs, y=1, z=as.matrix(levs), col=pal(ncolors), breaks=breaks, ylab="", xlab="", yaxt="n")
  mtext(paste0("Marxan ", type," solution for ",get_date,sep=" "), side=1, line=2.5)
  
  box()
  
  dev.off() # closes device
}