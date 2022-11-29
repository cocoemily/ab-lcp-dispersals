#Determine flat and gentle surface costs
library(tidyverse)
library(raster)
library(rgdal)

### LS cost with desert increased by 20%
my_dir = paste0(getwd(),"/cost-rasters/model-input-costs/LS-deserts-20")
files = list.files(path = my_dir, all.files = TRUE, full.names = TRUE, pattern = "\\.asc$")

pos.values = c()
for(f in files) {
  raster = raster(f)
  values = getValues(raster)
  positive = values[which(values > -999999)]
  pos.values = c(pos.values, positive)
}

quantile(pos.values)

### LS cost with desert increased by 10%
my_dir = paste0(getwd(),"/cost-rasters/model-input-costs/LS-deserts-10")
files = list.files(path = my_dir, all.files = TRUE, full.names = TRUE, pattern = "\\.asc$")

pos.values = c()
for(f in files) {
  raster = raster(f)
  values = getValues(raster)
  positive = values[which(values > -999999)]
  pos.values = c(pos.values, positive)
}

quantile(pos.values)
