## script to compare the effect of algorithm choice on mgmt effectiveness
source("load_functions.R")
source("hindcast_ms/summarize/algorithm_comparison.R")

plotdir="hindcast_ms/summarize/plots/"
csvdir="hindcast_ms/summarize/csvs/"
datadir="hindcast_ms/extract/extractions/"


## scenario A--> isolating the effect of swordfish weightings (5 runs, weightings are the same for both algorithms) (run) #### 
weightings <-c(0,0,0,0,0.1) #run A.1
run="A.1"
data=read.csv(paste0(datadir,"run_",run,".csv"))
agorithm_comparison(data=data,weightings=weightings,run=run)

weightings <-c(0,0,0,0,0.3) #run A.2
run="A.2"
data=read.csv(paste0(datadir,"run_",run,".csv"))
agorithm_comparison(data=data,weightings=weightings,run=run)

weightings <-c(0,0,0,0,0.5) #run A.3
run="A.3"
data=read.csv(paste0(datadir,"run_",run,".csv"))
agorithm_comparison(data=data,weightings=weightings,run=run)

weightings <-c(0,0,0,0,0.7) #run A.4
run="A.4"
data=read.csv(paste0(datadir,"run_",run,".csv"))
agorithm_comparison(data=data,weightings=weightings,run=run)

weightings <-c(0,0,0,0,0.9) #run A.5
run="A.5"
data=read.csv(paste0(datadir,"run_",run,".csv"))
agorithm_comparison(data=data,weightings=weightings,run=run)

## scenario B --> isolating the effect of leatherback weightings (5 runs, weightings are the same for both algorithms) (run) #### 
weightings <-c(0,0,0,-0.1,0) #run B.1
run="B.1"
data=read.csv(paste0(datadir,"run_",run,".csv"))
agorithm_comparison(data=data,weightings=weightings,run=run)

weightings <-c(0,0,0,-0.3,0) #run B.2
run="B.2"
data=read.csv(paste0(datadir,"run_",run,".csv"))
agorithm_comparison(data=data,weightings=weightings,run=run)

weightings <-c(0,0,0,-0.5,0) #run B.3
run="B.3"
data=read.csv(paste0(datadir,"run_",run,".csv"))
agorithm_comparison(data=data,weightings=weightings,run=run)

weightings <-c(0,0,0,-0.7,0) #run B.4
run="B.4"
data=read.csv(paste0(datadir,"run_",run,".csv"))
agorithm_comparison(data=data,weightings=weightings,run=run)

weightings <-c(0,0,0,-0.9,0) #run B.5
run="B.5"
data=read.csv(paste0(datadir,"run_",run,".csv"))
agorithm_comparison(data=data,weightings=weightings,run=run)

## scenario C--> testing the ability to manage swordfish and leatherback equally (5 runs, weightings are the same for both algorithms) (run) ####
weightings <-c(0,0,0,-0.1,0.1) #run C.1
run="C.1"
data=read.csv(paste0(datadir,"run_",run,".csv"))
agorithm_comparison(data=data,weightings=weightings,run=run)

weightings <-c(0,0,0,-0.3,0.3) #run C.2
run="C.2"
data=read.csv(paste0(datadir,"run_",run,".csv"))
agorithm_comparison(data=data,weightings=weightings,run=run)

weightings <-c(0,0,0,-0.5,0.5) #run C.3
run="C.3"
data=read.csv(paste0(datadir,"run_",run,".csv"))
agorithm_comparison(data=data,weightings=weightings,run=run)

weightings <-c(0,0,0,-0.7,0.7) #run C.4
run="C.4"
data=read.csv(paste0(datadir,"run_",run,".csv"))
agorithm_comparison(data=data,weightings=weightings,run=run)

weightings <-c(0,0,0,-0.9,0.9) #run C.5
run="C.5"
data=read.csv(paste0(datadir,"run_",run,".csv"))
agorithm_comparison(data=data,weightings=weightings,run=run)
## scenario D--> testing the ability to manage swordfish and leatherback, tailored based on above results (5 runs, weightings are the same for both algorithms) (run) ####
weightings <-c(0,0,0,-0.5,0.1) #run D.1
run="D.1"
data=read.csv(paste0(datadir,"run_",run,".csv"))
agorithm_comparison(data=data,weightings=weightings,run=run)

weightings <-c(0,0,0,-0.5,0.3) #run D.2
run="D.2"
data=read.csv(paste0(datadir,"run_",run,".csv"))
agorithm_comparison(data=data,weightings=weightings,run=run)

weightings <-c(0,0,0,-0.7,0.1) #run D.3
run="D.3"
data=read.csv(paste0(datadir,"run_",run,".csv"))
agorithm_comparison(data=data,weightings=weightings,run=run)

weightings <-c(0,0,0,-0.7,0.3) #run D.4
run="D.4"
data=read.csv(paste0(datadir,"run_",run,".csv"))
agorithm_comparison(data=data,weightings=weightings,run=run)

weightings <-c(0,0,0,-0.7,0.5) #run D.5
run="D.5"
data=read.csv(paste0(datadir,"run_",run,".csv"))
agorithm_comparison(data=data,weightings=weightings,run=run)

## scenario E--> testing the ability to manage swordfish and leatherback, tailored based on above results, swor > lbst (5 runs, weightings are the same for both algorithms) (run) ####
weightings <-c(0,0,0,-0.3,0.7) #run E.1
run="E.1"
data=read.csv(paste0(datadir,"run_",run,".csv"))
agorithm_comparison(data=data,weightings=weightings,run=run)

weightings <-c(0,0,0,-0.3,0.9) #run E.2
run="E.2"
data=read.csv(paste0(datadir,"run_",run,".csv"))
agorithm_comparison(data=data,weightings=weightings,run=run)

weightings <-c(0,0,0,-0.5,0.7) #run E.3
run="E.3"
data=read.csv(paste0(datadir,"run_",run,".csv"))
agorithm_comparison(data=data,weightings=weightings,run=run)

weightings <-c(0,0,0,-0.5,0.9) #run E.4
run="E.4"
data=read.csv(paste0(datadir,"run_",run,".csv"))
agorithm_comparison(data=data,weightings=weightings,run=run)

weightings <-c(0,0,0,-0.7,0.9) #run E.5
run="E.5"
data=read.csv(paste0(datadir,"run_",run,".csv"))
agorithm_comparison(data=data,weightings=weightings,run=run)



## scenario F--> adding in bluesharks. taking the best weightins from A-E and adding some blueshark to see how things change (run) (run) ####
weightings <-c(-0.05,-0.05,0,-0.3,0) #run F.1 (B.2)
run="F.1"
data=read.csv(paste0(datadir,"run_",run,".csv"))
agorithm_comparison(data=data,weightings=weightings,run=run)

weightings <-c(-0.05,-0.05,0,-0.9,0) #run F.2 (B.5)
run="F.2"
data=read.csv(paste0(datadir,"run_",run,".csv"))
agorithm_comparison(data=data,weightings=weightings,run=run)

weightings <-c(-0.05,-0.05,0,-0.5,0.5) #run F.3 (C.3)
run="F.3"
data=read.csv(paste0(datadir,"run_",run,".csv"))
agorithm_comparison(data=data,weightings=weightings,run=run)

weightings <-c(-0.05,-0.05,0,-0.7,0.1) #run F.4 (D.3)
run="F.4"
data=read.csv(paste0(datadir,"run_",run,".csv"))
agorithm_comparison(data=data,weightings=weightings,run=run)

weightings <-c(-0.05,-0.05,0,-0.7,0.3) #run F.5 (D.4)
run="F.5"
data=read.csv(paste0(datadir,"run_",run,".csv"))
agorithm_comparison(data=data,weightings=weightings,run=run)

weightings <-c(-0.05,-0.05,0,-0.3,0.7) #run F.6 (E.1)
run="F.6"
data=read.csv(paste0(datadir,"run_",run,".csv"))
agorithm_comparison(data=data,weightings=weightings,run=run)

## scenario G--> adding in bluesharks, a little bit more. taking the best weightins from A-E and adding some blueshark to see how things change. ####
weightings <-c(-0.25,-0.25,0,-0.3,0) #run F.1 (B.2)
run="G.1"
data=read.csv(paste0(datadir,"run_",run,".csv"))
agorithm_comparison(data=data,weightings=weightings,run=run)

weightings <-c(-0.25,-0.25,0,-0.9,0) #run F.2 (B.5)
run="G.2"
data=read.csv(paste0(datadir,"run_",run,".csv"))
agorithm_comparison(data=data,weightings=weightings,run=run)

weightings <-c(-0.25,-0.25,0,-0.5,0.5) #run F.3 (C.3)
run="G.3"
data=read.csv(paste0(datadir,"run_",run,".csv"))
agorithm_comparison(data=data,weightings=weightings,run=run)

weightings <-c(-0.25,-0.25,0,-0.7,0.1) #run F.4 (D.3)
run="G.4"
data=read.csv(paste0(datadir,"run_",run,".csv"))
agorithm_comparison(data=data,weightings=weightings,run=run)

weightings <-c(-0.25,-0.25,0,-0.7,0.3) #run F.5 (D.4)
run="G.5"
data=read.csv(paste0(datadir,"run_",run,".csv"))
agorithm_comparison(data=data,weightings=weightings,run=run)

weightings <-c(-0.25,-0.25,0,-0.3,0.7) #run F.6 (E.1)
run="G.6"
data=read.csv(paste0(datadir,"run_",run,".csv"))
agorithm_comparison(data=data,weightings=weightings,run=run)

## scenario H--> adding in bluesharks, a little bit more x2. taking the best weightins from A-E and adding some blueshark to see how things change. ####
weightings <-c(-0.35,-0.35,0,-0.3,0) #run F.1 (B.2)
run="H.1"
data=read.csv(paste0(datadir,"run_",run,".csv"))
agorithm_comparison(data=data,weightings=weightings,run=run)

weightings <-c(-0.35,-0.35,0,-0.9,0) #run F.2 (B.5)
run="H.2"
data=read.csv(paste0(datadir,"run_",run,".csv"))
agorithm_comparison(data=data,weightings=weightings,run=run)

weightings <-c(-0.35,-0.35,0,-0.5,0.5) #run F.3 (C.3)
run="H.3"
data=read.csv(paste0(datadir,"run_",run,".csv"))
agorithm_comparison(data=data,weightings=weightings,run=run)

weightings <-c(-0.35,-0.35,0,-0.7,0.1) #run F.4 (D.3)
run="H.4"
data=read.csv(paste0(datadir,"run_",run,".csv"))
agorithm_comparison(data=data,weightings=weightings,run=run)

weightings <-c(-0.35,-0.35,0,-0.7,0.3) #run F.5 (D.4)
run="H.5"
data=read.csv(paste0(datadir,"run_",run,".csv"))
agorithm_comparison(data=data,weightings=weightings,run=run)

weightings <-c(-0.35,-0.35,0,-0.3,0.7) #run F.6 (E.1)
run="H.6"
data=read.csv(paste0(datadir,"run_",run,".csv"))
agorithm_comparison(data=data,weightings=weightings,run=run)
