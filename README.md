# EcoCast_EcoROMS_comparison_ms
Comparison ms of EcoCast and EcoROMS. Compares: hindcast abilities to avoid bycatch, how both fit contingency plan, effect of species weightings

### 1. species_data_prep.R ###
script to prepare raw observer and tracking data for hindcast

### 2. hindcast_predict.R ###
predicts for each species at each raw data point, creates Eco products under conditions of different species weightings, make plots (original analysis)

### 3. marxan_clean_02.21.18.R ###
the finalized marxan functions: run marxan, make pngs + rasters
two functions, scp(): swordfish is a cost, scp_swor(): sordfish is inverted and seen as a conservation feature

### 4. Eco-ROMS-private/Extracto_Scripts/plot_EcoROMS_temporary.R ###
function run_ecoroms_hindcast is accessed to run the ecoroms portion

### 5. hindcast_predict_EcoCast.R ###
calls plot_EcoROMS_temporary to batch hindcast EcoROMS
runs two functions. Run_ecoroms_hindcast(): standard ecoroms/cast function, Run_ecoroms_hindcast_rations(): calculates a bycatch to targetcatch ratio

### 6. hindcast_predict_Marxan.R ###
calls run_marxan in (3) to batch hindcast Marxan

### 7. extract_function.R ###
Funtion to extract hindcast values at points from EcoROMS / Marxan rasters

### 8. hindcast_extract_plot.R ###
depreciated script that takes 2005 output from 1. and runs extract function (7.). Makes plots, boxplots and maps

### 9. hindcast_extract_plot_random.R ###
script that takes 1000 random data points form 2005 and runs extract function (7.)

### 10. hindcast_extract_plot_1997_random.R ###
script that takes 1997, and 2005 output from 1. and 1500 random points from the 1997 and 2005 windows, and runs extract function (7.). 

### 11. hindcast_plot_2005-08-11_RUNS1-3.Rmd ###
Rmarkdown that plots resutls of 8. with box plots, histograms, maps

### 12. hindcast_plot_2005-08-11_random_RUNS1-3.Rmd ###
Rmarkdown that plots resutls of 9. with point clouds of hab suit vs algorithm result

### 13. hindcast_plot_1997_2005_RUNS1-3.Rmd ###
Rmarkdown that plots resutls of 10. (raw and random data) with box plots, histograms, maps (raw) and point clouds (random)






