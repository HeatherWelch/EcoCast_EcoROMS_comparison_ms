# EcoCast_EcoROMS_comparison_ms
Comparison ms of EcoCast and EcoROMS. Compares: hindcast abilities to avoid bycatch, how both fit contingency plan, effect of species weightings

## 1. species_data_prep.R ##
script to prepare raw observer and tracking data for hindcast

## 2. hindcast_predict.R ##
predicts for each species at each raw data point, creates Eco products under conditions of different species weightings, make plots (original analysis)

## 3. marxan_clean_02.21.18.R ##
the finalized marxan functions: run marxan, make pngs + rasters

## Eco-ROMS-private/Extracto_Scripts/plot_EcoROMS_temporary.R ##
funtion run_ecoroms_hindcast is accessed to run the ecoroms portion

