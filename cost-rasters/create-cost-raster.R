library(tidyverse)
library(raster)
library(rgdal)
library(pastclim)
library(terra)
library(RSAGA)

get_vars_for_dataset(dataset="Beyer2020")
get_vars_for_dataset(dataset="Krapp2021")
path_to_example_nc <- system.file("/extdata/", package="pastclim")
#bio12 = annual precipitation
# download_dataset(dataset="Beyer2020", bio_variables = c("bio12"),
#                  path_to_nc = path_to_example_nc)
# download_dataset(dataset="Krapp2021", bio_variables = c("bio01", "bio12"),
#                  path_to_nc = path_to_example_nc)
get_downloaded_datasets(path_to_nc = path_to_example_nc)

get_biome_classes("Beyer2020", path_to_nc = path_to_example_nc)

mis3 = get_mis_time_steps(3, "Beyer2020", path_to_nc = path_to_example_nc)
mis4 = get_mis_time_steps(4, "Beyer2020", path_to_nc = path_to_example_nc)
mis5a = get_mis_time_steps("5a", "Beyer2020", path_to_nc = path_to_example_nc)
mis5b = get_mis_time_steps("5b", "Beyer2020", path_to_nc = path_to_example_nc)
mis5c = get_mis_time_steps("5c", "Beyer2020", path_to_nc = path_to_example_nc)
mis5d = get_mis_time_steps("5d", "Beyer2020", path_to_nc = path_to_example_nc)
mis5e = get_mis_time_steps("5e", "Beyer2020", path_to_nc = path_to_example_nc)
mis5 = array(c(mis5a, mis5b, mis5c, mis5d, mis5e))
mis6 = get_mis_time_steps("6", "Krapp2021", path_to_nc = path_to_example_nc)

mis3_climate_list<-list()
for (this_step in mis3){
  this_step_climate <- climate_for_time_slice(this_step ,c("bio12"),
                                              dataset="Beyer2020", path_to_nc = path_to_example_nc)
  mis3_climate_list[[as.character(this_step)]]<- this_step_climate
}
MIS3 = terra::app(sds(mis3_climate_list), mean)

mis4_climate_list<-list()
for (this_step in mis4){
  this_step_climate <- climate_for_time_slice(this_step ,c("bio12"),
                                              dataset="Beyer2020", path_to_nc = path_to_example_nc)
  mis4_climate_list[[as.character(this_step)]]<- this_step_climate
}
MIS4 = terra::app(sds(mis4_climate_list), mean)

mis5_climate_list<-list()
for (this_step in mis5){
  this_step_climate <- climate_for_time_slice(this_step ,c("bio12"),
                                              dataset="Beyer2020", path_to_nc = path_to_example_nc)
  mis5_climate_list[[as.character(this_step)]]<- this_step_climate
}
MIS5 = terra::app(sds(mis5_climate_list), mean)

mis6_climate_list<-list()
for (this_step in mis6){
  this_step_climate <- climate_for_time_slice(this_step ,c("bio12"),
                                              dataset="Beyer2020", path_to_nc = path_to_example_nc)
  mis6_climate_list[[as.character(this_step)]]<- this_step_climate
}
MIS6 = terra::app(sds(mis6_climate_list), mean)

bbox = readOGR(file.choose())
bbox.vec = terra::vect(bbox)
terra::crs(bbox.vec) = terra::crs(MIS6)

MIS3_clip = terra::mask(MIS3, bbox.vec)
MIS3_clip = terra::crop(MIS3_clip, bbox.vec)

MIS4_clip = terra::mask(MIS4, bbox.vec)
MIS4_clip = terra::crop(MIS4_clip, bbox.vec)

MIS5_clip = terra::mask(MIS5, bbox.vec)
MIS5_clip = terra::crop(MIS5_clip, bbox.vec)

MIS6_clip = terra::mask(MIS6, bbox.vec)
MIS6_clip = terra::crop(MIS6_clip, bbox.vec)


plot(MIS3_clip)
plot(MIS4_clip)
plot(MIS5_clip)
plot(MIS6_clip)



# env = rsaga.env()
# read.sgrd(paste0(getwd(), "/cost-rasters/input-data/DEM-sdat"))




#### TESTING 
# climate_100k = climate_for_time_slice(time_bp = -100000,
#                                       c("bio12"),
#                                       dataset="Beyer2020", path_to_nc = path_to_example_nc)
# plot(climate_100k)
# 
# ##need to create a mask to crop to our section
# bbox = readOGR(file.choose())
# 
# bbox.vec = terra::vect(bbox)
# terra::crs(bbox.vec) = terra::crs(climate_100k)
# climate_100k_clip = terra::mask(climate_100k, bbox.vec)
# climate_100k_clip = terra::crop(climate_100k_clip, bbox.vec)
# 
# plot(climate_100k_clip)
# 
# 
# climate_100k_ice_mask = get_ice_mask(time_bp = -100000, dataset="Beyer2020", path_to_nc = path_to_example_nc)
# climate_100k_im_clip = terra::mask(climate_100k_ice_mask, bbox.vec)
# climate_100k_im_clip = terra::crop(climate_100k_im_clip, bbox.vec)
# 
# plot(climate_100k_im_clip)
