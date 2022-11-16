## Steps for creating IMPASSABLE ICE RASTERS

1.  pull ice estimate shapefile to QGIS

2.  pull DEM into QGIS

3.  clip ice shapefile using the DEM extent

4.  clip the DEM by mask layer using the clipped shape file

5.  fill NODATA cells of clipped DEM with unique no data value (i.e. 999999 used for this study)

6.  raster calculator on new raster such that where values are not the no data value set them to impassable value (i.e. -999999 used for this study)
