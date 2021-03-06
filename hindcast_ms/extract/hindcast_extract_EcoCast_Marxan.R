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

## scenario F--> adding in bluesharks. taking the best weightins from A-E and adding some blueshark to see how things change (run) ####
marxandir="marxan" 

ER_weightings <-c(-0.05,-0.05,0,-0.3,0) #run F.1 (B.2)
M_weightings <-c(-0.05,-0.05,0,-0.3,0) #run F.1 (B.2)
run="F.1"
hindcast_extracto(points=points,outdir=outdir,ER_weightings=ER_weightings,M_weightings=M_weightings,preddir=preddir,run=run,marxandir=marxandir)

ER_weightings <-c(-0.05,-0.05,0,-0.9,0) #run F.2 (B.5)
M_weightings <-c(-0.05,-0.05,0,-0.9,0) #run F.2 (B.5)
run="F.2"
hindcast_extracto(points=points,outdir=outdir,ER_weightings=ER_weightings,M_weightings=M_weightings,preddir=preddir,run=run,marxandir=marxandir)

ER_weightings <-c(-0.05,-0.05,0,-0.5,0.5) #run F.3 (C.3)
M_weightings <-c(-0.05,-0.05,0,-0.5,0.5) #run F.3 (C.3)
run="F.3"
hindcast_extracto(points=points,outdir=outdir,ER_weightings=ER_weightings,M_weightings=M_weightings,preddir=preddir,run=run,marxandir=marxandir)

ER_weightings <-c(-0.05,-0.05,0,-0.7,0.1) #run F.4 (D.3)
M_weightings <-c(-0.05,-0.05,0,-0.7,0.1) #run F.4 (D.3)
run="F.4"
hindcast_extracto(points=points,outdir=outdir,ER_weightings=ER_weightings,M_weightings=M_weightings,preddir=preddir,run=run,marxandir=marxandir)

ER_weightings <-c(-0.05,-0.05,0,-0.7,0.3) #run F.5 (D.4)
M_weightings <-c(-0.05,-0.05,0,-0.7,0.3) #run F.5 (D.4) 
run="F.5"
hindcast_extracto(points=points,outdir=outdir,ER_weightings=ER_weightings,M_weightings=M_weightings,preddir=preddir,run=run,marxandir=marxandir)

ER_weightings <-c(-0.05,-0.05,0,-0.3,0.7) #run F.6 (E.1)
M_weightings <-c(-0.05,-0.05,0,-0.3,0.7) #run F.6 (E.1)
run="F.6"
hindcast_extracto(points=points,outdir=outdir,ER_weightings=ER_weightings,M_weightings=M_weightings,preddir=preddir,run=run,marxandir=marxandir)


## scenario G--> adding in bluesharks, a little bit more. taking the best weightins from A-E and adding some blueshark to see how things change.  (run) ####
marxandir="marxan" 

ER_weightings <-c(-0.25,-0.25,0,-0.3,0) #run G.1 (B.2)
M_weightings <-c(-0.25,-0.25,0,-0.3,0) #run G.1 (B.2)
run="G.1"
hindcast_extracto(points=points,outdir=outdir,ER_weightings=ER_weightings,M_weightings=M_weightings,preddir=preddir,run=run,marxandir=marxandir)

ER_weightings <-c(-0.25,-0.25,0,-0.9,0) #run G.2 (B.5)
M_weightings <-c(-0.25,-0.25,0,-0.9,0) #run G.2 (B.5)
run="G.2"
hindcast_extracto(points=points,outdir=outdir,ER_weightings=ER_weightings,M_weightings=M_weightings,preddir=preddir,run=run,marxandir=marxandir)

ER_weightings <-c(-0.25,-0.25,0,-0.5,0.5) #run G.3 (C.3)
M_weightings <-c(-0.25,-0.25,0,-0.5,0.5) #run G.3 (C.3)
run="G.3"
hindcast_extracto(points=points,outdir=outdir,ER_weightings=ER_weightings,M_weightings=M_weightings,preddir=preddir,run=run,marxandir=marxandir)

ER_weightings <-c(-0.25,-0.25,0,-0.7,0.1) #run G.4 (D.3)
M_weightings <-c(-0.25,-0.25,0,-0.7,0.1) #run G.4 (D.3)
run="G.4"
hindcast_extracto(points=points,outdir=outdir,ER_weightings=ER_weightings,M_weightings=M_weightings,preddir=preddir,run=run,marxandir=marxandir)

ER_weightings <-c(-0.25,-0.25,0,-0.7,0.3) #run G.5 (D.4)
M_weightings <-c(-0.25,-0.25,0,-0.7,0.3) #run G.5 (D.4)
run="G.5"
hindcast_extracto(points=points,outdir=outdir,ER_weightings=ER_weightings,M_weightings=M_weightings,preddir=preddir,run=run,marxandir=marxandir)

ER_weightings <-c(-0.25,-0.25,0,-0.3,0.7) #run G.6 (E.1)
M_weightings <-c(-0.25,-0.25,0,-0.3,0.7) #run G.6 (E.1)
run="G.6"
hindcast_extracto(points=points,outdir=outdir,ER_weightings=ER_weightings,M_weightings=M_weightings,preddir=preddir,run=run,marxandir=marxandir)



## scenario H--> adding in bluesharks, a little bit more x2. taking the best weightins from A-E and adding some blueshark to see how things change.  (run) ####
marxandir="marxan" 

ER_weightings <-c(-0.35,-0.35,0,-0.3,0) #run H.1 (B.2)
M_weightings <-c(-0.35,-0.35,0,-0.3,0) #run H.1 (B.2)
run="H.1"
hindcast_extracto(points=points,outdir=outdir,ER_weightings=ER_weightings,M_weightings=M_weightings,preddir=preddir,run=run,marxandir=marxandir)

ER_weightings <-c(-0.35,-0.35,0,-0.9,0) #run H.2 (B.5)
M_weightings <-c(-0.35,-0.35,0,-0.9,0) #run H.2 (B.5)
run="H.2"
hindcast_extracto(points=points,outdir=outdir,ER_weightings=ER_weightings,M_weightings=M_weightings,preddir=preddir,run=run,marxandir=marxandir)

ER_weightings <-c(-0.35,-0.35,0,-0.5,0.5) #run H.3 (C.3)
M_weightings <-c(-0.35,-0.35,0,-0.5,0.5) #run H.3 (C.3)
run="H.3"
hindcast_extracto(points=points,outdir=outdir,ER_weightings=ER_weightings,M_weightings=M_weightings,preddir=preddir,run=run,marxandir=marxandir)

ER_weightings <-c(-0.35,-0.35,0,-0.7,0.1) #run H.4 (D.3)
M_weightings <-c(-0.25,-0.25,0,-0.7,0.1) #run H.4 (D.3)
run="H.4"
hindcast_extracto(points=points,outdir=outdir,ER_weightings=ER_weightings,M_weightings=M_weightings,preddir=preddir,run=run,marxandir=marxandir)

ER_weightings <-c(-0.35,-0.35,0,-0.7,0.3) #run H.5 (D.4)
M_weightings <-c(-0.35,-0.35,0,-0.7,0.3) #run H.5 (D.4)
run="H.5"
hindcast_extracto(points=points,outdir=outdir,ER_weightings=ER_weightings,M_weightings=M_weightings,preddir=preddir,run=run,marxandir=marxandir)

ER_weightings <-c(-0.35,-0.35,0,-0.3,0.7) #run H.6 (E.1)
M_weightings <-c(-0.35,-0.35,0,-0.3,0.7) #run H.6 (E.1)
run="H.6"
hindcast_extracto(points=points,outdir=outdir,ER_weightings=ER_weightings,M_weightings=M_weightings,preddir=preddir,run=run,marxandir=marxandir)


## scenario I--> adding in bluesharks, and then sealions to check multispecies. taking the best weightins from A-E and adding some blueshark to see how things change.  (run) ####
marxandir="marxan" 

ER_weightings <-c(-0.05,-0.05,-0.1,-0.3,0) #run I.1 (B.2)
M_weightings <-c(-0.05,-0.05,-0.1,-0.3,0) #run I.1 (B.2)
run="I.1"
hindcast_extracto(points=points,outdir=outdir,ER_weightings=ER_weightings,M_weightings=M_weightings,preddir=preddir,run=run,marxandir=marxandir)

ER_weightings <-c(-0.05,-0.05,-0.1,-0.9,0) #run I.2 (B.5)
M_weightings <-c(-0.05,-0.05,-0.1,-0.9,0) #run I.2 (B.5)
run="I.2"
hindcast_extracto(points=points,outdir=outdir,ER_weightings=ER_weightings,M_weightings=M_weightings,preddir=preddir,run=run,marxandir=marxandir)

ER_weightings <-c(-0.05,-0.05,-0.1,-0.5,0.5) #run I.3 (C.3)
M_weightings <-c(-0.05,-0.05,-0.1,-0.5,0.5) #run I.3 (C.3)
run="I.3"
hindcast_extracto(points=points,outdir=outdir,ER_weightings=ER_weightings,M_weightings=M_weightings,preddir=preddir,run=run,marxandir=marxandir)

ER_weightings <-c(-0.05,-0.05,-0.1,-0.7,0.1) #run I.4 (D.3)
M_weightings <-c(-0.05,-0.05,-0.1,-0.7,0.1) #run I.4 (D.3)
run="I.4"
hindcast_extracto(points=points,outdir=outdir,ER_weightings=ER_weightings,M_weightings=M_weightings,preddir=preddir,run=run,marxandir=marxandir)

ER_weightings <-c(-0.05,-0.05,-0.1,-0.7,0.3) #run I.5 (D.4)
M_weightings <-c(-0.05,-0.05,-0.1,-0.7,0.3) #run I.5 (D.4)
run="I.5"
hindcast_extracto(points=points,outdir=outdir,ER_weightings=ER_weightings,M_weightings=M_weightings,preddir=preddir,run=run,marxandir=marxandir)

ER_weightings <-c(-0.05,-0.05,-0.1,-0.3,0.7) #run I.6 (E.1)
M_weightings <-c(-0.05,-0.05,-0.1,-0.3,0.7) #run I.6 (E.1)
run="I.6"
hindcast_extracto(points=points,outdir=outdir,ER_weightings=ER_weightings,M_weightings=M_weightings,preddir=preddir,run=run,marxandir=marxandir)



## scenario J--> adding in bluesharks a little bit more, and then sealions a little bit more to check multispecies. taking the best weightins from A-E and adding some blueshark to see how things change.  (run) ####
marxandir="marxan" 

ER_weightings <-c(-0.25,-0.25,-0.5,-0.3,0) #run J.1 (B.2)
M_weightings <-c(-0.25,-0.25,-0.5,-0.3,0) #run J.1 (B.2)
run="J.1"
hindcast_extracto(points=points,outdir=outdir,ER_weightings=ER_weightings,M_weightings=M_weightings,preddir=preddir,run=run,marxandir=marxandir)

ER_weightings <-c(-0.25,-0.25,-0.5,-0.9,0) #run J.2 (B.5)
M_weightings <-c(-0.25,-0.25,-0.5,-0.9,0) #run J.2 (B.5)
run="J.2"
hindcast_extracto(points=points,outdir=outdir,ER_weightings=ER_weightings,M_weightings=M_weightings,preddir=preddir,run=run,marxandir=marxandir)

ER_weightings <-c(-0.25,-0.25,-0.5,-0.5,0.5) #run J.3 (C.3)
M_weightings <-c(-0.25,-0.25,-0.5,-0.5,0.5) #run J.3 (C.3)
run="J.3"
hindcast_extracto(points=points,outdir=outdir,ER_weightings=ER_weightings,M_weightings=M_weightings,preddir=preddir,run=run,marxandir=marxandir)

ER_weightings <-c(-0.25,-0.25,-0.5,-0.7,0.1) #run J.4 (D.3)
M_weightings <-c(-0.25,-0.25,-0.5,-0.7,0.1) #run J.4 (D.3)
run="J.4"
hindcast_extracto(points=points,outdir=outdir,ER_weightings=ER_weightings,M_weightings=M_weightings,preddir=preddir,run=run,marxandir=marxandir)

ER_weightings <-c(-0.25,-0.25,-0.5,-0.7,0.3) #run J.5 (D.4)
M_weightings <-c(-0.25,-0.25,-0.5,-0.7,0.3) #run J.5 (D.4)
run="J.5"
hindcast_extracto(points=points,outdir=outdir,ER_weightings=ER_weightings,M_weightings=M_weightings,preddir=preddir,run=run,marxandir=marxandir)

ER_weightings <-c(-0.25,-0.25,-0.5,-0.3,0.7) #run J.6 (E.1)
M_weightings <-c(-0.25,-0.25,-0.5,-0.3,0.7) #run J.6 (E.1)
run="J.6"
hindcast_extracto(points=points,outdir=outdir,ER_weightings=ER_weightings,M_weightings=M_weightings,preddir=preddir,run=run,marxandir=marxandir)



## scenario K--> adding in bluesharks a little bit more x2, and then sealions a little bit more to check multispecies. taking the best weightins from A-E and adding some blueshark to see how things change.  (run) ####
marxandir="marxan" 

ER_weightings <-c(-0.35,-0.35,-0.7,-0.3,0) #run K.1 (B.2)
M_weightings <-c(-0.35,-0.35,-0.7,-0.3,0) #run K.1 (B.2)
run="K.1"
hindcast_extracto(points=points,outdir=outdir,ER_weightings=ER_weightings,M_weightings=M_weightings,preddir=preddir,run=run,marxandir=marxandir)

ER_weightings <-c(-0.35,-0.35,-0.7,-0.9,0) #run K.2 (B.5)
M_weightings <-c(-0.35,-0.35,-0.7,-0.9,0) #run K.2 (B.5)
run="K.2"
hindcast_extracto(points=points,outdir=outdir,ER_weightings=ER_weightings,M_weightings=M_weightings,preddir=preddir,run=run,marxandir=marxandir)

ER_weightings <-c(-0.35,-0.35,-0.7,-0.5,0.5) #run K.3 (C.3)
M_weightings <-c(-0.35,-0.35,-0.7,-0.5,0.5) #run K.3 (C.3)
run="K.3"
hindcast_extracto(points=points,outdir=outdir,ER_weightings=ER_weightings,M_weightings=M_weightings,preddir=preddir,run=run,marxandir=marxandir)

ER_weightings <-c(-0.35,-0.35,-0.7,-0.7,0.1) #run K.4 (D.3)
M_weightings <-c(-0.35,-0.35,-0.7,-0.7,0.1) #run K.4 (D.3)
run="K.4"
hindcast_extracto(points=points,outdir=outdir,ER_weightings=ER_weightings,M_weightings=M_weightings,preddir=preddir,run=run,marxandir=marxandir)

ER_weightings <-c(-0.35,-0.35,-0.7,-0.7,0.3) #run K.5 (D.4)
M_weightings <-c(-0.35,-0.35,-0.7,-0.7,0.3) #run K.5 (D.4)
run="K.5"
hindcast_extracto(points=points,outdir=outdir,ER_weightings=ER_weightings,M_weightings=M_weightings,preddir=preddir,run=run,marxandir=marxandir)

ER_weightings <-c(-0.35,-0.35,-0.7,-0.3,0.7) #run K.6 (E.1)
M_weightings <-c(-0.35,-0.35,-0.7,-0.3,0.7) #run K.6 (E.1)
run="K.6"
hindcast_extracto(points=points,outdir=outdir,ER_weightings=ER_weightings,M_weightings=M_weightings,preddir=preddir,run=run,marxandir=marxandir)




## scenario L--> runs to match example mgmt objectives.  (run) ####
marxandir="marxan" 

ER_weightings <-c(-0.25,-0.25,-0.05,-0.5,0.5) #run L.1 CASL 10% as important
M_weightings <-c(-0.25,-0.25,-0.05,-0.5,0.5) #run L.1 CASL 10% as important
run="L.1"
hindcast_extracto(points=points,outdir=outdir,ER_weightings=ER_weightings,M_weightings=M_weightings,preddir=preddir,run=run,marxandir=marxandir)

ER_weightings <-c(-0.025,-0.025,-0.05,-0.5,0.5) #run L.2 BLSH, CASL 10% as important
M_weightings <-c(-0.025,-0.025,-0.05,-0.5,0.5) #run L.2 BLSH, CASL 10% as important
run="L.2"
hindcast_extracto(points=points,outdir=outdir,ER_weightings=ER_weightings,M_weightings=M_weightings,preddir=preddir,run=run,marxandir=marxandir)

ER_weightings <-c(-0.15,-0.15,-0.3,-0.3,0.3) #run L.3 RUN, example of caring about all species equally
M_weightings <-c(-0.15,-0.15,-0.3,-0.3,0.3) #run L.3 RUN, example of caring about all species equally
run="L.3"
hindcast_extracto(points=points,outdir=outdir,ER_weightings=ER_weightings,M_weightings=M_weightings,preddir=preddir,run=run,marxandir=marxandir)

ER_weightings <-c(-0.15,-0.15,-0.03,-0.3,0.3) #run L.4 CASL 10% as important
M_weightings <-c(-0.15,-0.15,-0.03,-0.3,0.3) #run L.4 CASL 10% as important
run="L.4"
hindcast_extracto(points=points,outdir=outdir,ER_weightings=ER_weightings,M_weightings=M_weightings,preddir=preddir,run=run,marxandir=marxandir)

ER_weightings <-c(-0.015,-0.015,-0.03,-0.3,0.3) #run L.5 BLSH, CASL 10% as important
M_weightings <-c(-0.015,-0.015,-0.03,-0.3,0.3) #run L.5 BLSH, CASL 10% as important
run="L.5"
hindcast_extracto(points=points,outdir=outdir,ER_weightings=ER_weightings,M_weightings=M_weightings,preddir=preddir,run=run,marxandir=marxandir)


## scenario M-->  three extra ecroms runs to meet mike's new add to 1 thing'  (run) ####
ER_weightings <-c(0,0,0,0,1) #run M.1
run="M.1"
hindcast_extracto_EcoROMS_only(points=points,outdir=outdir,ER_weightings=ER_weightings,preddir=preddir,run=run)
data=read.csv(paste0(datadir,"run_",run,".csv")) %>% mutate(Marxan_raw=EcoROMS_original) %>% mutate(Marxan_raw_unscaled=EcoROMS_original_unscaled) %>% .[,3:ncol(.)] ## giving it a bullshit marxan column, even tho marxan w.n. run!
write.csv(data,paste0(datadir,"run_",run,".csv"))

ER_weightings <-c(0,0,0,-1,0) #run M.2
run="M.2"
hindcast_extracto_EcoROMS_only(points=points,outdir=outdir,ER_weightings=ER_weightings,preddir=preddir,run=run)
data=read.csv(paste0(datadir,"run_",run,".csv")) %>% mutate(Marxan_raw=EcoROMS_original) %>% mutate(Marxan_raw_unscaled=EcoROMS_original_unscaled)%>% .[,3:ncol(.)]
write.csv(data,paste0(datadir,"run_",run,".csv"))

ER_weightings <-c(0,0,0,-1,1) #run M.3
run="M.3"
hindcast_extracto_EcoROMS_only(points=points,outdir=outdir,ER_weightings=ER_weightings,preddir=preddir,run=run)
data=read.csv(paste0(datadir,"run_",run,".csv")) %>% mutate(Marxan_raw=EcoROMS_original) %>% mutate(Marxan_raw_unscaled=EcoROMS_original_unscaled)%>% .[,3:ncol(.)]
write.csv(data,paste0(datadir,"run_",run,".csv"))

ER_weightings <-c(-0.16,-0.16,0,-0.33,0.33) #run M.4
run="M.4"
hindcast_extracto_EcoROMS_only(points=points,outdir=outdir,ER_weightings=ER_weightings,preddir=preddir,run=run)
data=read.csv(paste0(datadir,"run_",run,".csv")) %>% mutate(Marxan_raw=EcoROMS_original) %>% mutate(Marxan_raw_unscaled=EcoROMS_original_unscaled)%>% .[,2:ncol(.)]
write.csv(data,paste0(datadir,"run_",run,".csv"))

ER_weightings <-c(-0.125,-0.125,-0.25,-0.25,0.25) #run M.5
run="M.5"
hindcast_extracto_EcoROMS_only(points=points,outdir=outdir,ER_weightings=ER_weightings,preddir=preddir,run=run)
data=read.csv(paste0(datadir,"run_",run,".csv")) %>% mutate(Marxan_raw=EcoROMS_original) %>% mutate(Marxan_raw_unscaled=EcoROMS_original_unscaled)%>% .[,2:ncol(.)]
write.csv(data,paste0(datadir,"run_",run,".csv"))


