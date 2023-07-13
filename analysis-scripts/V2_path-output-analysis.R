library(raster) 
library(reshape) 
library(tidyverse)

costRast = raster(file.choose(), sep=",")
# Get the dimensions of the raster to collate the route data 
#crs = crs(costRast)
cost.x <- dim(costRast)[2]
cost.y <- dim(costRast)[1]


# Assign the folder in which all the individual simulation output files are located 
# my_dir = paste0(getwd(),"/outputs/Azov")
# my_dir = paste0(getwd(),"/outputs/Caucasus")
my_dir = paste0(getwd(),"/test-outputs")

# Create a list of all the file names in the identified folder
all_files = list.files(path = my_dir, all.files = TRUE, full.names = TRUE, pattern = "\\.csv$")
low = all_files[str_detect(all_files, "low")]
high = all_files[str_detect(all_files, "high")]

timeperiods = list("low-water" = low, 
                   "high-water" = high)
names(timeperiods)

for(t in 1:length(timeperiods)) {
  period = names(timeperiods)[[t]]
  files = timeperiods[[t]]
  files = files[str_detect(files, "LIST")]
  
  if(length(files) != 0) {
    list_size = length(files)
    
    # Create a temporary dataframe that will take on the collated coordinate and popularity values 
    dat.final = data.frame(x=double(0), y=double(0), period=character(0), value=double(0))
    
    # Create a temporary dataframe that will help create raster 
    routes = data.frame(x=double(0), y=double(0), period=character(0), value=double(0))
    
    # Iterate over all the files located in the given folder 
    for(l in 1:list_size[1]){
      # Reformat the name of the files so that it can be used later 
      file.name = strsplit(files[l],"/")
      file.name = unlist(file.name)
      name.size = length(file.name)
      new.file = file.name[name.size]
      
      # Separate out the components of the file name 
      filename.split = strsplit(new.file,"_") 
      filename.split = unlist(filename.split)
      origin = gsub("\\)|\\(", "", filename.split[4]) # Origin of the run 
      #goal = gsub("\\)|\\(", "", filename.split[5])
      
      patch_res_km = as.numeric(filename.split[8])
      #desert_cost = filename.split[6]
      time_period = filename.split[5]
      
      # Import the data without headers
      ds <- read.table(paste(my_dir, "/", new.file,sep=""), fill = TRUE, skip = 19, stringsAsFactors = FALSE, sep = ",")
      # Keep only the coordinates of the paths 
      #ds <- ds[,c(2,6)]
      # Change the names and reduce the floats coordinates to integers 
      colnames(ds) <- c("x","y", "period")
      ds$x <- as.integer(ds$x)
      ds$y <- as.integer(ds$y)
      
      # For each path, each cell is walked on only once 
      ds$value <- 1
      # If this is not an empty dataset 
      if(nrow(ds) > 1) {
        # Add this new path to the big dat dataset 
        routes <- rbind(routes,ds)
        # Then group by coordinates and sum up the number of times each cell is walked on
        route.group <- group_by(routes, x, y, period)
        b <- dplyr::summarize(route.group, value = sum(value)) 
        routes <- as.data.frame(b)
        # Assign the dataset to the global environment so it can be used outside the loop.
        assign('routes',routes, envir = .GlobalEnv) 
        #assign('desert_cost', desert_cost, envir = .GlobalEnv)
      }
    }
    
    ################################################ ## USING ROUTES TO IDENTIFY MOST POPULAR PATH ## ################################################ 
    print("creating route") # Show progress
    dat <- routes
    # Change the name of the dat file because we will add new columns 
    colnames(dat) <- c("long","lat", "period","value")
    # Ensure that the x and y columns are numeric 
    dat$x <- as.numeric(as.character(dat[,1])) 
    dat$y <- as.numeric(as.character(dat[,2]))
    # Change the order of the dat file to have x,y,value. 
    dat <- dat[,c(5,6,3,4)]
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
    
    for(p in unique(dat.final$period)) { 
      dat.period = dat.final[which(dat.final$period == p),c(1,2,4)]
      
      # Create the raster
      r.sub <- rasterFromXYZ(dat.period)
      #crs(r.sub) = crs
      crs(r.sub) = CRS("+init=epsg:3857")
      #plot(r.sub)
      #plot(costRast)
      writeRaster(r.sub, paste0(getwd(), "/routes/", period, "_", p, "_routes.asc"), overwrite = T)
    }
    
  }
}

