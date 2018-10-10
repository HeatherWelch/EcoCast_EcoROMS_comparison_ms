### correlations and thresholds, batch runs
weightings=read.csv("hindcast_ms/predict/weighting_scenarios.csv")

source("load_functions.R")
source("hindcast_ms/summarize_ms/threshold_fcn.R")
source("hindcast_ms/summarize_ms/correlation_fcn.R")
source("hindcast_ms/summarize_ms/threshold_unique_fcn.R")
source("hindcast_ms/summarize_ms/correlation_unique_fcn.R")
source("hindcast_ms/summarize_ms/threshold_unique_constrained_fcn.R")
source("hindcast_ms/summarize_ms/correlation_unique_constrained_fcn.R")

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
correlations_unique_constrained(plotdir = plotdir,datadir = datadir)

lbstRisk=0
thresholds_unique(lbstRisk=lbstRisk,plotdir = plotdir,csvdir = csvdir)
thresholds_unique_constrained(lbstRisk=lbstRisk,plotdir = plotdir,csvdir = csvdir)

lbstRisk=10
thresholds_unique(lbstRisk=lbstRisk,plotdir = plotdir,csvdir = csvdir)
thresholds_unique_constrained(lbstRisk=lbstRisk,plotdir = plotdir,csvdir = csvdir)

lbstRisk=20
thresholds_unique(lbstRisk=lbstRisk,plotdir = plotdir,csvdir = csvdir)
thresholds_unique_constrained(lbstRisk=lbstRisk,plotdir = plotdir,csvdir = csvdir)

