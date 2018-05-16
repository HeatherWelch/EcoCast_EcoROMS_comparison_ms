### Weightings for systematic hindcast
# Marxan has a range of -1 to 0 ; assuming EcoROMS has a range of -3 to 3 (we don't know actual limits, but we know there is a larger range than Marxan)
# EcoROMS weightings will be rescaled relative to assumed range to have the same interspecies ratios as Marxan

namesrisk<-c("Blue shark bycatch","Blue sharks","Sea lions","Leatherbacks","Swordfish")

## scenario 1--> isolating the effect of swordfish weightings (5 runs, weightings are the same for both algorithms)
weightings <-c(0,0,0,0,0.1)
weightings <-c(0,0,0,0,0.3)
weightings <-c(0,0,0,0,0.5)
weightings <-c(0,0,0,0,0.7)
weightings <-c(0,0,0,0,0.9)

## scenario 2--> isolating the effect of leatherback weightings (5 runs, weightings are the same for both algorithms)
weightings <-c(0,0,0,-0.1,0)
weightings <-c(0,0,0,-0.3,0)
weightings <-c(0,0,0,-0.5,0)
weightings <-c(0,0,0,-0.7,0)
weightings <-c(0,0,0,-0.9,0)

## scenario 3--> testing the ability to manage swordfish and leatherback equally (5 runs, weightings are the same for both algorithms)
weightings <-c(0,0,0,-0.1,0.1)
weightings <-c(0,0,0,-0.3,0.3)
weightings <-c(0,0,0,-0.5,0.5)
weightings <-c(0,0,0,-0.7,0.7)
weightings <-c(0,0,0,-0.9,0.9)

## scenario 4--> testing the ability to manage swordfish and bluesharks
M_weightings <-c(-0.1,-0.1,0,"lbst",0)
M_weightings <-c(-0.5,-0.5,0,"lbst",0)
M_weightings <-c(-0.9,-0.9,0,"lbst",0)
E_weightings <-c(-0.3,-0.3,0,"lbst",0)
E_weightings <-c(-1.5,-1.5,0,"lbst",0)
E_weightings <-c(-2.7,-2.7,0,"lbst",0)
