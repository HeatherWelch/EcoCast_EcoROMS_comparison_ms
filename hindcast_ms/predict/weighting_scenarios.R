### Weightings for systematic hindcast
# Marxan has a range of -1 to 0 ; assuming EcoROMS has a range of -3 to 3 (we don't know actual limits, but we know there is a larger range than Marxan)
# EcoROMS weightings will be rescaled relative to assumed range to have the same interspecies ratios as Marxan

namesrisk<-c("Blue shark bycatch","Blue sharks","Sea lions","Leatherbacks","Swordfish")

## scenario A--> isolating the effect of swordfish weightings (5 runs, weightings are the same for both algorithms)
weightings <-c(0,0,0,0,0.1) #run A.1
weightings <-c(0,0,0,0,0.3) #run A.2
weightings <-c(0,0,0,0,0.5) #run A.3
weightings <-c(0,0,0,0,0.7) #run A.4
weightings <-c(0,0,0,0,0.9) #run A.5

## scenario B--> isolating the effect of leatherback weightings (5 runs, weightings are the same for both algorithms)
weightings <-c(0,0,0,-0.1,0) #run B.1
weightings <-c(0,0,0,-0.3,0) #run B.2
weightings <-c(0,0,0,-0.5,0) #run B.3
weightings <-c(0,0,0,-0.7,0) #run B.4
weightings <-c(0,0,0,-0.9,0) #run B.5

## scenario C--> testing the ability to manage swordfish and leatherback equally (5 runs, weightings are the same for both algorithms)
weightings <-c(0,0,0,-0.1,0.1) #run C.1
weightings <-c(0,0,0,-0.3,0.3) #run C.2
weightings <-c(0,0,0,-0.5,0.5) #run C.3
weightings <-c(0,0,0,-0.7,0.7) #run C.4
weightings <-c(0,0,0,-0.9,0.9) #run C.5

## scenario D--> testing the ability to manage swordfish and leatherback, tailored based on above results (5 runs, weightings are the same for both algorithms)
# C.3 was the best for Marxan, the Bs were the best for EcoROMS. Seems like its best when lbst is greater than swor
weightings <-c(0,0,0,-0.5,0.1) #run D.1
weightings <-c(0,0,0,-0.5,0.3) #run D.2
weightings <-c(0,0,0,-0.7,0.1) #run D.3
weightings <-c(0,0,0,-0.7,0.3) #run D.4
weightings <-c(0,0,0,-0.7,0.5) #run D.5

## scenario E--> testing the ability to manage swordfish and leatherback, tailored based on above results, swor > lbst (5 runs, weightings are the same for both algorithms)
# in the orginial analysis, this config should make marxan work better
weightings <-c(0,0,0,-0.3,0.7) #run E.1
weightings <-c(0,0,0,-0.3,0.9) #run E.2
weightings <-c(0,0,0,-0.5,0.7) #run E.3
weightings <-c(0,0,0,-0.5,0.9) #run E.4
weightings <-c(0,0,0,-0.7,0.9) #run E.5

## scenario F--> adding in bluesharks. taking the best weightins from A-E and adding some blueshark to see how things change.
#best runs EcoROMS: "EcoROMS_original_unscaled_D.3","EcoROMS_original_unscaled_D.1","EcoROMS_original_unscaled_B.5","EcoROMS_original_unscaled_D.4"
#best runs Marxan: "Marxan_raw_unscaled_C.3","Marxan_raw_unscaled_E.1","Marxan_raw_unscaled_D.4","Marxan_raw_unscaled_B.2"
weightings <-c(-0.05,-0.05,0,-0.3,0) #run F.1 (B.2)
weightings <-c(-0.05,-0.05,0,-0.9,0) #run F.2 (B.5)
weightings <-c(-0.05,-0.05,0,-0.5,0.5) #run F.3 (C.3)
weightings <-c(-0.05,-0.05,0,-0.7,0.1) #run F.4 (D.3)
weightings <-c(-0.05,-0.05,0,-0.7,0.3) #run F.5 (D.4)
weightings <-c(-0.05,-0.05,0,-0.3,0.7) #run F.6 (E.1)

## scenario G--> adding in bluesharks, a little bit more. taking the best weightins from A-E and adding some blueshark to see how things change.
#best runs EcoROMS: "EcoROMS_original_unscaled_D.3","EcoROMS_original_unscaled_D.1","EcoROMS_original_unscaled_B.5","EcoROMS_original_unscaled_D.4"
#best runs Marxan: "Marxan_raw_unscaled_C.3","Marxan_raw_unscaled_E.1","Marxan_raw_unscaled_D.4","Marxan_raw_unscaled_B.2"
weightings <-c(-0.25,-0.25,0,-0.3,0) #run G.1 (B.2)
weightings <-c(-0.25,-0.25,0,-0.9,0) #run G.2 (B.5)
weightings <-c(-0.25,-0.25,0,-0.5,0.5) #run G.3 (C.3)
weightings <-c(-0.25,-0.25,0,-0.7,0.1) #run G.4 (D.3)
weightings <-c(-0.25,-0.25,0,-0.7,0.3) #run G.5 (D.4)
weightings <-c(-0.25,-0.25,0,-0.3,0.7) #run G.6 (E.1)




## scenario D--> testing the ability to manage swordfish and bluesharks (lbst weighting to be determined in scenarios 1-3)
M_weightings <-c(-0.1,-0.1,0,"lbst",0) #run D.1
M_weightings <-c(-0.5,-0.5,0,"lbst",0) #run D.2
M_weightings <-c(-0.9,-0.9,0,"lbst",0) #run D.3
E_weightings <-c(-0.3,-0.3,0,"lbst",0) #run D.1
E_weightings <-c(-1.5,-1.5,0,"lbst",0) #run D.2
E_weightings <-c(-2.7,-2.7,0,"lbst",0) #run D.3
