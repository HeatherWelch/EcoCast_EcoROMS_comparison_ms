### script to look at the effect of weightings / algorithms on species presences histograms

source("load_functions.R")
source("hindcast_ms/summarize/histograms.R")

## scenario A--> isolating the effect of swordfish weightings (5 runs, weightings are the same for both algorithms) (run) #### 
one=read.csv("hindcast_ms/extract/extractions/run_A.1.csv") %>% mutate(weighting=.1)
two=read.csv("hindcast_ms/extract/extractions/run_A.2.csv") %>% mutate(weighting=.3)
three=read.csv("hindcast_ms/extract/extractions/run_A.3.csv") %>% mutate(weighting=.5)
four=read.csv("hindcast_ms/extract/extractions/run_A.4.csv") %>% mutate(weighting=.7)
five=read.csv("hindcast_ms/extract/extractions/run_A.5.csv") %>% mutate(weighting=.9)

plotdir="~/Dropbox/EcoEast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/hindcast_ms/summarize/plots/"
run="A"
weighting_delta=c(.1,.3,.5,.7,.9)
species_delta="swordfish"
species_delta_short="swor"

histograms(plotdir = plotdir,weighting_delta = weighting_delta,species_delta = species_delta,run=run,species_delta_short)
