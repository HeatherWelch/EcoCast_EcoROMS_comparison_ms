### Funtion to extract hindcast values at points

library(tidyverse)
library(raster)
library(sp)
library(tidyverse)
library(rworldmap)
library(rgdal)
library(rasterVis)
library(RColorBrewer)
library(ggmap)
library(grid)
library(lattice)
library(gridExtra)
library(maptools)
library(dplyr)
library(reshape)
library(tidyverse)

##### b. build new extracto function for ecoroms and marxan ####

extracto_raster=function(algorithm,pts,solution_list,weightings){
  dates=pts$dt %>% unique() %>% as.character()
  for(x in dates){
    print(x)
    ras=grep(x,solution_list,value = T) %>% raster()
    points=filter(pts,dt==x)
    coordinates(points)=~lon+lat
    ex=extract(ras,points)
    pts[pts$dt==x,algorithm]=ex
  }
  return(pts)
}