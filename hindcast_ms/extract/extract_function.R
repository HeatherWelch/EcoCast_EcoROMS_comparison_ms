### Funtion to extract hindcast values at points

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