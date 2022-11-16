#assign river crossing weights

library(tidyverse)
library(raster)
library(rgdal)
library(sp)
library(fitdistrplus)
library(MASS)

rivers = readOGR(dsn = "/Users/emilycoco/Desktop/ab-lcp-dispersals/cost-rasters/input-data/other-water/HydroRIVERS_v10_shp", 
                 layer = "crossable-rivers2")

hist(rivers@data$river_W)
descdist(rivers@data$river_W, discrete = F)

fit = fitdist(rivers@data$river_W, "gamma")
plot(fit, las = 1)

x = seq(1.01, 1.2, by =0.01)
y = dgamma(x, shape = fit$estimate[1], rate = fit$estimate[2])
plot(x,y)
