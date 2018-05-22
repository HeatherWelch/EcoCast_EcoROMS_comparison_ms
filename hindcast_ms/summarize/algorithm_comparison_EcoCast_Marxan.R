## script to compare the effect of algorithm choice on mgmt effectiveness
source("load_functions.R")
source("hindcast_ms/summarize/algorithm_comparison.R")

plotdir="~/Dropbox/EcoEast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/hindcast_ms/summarize/plots/"
csvdir="~/Dropbox/EcoEast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/hindcast_ms/summarize/csvs/"
datadir="~/Dropbox/EcoEast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/hindcast_ms/extract/extractions/"


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
