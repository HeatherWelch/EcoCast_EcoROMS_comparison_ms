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

