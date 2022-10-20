library(tidyverse)
library(raster)
library(rgdal)
library(pastclim)
library(terra)

get_vars_for_dataset(dataset="Beyer2020")
get_vars_for_dataset(dataset="Krapp2021")
path_to_example_nc <- system.file("/extdata/", package="pastclim")
#bio12 = annual precipitation
# download_dataset(dataset="Beyer2020", bio_variables = c("bio12"),
#                  path_to_nc = path_to_example_nc)
download_dataset(dataset="Krapp2021", bio_variables = c("bio12"),
                 path_to_nc = path_to_example_nc)
get_downloaded_datasets(path_to_nc = path_to_example_nc)

get_biome_classes("Beyer2020", path_to_nc = path_to_example_nc)

mis3 = get_mis_time_steps(3, "Beyer2020", path_to_nc = path_to_example_nc)
mis4 = get_mis_time_steps(4, "Beyer2020", path_to_nc = path_to_example_nc)
mis5c = get_mis_time_steps("5c", "Beyer2020", path_to_nc = path_to_example_nc)
#need other mis 5 slices
mis6 = get_mis_time_steps(6, "Beyer2020", path_to_nc = path_to_example_nc)

mis3_climate_list<-list()
for (this_step in mis3){
  this_step_climate <- climate_for_time_slice(this_step ,c("bio12"),
                                              dataset="Beyer2020", path_to_nc = path_to_example_nc)
  mis3_climate_list[[as.character(this_step)]]<- this_step_climate
}

##need to figure out how to average the values all together

#### TESTING 
climate_100k = climate_for_time_slice(time_bp = -100000,
                                      c("bio12"),
                                      dataset="Beyer2020", path_to_nc = path_to_example_nc)
plot(climate_100k)

##need to create a mask to crop to our section
# afr_eurasia_vec<- terra::vect("POLYGON ((0 70, 25 70, 50 80, 170 80, 170 10, 
#                               119 2.4, 119 0.8, 116 -7.6, 114 -12, 100 -40,
#                               -25 -40, -25 64, 0 70))")
# terra::crs(afr_eurasia_vec)<-terra::crs(climate_20k)
# climate_20k_afr_eurasia <- terra::mask(climate_20k, afr_eurasia_vec)
# climate_20k_afr_eurasia <- terra::crop(climate_20k_afr_eurasia,afr_eurasia_vec)
# terra::plot(climate_20k_afr_eurasia)

climate_100k$ice_mask = get_ice_mask(time_bp = -100000, dataset="Beyer2020", path_to_nc = path_to_example_nc)
climate_100k$land_mask = get_land_mask(time_bp = -100000, dataset="Beyer2020", path_to_nc = path_to_example_nc)

plot(climate_100k)
