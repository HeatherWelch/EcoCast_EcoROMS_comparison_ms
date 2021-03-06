## script to compare the effect of weighting choice on mgmt effectiveness
source("load_functions.R")
source("hindcast_ms/summarize/weightings_comparison.R")

plotdir="hindcast_ms/summarize/plots/"
csvdir="hindcast_ms/summarize/csvs/"

## scenario A--> isolating the effect of swordfish weightings (5 runs, weightings are the same for both algorithms) (run) #### 
one=read.csv("hindcast_ms/extract/extractions/run_A.1.csv") %>% mutate(weighting=.1)
two=read.csv("hindcast_ms/extract/extractions/run_A.2.csv") %>% mutate(weighting=.3)
three=read.csv("hindcast_ms/extract/extractions/run_A.3.csv") %>% mutate(weighting=.5)
four=read.csv("hindcast_ms/extract/extractions/run_A.4.csv") %>% mutate(weighting=.7)
five=read.csv("hindcast_ms/extract/extractions/run_A.5.csv") %>% mutate(weighting=.9)

species_delta="swordfish"
weighting_delta=c(.1,.3,.5,.7,.9)
run="A"

weightings_comparison(species_delta = species_delta,weighting_delta = weighting_delta,plotdir = plotdir,csvdir = csvdir,run=run)

## scenario B --> isolating the effect of leatherback weightings (5 runs, weightings are the same for both algorithms) (run) #### 
one=read.csv("hindcast_ms/extract/extractions/run_B.1.csv") %>% mutate(weighting=-0.1)
two=read.csv("hindcast_ms/extract/extractions/run_B.2.csv") %>% mutate(weighting=-0.3)
three=read.csv("hindcast_ms/extract/extractions/run_B.3.csv") %>% mutate(weighting=-0.5)
four=read.csv("hindcast_ms/extract/extractions/run_B.4.csv") %>% mutate(weighting=-0.7)
five=read.csv("hindcast_ms/extract/extractions/run_B.5.csv") %>% mutate(weighting=-0.9)

species_delta="leatherback"
weighting_delta=c(-0.1,-0.3,-0.5,-0.7,-0.9)
run="B"

weightings_comparison(species_delta = species_delta,weighting_delta = weighting_delta,plotdir = plotdir,csvdir = csvdir,run=run)


## scenario C--> testing the ability to manage swordfish and leatherback equally (5 runs, weightings are the same for both algorithms) (run) ####
one=read.csv("hindcast_ms/extract/extractions/run_C.1.csv") %>% mutate(weighting=-.1)
two=read.csv("hindcast_ms/extract/extractions/run_C.2.csv") %>% mutate(weighting=-.3)
three=read.csv("hindcast_ms/extract/extractions/run_C.3.csv") %>% mutate(weighting=-.5)
four=read.csv("hindcast_ms/extract/extractions/run_C.4.csv") %>% mutate(weighting=-.7)
five=read.csv("hindcast_ms/extract/extractions/run_C.5.csv") %>% mutate(weighting=-.9)

species_delta="swordfish/leatherback"
weighting_delta=c(-0.1,-0.3,-0.5,-0.7,-0.9)
run="C"

weightings_comparison(species_delta = species_delta,weighting_delta = weighting_delta,plotdir = plotdir,csvdir = csvdir,run=run)

## scenario D--> testing the ability to manage swordfish and leatherback, tailored based on above results (5 runs, weightings are the same for both algorithms) (run) ####
one=read.csv("hindcast_ms/extract/extractions/run_D.1.csv") %>% mutate(weighting="-0.5_0.1")
two=read.csv("hindcast_ms/extract/extractions/run_D.2.csv") %>% mutate(weighting="-0.5_0.3")
three=read.csv("hindcast_ms/extract/extractions/run_D.3.csv") %>% mutate(weighting="-0.7_0.1")
four=read.csv("hindcast_ms/extract/extractions/run_D.4.csv") %>% mutate(weighting="-0.7_0.3")
five=read.csv("hindcast_ms/extract/extractions/run_D.5.csv") %>% mutate(weighting="-0.7_0.5")

species_delta="swordfish/leatherback"
weighting_delta=c("-0.5_0.1","-0.5_0.3","-0.7_0.1","-0.7_0.3","-0.7_0.5")
run="D"

weightings_comparison(species_delta = species_delta,weighting_delta = weighting_delta,plotdir = plotdir,csvdir = csvdir,run=run)

## scenario E--> testing the ability to manage swordfish and leatherback, tailored based on above results, swor > lbst (5 runs, weightings are the same for both algorithms) (run) ####
one=read.csv("hindcast_ms/extract/extractions/run_E.1.csv") %>% mutate(weighting="-0.3_0.7")
two=read.csv("hindcast_ms/extract/extractions/run_E.2.csv") %>% mutate(weighting="-0.3_0.9")
three=read.csv("hindcast_ms/extract/extractions/run_E.3.csv") %>% mutate(weighting="-0.5_0.7")
four=read.csv("hindcast_ms/extract/extractions/run_E.4.csv") %>% mutate(weighting="-0.5_0.9")
five=read.csv("hindcast_ms/extract/extractions/run_E.5.csv") %>% mutate(weighting="-0.7_0.9")

species_delta="swordfish/leatherback"
weighting_delta=c("-0.3_0.7","-0.3_0.9","-0.5_0.7","-0.5_0.9","-0.7_0.9")
run="E"

weightings_comparison(species_delta = species_delta,weighting_delta = weighting_delta,plotdir = plotdir,csvdir = csvdir,run=run)

## scenario F--> adding in bluesharks. taking the best weightins from A-E and adding some blueshark to see how things change. (run) ####
one=read.csv("hindcast_ms/extract/extractions/run_F.1.csv") %>% mutate(weighting="B.2")
two=read.csv("hindcast_ms/extract/extractions/run_F.2.csv") %>% mutate(weighting="B.5")
three=read.csv("hindcast_ms/extract/extractions/run_F.3.csv") %>% mutate(weighting="C.3")
four=read.csv("hindcast_ms/extract/extractions/run_F.4.csv") %>% mutate(weighting="D.3")
five=read.csv("hindcast_ms/extract/extractions/run_F.5.csv") %>% mutate(weighting="D.4")

species_delta="swordfish/leatherback"
weighting_delta=c("-0.3_0","-0.9_0","-0.5_0.5","-0.7_0.1","-0.7_0.3")
run="F"

weightings_comparison(species_delta = species_delta,weighting_delta = weighting_delta,plotdir = plotdir,csvdir = csvdir,run=run)

## scenario G--> adding in bluesharks, a little bit more. taking the best weightins from A-E and adding some blueshark to see how things change. (run) ####
one=read.csv("hindcast_ms/extract/extractions/run_G.1.csv") %>% mutate(weighting="B.2")
two=read.csv("hindcast_ms/extract/extractions/run_G.2.csv") %>% mutate(weighting="B.5")
three=read.csv("hindcast_ms/extract/extractions/run_G.3.csv") %>% mutate(weighting="C.3")
four=read.csv("hindcast_ms/extract/extractions/run_G.4.csv") %>% mutate(weighting="D.3")
five=read.csv("hindcast_ms/extract/extractions/run_G.5.csv") %>% mutate(weighting="D.4")

species_delta="swordfish/leatherback"
weighting_delta=c("-0.3_0","-0.9_0","-0.5_0.5","-0.7_0.1","-0.7_0.3")
run="G"

weightings_comparison(species_delta = species_delta,weighting_delta = weighting_delta,plotdir = plotdir,csvdir = csvdir,run=run)

## scenario H--> adding in bluesharks, a little bit more x2. taking the best weightins from A-E and adding some blueshark to see how things change. (run) ####
one=read.csv("hindcast_ms/extract/extractions/run_H.1.csv") %>% mutate(weighting="B.2")
two=read.csv("hindcast_ms/extract/extractions/run_H.2.csv") %>% mutate(weighting="B.5")
three=read.csv("hindcast_ms/extract/extractions/run_H.3.csv") %>% mutate(weighting="C.3")
four=read.csv("hindcast_ms/extract/extractions/run_H.4.csv") %>% mutate(weighting="D.3")
five=read.csv("hindcast_ms/extract/extractions/run_H.5.csv") %>% mutate(weighting="D.4")

species_delta="swordfish/leatherback"
weighting_delta=c("-0.3_0","-0.9_0","-0.5_0.5","-0.7_0.1","-0.7_0.3")
run="H"

weightings_comparison(species_delta = species_delta,weighting_delta = weighting_delta,plotdir = plotdir,csvdir = csvdir,run=run)

## scenario I--> adding in bluesharks, and then sealions to check multispecies. taking the best weightins from A-E and adding some blueshark to see how things change. (run) ####
one=read.csv("hindcast_ms/extract/extractions/run_I.1.csv") %>% mutate(weighting="I.2")
two=read.csv("hindcast_ms/extract/extractions/run_I.2.csv") %>% mutate(weighting="I.5")
three=read.csv("hindcast_ms/extract/extractions/run_I.3.csv") %>% mutate(weighting="I.3")
four=read.csv("hindcast_ms/extract/extractions/run_I.4.csv") %>% mutate(weighting="I.3")
five=read.csv("hindcast_ms/extract/extractions/run_I.5.csv") %>% mutate(weighting="I.4")

species_delta="swordfish/leatherback"
weighting_delta=c("-0.3_0","-0.9_0","-0.5_0.5","-0.7_0.1","-0.7_0.3")
run="I"

weightings_comparison(species_delta = species_delta,weighting_delta = weighting_delta,plotdir = plotdir,csvdir = csvdir,run=run)

## scenario J--> adding in bluesharks a little bit more, and then sealions a little bit more to check multispecies. taking the best weightins from A-E and adding some blueshark to see how things change. (run) ####
one=read.csv("hindcast_ms/extract/extractions/run_J.1.csv") %>% mutate(weighting="J.2")
two=read.csv("hindcast_ms/extract/extractions/run_J.2.csv") %>% mutate(weighting="J.5")
three=read.csv("hindcast_ms/extract/extractions/run_J.3.csv") %>% mutate(weighting="J.3")
four=read.csv("hindcast_ms/extract/extractions/run_J.4.csv") %>% mutate(weighting="J.3")
five=read.csv("hindcast_ms/extract/extractions/run_J.5.csv") %>% mutate(weighting="J.4")

species_delta="swordfish/leatherback"
weighting_delta=c("-0.3_0","-0.9_0","-0.5_0.5","-0.7_0.1","-0.7_0.3")
run="J"

weightings_comparison(species_delta = species_delta,weighting_delta = weighting_delta,plotdir = plotdir,csvdir = csvdir,run=run)

## scenario K--> adding in bluesharks a little bit more x2, and then sealions a little bit more to check multispecies. taking the best weightins from A-E and adding some blueshark to see how things change. (run) ####
one=read.csv("hindcast_ms/extract/extractions/run_K.1.csv") %>% mutate(weighting="K.2")
two=read.csv("hindcast_ms/extract/extractions/run_K.2.csv") %>% mutate(weighting="K.5")
three=read.csv("hindcast_ms/extract/extractions/run_K.3.csv") %>% mutate(weighting="K.3")
four=read.csv("hindcast_ms/extract/extractions/run_K.4.csv") %>% mutate(weighting="K.3")
five=read.csv("hindcast_ms/extract/extractions/run_K.5.csv") %>% mutate(weighting="K.4")

species_delta="swordfish/leatherback"
weighting_delta=c("-0.3_0","-0.9_0","-0.5_0.5","-0.7_0.1","-0.7_0.3")
run="K"

weightings_comparison(species_delta = species_delta,weighting_delta = weighting_delta,plotdir = plotdir,csvdir = csvdir,run=run)

## scenario L--> runs to match example mgmt objectives. (run) ####
one=read.csv("hindcast_ms/extract/extractions/run_L.1.csv") %>% mutate(weighting="L.2")
two=read.csv("hindcast_ms/extract/extractions/run_L.2.csv") %>% mutate(weighting="L.5")
three=read.csv("hindcast_ms/extract/extractions/run_L.3.csv") %>% mutate(weighting="L.3")
four=read.csv("hindcast_ms/extract/extractions/run_L.4.csv") %>% mutate(weighting="L.31")
five=read.csv("hindcast_ms/extract/extractions/run_L.5.csv") %>% mutate(weighting="L.4")

species_delta="swordfish/leatherback"
weighting_delta=c("-0.3_0","-0.9_0","-0.5_0.5","-0.7_0.1","-0.7_0.3")
run="L"

weightings_comparison(species_delta = species_delta,weighting_delta = weighting_delta,plotdir = plotdir,csvdir = csvdir,run=run)

