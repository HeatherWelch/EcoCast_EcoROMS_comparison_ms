## script to hindcast the temporal variability of hindcasts
## testing the ratio of lbst:swor at different weightings and different catch limits and different algorithms
## weightings: run 4, run 5, run 6
## catch limits: lbst @ 60,80, 90; swor 

run4_random=read.csv("raw_data/species_predict_05.01.18_random_run4.csv") %>% .[1:1698,]
run5_random=read.csv("raw_data/species_predict_05.01.18_random_run5.csv") %>% .[1:1698,]
run6_random=read.csv("raw_data/species_predict_05.01.18_random_run6.csv") %>% .[1:1698,]

run4_random_scaling=read.csv("raw_data/species_predict_05.02.18_random_scaled_unscaled_run4.csv") %>% .[1:1698,]
run5_random_scaling=read.csv("raw_data/species_predict_05.02.18_random_scaled_unscaled_run5.csv") %>% .[1:1698,]
run6_random_scaling=read.csv("raw_data/species_predict_05.02.18_random_scaled_unscaled_run6.csv") %>% .[1:1698,]
