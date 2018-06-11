source("load_functions.R")
source("hindcast_ms/summarize/point_clouds.R")

plotdir="hindcast_ms/summarize/plots/"
csvdir="hindcast_ms/summarize/csvs/"
namesrisk<-c("Blue shark bycatch","Blue sharks","Sea lions","Leatherbacks","Swordfish")

## scenario A--> isolating the effect of swordfish weightings (5 runs, weightings are the same for both algorithms) (run) #### 
data=read.csv("hindcast_ms/extract/extractions/run_A.1.csv") 
data_thresh=read.csv("hindcast_ms/summarize/csvs/A.1_thresholds_algorithm_comparison.csv") %>% filter(limit_target=="leatherback")
data5=read.csv("hindcast_ms/extract/extractions/run_A.5.csv") 
data5_thresh=read.csv("hindcast_ms/summarize/csvs/A.5_thresholds_algorithm_comparison.csv") %>% filter(limit_target=="leatherback")
weightings <-c(0,0,0,0,0.1) #run A.1
weightings5 <-c(0,0,0,0,0.9) #run A.5
run="A"

data_cloud(data=data,data_thresh = data_thresh,data5 = data5,data5_thresh = data5_thresh,run = run)

## scenario B --> isolating the effect of leatherback weightings (5 runs, weightings are the same for both algorithms) (run) #### 
data=read.csv("hindcast_ms/extract/extractions/run_B.1.csv") 
data_thresh=read.csv("hindcast_ms/summarize/csvs/B.1_thresholds_algorithm_comparison.csv") %>% filter(limit_target=="leatherback")
data5=read.csv("hindcast_ms/extract/extractions/run_B.5.csv") 
data5_thresh=read.csv("hindcast_ms/summarize/csvs/B.5_thresholds_algorithm_comparison.csv") %>% filter(limit_target=="leatherback")
weightings <-c(0,0,0,-0.1,0) #run A.1
weightings5 <-c(0,0,0,-0.9,0) #run A.5
run="B"

data_cloud(data=data,data_thresh = data_thresh,data5 = data5,data5_thresh = data5_thresh,run = run)

## scenario C --> testing the ability to manage swordfish and leatherback equally (5 runs, weightings are the same for both algorithms) (run) #### 
data=read.csv("hindcast_ms/extract/extractions/run_C.1.csv") 
data_thresh=read.csv("hindcast_ms/summarize/csvs/C.1_thresholds_algorithm_comparison.csv") %>% filter(limit_target=="leatherback")
data5=read.csv("hindcast_ms/extract/extractions/run_C.5.csv") 
data5_thresh=read.csv("hindcast_ms/summarize/csvs/C.5_thresholds_algorithm_comparison.csv") %>% filter(limit_target=="leatherback")
weightings <-c(0,0,0,-0.1,0.1) #run C.1
weightings5 <-c(0,0,0,-0.9,0.9) #run C.5
run="C"

data_cloud(data=data,data_thresh = data_thresh,data5 = data5,data5_thresh = data5_thresh,run = run)

## scenario D --> testing the ability to manage swordfish and leatherback, tailored based on above results (5 runs, weightings are the same for both algorithms) (run) #### 
data=read.csv("hindcast_ms/extract/extractions/run_D.1.csv") 
data_thresh=read.csv("hindcast_ms/summarize/csvs/D.1_thresholds_algorithm_comparison.csv") %>% filter(limit_target=="leatherback")
data5=read.csv("hindcast_ms/extract/extractions/run_D.5.csv") 
data5_thresh=read.csv("hindcast_ms/summarize/csvs/D.5_thresholds_algorithm_comparison.csv") %>% filter(limit_target=="leatherback")
weightings <-c(0,0,0,-0.5,0.1) #run D.1
weightings5 <-c(0,0,0,-0.7,0.5) #run D.5
run="D"

data_cloud(data=data,data_thresh = data_thresh,data5 = data5,data5_thresh = data5_thresh,run = run)
