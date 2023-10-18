library(raster) 
library(reshape) 
library(tidyverse)

costRast = raster(file.choose(), sep=",")
# Get the dimensions of the raster to collate the route data 
#crs = crs(costRast)
cost.x <- dim(costRast)[2]
cost.y <- dim(costRast)[1]

num.years = data.frame(id = double(0),
                       start = character(0),
                       period = character(0), 
                       water.level = character(0), 
                       num.steps = double(0), 
                       num.years.hg = double(0), 
                       #num.years.ne = double(0),
                       cut = logical(0))

my_dir = paste0(getwd(),"/outputs/Caucasus")
all_files = list.files(path = my_dir, all.files = TRUE, full.names = TRUE, pattern = "\\.csv$")
MIS5c = all_files[str_detect(all_files, "MIS5c")]

for(l in 1:length(MIS5c)){
  # Reformat the name of the files so that it can be used later 
  file.name = strsplit(MIS5c[l],"/")
  file.name = unlist(file.name)
  name.size = length(file.name)
  new.file = file.name[name.size]
  
  # Separate out the components of the file name 
  filename.split = strsplit(new.file,"_") 
  filename.split = unlist(filename.split)
  origin = gsub("\\)|\\(", "", filename.split[4]) # Origin of the run 
  #goal = gsub("\\)|\\(", "", filename.split[5])
  
  patch_res_km = as.numeric(filename.split[7])
  #desert_cost = filename.split[6]
  time_period = filename.split[5]
  
  # Import the data without headers
  ds <- read.table(paste(my_dir, "/", new.file,sep=""), fill = TRUE, skip = 19, stringsAsFactors = FALSE, sep = ",")
  
  num.years[nrow(num.years) + 1,] <- c(l, "Caucasus", 
                                       "MIS5c", 
                                       "none",
                                       nrow(ds), 
                                       floor(nrow(ds)/600), 
                                       #floor(nrow(ds)/2100), 
                                       FALSE)
  
  
  colnames(ds) <- c("x","y")
  ds$x <- as.integer(ds$x)
  ds$y <- as.integer(ds$y)
  
  ds$inwindow = ifelse(
    ds$x < cost.x & ds$y < cost.y & ds$x > 0 & ds$y > 0, TRUE, FALSE
  )
  outwindow = as.numeric(rownames(ds[which(ds$inwindow == F),])[1])
  
  if(!is.na(outwindow)) {
    ds = ds[c(1:outwindow),]
    num.years[nrow(num.years) + 1,] <- c(l, "Caucasus", 
                                         "MIS5c", 
                                         "none",
                                         nrow(ds), 
                                         floor(nrow(ds)/600), 
                                         #floor(nrow(ds)/2100), 
                                         TRUE)
  }
  
  ds = ds[,c(1,2)]
  
  # For each path, each cell is walked on only once 
  ds$value <- 1
  
  
  if(nrow(ds) > 1) {
    # Add this new path to the big dat dataset 
    routes <- ds
    # Then group by coordinates and sum up the number of times each cell is walked on
    route.group <- group_by(routes, x, y)
    b <- dplyr::summarize(route.group, value = sum(value)) 
    routes <- as.data.frame(b)
    
  }
  
  print("creating route") # Show progress
  dat <- routes
  # Change the name of the dat file because we will add new columns 
  colnames(dat) <- c("long","lat","value")
  # Ensure that the x and y columns are numeric 
  dat$x <- as.numeric(as.character(dat[,1])) 
  dat$y <- as.numeric(as.character(dat[,2]))
  # Change the order of the dat file to have x,y,value. 
  dat <- dat[,c(4,5,3)]
  # Transform the times walked on into a 0-1 value (divide by the max times walked) 
  dat$value <- dat$value / max(dat$value)
  # Create the final dataset and remove the dat dataset to avoid errors in subsequent loop iterations 
  dat.final <- dat
  #rm(dat)
  
  # Transform into a raster with the same coordinates as the imported DEM
  # if 1:1 ratio on DEM to patches
  #dat.final$x <- (dat.final$x * xres(costRast) ) + xmin(costRast) + (xres(costRast) / 2) # xmin extent of the original map 
  #dat.final$y <- (dat.final$y * yres(costRast) ) + ymin(costRast) + (yres(costRast) / 2) # ymin extent of the original map
  dat.final$x <- (dat.final$x * xres(costRast) * patch_res_km ) + xmin(costRast) + (xres(costRast) * patch_res_km / 2) # xmin extent of the original map 
  dat.final$y <- (dat.final$y * yres(costRast) * patch_res_km ) + ymin(costRast) + (yres(costRast) * patch_res_km / 2) # ymin extent of the original map
  
  # Create the raster
  r.sub <- rasterFromXYZ(dat.final)
  #crs(r.sub) = crs
  crs(r.sub) = CRS("+init=epsg:3857")
  #plot(r.sub)
  #plot(costRast)
  #writeRaster(r.sub, paste0(getwd(), "/routes/Caucasus_MIS5c_route", l, ".asc"), overwrite = T)
  
}  
