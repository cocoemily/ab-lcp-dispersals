library(tidyverse)
library(pastclim)
library(raster)
library(rgdal)
library(binford)

DEM = raster("cost-rasters/input-data/DEM_resample_PseudoMercator.tif")
sr = "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs"
projected_DEM = projectRaster(DEM, crs = sr)
extent(projected_DEM)


get_vars_for_dataset(dataset="Beyer2020")
get_vars_for_dataset(dataset="Krapp2021")
set_data_path(system.file("extdata/", package="pastclim"))
#bio12 = annual precipitation
download_dataset(dataset="Beyer2020", bio_variables = c("bio01", "bio12"))
download_dataset(dataset="Krapp2021", bio_variables = c("bio01", "bio12"))

mis3 = get_mis_time_steps(3, "Beyer2020")
mis4 = get_mis_time_steps(4, "Beyer2020")
mis5a = get_mis_time_steps("5a", "Beyer2020")
mis5b = get_mis_time_steps("5b", "Beyer2020")
mis5c = get_mis_time_steps("5c", "Beyer2020")
mis5d = get_mis_time_steps("5d", "Beyer2020")
mis5e = get_mis_time_steps("5e", "Beyer2020")
mis6 = get_mis_time_steps("6", "Krapp2021")

periods = list(
  "MIS3" = mis3, 
  "MIS4" = mis4, 
  "MIS5a" = mis5a, 
  "MIS5b" = mis5b, 
  "MIS5c" = mis5c, 
  "MIS5d" = mis5d, 
  "MIS5e" = mis5e
)
names(periods)

for(i in 1:length(periods)) {
  print(names(periods)[i])
  
  nomov = 0
  tcount = 0
  for(t in periods[[i]]) {
    DEM_temp = region_slice(
      time_bp = t, 
      bio_variables = c("bio01"), 
      dataset = "Beyer2020", 
      ext = terra::ext(projected_DEM)
    )
    #summary(DEM_temp)
    DEM_precip = region_slice(
      time_bp = t, 
      bio_variables = c("bio12"), 
      dataset = "Beyer2020", 
      ext = terra::ext(projected_DEM)
    )
    #summary(DEM_precip)
    
    temp_25 = quantile(as.vector(DEM_temp), 0.25, na.rm = T)
    temp_75 = quantile(as.vector(DEM_temp), 0.75, na.rm = T)
    
    precip_25 = quantile(as.vector(DEM_precip), 0.25, na.rm = T)
    precip_75 = quantile(as.vector(DEM_precip), 0.75, na.rm = T)
    
    #View(LRBkey)
    
    hg_data = binford::LRB %>% filter(sed <= 2) %>%
      filter(cmat >= temp_25 & cmat <= temp_75) %>%
      filter(crr >= precip_25 & crr <= precip_75)
    
    tcount = tcount + 1
    nomov = nomov + median(hg_data$nomov, na.rm = T)
    
  }
  print(nomov/tcount)
}

##across all time periods, the average number of moves per year for the climate
## conditions in the study area is approximately 15

