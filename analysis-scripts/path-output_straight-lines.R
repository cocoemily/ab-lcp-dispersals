library(tidyverse)
library(ggthemes)
library(RColorBrewer)
library(raster) 
library(reshape) 
library(here)
library(fractaldim)
library(trajr)
library(sf)

theme_set(theme_bw())

raster.file = here("cost-rasters", "model-input-costs", "ascii-files", "MIS3.asc")

shapefile = here("analysis-scripts", "data")
sz.small = read_sf(shapefile, layer="Russian-Altai-buffer_500km")

costRast = raster(raster.file, sep=",")
# Get the dimensions of the raster to collate the route data 
#crs = crs(costRast)
cost.x <- dim(costRast)[2]
cost.y <- dim(costRast)[1]

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
        #desert_cost = filename.split[6]
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
        #write_csv(ds, here("outputs", "test-resampled", paste0("original_path_route", l, ".csv")))
        
        ds.real = ds
        ds.real$x <- (ds$x * xres(costRast) * patch_res_km ) + xmin(costRast) + (xres(costRast) * patch_res_km / 2) # xmin extent of the original map 
        ds.real$y = (ds$y * yres(costRast) * patch_res_km ) + ymin(costRast) + (yres(costRast) * patch_res_km / 2) # ymin extent of the original map
        ds.real$value <- 1
        ds.real$step = rownames(ds.real)
        
        ##determine if path intersects with shapefile
        success.small = F
        r.sub <- rasterFromXYZ(ds.real[,1:3])
        crs(r.sub) = CRS("+init=epsg:3857")
        
        if(sum(unlist(raster::extract(r.sub, sz.small)), na.rm = T) > 0 ) {
          success.small = T
        }
        
        trj = TrajFromCoords(ds.real, xCol = "x", yCol = "y")
        
        #change in angles 
        angles = trj %>% mutate(angle = c(NA, TrajAngles(trj, compass.direction = 0))) %>%
          dplyr::select(x,y, step, angle) %>%
          mutate(lag = lag(angle), 
                 change = lag - angle)
        
        ##I think this is the correct way, but for some reason only identifying vertical and horizontal lines
        ##need to update calculate straight-lines script
        nc.steps = angles %>% filter(change == 0)
        nc.steps$step = as.numeric(nc.steps$step)
        nc.steps$sequence = c(NA, head(as.numeric(nc.steps$step), -1)) + 1 == as.numeric(nc.steps$step)

        nc.steps = nc.steps %>% mutate(ID = dplyr::case_when(step == lead(step) - 1 ~ 1, TRUE ~ 0)) %>%
          mutate(ID2 = dplyr::case_when(step == lag(step) + 1 ~ 2, TRUE ~ ID)) %>%
          mutate(position = ifelse(ID == 1 & ID2 == 1, "start",
                                   ifelse(ID == 0 & ID2 == 2, "end",
                                          ifelse(ID == 0 & ID2 == 0, "noseq", "middle")))) %>%
          filter(position != "noseq")
        seq = nc.steps[which(nc.steps$position == "start"),]
        seq$seq_num = seq_along(seq[,1])
        seq = seq %>% dplyr::select(step, seq_num)

        nc.steps = nc.steps %>% left_join(seq, by = "step") %>%
          fill(seq_num) %>% 
          dplyr::select(x, y, seq_num)
        
        rl = rle(nc.steps$seq_num)
        rl.df = bind_cols(length = rl$lengths, seq_num = rl$values)
        
        nc.steps = nc.steps %>% left_join(rl.df, by = "seq_num")
        final = nc.steps %>% filter(length >= 5)
        
        if(success.small == T) {
          # r.seq = rasterFromXYZ(final[,1:3])
          # crs(r.seq) = CRS("+init=epsg:3857")
          # writeRaster(r.seq, paste0(getwd(), "/routes/individual/RA_success/seq_rasters/seq_", start, "_", period, "_route", l,".asc"), overwrite = T)
        
          line = st_as_sf(x = final[,1:3], coords = c("x", "y"), crs = 3857)
          st_write(line, paste0("routes/individual/RA_success/seq_rasters/seq_", start, "_", period, "_route", l, "_line.shp"), delete_dsn = T)
          
        }
  
      }
    }
    
  }
}
