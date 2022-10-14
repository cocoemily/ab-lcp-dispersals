library(raster)
library(rgdal)

files = list.files(paste0(getwd(),"/test-data/DEM"), full.names = T)
print(files)

# DEM = raster(files[4])
# plot(DEM)
# DEM.crop = crop(DEM, extent(c(60, 65, 45, 50)))
# plot(DEM.crop)

DEM.ascii = read.table(files[1], header = F, skip = 6) ## DEM as a data.frame with elevation values

viewshed = function(x, y, dir) {
  #find set of squares the agent can move to using this function
  #see figure 2 from AB-LCP paper
}





