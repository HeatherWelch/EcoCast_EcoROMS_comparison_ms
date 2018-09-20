library(magick)
plotdir_ms="~/Dropbox/EcoEast_EcoROMS_comparison_ms/EcoCast_EcoROMS_comparison_ms/hindcast_ms/summarize_ms/plots/"#;dir.create(plotdir_ms)

file=paste0(plotdir_ms,"histograms3.png")
template=paste0(plotdir_ms,"template.png")

hist=image_read(file)
template=image_read(template)
template2=image_scale(template, "8100")
#hist2=image_scale(hist, "970")
hist2=image_crop(hist,"+50-0") 

a=image_composite(template2,hist2,offset = "+200+240")
a
image_write(a,path = paste0(plotdir_ms,"trial.png"))

