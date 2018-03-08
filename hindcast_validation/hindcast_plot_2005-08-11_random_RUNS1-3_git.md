# EcoROMS & EcoMarxan
Heather Welch  
`r format(Sys.Date())`  


# Introduction
This is a hindcast test of the EcoVerse - a sweet of algorithms to reduce bycatch while maximizing target catch in near real-time. The hindcast was run between **2005-08-01 and 2005-11-31**, a time period for which there are historical observer and tracking records for each species in the EcoVerse. 

Number of records: <br>
-blueshark observer = 28 <br>
-blueshark track = 909 <br>
-California sea lion = 37101 <br>
-Leatherback = 2921 <br>
-Swordfish = 89 <br>

![](hindcast_plot_2005-08-11_random_RUNS1-3_git_files/figure-html/unnamed-chunk-1-1.png)<!-- -->


**How the Marxan algorithm works**  <br>
Marxan attempts to solve a min set cover problem, i.e. what is the minimum set of planning units (here 10x10 pixels) needed to meet **targets** for **conservation features** while minimizing **costs**. <br>
-targets: the bycatch species weightings <br>
-conservation features: the bycatch species  <br>
-costs: avoided swordfish  <br>

How Marxan is run in EcoMarxan <br>
Species habitat suitability layers HSL are input into Marxan with the three bycatch species as conservation features and swordfish as a cost. The bycatch species weightings used to set targets for the conservation features (e.g. blsh = .4 ---> protect 40% of blsh habitat). The swordfish weighting is used to set a penalty for failing to meet targets for the conservation features, e.g. when swor is high, the penalty is low, therefor we get a less conservative (in terms of avoiding bycatch) solution. For a given day, Marxan is run 1000 times to create an output of selection frequency, i.e. the number of times / 1000 each pixel was selected for a solution.

Four algorithms were tested:  <br>
**1. EcoROMS** - species habitat suitability layers (HSL) are weighted, summed, and then normalized between -1 and 1  <br>
**2. Marxan raw** - the raw selection frequency output (0-1000) rescaled to (-1,1)  <br>
**3. Marxan mosaic** - remove marxan pixels selected in < 100 solutions, rescale remaining pixels between -1 and 0, where -1= highly selected marxan pixels (e.g. most important for avoiding bycatch); 0=infrequently selected marxan pixels (e.g. least important for avoiding bycatch), fill in removed areas w raw swordfish values from HSL (scaled between 0,1)  <br>
**4. Marxan mosaic 01** - remove marxan pixels selected in < 100 solutions, rescale between -1 and 0, where -1= highly selected marxan pixels (e.g. most important for avoiding bycatch); 0=infrequently selected marxan pixels (e.g. least important for avoiding bycatch), fill in removed areas w swordfish values (unscaled), rescale whole thing between -1,1  <br>


# Run 1 - "generic weightings"
The generic EcoROMS weightings (-0.1,-0.1,-0.05,-0.9,0.9), and Marxan weightings that produce similar outputs (-0.1,-0.1,-0.05,-0.2,0.1). <br>
namesrisk<-c("Blue shark bycatch","Blue sharks","Sea lions","Leatherbacks","Swordfish")

## Example alorithm solutions
From 2005-08-01 <br>
<img src="/Users/heatherwelch/Dropbox/Eco-ROMS/EcoROMSruns/output/mean/EcoROMS_-0.1_-0.1_-0.05_-0.9_0.9_2005-08-01_mean.png" width="25%" /><img src="/Users/heatherwelch/Dropbox/Eco-ROMS/EcoROMSruns/output/marxan/marxan_-0.1_-0.1_-0.05_-0.2_0.1_2005-08-01_raw.png" width="25%" /><img src="/Users/heatherwelch/Dropbox/Eco-ROMS/EcoROMSruns/output/marxan/marxan_-0.1_-0.1_-0.05_-0.2_0.1_2005-08-01_mosaic.png" width="25%" /><img src="/Users/heatherwelch/Dropbox/Eco-ROMS/EcoROMSruns/output/marxan/marxan_-0.1_-0.1_-0.05_-0.2_0.1_2005-08-01_mosaic01.png" width="25%" />


<img src="/Users/heatherwelch/Dropbox/Eco-ROMS/Model Prediction Plots/daily_predictions/swor/swor_2005-08-01_mean.png" width="20%" /><img src="/Users/heatherwelch/Dropbox/Eco-ROMS/Model Prediction Plots/daily_predictions/lbst_nolat/lbst_nolat_2005-08-01_mean.png" width="20%" /><img src="/Users/heatherwelch/Dropbox/Eco-ROMS/Model Prediction Plots/daily_predictions/casl_nolat/casl_nolat_2005-08-01_mean.png" width="20%" /><img src="/Users/heatherwelch/Dropbox/Eco-ROMS/Model Prediction Plots/daily_predictions/blshobs/blshobs_2005-08-01_mean.png" width="20%" /><img src="/Users/heatherwelch/Dropbox/Eco-ROMS/Model Prediction Plots/daily_predictions/blshtrk_nolat/blshtrk_nolat_2005-08-01_mean.png" width="20%" />

## Point clouds
Habitat suitability layers vs algorithm solutions
 
<img src="hindcast_plot_2005-08-11_random_RUNS1-3_git_files/figure-html/unnamed-chunk-4-1.png" width="50%" /><img src="hindcast_plot_2005-08-11_random_RUNS1-3_git_files/figure-html/unnamed-chunk-4-2.png" width="50%" /><img src="hindcast_plot_2005-08-11_random_RUNS1-3_git_files/figure-html/unnamed-chunk-4-3.png" width="50%" /><img src="hindcast_plot_2005-08-11_random_RUNS1-3_git_files/figure-html/unnamed-chunk-4-4.png" width="50%" />

# Run 2 - "SWOR and LBST at their most extremes"
Weightings in this run were select to seperate swordfish and leatherbacks as much as possible, keeping all other species weightings constant with Run 1. EcoROMS weightings: -0.1,-0.1,-0.05,-1.5,2 ; and Marxan weightings: -0.1,-0.1,-0.05,-0.3,0.6 <br>
namesrisk<-c("Blue shark bycatch","Blue sharks","Sea lions","Leatherbacks","Swordfish")

## Example alorithm solutions
From 2005-08-01 <br>
<img src="/Users/heatherwelch/Dropbox/Eco-ROMS/EcoROMSruns/output/mean/EcoROMS_-0.1_-0.1_-0.05_-1.5_2_2005-08-01_mean.png" width="25%" /><img src="/Users/heatherwelch/Dropbox/Eco-ROMS/EcoROMSruns/output/marxan/marxan_-0.1_-0.1_-0.05_-0.3_0.6_2005-08-01_raw.png" width="25%" /><img src="/Users/heatherwelch/Dropbox/Eco-ROMS/EcoROMSruns/output/marxan/marxan_-0.1_-0.1_-0.05_-0.3_0.6_2005-08-01_mosaic.png" width="25%" /><img src="/Users/heatherwelch/Dropbox/Eco-ROMS/EcoROMSruns/output/marxan/marxan_-0.1_-0.1_-0.05_-0.3_0.6_2005-08-01_mosaic01.png" width="25%" />


<img src="/Users/heatherwelch/Dropbox/Eco-ROMS/Model Prediction Plots/daily_predictions/swor/swor_2005-08-01_mean.png" width="20%" /><img src="/Users/heatherwelch/Dropbox/Eco-ROMS/Model Prediction Plots/daily_predictions/lbst_nolat/lbst_nolat_2005-08-01_mean.png" width="20%" /><img src="/Users/heatherwelch/Dropbox/Eco-ROMS/Model Prediction Plots/daily_predictions/casl_nolat/casl_nolat_2005-08-01_mean.png" width="20%" /><img src="/Users/heatherwelch/Dropbox/Eco-ROMS/Model Prediction Plots/daily_predictions/blshobs/blshobs_2005-08-01_mean.png" width="20%" /><img src="/Users/heatherwelch/Dropbox/Eco-ROMS/Model Prediction Plots/daily_predictions/blshtrk_nolat/blshtrk_nolat_2005-08-01_mean.png" width="20%" />

## Point clouds
Habitat suitability layers vs algorithm solutions
 
<img src="hindcast_plot_2005-08-11_random_RUNS1-3_git_files/figure-html/unnamed-chunk-7-1.png" width="50%" /><img src="hindcast_plot_2005-08-11_random_RUNS1-3_git_files/figure-html/unnamed-chunk-7-2.png" width="50%" /><img src="hindcast_plot_2005-08-11_random_RUNS1-3_git_files/figure-html/unnamed-chunk-7-3.png" width="50%" /><img src="hindcast_plot_2005-08-11_random_RUNS1-3_git_files/figure-html/unnamed-chunk-7-4.png" width="50%" />


# Run 3 - "extreme LBST, neutral SWOR"
Weightings in this run were select to seperate swordfish and leatherbacks as much as possible, keeping all other species weightings constant with Run 1. EcoROMS weightings: -0.1,-0.1,-0.05,-1.5,.1 ; and Marxan weightings: -0.1,-0.1,-0.05,-0.3,0.1 <br>
namesrisk<-c("Blue shark bycatch","Blue sharks","Sea lions","Leatherbacks","Swordfish")

## Example alorithm solutions
From 2005-08-01 <br>
<img src="/Users/heatherwelch/Dropbox/Eco-ROMS/EcoROMSruns/output/mean/EcoROMS_-0.1_-0.1_-0.05_-1.5_0.1_2005-08-01_mean.png" width="25%" /><img src="/Users/heatherwelch/Dropbox/Eco-ROMS/EcoROMSruns/output/marxan/marxan_-0.1_-0.1_-0.05_-0.3_0.1_2005-08-01_raw.png" width="25%" /><img src="/Users/heatherwelch/Dropbox/Eco-ROMS/EcoROMSruns/output/marxan/marxan_-0.1_-0.1_-0.05_-0.3_0.1_2005-08-01_mosaic.png" width="25%" /><img src="/Users/heatherwelch/Dropbox/Eco-ROMS/EcoROMSruns/output/marxan/marxan_-0.1_-0.1_-0.05_-0.3_0.1_2005-08-01_mosaic01.png" width="25%" />


<img src="/Users/heatherwelch/Dropbox/Eco-ROMS/Model Prediction Plots/daily_predictions/swor/swor_2005-08-01_mean.png" width="20%" /><img src="/Users/heatherwelch/Dropbox/Eco-ROMS/Model Prediction Plots/daily_predictions/lbst_nolat/lbst_nolat_2005-08-01_mean.png" width="20%" /><img src="/Users/heatherwelch/Dropbox/Eco-ROMS/Model Prediction Plots/daily_predictions/casl_nolat/casl_nolat_2005-08-01_mean.png" width="20%" /><img src="/Users/heatherwelch/Dropbox/Eco-ROMS/Model Prediction Plots/daily_predictions/blshobs/blshobs_2005-08-01_mean.png" width="20%" /><img src="/Users/heatherwelch/Dropbox/Eco-ROMS/Model Prediction Plots/daily_predictions/blshtrk_nolat/blshtrk_nolat_2005-08-01_mean.png" width="20%" />

## Point clouds
Habitat suitability layers vs algorithm solutions
 
<img src="hindcast_plot_2005-08-11_random_RUNS1-3_git_files/figure-html/unnamed-chunk-10-1.png" width="50%" /><img src="hindcast_plot_2005-08-11_random_RUNS1-3_git_files/figure-html/unnamed-chunk-10-2.png" width="50%" /><img src="hindcast_plot_2005-08-11_random_RUNS1-3_git_files/figure-html/unnamed-chunk-10-3.png" width="50%" /><img src="hindcast_plot_2005-08-11_random_RUNS1-3_git_files/figure-html/unnamed-chunk-10-4.png" width="50%" />
