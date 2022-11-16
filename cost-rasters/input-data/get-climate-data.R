library(tidyverse)
library(raster)
library(rgdal)
library(pastclim)
library(terra)
library(RSAGA)
library(sf)

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
mis5ad = array(c(mis5a, mis5b, mis5c, mis5d))
mis6 = get_mis_time_steps("6", "Krapp2021", path_to_nc = path_to_example_nc)

mis3_climate_list<-list()
mis3_ice_mask_list = list()
for (this_step in mis3){
  this_step_climate <- climate_for_time_slice(this_step ,c("bio12"),
                                              dataset="Beyer2020", path_to_nc = path_to_example_nc)
  mis3_climate_list[[as.character(this_step)]]<- this_step_climate
  
  this_ice_mask = get_ice_mask(this_step, dataset="Beyer2020", path_to_nc = path_to_example_nc)
  mis3_ice_mask_list[[as.character(this_step)]]<- this_ice_mask
  
}
MIS3 = terra::app(sds(mis3_climate_list), mean)
MIS3.ice = terra::app(sds(mis3_ice_mask_list), sum)

mis4_climate_list<-list()
mis4_ice_mask_list = list()
for (this_step in mis4){
  this_step_climate <- climate_for_time_slice(this_step ,c("bio12"),
                                              dataset="Beyer2020", path_to_nc = path_to_example_nc)
  mis4_climate_list[[as.character(this_step)]]<- this_step_climate
  
  this_ice_mask = get_ice_mask(this_step, dataset="Beyer2020", path_to_nc = path_to_example_nc)
  mis4_ice_mask_list[[as.character(this_step)]]<- this_ice_mask
}
MIS4 = terra::app(sds(mis4_climate_list), mean)
MIS4.ice = terra::app(sds(mis4_ice_mask_list), sum)

mis5ad_climate_list <-list()
mis5ad_ice_mask_list = list()
for (this_step in mis5ad){
  this_step_climate <- climate_for_time_slice(this_step ,c("bio12"),
                                              dataset="Beyer2020", path_to_nc = path_to_example_nc)
  mis5ad_climate_list[[as.character(this_step)]]<- this_step_climate
  
  this_ice_mask = get_ice_mask(this_step, dataset="Beyer2020", path_to_nc = path_to_example_nc)
  mis5ad_ice_mask_list[[as.character(this_step)]]<- this_ice_mask
}
MIS5ad = terra::app(sds(mis5ad_climate_list), mean)
MIS5ad.ice = terra::app(sds(mis5ad_ice_mask_list), sum)

mis5a_climate_list <-list()
mis5a_ice_mask_list = list()
for (this_step in mis5a){
  this_step_climate <- climate_for_time_slice(this_step ,c("bio12"),
                                              dataset="Beyer2020", path_to_nc = path_to_example_nc)
  mis5a_climate_list[[as.character(this_step)]]<- this_step_climate
  
  this_ice_mask = get_ice_mask(this_step, dataset="Beyer2020", path_to_nc = path_to_example_nc)
  mis5a_ice_mask_list[[as.character(this_step)]]<- this_ice_mask
}
MIS5a = terra::app(sds(mis5a_climate_list), mean)
MIS5a.ice = terra::app(sds(mis5a_ice_mask_list), sum)

mis5b_climate_list <-list()
mis5b_ice_mask_list = list()
for (this_step in mis5b){
  this_step_climate <- climate_for_time_slice(this_step ,c("bio12"),
                                              dataset="Beyer2020", path_to_nc = path_to_example_nc)
  mis5b_climate_list[[as.character(this_step)]]<- this_step_climate
  
  this_ice_mask = get_ice_mask(this_step, dataset="Beyer2020", path_to_nc = path_to_example_nc)
  mis5b_ice_mask_list[[as.character(this_step)]]<- this_ice_mask
}
MIS5b = terra::app(sds(mis5b_climate_list), mean)
MIS5b.ice = terra::app(sds(mis5b_ice_mask_list), sum)

mis5c_climate_list <-list()
mis5c_ice_mask_list = list()
for (this_step in mis5c){
  this_step_climate <- climate_for_time_slice(this_step ,c("bio12"),
                                              dataset="Beyer2020", path_to_nc = path_to_example_nc)
  mis5c_climate_list[[as.character(this_step)]]<- this_step_climate
  
  this_ice_mask = get_ice_mask(this_step, dataset="Beyer2020", path_to_nc = path_to_example_nc)
  mis5c_ice_mask_list[[as.character(this_step)]]<- this_ice_mask
}
MIS5c = terra::app(sds(mis5c_climate_list), mean)
MIS5c.ice = terra::app(sds(mis5c_ice_mask_list), sum)

mis5d_climate_list <-list()
mis5d_ice_mask_list = list()
for (this_step in mis5d){
  this_step_climate <- climate_for_time_slice(this_step ,c("bio12"),
                                              dataset="Beyer2020", path_to_nc = path_to_example_nc)
  mis5d_climate_list[[as.character(this_step)]]<- this_step_climate
  
  this_ice_mask = get_ice_mask(this_step, dataset="Beyer2020", path_to_nc = path_to_example_nc)
  mis5d_ice_mask_list[[as.character(this_step)]]<- this_ice_mask
}
MIS5d = terra::app(sds(mis5d_climate_list), mean)
MIS5d.ice = terra::app(sds(mis5d_ice_mask_list), sum)

mis5e_climate_list <-list()
mis5e_ice_mask_list = list()
for (this_step in mis5e){
  this_step_climate <- climate_for_time_slice(this_step ,c("bio12"),
                                              dataset="Beyer2020", path_to_nc = path_to_example_nc)
  mis5e_climate_list[[as.character(this_step)]]<- this_step_climate
  
  this_ice_mask = get_ice_mask(this_step, dataset="Beyer2020", path_to_nc = path_to_example_nc)
  mis5e_ice_mask_list[[as.character(this_step)]]<- this_ice_mask
}
MIS5e = terra::app(sds(mis5e_climate_list), mean)
MIS5e.ice = terra::app(sds(mis5e_ice_mask_list), sum)


mis6_climate_list<-list()
mis6_ice_mask_list = list()
for (this_step in mis6){
  this_step_climate <- climate_for_time_slice(this_step ,c("bio12"),
                                              dataset="Krapp2021", path_to_nc = path_to_example_nc)
  mis6_climate_list[[as.character(this_step)]]<- this_step_climate
  
  this_ice_mask = get_ice_mask(this_step, dataset="Krapp2021", path_to_nc = path_to_example_nc)
  mis6_ice_mask_list[[as.character(this_step)]]<- this_ice_mask
}
MIS6 = terra::app(sds(mis6_climate_list), mean)
MIS6.ice = terra::app(sds(mis6_ice_mask_list), sum)


writeRaster(MIS3, filename = paste0(getwd(),"/cost-rasters/input-data/precip/MIS3-bio12.tif"), overwrite=T)
writeRaster(MIS4, filename = paste0(getwd(),"/cost-rasters/input-data/precip/MIS4-bio12.tif"), overwrite=T)
writeRaster(MIS5ad, filename = paste0(getwd(),"/cost-rasters/input-data/precip/MIS5ad-bio12.tif"), overwrite=T)
writeRaster(MIS5a, filename = paste0(getwd(),"/cost-rasters/input-data/precip/MIS5a-bio12.tif"), overwrite=T)
writeRaster(MIS5b, filename = paste0(getwd(),"/cost-rasters/input-data/precip/MIS5b-bio12.tif"), overwrite=T)
writeRaster(MIS5c, filename = paste0(getwd(),"/cost-rasters/input-data/precip/MIS5c-bio12.tif"), overwrite=T)
writeRaster(MIS5d, filename = paste0(getwd(),"/cost-rasters/input-data/precip/MIS5d-bio12.tif"), overwrite=T)
writeRaster(MIS5e, filename = paste0(getwd(),"/cost-rasters/input-data/precip/MIS5e-bio12.tif"), overwrite=T)
writeRaster(MIS6, filename = paste0(getwd(),"/cost-rasters/input-data/precip/MIS6-bio12.tif"), overwrite=T)

#ICE IS WRONG
# writeRaster(MIS3.ice, filename = paste0(getwd(),"/cost-rasters/input-data/ice/MIS3-ice.tif"), overwrite=T)
# writeRaster(MIS4.ice, filename = paste0(getwd(),"/cost-rasters/input-data/ice/MIS4-ice.tif"), overwrite=T)
# writeRaster(MIS5ad.ice, filename = paste0(getwd(),"/cost-rasters/input-data/ice/MIS5ad-ice.tif"), overwrite=T)
# writeRaster(MIS5e.ice, filename = paste0(getwd(),"/cost-rasters/input-data/ice/MIS5e-ice.tif"), overwrite=T)
# writeRaster(MIS6.ice, filename = paste0(getwd(),"/cost-rasters/input-data/ice/MIS6-ice.tif"), overwrite=T)
# 

