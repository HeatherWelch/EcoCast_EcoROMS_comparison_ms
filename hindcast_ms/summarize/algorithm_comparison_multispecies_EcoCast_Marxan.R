source("load_functions.R")

plotdir="hindcast_ms/summarize/plots/"
csvdir="hindcast_ms/summarize/csvs/"
datadir="hindcast_ms/extract/extractions/"

## scenario A--> isolating the effect of swordfish weightings (5 runs, weightings are the same for both algorithms) (run) #### 
run="A.1"
agorithm_comparison_multispecies(run=run,csvdir=csvdir,datadir=datadir)

run="A.2"
agorithm_comparison_multispecies(run=run,csvdir=csvdir,datadir=datadir)

run="A.3"
agorithm_comparison_multispecies(run=run,csvdir=csvdir,datadir=datadir)

run="A.4"
agorithm_comparison_multispecies(run=run,csvdir=csvdir,datadir=datadir)

run="A.5"
agorithm_comparison_multispecies(run=run,csvdir=csvdir,datadir=datadir)

## scenario B --> isolating the effect of leatherback weightings (5 runs, weightings are the same for both algorithms) (run) #### 
run="B.1"
agorithm_comparison_multispecies(run=run,csvdir=csvdir,datadir=datadir)

run="B.2"
agorithm_comparison_multispecies(run=run,csvdir=csvdir,datadir=datadir)

run="B.3"
agorithm_comparison_multispecies(run=run,csvdir=csvdir,datadir=datadir)

run="B.4"
agorithm_comparison_multispecies(run=run,csvdir=csvdir,datadir=datadir)

run="B.5"
agorithm_comparison_multispecies(run=run,csvdir=csvdir,datadir=datadir)

## scenario C--> testing the ability to manage swordfish and leatherback equally (5 runs, weightings are the same for both algorithms) (run) ####
run="C.1"
agorithm_comparison_multispecies(run=run,csvdir=csvdir,datadir=datadir)

run="C.2"
agorithm_comparison_multispecies(run=run,csvdir=csvdir,datadir=datadir)

run="C.3"
agorithm_comparison_multispecies(run=run,csvdir=csvdir,datadir=datadir)

run="C.4"
agorithm_comparison_multispecies(run=run,csvdir=csvdir,datadir=datadir)

run="C.5"
agorithm_comparison_multispecies(run=run,csvdir=csvdir,datadir=datadir)

## scenario D--> testing the ability to manage swordfish and leatherback, tailored based on above results (5 runs, weightings are the same for both algorithms) (run) ####
run="D.1"
agorithm_comparison_multispecies(run=run,csvdir=csvdir,datadir=datadir)

run="D.2"
agorithm_comparison_multispecies(run=run,csvdir=csvdir,datadir=datadir)

run="D.3"
agorithm_comparison_multispecies(run=run,csvdir=csvdir,datadir=datadir)

run="D.4"
agorithm_comparison_multispecies(run=run,csvdir=csvdir,datadir=datadir)

run="D.5"
agorithm_comparison_multispecies(run=run,csvdir=csvdir,datadir=datadir)

## scenario E--> testing the ability to manage swordfish and leatherback, tailored based on above results, swor > lbst (5 runs, weightings are the same for both algorithms) (run) ####
run="E.1"
agorithm_comparison_multispecies(run=run,csvdir=csvdir,datadir=datadir)

run="E.2"
agorithm_comparison_multispecies(run=run,csvdir=csvdir,datadir=datadir)

run="E.3"
agorithm_comparison_multispecies(run=run,csvdir=csvdir,datadir=datadir)

run="E.4"
agorithm_comparison_multispecies(run=run,csvdir=csvdir,datadir=datadir)

run="E.5"
agorithm_comparison_multispecies(run=run,csvdir=csvdir,datadir=datadir)
