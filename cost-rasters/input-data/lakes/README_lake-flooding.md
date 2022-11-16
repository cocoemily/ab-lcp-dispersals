## Lake Flooding Steps

1.  Reproject lake shapefile to be in same projection as DEM

2.  Use SAGA Clip raster with polygon to clip the DEM

3.  Use Raster Calculator to multiply all cells with values in the clipped raster by the level you want to flood to ( raster \>= -99999 (or another null value)) \* lake level )

    -   MAKE SURE TO SET EXTENT TO OVERALL DEM

4.  Use SAGA Lake Flood to create Surface layer

5.  Reclassify the surface raster so that cells with values equal to the desired lake level are coded as 1 and all others are 0
