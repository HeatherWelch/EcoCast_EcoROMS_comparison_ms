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

## scenario C--> testing the ability to manage swordfish and leatherback equally (5 runs, weightings are the same for both algorithms) (run) ####
marxandir="marxan" 
ER_weightings <-c(0,0,0,-0.1,0.1) #run C.1
M_weightings <-c(0,0,0,-0.1,0.1)
run="C.1"
hindcast_extracto(points=points,outdir=outdir,ER_weightings=ER_weightings,M_weightings=M_weightings,preddir=preddir,run=run,marxandir=marxandir)

ER_weightings <-c(0,0,0,-0.3,0.3) #run C.2
M_weightings <-c(0,0,0,-0.3,0.3)
run="C.2"
hindcast_extracto(points=points,outdir=outdir,ER_weightings=ER_weightings,M_weightings=M_weightings,preddir=preddir,run=run,marxandir=marxandir)

ER_weightings <-c(0,0,0,-0.5,0.5) #run C.3
M_weightings <-c(0,0,0,-0.5,0.5)
run="C.3"
hindcast_extracto(points=points,outdir=outdir,ER_weightings=ER_weightings,M_weightings=M_weightings,preddir=preddir,run=run,marxandir=marxandir)

ER_weightings <-c(0,0,0,-0.7,0.7) #run C.4
M_weightings <-c(0,0,0,-0.7,0.7)
run="C.4"
hindcast_extracto(points=points,outdir=outdir,ER_weightings=ER_weightings,M_weightings=M_weightings,preddir=preddir,run=run,marxandir=marxandir)

ER_weightings <-c(0,0,0,-0.9,0.9) #run C.5
M_weightings <-c(0,0,0,-0.9,0.9)
run="C.5"
hindcast_extracto(points=points,outdir=outdir,ER_weightings=ER_weightings,M_weightings=M_weightings,preddir=preddir,run=run,marxandir=marxandir)

## scenario D--> testing the ability to manage swordfish and leatherback, tailored based on above results (5 runs, weightings are the same for both algorithms) (run) ####
marxandir="marxan" 

ER_weightings <-c(0,0,0,-0.5,0.1) #run D.1
M_weightings <-c(0,0,0,-0.5,0.1) 
run="D.1"
hindcast_extracto(points=points,outdir=outdir,ER_weightings=ER_weightings,M_weightings=M_weightings,preddir=preddir,run=run,marxandir=marxandir)

ER_weightings <-c(0,0,0,-0.5,0.3) #run D.2
M_weightings <-c(0,0,0,-0.5,0.3)
run="D.2"
hindcast_extracto(points=points,outdir=outdir,ER_weightings=ER_weightings,M_weightings=M_weightings,preddir=preddir,run=run,marxandir=marxandir)

ER_weightings <-c(0,0,0,-0.7,0.1) #run D.3
M_weightings <-c(0,0,0,-0.7,0.1) 
run="D.3"
hindcast_extracto(points=points,outdir=outdir,ER_weightings=ER_weightings,M_weightings=M_weightings,preddir=preddir,run=run,marxandir=marxandir)

ER_weightings <-c(0,0,0,-0.7,0.3) #run D.4
M_weightings <-c(0,0,0,-0.7,0.3) 
run="D.4"
hindcast_extracto(points=points,outdir=outdir,ER_weightings=ER_weightings,M_weightings=M_weightings,preddir=preddir,run=run,marxandir=marxandir)

ER_weightings <-c(0,0,0,-0.7,0.5) #run D.5
M_weightings <-c(0,0,0,-0.7,0.5) 
run="D.5"
hindcast_extracto(points=points,outdir=outdir,ER_weightings=ER_weightings,M_weightings=M_weightings,preddir=preddir,run=run,marxandir=marxandir)


## scenario E--> testing the ability to manage swordfish and leatherback, tailored based on above results, swor > lbst (5 runs, weightings are the same for both algorithms) (run) ####
# in the orginial analysis, this config should make marxan work better 
marxandir="marxan" 

ER_weightings <-c(0,0,0,-0.3,0.7) #run E.1
M_weightings <-c(0,0,0,-0.3,0.7)
run="E.1"
hindcast_extracto(points=points,outdir=outdir,ER_weightings=ER_weightings,M_weightings=M_weightings,preddir=preddir,run=run,marxandir=marxandir)

ER_weightings <-c(0,0,0,-0.3,0.9) #run E.2
M_weightings <-c(0,0,0,-0.3,0.9)
run="E.2"
hindcast_extracto(points=points,outdir=outdir,ER_weightings=ER_weightings,M_weightings=M_weightings,preddir=preddir,run=run,marxandir=marxandir)

ER_weightings <-c(0,0,0,-0.5,0.7) #run E.3
M_weightings <-c(0,0,0,-0.5,0.7) 
run="E.3"
hindcast_extracto(points=points,outdir=outdir,ER_weightings=ER_weightings,M_weightings=M_weightings,preddir=preddir,run=run,marxandir=marxandir)

ER_weightings <-c(0,0,0,-0.5,0.9) #run E.4
M_weightings <-c(0,0,0,-0.5,0.9) 
run="E.4"
hindcast_extracto(points=points,outdir=outdir,ER_weightings=ER_weightings,M_weightings=M_weightings,preddir=preddir,run=run,marxandir=marxandir)

ER_weightings <-c(0,0,0,-0.7,0.9) #run E.5
M_weightings <-c(0,0,0,-0.7,0.9) 
run="E.5"
hindcast_extracto(points=points,outdir=outdir,ER_weightings=ER_weightings,M_weightings=M_weightings,preddir=preddir,run=run,marxandir=marxandir)

