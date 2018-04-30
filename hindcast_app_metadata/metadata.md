# EcoCast 2.0 hindcast exploration
Heather Welch  
`r format(Sys.Date())`  


# Introduction
This is a hindcast test of the EcoVerse - a suite of algorithms to reduce bycatch while maximizing target catch in near real-time. 
The hindcast was run between **1997-10-01 and 1997-11-31** (lots of swordfish catches), **2003-04-01 and 2003-04-30** (lots of lbst tracking points), **2005-08-01 and 2005-11-31** (lots of tracking points for all species), and **all dates with leatherback bycatch events**. 

Additionally, a random point hindcast was conducted, consisting of 1700 random points between across the same date ranges as the real data. At each random point, all algorithm values were compared to all species habitat suitabilities. Random data was used to remove the effect of model fit on hindcast results. As opposed to evaluating the ability of the algorithm to avoid/target true presences (which can have low predicted suitability), we are evaluating the ability of the algorithm to avoid/target predicted suitability values.


<img src="metadata_files/figure-html/unnamed-chunk-1-1.png" width="50%" /><img src="metadata_files/figure-html/unnamed-chunk-1-2.png" width="50%" />


**How the Marxan algorithm works**  <br>
Marxan attempts to solve a min set cover problem, i.e. what is the minimum set of planning units (here 10x10 pixels) needed to meet **targets** for **conservation features** while minimizing **costs**. <br>
-targets: the species weightings <br>
-conservation features: the bycatch species and the inverse of swordfish  <br>
-costs: total area (the impact of cost here is minimized as far as possible: we're not trying to design compact protected areas)  <br>

How Marxan is run in EcoMarxan <br>
Species habitat suitability layers (HSL) are input into Marxan with the three bycatch species and inverted swordfish as conservation features. The species weightings used to set targets for the conservation features (e.g. blsh = .4 ---> protect 40% of blsh habitat). Because we are trying to avoid swordfish habitat, swordfish is inverted (subtracted from 1), such that where swor equaled .1, it now equales .9. Marxan will try to maximize protecting "highly suitable" swordfish habitat, which is in actually areas that are most unsuitable pre inversion.

For a given day, Marxan is run 1000 times to create an output of selection frequency, i.e. the number of times / 1000 each pixel was selected for a solution.

Two algorithms were tested:  <br>
**1. EcoROMS original** - species habitat suitability layers (HSL) are weighted, summed, and then normalized between -1 and 1  <br>
**2. Marxan raw** - the raw selection frequency output (0-1000) rescaled to (-1,1)  <br>

Three "runs" with differing species weightings were evaluated.

# Run 1 - "extreme LBST, neutral SWOR" (all other species neutral)
Weightings in this run were select to emphasize avoiding leatherbacks as much as possible, keeping all other species weightings neutral.<br>
EcoROMS weightings: -0.1,-0.1,-0.05,-2.5,.1 ; <br>
and Marxan weightings: -0.1,-0.1,-0.05,-0.4,0.1 <br>
namesrisk<-c("Blue shark bycatch","Blue sharks","Sea lions","Leatherbacks","Swordfish")

**Example alorithm solutions
From 1995-09-11** <br>
<img src="/Users/heatherwelch/Dropbox/Eco-ROMS/EcoROMSruns/output/hindcast/mean/EcoROMS_original_-0.1_-0.1_-0.05_-2.5_0.1_1995-09-11_mean.png" width="50%" /><img src="/Users/heatherwelch/Dropbox/Eco-ROMS/EcoROMSruns/output/hindcast/marxan/marxan_-0.1_-0.1_-0.05_-0.4_0.1_1995-09-11_raw.png" width="50%" />


<img src="/Users/heatherwelch/Dropbox/Eco-ROMS/Model Prediction Plots/daily_predictions/swor/swor_1995-09-11_mean.png" width="20%" /><img src="/Users/heatherwelch/Dropbox/Eco-ROMS/Model Prediction Plots/daily_predictions/lbst_nolat/lbst_nolat_1995-09-11_mean.png" width="20%" /><img src="/Users/heatherwelch/Dropbox/Eco-ROMS/Model Prediction Plots/daily_predictions/casl_nolat/casl_nolat_1995-09-11_mean.png" width="20%" /><img src="/Users/heatherwelch/Dropbox/Eco-ROMS/Model Prediction Plots/daily_predictions/blshobs/blshobs_1995-09-11_mean.png" width="20%" /><img src="/Users/heatherwelch/Dropbox/Eco-ROMS/Model Prediction Plots/daily_predictions/blshtrk_nolat/blshtrk_nolat_1995-09-11_mean.png" width="20%" />


# Run 2 - "extreme LBST, moderate SWOR" (all other species neutral)
Weightings in this run were select to emphasize avoiding leatherbacks as much as possible, with moderate swordfishing weightings, keeping all other species weightings neutral.<br>
EcoROMS weightings: -0.1,-0.1,-0.05,-2.5,1.5 ;<br>
and Marxan weightings: -0.1,-0.1,-0.05,-0.4,0.2 <br>
namesrisk<-c("Blue shark bycatch","Blue sharks","Sea lions","Leatherbacks","Swordfish")

**Example alorithm solutions
From 1995-09-11** <br>
<img src="/Users/heatherwelch/Dropbox/Eco-ROMS/EcoROMSruns/output/hindcast/mean/EcoROMS_original_-0.1_-0.1_-0.05_-2.5_1.5_1995-09-11_mean.png" width="50%" /><img src="/Users/heatherwelch/Dropbox/Eco-ROMS/EcoROMSruns/output/hindcast/marxan/marxan_-0.1_-0.1_-0.05_-0.4_0.2_1995-09-11_raw.png" width="50%" />


<img src="/Users/heatherwelch/Dropbox/Eco-ROMS/Model Prediction Plots/daily_predictions/swor/swor_1995-09-11_mean.png" width="20%" /><img src="/Users/heatherwelch/Dropbox/Eco-ROMS/Model Prediction Plots/daily_predictions/lbst_nolat/lbst_nolat_1995-09-11_mean.png" width="20%" /><img src="/Users/heatherwelch/Dropbox/Eco-ROMS/Model Prediction Plots/daily_predictions/casl_nolat/casl_nolat_1995-09-11_mean.png" width="20%" /><img src="/Users/heatherwelch/Dropbox/Eco-ROMS/Model Prediction Plots/daily_predictions/blshobs/blshobs_1995-09-11_mean.png" width="20%" /><img src="/Users/heatherwelch/Dropbox/Eco-ROMS/Model Prediction Plots/daily_predictions/blshtrk_nolat/blshtrk_nolat_1995-09-11_mean.png" width="20%" />


# Run 3 - "extreme LBST, extreme SWOR" (all other species neutral)
Weightings in this run were select to emphasize avoiding leatherbacks and swordfish as much as possible, keeping all other species weightings neutral.<br>
EcoROMS weightings: -0.1,-0.1,-0.05,-2.5,2.5 ; <br>
and Marxan weightings: -0.1,-0.1,-0.05,-0.4,0.4 <br>
namesrisk<-c("Blue shark bycatch","Blue sharks","Sea lions","Leatherbacks","Swordfish")

**Example alorithm solutions
From 1995-09-11** <br>
<img src="/Users/heatherwelch/Dropbox/Eco-ROMS/EcoROMSruns/output/hindcast/mean/EcoROMS_original_-0.1_-0.1_-0.05_-2.5_2.5_1995-09-11_mean.png" width="50%" /><img src="/Users/heatherwelch/Dropbox/Eco-ROMS/EcoROMSruns/output/hindcast/marxan/marxan_-0.1_-0.1_-0.05_-0.4_0.4_1995-09-11_raw.png" width="50%" />


<img src="/Users/heatherwelch/Dropbox/Eco-ROMS/Model Prediction Plots/daily_predictions/swor/swor_1995-09-11_mean.png" width="20%" /><img src="/Users/heatherwelch/Dropbox/Eco-ROMS/Model Prediction Plots/daily_predictions/lbst_nolat/lbst_nolat_1995-09-11_mean.png" width="20%" /><img src="/Users/heatherwelch/Dropbox/Eco-ROMS/Model Prediction Plots/daily_predictions/casl_nolat/casl_nolat_1995-09-11_mean.png" width="20%" /><img src="/Users/heatherwelch/Dropbox/Eco-ROMS/Model Prediction Plots/daily_predictions/blshobs/blshobs_1995-09-11_mean.png" width="20%" /><img src="/Users/heatherwelch/Dropbox/Eco-ROMS/Model Prediction Plots/daily_predictions/blshtrk_nolat/blshtrk_nolat_1995-09-11_mean.png" width="20%" />

# Stuff that didn't work
For reference, here are some algorithms I tried that didn't work

## EcoROMS species weightings >=3
These outputs can contain occasional extremely high values which washes out the variability on the low end of the values range

<img src="/Users/heatherwelch/Dropbox/Eco-ROMS/EcoROMSruns/output/mean/EcoROMS_-0.1_-0.1_-0.05_-0.9_3_2005-08-07_mean.png" width="960" />

## EcoROMS ratio
These outputs can contain occasional extremely high values (large swordfish value divided by small bycatch value) which washes out the variability on the low end of the values range (I even tried capping ratio values at 2.5 before the rescale) <br>



```r
#Here's the ratio code: <br>
EcoCalc<-function(a,b,c,d,e,risk=weightings,clipTarget=TRUE){
    ecorisk_bycatch<-(a*risk[1]+b*risk[2]+c*risk[3]+d*risk[4])%>% alt_rasterRescale2(.)
    ecorisk_bycatch=ecorisk_bycatch*-1
    ecorisk_target<-(e*risk[5]) %>% inv_alt_rasterRescale()
    
    ecorisk=overlay(ecorisk_target,ecorisk_bycatch,fun=function(x,y)x/y) #%>% rasterRescale()  ### option to make ratio work, but ends up capping data (range of values can get so extreme)<br>
    ecorisk[ecorisk>2.5]<-2.5
    ecorisk=rasterRescale(ecorisk)
    if (clipTarget) {
      (ecorisk[(e<0.25)&(ecorisk>0.5)]=100)
    }
    return(ecorisk)
}

E_orig=paste0("/Users/heatherwelch/Dropbox/Eco-ROMS/EcoROMSruns/output/hindcast/mean/EcoROMS_ratio_-0.1_-0.1_-0.05_-1.5_0.1_1997-11-20_mean.png")
knitr::include_graphics(E_orig)
```

<img src="/Users/heatherwelch/Dropbox/Eco-ROMS/EcoROMSruns/output/hindcast/mean/EcoROMS_ratio_-0.1_-0.1_-0.05_-1.5_0.1_1997-11-20_mean.png" width="960" />

## Marxan with swordfish as a cost
This did work, but the products were not very responsive to changes in swordfish weightings (the way I set this up was not really how marxan is supposed to be run)<br>

**How the Marxan algorithm works with swordfish as a cost**  <br>
Marxan attempts to solve a min set cover problem, i.e. what is the minimum set of planning units (here 10x10 pixels) needed to meet **targets** for **conservation features** while minimizing **costs**. <br>
-targets: the bycatch species weightings <br>
-conservation features: the bycatch species  <br>
-costs: avoided swordfish  <br>

How Marxan is run in EcoMarxan <br>
Species habitat suitability layers HSL are input into Marxan with the three bycatch species as conservation features and swordfish as a cost. The bycatch species weightings used to set targets for the conservation features (e.g. blsh = .4 ---> protect 40% of blsh habitat). The swordfish weighting is used to set a penalty for failing to meet targets for the conservation features, e.g. when swor is high, the penalty is low, therefor we get a less conservative (in terms of avoiding bycatch) solution. For a given day, Marxan is run 1000 times to create an output of selection frequency, i.e. the number of times / 1000 each pixel was selected for a solution.


## Mosaiced Marxan
This produced unwanted artifacts in the solutions, i.e. certain ranges of values were excluded<br>
Here's how the mosaic algorithm worked <br>
**4. Marxan mosaic 01** - remove marxan pixels selected in < 100 solutions, rescale between -1 and 0, where -1= highly selected marxan pixels (e.g. most important for avoiding bycatch); 0=infrequently selected marxan pixels (e.g. least important for avoiding bycatch), fill in removed areas w swordfish values (unscaled), rescale whole thing between -1,1  <br>

<img src="/Users/heatherwelch/Dropbox/Eco-ROMS/EcoROMSruns/output/marxan/marxan_-0.1_-0.1_-0.05_-0.2_0.1_2005-11-12_mosaic01.png" width="960" />

![](metadata_files/figure-html/unnamed-chunk-11-1.png)<!-- -->

