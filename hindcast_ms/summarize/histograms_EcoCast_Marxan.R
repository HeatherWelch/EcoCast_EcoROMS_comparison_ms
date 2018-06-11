### script to look at the effect of weightings / algorithms on species presences histograms

source("load_functions.R")
source("hindcast_ms/summarize/histograms.R")

plotdir="~/Dropbox/EcoEast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/hindcast_ms/summarize/plots/"

## scenario A--> isolating the effect of swordfish weightings (5 runs, weightings are the same for both algorithms) (run) #### 
one=read.csv("hindcast_ms/extract/extractions/run_A.1.csv") %>% mutate(weighting=.1)
two=read.csv("hindcast_ms/extract/extractions/run_A.2.csv") %>% mutate(weighting=.3)
three=read.csv("hindcast_ms/extract/extractions/run_A.3.csv") %>% mutate(weighting=.5)
four=read.csv("hindcast_ms/extract/extractions/run_A.4.csv") %>% mutate(weighting=.7)
five=read.csv("hindcast_ms/extract/extractions/run_A.5.csv") %>% mutate(weighting=.9)

run="A"
weighting_delta=c(.1,.3,.5,.7,.9)
species_delta="swordfish"
species_delta_short="swor"

histograms(plotdir = plotdir,weighting_delta = weighting_delta,species_delta = species_delta,run=run,species_delta_short)

## scenario B --> isolating the effect of leatherback weightings (5 runs, weightings are the same for both algorithms) (run) #### 
one=read.csv("hindcast_ms/extract/extractions/run_B.1.csv") %>% mutate(weighting=-0.1)
two=read.csv("hindcast_ms/extract/extractions/run_B.2.csv") %>% mutate(weighting=-0.3)
three=read.csv("hindcast_ms/extract/extractions/run_B.3.csv") %>% mutate(weighting=-0.5)
four=read.csv("hindcast_ms/extract/extractions/run_B.4.csv") %>% mutate(weighting=-0.7)
five=read.csv("hindcast_ms/extract/extractions/run_B.5.csv") %>% mutate(weighting=-0.9)

run="B"
weighting_delta=c(-0.1,-0.3,-0.5,-0.7,-0.9)
species_delta="leatherback"
species_delta_short="lbst"

histograms(plotdir = plotdir,weighting_delta = weighting_delta,species_delta = species_delta,run=run,species_delta_short)


# scenario C--> testing the ability to manage swordfish and leatherback equally (5 runs, weightings are the same for both algorithms) (run) ####
one=read.csv("hindcast_ms/extract/extractions/run_C.1.csv") %>% mutate(weighting=.1)
two=read.csv("hindcast_ms/extract/extractions/run_C.2.csv") %>% mutate(weighting=.3)
three=read.csv("hindcast_ms/extract/extractions/run_C.3.csv") %>% mutate(weighting=.5)
four=read.csv("hindcast_ms/extract/extractions/run_C.4.csv") %>% mutate(weighting=.7)
five=read.csv("hindcast_ms/extract/extractions/run_C.5.csv") %>% mutate(weighting=.9)

run="C"
weighting_delta=c(.1,.3,.5,.7,.9)
species_delta="swordfish/leatherback"
species_delta_short="swor"

histograms(plotdir = plotdir,weighting_delta = weighting_delta,species_delta = species_delta,run=run,species_delta_short)


# scenario D--> testing the ability to manage swordfish and leatherback, tailored based on above results (5 runs, weightings are the same for both algorithms) (run) ####
one=read.csv("hindcast_ms/extract/extractions/run_D.1.csv") %>% mutate(weighting="-0.5_0.1")
two=read.csv("hindcast_ms/extract/extractions/run_D.2.csv") %>% mutate(weighting="-0.5_0.3")
three=read.csv("hindcast_ms/extract/extractions/run_D.3.csv") %>% mutate(weighting="-0.7_0.1")
four=read.csv("hindcast_ms/extract/extractions/run_D.4.csv") %>% mutate(weighting="-0.7_0.3")
five=read.csv("hindcast_ms/extract/extractions/run_D.5.csv") %>% mutate(weighting="-0.7_0.5")

run="D"
weighting_delta=c("-0.5_0.1","-0.5_0.3","-0.7_0.1","-0.7_0.3","-0.7_0.5")
species_delta="leatherback/swor"
species_delta_short="lbst"

histograms(plotdir = plotdir,weighting_delta = weighting_delta,species_delta = species_delta,run=run,species_delta_short)
