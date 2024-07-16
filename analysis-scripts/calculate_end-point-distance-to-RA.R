library(raster) 
library(reshape) 
library(tidyverse)
library(here)
library(sf)
library(ggthemes)

theme_set(theme_bw())

raster.file = here("cost-rasters", "model-input-costs", "ascii-files", "MIS3.asc")

costRast = raster(raster.file, sep=",")
# Get the dimensions of the raster to collate the route data 
#crs = crs(costRast)
cost.x <- dim(costRast)[2]
cost.y <- dim(costRast)[1]

shapefile = here("analysis-scripts", "data")
ra.small = read_sf(shapefile, layer="Russian-Altai-buffer_500km")

distance.df = data.frame(start = character(0), 
                         period = character(0), 
                         route = double(0),
                         success = logical(0),
                         end.distance = double(0), 
                         close.distance = double(0))

for(start in c("Caucasus-north", "Caucasus-south")) {
  
  # Assign the folder in which all the individual simulation output files are located 
  my_dir = paste0(getwd(),"/outputs/", start)
  
  # Create a list of all the file names in the identified folder
  all_files = list.files(path = my_dir, all.files = TRUE, full.names = TRUE, pattern = "\\.csv$")
  MIS3 = all_files[str_detect(all_files, "MIS3")]
  MIS4s = all_files[str_detect(all_files, "MIS4-small-Caspian")]
  MIS4b = all_files[str_detect(all_files, "MIS4-big-Caspian")]
  MIS5a = all_files[str_detect(all_files, "MIS5a")]
  MIS5bl = all_files[str_detect(all_files, "MIS5b-low-water")]
  MIS5bh = all_files[str_detect(all_files, "MIS5b-high-water")]
  MIS5c = all_files[str_detect(all_files, "MIS5c")]
  MIS5dl = all_files[str_detect(all_files, "MIS5d-low-water")]
  MIS5dh = all_files[str_detect(all_files, "MIS5d-high-water")]
  MIS5e = all_files[str_detect(all_files, "MIS5e")]
  MIS6s = all_files[str_detect(all_files, "MIS6-small-Kara")]
  MIS6b = all_files[str_detect(all_files, "MIS6-big-Kara")]
  
  timeperiods = list("MIS3" = MIS3, 
                     "MIS4s" = MIS4s, "MIS4b" = MIS4b,
                     "MIS5a" = MIS5a, 
                     "MIS5bl" = MIS5bl, "MIS5bh" = MIS5bh,
                     "MIS5c" = MIS5c, 
                     "MIS5dl" = MIS5dl, "MIS5dh" = MIS5dh,
                     "MIS5e" = MIS5e,
                     "MIS6s" = MIS6s, "MIS6b" = MIS6b)
  names(timeperiods)
  
  for(t in 1:length(timeperiods)) {
    period = names(timeperiods)[[t]]
    print(period)
    files = timeperiods[[t]]
    files = files[str_detect(files, "LIST")]
    
    if(length(files) != 0) {
      list_size = length(files)
      
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
        
        patch_res_km = as.numeric(filename.split[7])
        time_period = filename.split[5]
        
        # Import the data without headers
        ds <- read.table(paste(my_dir, "/", new.file,sep=""), fill = TRUE, skip = 19, stringsAsFactors = FALSE, sep = ",")
        
        # Keep only the coordinates of the paths 
        #ds <- ds[,c(2,6)]
        # Change the names and reduce the floats coordinates to integers 
        colnames(ds) <- c("x","y")
        ds$x <- as.integer(ds$x)
        ds$y <- as.integer(ds$y)
        
        ds = ds[,c(1,2)]
        ds$step <- rownames(ds)
        
        dat.final <- ds
        #rm(dat)
        
        # Transform into a raster with the same coordinates as the imported DEM
        dat.final$x <- (ds$x * xres(costRast) * patch_res_km ) + xmin(costRast) + (xres(costRast) * patch_res_km / 2) # xmin extent of the original map 
        dat.final$y <- (ds$y * yres(costRast) * patch_res_km ) + ymin(costRast) + (yres(costRast) * patch_res_km / 2) # ymin extent of the original map
        
        dat.clean =  dat.final %>% filter(!is.na(x) & !is.na(y))
        line = st_as_sf(x = dat.clean, coords = c("x", "y"), crs = 3857)
        success = Reduce("|", st_within(line, ra.small, sparse = F))
        
        ##turn last point into something that can be compared to buffer zone
        last.point = dat.clean[nrow(dat.clean),]
        point = st_as_sf(x = last.point, coords = c("x", "y"), crs = 3857)
        
        ##calculate distance between point and buffer zone
        dist = as.numeric(st_distance(point, ra.small))
        
        #calculate distance between nearest points on line and buffer zone
        cdist = min(as.numeric(st_distance(st_centroid(ra.small), line)))
        
        ##add information to a table
        add.df = data.frame(start, period, l, success, dist, cdist)
        distance.df = rbind(distance.df, add.df)
      }
    }
    
  }
}


end.dist.dens = ggplot() +
  geom_density(data = distance.df %>% filter(success == FALSE), 
               aes(x = dist/1000, fill = start),color = NA, alpha = 0.5) +
  geom_vline(data = distance.df %>% filter(success == TRUE), 
             aes(xintercept = dist/1000)) +
  scale_fill_tableau(name = "starting position", labels = c("northern Caucasus", "southern Caucasus")) +
  scale_x_continuous(name = "distance (km) from path end point to Russian Altai") +
  theme(text = element_text(size = 8), legend.position = "bottom")

ggsave(filename = here("figures", "path-end-point_distance-to-RA.png"), 
       plot = end.dist.dens, dpi = 300, 
       width = 4, height = 3)



