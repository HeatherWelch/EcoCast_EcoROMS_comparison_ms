# EcoROMS original & EcoMarxan hindcast comparison
Heather Welch  
`r format(Sys.Date())`  


# Introduction
This is a hindcast test of the EcoVerse - a suite of algorithms to reduce bycatch while maximizing target catch in near real-time. 
The hindcast was run between **1997-10-01 and 1997-11-31** (lots of swordfish catches), **2003-04-01 and 2003-04-30** (lots of lbst tracking points), **2005-08-01 and 2005-11-31** (lots of tracking points for all species), and **all dates with leatherback bycatch events**. 

Additionally, a random point hindcast was conducted, consisting of 1700 random points between across the same date ranges as the real data. At each random point, all algorithm values were compared to all species habitat suitabilities.

<img src="point_clouds_04.2418_RUNS5_git_files/figure-html/unnamed-chunk-1-1.png" width="50%" /><img src="point_clouds_04.2418_RUNS5_git_files/figure-html/unnamed-chunk-1-2.png" width="50%" />

**Histograms of predicted habitat suitability at species presences**



<img src="point_clouds_04.2418_RUNS5_git_files/figure-html/unnamed-chunk-3-1.png" width="30%" /><img src="point_clouds_04.2418_RUNS5_git_files/figure-html/unnamed-chunk-3-2.png" width="30%" /><img src="point_clouds_04.2418_RUNS5_git_files/figure-html/unnamed-chunk-3-3.png" width="30%" /><img src="point_clouds_04.2418_RUNS5_git_files/figure-html/unnamed-chunk-3-4.png" width="30%" /><img src="point_clouds_04.2418_RUNS5_git_files/figure-html/unnamed-chunk-3-5.png" width="30%" />


**How the Marxan algorithm works**  <br>
Marxan attempts to solve a min set cover problem, i.e. what is the minimum set of planning units (here 10x10 pixels) needed to meet **targets** for **conservation features** while minimizing **costs**. <br>
-targets: the species weightings <br>
-conservation features: the bycatch species and the inverse of swordfish  <br>
-costs: total area (the impact of cost here is minimized as far as possible: we're not trying to design compact protected areas)  <br>

How Marxan is run in EcoMarxan <br>
Species habitat suitability layers (HSL) are input into Marxan with the three bycatch species and inverted swordfish as conservation features. The species weightings used to set targets for the conservation features (e.g. blsh = .4 ---> protect 40% of blsh habitat). Because we are trying to avoid swordfish habitat, swordfish is inverted (subtracted from 1), such that where swor equaled .1, it now equales .9. Marxan will try to maximize protected "highly suitable" swordfish habitat, which is in actually areas that are most unsuitable pre inversion.

For a given day, Marxan is run 1000 times to create an output of selection frequency, i.e. the number of times / 1000 each pixel was selected for a solution.

Two algorithms were tested:  <br>
**1. EcoROMS original** - species habitat suitability layers (HSL) are weighted, summed, and then normalized between -1 and 1  <br>
**2. Marxan raw** - the raw selection frequency output (0-1000) rescaled to (-1,1)  <br>


# Run 5 - "extreme LBST, upweighted SWOR" - raw data
Weightings in this run were select to emphasize avoiding leatherbacks as much as possible, moderate swordfish avoidance, keeping all other species weightings neutral. EcoROMS weightings: -0.1,-0.1,-0.05,-2.5,1.5 ; and Marxan weightings: -0.1,-0.1,-0.05,-0.4,0.2 <br>
namesrisk<-c("Blue shark bycatch","Blue sharks","Sea lions","Leatherbacks","Swordfish")

## Example alorithm solutions
From 1995-09-11 <br>
<img src="/Users/heatherwelch/Dropbox/Eco-ROMS/EcoROMSruns/output/hindcast/mean/EcoROMS_original_-0.1_-0.1_-0.05_-2.5_1.5_1995-09-11_mean.png" width="50%" /><img src="/Users/heatherwelch/Dropbox/Eco-ROMS/EcoROMSruns/output/hindcast/marxan/marxan_-0.1_-0.1_-0.05_-0.4_0.2_1995-09-11_raw.png" width="50%" />


<img src="/Users/heatherwelch/Dropbox/Eco-ROMS/Model Prediction Plots/daily_predictions/swor/swor_1995-09-11_mean.png" width="20%" /><img src="/Users/heatherwelch/Dropbox/Eco-ROMS/Model Prediction Plots/daily_predictions/lbst_nolat/lbst_nolat_1995-09-11_mean.png" width="20%" /><img src="/Users/heatherwelch/Dropbox/Eco-ROMS/Model Prediction Plots/daily_predictions/casl_nolat/casl_nolat_1995-09-11_mean.png" width="20%" /><img src="/Users/heatherwelch/Dropbox/Eco-ROMS/Model Prediction Plots/daily_predictions/blshobs/blshobs_1995-09-11_mean.png" width="20%" /><img src="/Users/heatherwelch/Dropbox/Eco-ROMS/Model Prediction Plots/daily_predictions/blshtrk_nolat/blshtrk_nolat_1995-09-11_mean.png" width="20%" />


## Box plots
Algorithm values at historical records

<img src="point_clouds_04.2418_RUNS5_git_files/figure-html/unnamed-chunk-6-1.png" width="50%" /><img src="point_clouds_04.2418_RUNS5_git_files/figure-html/unnamed-chunk-6-2.png" width="50%" />


## Point clouds
Habitat suitability layers vs algorithm solutions

<img src="point_clouds_04.2418_RUNS5_git_files/figure-html/unnamed-chunk-7-1.png" width="50%" /><img src="point_clouds_04.2418_RUNS5_git_files/figure-html/unnamed-chunk-7-2.png" width="50%" />

# Run 5 - "extreme LBST, upweighted SWOR" - random data

## Point clouds
Habitat suitability layers vs algorithm solutions
 
<img src="point_clouds_04.2418_RUNS5_git_files/figure-html/unnamed-chunk-8-1.png" width="50%" /><img src="point_clouds_04.2418_RUNS5_git_files/figure-html/unnamed-chunk-8-2.png" width="50%" />
