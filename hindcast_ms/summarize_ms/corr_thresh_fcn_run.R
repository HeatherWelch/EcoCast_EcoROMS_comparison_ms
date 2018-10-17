### correlations and thresholds, batch runs
weightings=read.csv("hindcast_ms/predict/weighting_scenarios.csv")

source("load_functions.R")
source("hindcast_ms/summarize_ms/threshold_fcn.R")
source("hindcast_ms/summarize_ms/correlation_fcn.R")
source("hindcast_ms/summarize_ms/threshold_unique_fcn.R")
source("hindcast_ms/summarize_ms/correlation_unique_fcn.R")
source("hindcast_ms/summarize_ms/threshold_unique_constrained_fcn.R")
source("hindcast_ms/summarize_ms/correlation_unique_constrained_fcn.R")

source("hindcast_ms/summarize_ms/threshold_unique_constrained_fcn_nopt1.R")
source("hindcast_ms/summarize_ms/correlation_unique_constrained_fcn_nopt1.R")

library(ggalt)
library(plotly)
library(ggplot2)
library(scales)
library(DescTools)
library(fmsb)

plotdir="hindcast_ms/summarize_ms/plots/"
csvdir="hindcast_ms/summarize/csvs/"
datadir="hindcast_ms/extract/extractions/"



correlations_unique(plotdir = plotdir,datadir = datadir)

type="lenient"
cons_obj1=c("run_G","run_H","run_I","run_J","run_K","run_L")
cons_obj2=c("run_F","run_G","run_H","run_I","run_L")
cons_obj3=c("run_A","run_B","run_C","run_D","run_E","run_F","run_I","run_L")
correlations_unique_constrained(plotdir = plotdir,datadir = datadir,type=type,cons_obj1=cons_obj1,cons_obj2=cons_obj2,cons_obj3=cons_obj3)

type="strict"
cons_obj1=c("run_I","run_J","run_K","run_L")
cons_obj2=c("run_F","run_G","run_L")
cons_obj3=c("run_A","run_B","run_C","run_D","run_E","run_L")
correlations_unique_constrained(plotdir = plotdir,datadir = datadir,type=type,cons_obj1=cons_obj1,cons_obj2=cons_obj2,cons_obj3=cons_obj3)
correlations_unique_constrained_nopt1(plotdir = plotdir,datadir = datadir,type=type,cons_obj1=cons_obj1,cons_obj2=cons_obj2,cons_obj3=cons_obj3)

lbstRisk=0
thresholds_unique(lbstRisk=lbstRisk,plotdir = plotdir,csvdir = csvdir)
type="lenient"
cons_obj1=c("unscaled_G","unscaled_H","unscaled_I","unscaled_J","unscaled_K","unscaled_L")
cons_obj2=c("unscaled_F","unscaled_G","unscaled_H","unscaled_I","unscaled_L")
cons_obj3=c("unscaled_A","unscaled_B","unscaled_C","unscaled_D","unscaled_E","unscaled_F","unscaled_I","unscaled_L")
thresholds_unique_constrained(lbstRisk=lbstRisk,plotdir = plotdir,csvdir = csvdir,type=type,cons_obj1=cons_obj1,cons_obj2=cons_obj2,cons_obj3=cons_obj3)

type="strict"
cons_obj1=c("unscaled_I","unscaled_J","unscaled_K","unscaled_L")
cons_obj2=c("unscaled_F","unscaled_G","unscaled_L")
cons_obj3=c("unscaled_A","unscaled_B","unscaled_C","unscaled_D","unscaled_E","unscaled_L")
thresholds_unique_constrained(lbstRisk=lbstRisk,plotdir = plotdir,csvdir = csvdir,type=type,cons_obj1=cons_obj1,cons_obj2=cons_obj2,cons_obj3=cons_obj3)


lbstRisk=10
thresholds_unique(lbstRisk=lbstRisk,plotdir = plotdir,csvdir = csvdir)
type="lenient"
cons_obj1=c("unscaled_G","unscaled_H","unscaled_I","unscaled_J","unscaled_K","unscaled_L")
cons_obj2=c("unscaled_F","unscaled_G","unscaled_H","unscaled_I","unscaled_L")
cons_obj3=c("unscaled_A","unscaled_B","unscaled_C","unscaled_D","unscaled_E","unscaled_F","unscaled_I","unscaled_L")
thresholds_unique_constrained(lbstRisk=lbstRisk,plotdir = plotdir,csvdir = csvdir,type=type,cons_obj1=cons_obj1,cons_obj2=cons_obj2,cons_obj3=cons_obj3)

type="strict"
cons_obj1=c("unscaled_I","unscaled_J","unscaled_K","unscaled_L")
cons_obj2=c("unscaled_F","unscaled_G","unscaled_L")
cons_obj3=c("unscaled_A","unscaled_B","unscaled_C","unscaled_D","unscaled_E","unscaled_L")
thresholds_unique_constrained(lbstRisk=lbstRisk,plotdir = plotdir,csvdir = csvdir,type=type,cons_obj1=cons_obj1,cons_obj2=cons_obj2,cons_obj3=cons_obj3)
thresholds_unique_constrained_nopt1(lbstRisk=lbstRisk,plotdir = plotdir,csvdir = csvdir,type=type,cons_obj1=cons_obj1,cons_obj2=cons_obj2,cons_obj3=cons_obj3)


lbstRisk=20
thresholds_unique(lbstRisk=lbstRisk,plotdir = plotdir,csvdir = csvdir)
type="lenient"
cons_obj1=c("unscaled_G","unscaled_H","unscaled_I","unscaled_J","unscaled_K","unscaled_L")
cons_obj2=c("unscaled_F","unscaled_G","unscaled_H","unscaled_I","unscaled_L")
cons_obj3=c("unscaled_A","unscaled_B","unscaled_C","unscaled_D","unscaled_E","unscaled_F","unscaled_I","unscaled_L")
thresholds_unique_constrained(lbstRisk=lbstRisk,plotdir = plotdir,csvdir = csvdir,type=type,cons_obj1=cons_obj1,cons_obj2=cons_obj2,cons_obj3=cons_obj3)

type="strict"
cons_obj1=c("unscaled_I","unscaled_J","unscaled_K","unscaled_L")
cons_obj2=c("unscaled_F","unscaled_G","unscaled_L")
cons_obj3=c("unscaled_A","unscaled_B","unscaled_C","unscaled_D","unscaled_E","unscaled_L")
thresholds_unique_constrained(lbstRisk=lbstRisk,plotdir = plotdir,csvdir = csvdir,type=type,cons_obj1=cons_obj1,cons_obj2=cons_obj2,cons_obj3=cons_obj3)



