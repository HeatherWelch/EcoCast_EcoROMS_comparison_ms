####### script to extract EcoCast and Marxan values from runs
source("hindcast_ms/extract/hindcast_extracto.R")

preddir="~/Dropbox/Eco-ROMS/EcoROMSruns/output/hindcast_ms/"
outdir="hindcast_ms/extract/extractions/"
points=read.csv("hindcast_ms/extract/random_points.csv")

## scenario A --> isolating the effect of swordfish weightings (5 runs, weightings are the same for both algorithms) (run) #### 
marxandir="marxan_run_A/" ## fixing run A (see fixing_run_A.R)
ER_weightings <-c(0,0,0,0,0.1) #run A.1
M_weightings <-c(0,0,0,0,0.1)
run="A.1"
hindcast_extracto(points=points,outdir=outdir,ER_weightings=ER_weightings,M_weightings=M_weightings,preddir=preddir,run=run,marxandir=marxandir)

ER_weightings <-c(0,0,0,0,0.3) #run A.2
M_weightings <-c(0,0,0,0,0.3)
run="A.2"
hindcast_extracto(points=points,outdir=outdir,ER_weightings=ER_weightings,M_weightings=M_weightings,preddir=preddir,run=run,marxandir=marxandir)

ER_weightings <-c(0,0,0,0,0.5) #run A.3
M_weightings <-c(0,0,0,0,0.5)
run="A.3"
hindcast_extracto(points=points,outdir=outdir,ER_weightings=ER_weightings,M_weightings=M_weightings,preddir=preddir,run=run,marxandir=marxandir)

ER_weightings <-c(0,0,0,0,0.7) #run A.4
M_weightings <-c(0,0,0,0,0.7)
run="A.4"
hindcast_extracto(points=points,outdir=outdir,ER_weightings=ER_weightings,M_weightings=M_weightings,preddir=preddir,run=run,marxandir=marxandir)

ER_weightings <-c(0,0,0,0,0.9) #run A.5
M_weightings <-c(0,0,0,0,0.9)
run="A.5"
hindcast_extracto(points=points,outdir=outdir,ER_weightings=ER_weightings,M_weightings=M_weightings,preddir=preddir,run=run,marxandir=marxandir)

## scenario B --> isolating the effect of leatherback weightings (5 runs, weightings are the same for both algorithms) (run) #### 
marxandir="marxan/" 
ER_weightings <-c(0,0,0,-0.1,0) #run B.1
M_weightings <-c(0,0,0,-0.1,0)
run="B.1"
hindcast_extracto(points=points,outdir=outdir,ER_weightings=ER_weightings,M_weightings=M_weightings,preddir=preddir,run=run,marxandir=marxandir)

ER_weightings <-c(0,0,0,-0.3,0) #run B.2
M_weightings <-c(0,0,0,-0.3,0)
run="B.2"
hindcast_extracto(points=points,outdir=outdir,ER_weightings=ER_weightings,M_weightings=M_weightings,preddir=preddir,run=run,marxandir=marxandir)

ER_weightings <-c(0,0,0,-0.5,0) #run B.3
M_weightings <-c(0,0,0,-0.5,0)
run="B.3"
hindcast_extracto(points=points,outdir=outdir,ER_weightings=ER_weightings,M_weightings=M_weightings,preddir=preddir,run=run,marxandir=marxandir)

ER_weightings <-c(0,0,0,-0.7,0) #run B.4
M_weightings <-c(0,0,0,-0.7,0)
run="B.4"
hindcast_extracto(points=points,outdir=outdir,ER_weightings=ER_weightings,M_weightings=M_weightings,preddir=preddir,run=run,marxandir=marxandir)

ER_weightings <-c(0,0,0,-0.9,0) #run B.5
M_weightings <-c(0,0,0,-0.9,0)
run="B.5"
hindcast_extracto(points=points,outdir=outdir,ER_weightings=ER_weightings,M_weightings=M_weightings,preddir=preddir,run=run,marxandir=marxandir)
