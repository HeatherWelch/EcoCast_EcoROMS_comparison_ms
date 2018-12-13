### temperature trends at species extraction points

points=read.csv("hindcast_ms/extract/random_points.csv")
source("~/Dropbox/Eco-ROMS/heather_working/Eco-ROMS-private/Extracto_Scripts/Extracto_ROMS.R")
source("load_functions.R")

ROMS_files_hist <- list.files("~/Dropbox/Eco-ROMS/ROMS & Bathym Data/wcra31_daily_1980-2010",pattern=".nc", full.names=T)
ROMS_files_newNRT <- list.files("~/Dropbox/Eco-ROMS/ROMS & Bathym Data/WCNRT",pattern=".nc", full.names=T)

input_file <- getvarROMS(ROMS_files_hist[7], 'sst', points, desired.resolution = 0.1, mean, 'mean_0.1')
input_file_newRT <- getvarROMS(ROMS_files_newNRT[7], 'sst', input_file, desired.resolution = 0.1, mean, 'mean_0.1')

points=input_file_newRT %>% mutate(year=as.factor(substr(dt,1,4)))
write.csv(points,"/Volumes/SeaGate/EcoCast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/hindcast_ms/figures/plots/temp_points.csv")

a=ggplot(points,aes(x=year, y=sst_mean_0.1))+geom_boxplot()+ylab("Sea surface temperature °C")+xlab("Year")+
  theme(text = element_text(size=5),axis.text = element_text(size=5),plot.title = element_text(hjust=0,size=5))

png(paste0(plotdir_ms,"points_temp_boxplot.png"),width=3, height=3, units="in", res=400)
par(ps=10)
par(cex=1)
par(mar=c(4,4,1,1))
plot_grid(a)
dev.off()

a=points %>% group_by(year) %>% .[complete.cases(.),] %>% summarise(mean=mean(sst_mean_0.1))
