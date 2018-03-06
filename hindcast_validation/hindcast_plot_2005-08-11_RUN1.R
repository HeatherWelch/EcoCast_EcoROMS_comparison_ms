# step 4. extract all values at all points for hindcast analysis

# RUN 1: GENERIC WEIGHTINGS
namesrisk<-c("Blue shark bycatch","Blue sharks","Sea lions","Leatherbacks","Swordfish")
ER_weightings<-c(-0.1,-0.1,-0.05,-0.9,0.9)
M_weightings<-c(-0.1,-0.1,-0.05,-0.2,0.1)

## load function
source("hindcast_validation/extract_function.R")
