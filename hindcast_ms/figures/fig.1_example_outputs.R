## figure 1. Examples of how EcoCast and Marxan vary over different mgmg scenarios

source("/Volumes/SeaGate/EcoROMS/Eco-ROMS-private/EcoROMs/save_png.R")

weightings<-c(-0.1,-0.1,-0.05,-0.4,0.2)
dates=list.files("~/Dropbox/Eco-ROMS/EcoROMSruns/output/hindcast/marxan",pattern=".grd") %>% grep("_raw",.,value=T) %>% grep(paste0(weightings,collapse="_"),.,value=T) %>% 
  gsub(paste0("marxan_nocost_",paste0(weightings,collapse="_"),"_"),"",.) %>% gsub("_raw.grd","",.)

## directories
dailypreddir="~/Dropbox/Eco-ROMS/Model Prediction Plots/daily_predictions/"
speciesdirs=c("blshobs","blshtrk_nolat","casl_noLat","lbst_nolat","swor")
blshobsdir=paste0(dailypreddir,speciesdirs[1],"/")
blshtrkdir=paste0(dailypreddir,speciesdirs[2],"/")
casldir=paste0(dailypreddir,speciesdirs[3],"/")
lbstdir=paste0(dailypreddir,speciesdirs[4],"/")
swordir=paste0(dailypreddir,speciesdirs[5],"/")

tempdir="~/Dropbox/Eco-ROMS/ROMS & Bathym Data/daily_prediction_layers/"
marxdir="~/Dropbox/Eco-ROMS/EcoROMSruns/output/hindcast_ms/marxan/"
ecodir="~/Dropbox/Eco-ROMS/EcoROMSruns/output/hindcast_ms/mean/"

weightings <-c(0,0,0,-0.5,0) #run B.3
paste(weightings,collapse ="_")

date=dates[18]

## raw species layers ####
blshobs=list.files(blshobsdir,full.names = T) %>% grep(date,.,value=T) %>% grep("mean",.,value=T)
blshtrk=list.files(blshtrkdir,full.names = T) %>% grep(date,.,value=T) %>% grep("mean",.,value=T)
casl=list.files(casldir,full.names = T) %>% grep(date,.,value=T) %>% grep("mean",.,value=T)
lbst=list.files(lbstdir,full.names = T) %>% grep(date,.,value=T) %>% grep("mean",.,value=T)
swor=list.files(swordir,full.names = T) %>% grep(date,.,value=T) %>% grep("mean",.,value=T)

file.copy(blshobs,"/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/hindcast_ms/figures/example_runs_fig1")
file.copy(blshtrk,"/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/hindcast_ms/figures/example_runs_fig1")
file.copy(casl,"/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/hindcast_ms/figures/example_runs_fig1")
file.copy(lbst,"/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/hindcast_ms/figures/example_runs_fig1")
file.copy(swor,"/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/hindcast_ms/figures/example_runs_fig1")

## averaging blsh
a=raster("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/hindcast_ms/figures/example_runs_fig1/blshobs_1997-10-01_mean.grd")
b=raster("/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/hindcast_ms/figures/example_runs_fig1/blshtrk_nolat_1997-10-01_mean.grd")
c=mean(a,b)
outdir="/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/hindcast_ms/figures/example_runs_fig1/"
make_png_operationalization(r=c,spname = "blshAve",get_date=date, outDir = outdir,type = "mean")
image(c, col=pal(ncolors), breaks=breaks, ylab="", xlab="", xlim=c(-130,-115.5),ylim=c(30,47))
image.plot(c,col=pal(ncolors),xlim=c(-130,-115),ylim=c(30,47),zlim=c(0,1))

## EcoCast lbst, swor, dual
weightings <-c(0,0,0,0,1) #run M.1
ecocast=list.files(ecodir,full.names = T) %>% grep(paste0(paste(weightings,collapse ="_"),"_",date,"_mean"),.,value=T)%>% grep("unscaled",.,value=T)
file.copy(ecocast,outdir)

weightings <-c(0,0,0,-1,0) #run M.2
ecocast=list.files(ecodir,full.names = T) %>% grep(paste0(paste(weightings,collapse ="_"),"_",date,"_mean"),.,value=T)%>% grep("unscaled",.,value=T)
file.copy(ecocast,outdir)

weightings <-c(0,0,0,-0.5,0.5) #run C.3
ecocast=list.files(ecodir,full.names = T) %>% grep(paste0(paste(weightings,collapse ="_"),"_",date,"_mean"),.,value=T)%>% grep("unscaled",.,value=T)
file.copy(ecocast,outdir)


## EcoCast, increasing numbers of species
# weightings <-c(0,0,0,-1,0) #run M.2 (already copies)
# ecocast=list.files(ecodir,full.names = T) %>% grep(paste0(paste(weightings,collapse ="_"),"_",date,"_mean"),.,value=T)%>% grep("unscaled",.,value=T)
# file.copy(ecocast,outdir)
# 
# weightings <-c(0,0,0,-0.5,0.5) #run C.3  (already copies)
# ecocast=list.files(ecodir,full.names = T) %>% grep(paste0(paste(weightings,collapse ="_"),"_",date,"_mean"),.,value=T)%>% grep("unscaled",.,value=T)
# file.copy(ecocast,outdir)

weightings <-c(-0.25,-0.25,0,-0.5,0.5) #run G.3
ecocast=list.files(ecodir,full.names = T) %>% grep(paste0(paste(weightings,collapse ="_"),"_",date,"_mean"),.,value=T)%>% grep("unscaled",.,value=T)
file.copy(ecocast,outdir)

weightings <-c(-0.25,-0.25,-0.5,-0.5,0.5) #run J.3
ecocast=list.files(ecodir,full.names = T) %>% grep(paste0(paste(weightings,collapse ="_"),"_",date,"_mean"),.,value=T)%>% grep("unscaled",.,value=T)
file.copy(ecocast,outdir)


## Marxan, swordfish
weightings <-c(0,0,0,0,0.1) #run A.1
marxan=list.files(marxdir,full.names = T) %>% grep(paste0(paste(weightings,collapse ="_"),"_",date),.,value=T)%>% grep("raw_unscaled",.,value=T)
file.copy(marxan,outdir)

weightings <-c(0,0,0,0,0.3) #run A.2
marxan=list.files(marxdir,full.names = T) %>% grep(paste0(paste(weightings,collapse ="_"),"_",date),.,value=T)%>% grep("raw_unscaled",.,value=T)
file.copy(marxan,outdir)

weightings <-c(0,0,0,0,0.5) #run A.3
marxan=list.files(marxdir,full.names = T) %>% grep(paste0(paste(weightings,collapse ="_"),"_",date),.,value=T)%>% grep("raw_unscaled",.,value=T)
file.copy(marxan,outdir)

weightings <-c(0,0,0,0,0.7) #run A.4
marxan=list.files(marxdir,full.names = T) %>% grep(paste0(paste(weightings,collapse ="_"),"_",date),.,value=T)%>% grep("raw_unscaled",.,value=T)
file.copy(marxan,outdir)

weightings <-c(0,0,0,0,0.9) #run A.5
marxan=list.files(marxdir,full.names = T) %>% grep(paste0(paste(weightings,collapse ="_"),"_",date),.,value=T)%>% grep("raw_unscaled",.,value=T)
file.copy(marxan,outdir)

## Marxan, leatherback
weightings <-c(0,0,0,-0.1,0) #run B.1
marxan=list.files(marxdir,full.names = T) %>% grep(paste0(paste(weightings,collapse ="_"),"_",date),.,value=T)%>% grep("raw_unscaled",.,value=T)
file.copy(marxan,outdir)

weightings <-c(0,0,0,-0.3,0) #run B.2
marxan=list.files(marxdir,full.names = T) %>% grep(paste0(paste(weightings,collapse ="_"),"_",date),.,value=T)%>% grep("raw_unscaled",.,value=T)
file.copy(marxan,outdir)

weightings <-c(0,0,0,-0.5,0) #run B.3
marxan=list.files(marxdir,full.names = T) %>% grep(paste0(paste(weightings,collapse ="_"),"_",date),.,value=T)%>% grep("raw_unscaled",.,value=T)
file.copy(marxan,outdir)

weightings <-c(0,0,0,-0.7,0) #run B.4
marxan=list.files(marxdir,full.names = T) %>% grep(paste0(paste(weightings,collapse ="_"),"_",date),.,value=T)%>% grep("raw_unscaled",.,value=T)
file.copy(marxan,outdir)

weightings <-c(0,0,0,-0.9,0) #run B.5
marxan=list.files(marxdir,full.names = T) %>% grep(paste0(paste(weightings,collapse ="_"),"_",date),.,value=T)%>% grep("raw_unscaled",.,value=T)
file.copy(marxan,outdir)

## Marxan, leatherback + swor
weightings <-c(0,0,0,-0.1,0.1) #run C.1
marxan=list.files(marxdir,full.names = T) %>% grep(paste0(paste(weightings,collapse ="_"),"_",date),.,value=T)%>% grep("raw_unscaled",.,value=T)
file.copy(marxan,outdir)

weightings <-c(0,0,0,-0.3,0.3) #run C.2
marxan=list.files(marxdir,full.names = T) %>% grep(paste0(paste(weightings,collapse ="_"),"_",date),.,value=T)%>% grep("raw_unscaled",.,value=T)
file.copy(marxan,outdir)

weightings <-c(0,0,0,-0.5,0.5) #run C.3
marxan=list.files(marxdir,full.names = T) %>% grep(paste0(paste(weightings,collapse ="_"),"_",date),.,value=T)%>% grep("raw_unscaled",.,value=T)
file.copy(marxan,outdir)

weightings <-c(0,0,0,-0.7,0.7) #run C.4
marxan=list.files(marxdir,full.names = T) %>% grep(paste0(paste(weightings,collapse ="_"),"_",date),.,value=T)%>% grep("raw_unscaled",.,value=T)
file.copy(marxan,outdir)

weightings <-c(0,0,0,-0.9,0.9) #run C.5
marxan=list.files(marxdir,full.names = T) %>% grep(paste0(paste(weightings,collapse ="_"),"_",date),.,value=T)%>% grep("raw_unscaled",.,value=T)
file.copy(marxan,outdir)

#### averageing by warm cold ####
outdir="/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/hindcast_ms/figures/example_runs_fig1/"
dir.create(paste0(outdir,"lbst/"))
dir.create(paste0(outdir,"casl/"))
dir.create(paste0(outdir,"swor/"))
dir.create(paste0(outdir,"blsh/"))

a=list.files(lbstdir,pattern="*.grd",full.names = T) %>% grep("2005",.,value=T)%>% grep("mean",.,value=T)
b=list.files(lbstdir,pattern="*.grd",full.names = T) %>% grep("1997",.,value=T)%>% grep("mean",.,value=T)
c=list(a,b) %>% unlist() %>% stack() %>% mean(.)
make_png_operationalization(r=c,spname = "lbst",get_date="warm", outDir = outdir,type = "mean")

d=list.files(lbstdir,pattern="*.grd",full.names = T) %>% grep("2003",.,value=T)%>% grep("mean",.,value=T) %>% stack() %>% mean()
make_png_operationalization(r=d,spname = "lbst",get_date="cold", outDir = outdir,type = "mean")

a=list.files(swordir,pattern="*.grd",full.names = T) %>% grep("2005",.,value=T)%>% grep("mean",.,value=T)
b=list.files(swordir,pattern="*.grd",full.names = T) %>% grep("1997",.,value=T)%>% grep("mean",.,value=T)
c=list(a,b) %>% unlist() %>% stack() %>% mean(.)
make_png_operationalization(r=c,spname = "swor",get_date="warm", outDir = outdir,type = "mean")

d=list.files(swordir,pattern="*.grd",full.names = T) %>% grep("2003",.,value=T)%>% grep("mean",.,value=T) %>% stack() %>% mean()
make_png_operationalization(r=d,spname = "swor",get_date="cold", outDir = outdir,type = "mean")

a=list.files(casldir,pattern="*.grd",full.names = T) %>% grep("2005",.,value=T)%>% grep("mean",.,value=T)
b=list.files(casldir,pattern="*.grd",full.names = T) %>% grep("1997",.,value=T)%>% grep("mean",.,value=T)
c=list(a,b) %>% unlist() %>% stack() %>% mean(.)
make_png_operationalization(r=c,spname = "casl",get_date="warm", outDir = outdir,type = "mean")

d=list.files(casldir,pattern="*.grd",full.names = T) %>% grep("2003",.,value=T)%>% grep("mean",.,value=T) %>% stack() %>% mean()
make_png_operationalization(r=d,spname = "casl",get_date="cold", outDir = outdir,type = "mean")

a=list.files(blshobsdir,pattern="*.grd",full.names = T) %>% grep("2005",.,value=T)%>% grep("mean",.,value=T)
b=list.files(blshobsdir,pattern="*.grd",full.names = T) %>% grep("1997",.,value=T)%>% grep("mean",.,value=T)
a.1=list.files(blshtrkdir,pattern="*.grd",full.names = T) %>% grep("2005",.,value=T)%>% grep("mean",.,value=T)
b.1=list.files(blshtrkdir,pattern="*.grd",full.names = T) %>% grep("1997",.,value=T)%>% grep("mean",.,value=T)
c=list(a,b,a.1,b.1) %>% unlist() %>% stack() %>% mean(.)
make_png_operationalization(r=c,spname = "blsh",get_date="warm", outDir = outdir,type = "mean")

d=list.files(blshobsdir,pattern="*.grd",full.names = T) %>% grep("2003",.,value=T)%>% grep("mean",.,value=T)
d.1=list.files(blshtrkdir,pattern="*.grd",full.names = T) %>% grep("2003",.,value=T)%>% grep("mean",.,value=T)
d=list(d,d.1) %>% unlist() %>% stack() %>% mean()
make_png_operationalization(r=d,spname = "blsh",get_date="cold", outDir = outdir,type = "mean")

### testing correlations in ppt conceptual schematic

one=c(1,.33,.33,.33)
one_sf=c(6,0,0,0)
cor(one,one_sf)
lm(one_sf~one)

one=c(.5,0,.25,.25)
one_sf=c(6,0,0,0)
cor(one,one_sf)
lm(one_sf~one)

one=c(.5,.5,.5,.5)
one_sf=c(3,3,3,3)
cor(one,one_sf)
lm(one_sf~one)

one=c(.25,.25,.25,.25)
one_sf=c(6,0,0,0)
cor(one,one_sf)
lm(one_sf~one)

### new idea for figure 6
#a=a %>% filter(id=="Marxan_run_D.5_Cold"|id=="Marxan_run_J.6_Warm"|id=="EcoROMS_run_L.4_Cold"|id=="EcoROMS_run_J.6_Warm")
namesrisk<-c("Blue shark bycatch","Blue sharks","Sea lions","Leatherbacks","Swordfish")
Run_ecoroms_hindcast_ms=function(r,get_date,outdir,namesrisk,weightings,version){ ### added to streamline hindcast validation
  
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
  PlotEcoROMS<-function(r,get_date,outdir,leg=TRUE,scalbar=FALSE,risk=weightings,spp=namesrisk,version="_V1",contourval=NA,addLCA=FALSE,addtext=TRUE){
    
    ####### produce png - unscaled
    png(paste(outdir,"EcoROMS_original_unscaled_",paste(risk,collapse="_"),'_',get_date,version,'.png',sep=''),width=960,height=1100,units='px',pointsize=20)
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
    
    
    
    maps::map('worldHires',add=TRUE,col=grey(0.7),fill=TRUE)
    if (addtext) {
      text(-122,46,get_date,adj=c(0,0),cex=2) 
      text(-122,45,"Species weightings",adj=c(0,0),cex=1)
      #text(-122,45,paste(namesrisk[1],' weighting = ',risk[1],sep=''),adj=c(0,0),cex=.75)
      text(-122,44.5,paste(namesrisk[2],' weighting = ',risk[2],sep=''),adj=c(0,0),cex=.75)
      text(-122,44,paste(namesrisk[3],' weighting = ',risk[3],sep=''),adj=c(0,0),cex=.75)
      text(-122,43.5,paste(namesrisk[4],' weighting = ',risk[4],sep=''),adj=c(0,0),cex=.75)
      text(-122,43,paste(namesrisk[5],' weighting = ',risk[5],sep=''),adj=c(0,0),cex=.75)
      text(-122,42,"EcoROMS original (unscaled)",adj=c(0,0),cex=1)
      
    }
    
    box()
    dev.off()
    
    
    ####### produce raster
    #writeRaster(r,filename=paste(wd,'/EcoROMS_original_unscaled_',paste(risk,collapse="_"),"_",get_date,version,'.grd',sep=''),overwrite=TRUE) 
    
  }
  
  PlotEcoROMS(r=r,get_date=get_date,outdir = outdir,risk=weightings,version="_mean") ## standard directory
}

### ecocast ####
weightings <-c(-0.15,-0.15,-0.03,-0.3,0.3) #run L.4 CASL 10% as important
ecocast=list.files(ecodir,full.names = T) %>% grep(paste0(paste(weightings,collapse ="_")),.,value=T)%>% grep("unscaled",.,value=T) %>% grep("2003",.,value=T)%>% grep(".grd",.,value=T)
mean=stack(ecocast) %>% mean()
get_date="EcoCast Cold"
Run_ecoroms_hindcast_ms(r=mean,get_date = get_date,outdir =outdir,namesrisk = namesrisk,weightings=weightings,version="_mean" )
plot(mean)

weightings <-c(-0.25,-0.25,-0.5,-0.3,0.7) #run J.6 (E.1)
ecocast=list.files(ecodir,full.names = T) %>% grep(paste0(paste(weightings,collapse ="_")),.,value=T)%>% grep("unscaled",.,value=T) %>% grep("2005",.,value=T)%>% grep(".grd",.,value=T)
ecocast3=list.files(ecodir,full.names = T) %>% grep(paste0(paste(weightings,collapse ="_")),.,value=T)%>% grep("unscaled",.,value=T) %>% grep("1997",.,value=T)%>% grep(".grd",.,value=T)
ecocast=list(ecocast,ecocast3) %>% unlist
mean=stack(ecocast) %>% mean()
get_date="EcoCast Warm"
Run_ecoroms_hindcast_ms(r=mean,get_date = get_date,outdir =outdir,namesrisk = namesrisk,weightings=weightings,version="_mean" )
plot(mean)

weightings <-c(-0.125,-0.125,-0.25,-0.25,0.25) #run M.5
ecocast=list.files(ecodir,full.names = T) %>% grep(paste0(paste(weightings,collapse ="_")),.,value=T)%>% grep("unscaled",.,value=T) %>% grep("2003",.,value=T)%>% grep(".grd",.,value=T)
mean=stack(ecocast) %>% mean()
get_date="EcoCast fixed (Cold)"
Run_ecoroms_hindcast_ms(r=mean,get_date = get_date,outdir =outdir,namesrisk = namesrisk,weightings=weightings,version="_mean" )
plot(mean)

weightings <-c(-0.125,-0.125,-0.25,-0.25,0.25) #run M.5
ecocast=list.files(ecodir,full.names = T) %>% grep(paste0(paste(weightings,collapse ="_")),.,value=T)%>% grep("unscaled",.,value=T) %>% grep("2005",.,value=T)%>% grep(".grd",.,value=T)
ecocast3=list.files(ecodir,full.names = T) %>% grep(paste0(paste(weightings,collapse ="_")),.,value=T)%>% grep("unscaled",.,value=T) %>% grep("1997",.,value=T)%>% grep(".grd",.,value=T)
ecocast=list(ecocast,ecocast3) %>% unlist
mean=stack(ecocast) %>% mean()
get_date="EcoCast fixed (Warm)"
Run_ecoroms_hindcast_ms(r=mean,get_date = get_date,outdir =outdir,namesrisk = namesrisk,weightings=weightings,version="_mean" )
plot(mean)

### marxan ####
weightings <-c(0,0,0,-0.7,0.5) #run D.5
ecocast=list.files(marxdir,full.names = T) %>% grep(paste0(paste(weightings,collapse ="_")),.,value=T)%>% grep("unscaled",.,value=T) %>% grep("2003",.,value=T)%>% grep(".grd",.,value=T)
mean=stack(ecocast) %>% mean()
get_date="Marxan Cold"
Run_ecoroms_hindcast_ms(r=mean,get_date = get_date,outdir =outdir,namesrisk = namesrisk,weightings=weightings,version="_mean" )
plot(mean)

weightings <-c(-0.25,-0.25,-0.5,-0.3,0.7) #run J.6 (E.1)
ecocast=list.files(marxdir,full.names = T) %>% grep(paste0(paste(weightings,collapse ="_")),.,value=T)%>% grep("unscaled",.,value=T) %>% grep("2005",.,value=T)%>% grep(".grd",.,value=T)
ecocast3=list.files(marxdir,full.names = T) %>% grep(paste0(paste(weightings,collapse ="_")),.,value=T)%>% grep("unscaled",.,value=T) %>% grep("1997",.,value=T)%>% grep(".grd",.,value=T)
ecocast=list(ecocast,ecocast3) %>% unlist
mean=stack(ecocast) %>% mean()
get_date="Marxan Warm"
Run_ecoroms_hindcast_ms(r=mean,get_date = get_date,outdir =outdir,namesrisk = namesrisk,weightings=weightings,version="_mean" )
plot(mean)

weightings <-c(-0.25,-0.25,-0.5,-0.5,0.5) #run J.3 (C.3)
ecocast=list.files(marxdir,full.names = T) %>% grep(paste0(paste(weightings,collapse ="_")),.,value=T)%>% grep("unscaled",.,value=T) %>% grep("2003",.,value=T)%>% grep(".grd",.,value=T)
mean=stack(ecocast) %>% mean()
get_date="Marxan fixed (Cold)"
Run_ecoroms_hindcast_ms(r=mean,get_date = get_date,outdir =outdir,namesrisk = namesrisk,weightings=weightings,version="_mean" )
plot(mean)

weightings <-c(-0.25,-0.25,-0.5,-0.5,0.5) #run J.3 (C.3)
ecocast=list.files(marxdir,full.names = T) %>% grep(paste0(paste(weightings,collapse ="_")),.,value=T)%>% grep("unscaled",.,value=T) %>% grep("2005",.,value=T)%>% grep(".grd",.,value=T)
ecocast3=list.files(marxdir,full.names = T) %>% grep(paste0(paste(weightings,collapse ="_")),.,value=T)%>% grep("unscaled",.,value=T) %>% grep("1997",.,value=T)%>% grep(".grd",.,value=T)
ecocast=list(ecocast,ecocast3) %>% unlist
mean=stack(ecocast) %>% mean()
get_date="Marxan fixed (Warm)"
Run_ecoroms_hindcast_ms(r=mean,get_date = get_date,outdir =outdir,namesrisk = namesrisk,weightings=weightings,version="_mean" )
plot(mean)

# a=stack(mean,d)
# corMat=layerStats(a,"pearson",na.rm = T)
# colnames(corMat$`pearson correlation coefficient`)=c("blshobs","blshtrk","casl","lbst","swor","marxan","ecocast","temp")
# rownames(corMat$`pearson correlation coefficient`)=c("blshobs","blshtrk","casl","lbst","swor","marxan","ecocast","temp")
