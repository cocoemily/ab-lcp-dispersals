#Determine flat and gentle surface costs
library(tidyverse)
library(raster)
library(rgdal)

MIS3 = raster("/Users/emilycoco/Desktop/ab-lcp-dispersals/cost-rasters/model-input-costs/LS-deserts-20/MIS3.asc")
plot(MIS3)

MIS3.vals = getValues(MIS3)
MIS3.pos.vals = MIS3.vals[which(MIS3.vals > -999999)]
summary(MIS3.pos.vals)
hist(MIS3.pos.vals)
quantile(MIS3.pos.vals)

MIS6.SK = raster("/Users/emilycoco/Desktop/ab-lcp-dispersals/cost-rasters/model-input-costs/LS-deserts-20/MIS6_smallKara.asc")
MIS6.BK = raster("/Users/emilycoco/Desktop/ab-lcp-dispersals/cost-rasters/model-input-costs/LS-deserts-20/MIS6_bigKara.asc")

MIS6s.vals = getValues(MIS6.SK)
MIS6s.pos.vals = MIS6s.vals[which(MIS6s.vals > -999999)]
summary(MIS6s.pos.vals)
quantile(MIS6s.pos.vals)

MIS6b.vals = getValues(MIS6.BK)
MIS6b.pos.vals = MIS6b.vals[which(MIS6b.vals > -999999)]
summary(MIS6b.pos.vals)
quantile(MIS6b.pos.vals)
