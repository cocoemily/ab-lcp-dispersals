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
#sz.large = read_sf(shapefile, layer="Russian-Altai-buffer_1000km")

costRast = raster(raster.file, sep=",")
# Get the dimensions of the raster to collate the route data 
#crs = crs(costRast)
cost.x <- dim(costRast)[2]
cost.y <- dim(costRast)[1]

no.angle.change = data.frame()

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
        
        # #resample
        # ds.50 = slice(ds, seq(1, nrow(ds), 50))
        # #write_csv(ds.50, here("outputs", "test-resampled", paste0("resampled_path_50steps_route", l, ".csv")))
        # ds.100 = slice(ds, seq(1, nrow(ds), 100))
        # #write_csv(ds.100, here("outputs", "test-resampled", paste0("resampled_path_100steps_route", l, ".csv")))
        # ds.1000 = slice(ds, seq(1, nrow(ds), 1000))
        # #write_csv(ds.1000, here("outputs", "test-resampled", paste0("resampled_path_1000steps_route", l, ".csv")))
        
        ds.real = ds
        ds.real$x <- (ds$x * xres(costRast) * patch_res_km ) + xmin(costRast) + (xres(costRast) * patch_res_km / 2) # xmin extent of the original map 
        ds.real$y = (ds$y * yres(costRast) * patch_res_km ) + ymin(costRast) + (yres(costRast) * patch_res_km / 2) # ymin extent of the original map
        ds.real$value <- 1
        ds.real$step = rownames(ds.real)
        
        ##determine if path intersects with shapefile
        success.small = F
        #success.large = F
        r.sub <- rasterFromXYZ(ds.real)
        crs(r.sub) = CRS("+init=epsg:3857")
        
        if(sum(unlist(raster::extract(r.sub, sz.small)), na.rm = T) > 0 ) {
          success.small = T
        }
        # if(sum(unlist(raster::extract(r.sub, sz.large)), na.rm = T) > 0 ) {
        #   success.large = T
        # }
        
        trj = TrajFromCoords(ds.real, xCol = "x", yCol = "y")
        
        #change in angles 
        angles = trj %>% mutate(angle = c(NA, TrajAngles(trj, compass.direction = 0))) %>%
          dplyr::select(x,y, step, angle) %>%
          mutate(lag = lag(angle), 
                 change = lag - angle)
        
        lengths = cbind(as.data.frame(rle(angles$change)[["lengths"]]), 
                        as.data.frame(rle(angles$change)[["values"]]))
        colnames(lengths) = c("run.length", "angle.change")
        no.change.runs = lengths %>% filter(angle.change == 0)
        
        no.change.runs$success.500 = success.small
        #no.change.runs$success.1000 = success.large
        no.change.runs$start = start
        no.change.runs$period = period
        no.change.runs$route = l
        no.change.runs$steps = nrow(ds.real)
        no.change.runs$distance = TrajDistance(trj)
        
        no.angle.change = rbind(no.angle.change, no.change.runs)
      }
    }
    
  }
}

summary(no.angle.change$run.length)
sd(no.angle.change$run.length)
quantile(no.angle.change$run.length, probs = c(0.975))

na.runs.count = no.angle.change %>% filter(run.length >= 5) %>%
  group_by(start, period, route, distance, success.500) %>%
  summarize(number.na.runs = n()) %>%
  mutate(distance.km = distance/1000)

summary(na.runs.count$number.na.runs)
hist(na.runs.count$number.na.runs)

ggplot(na.runs.count) +
  geom_vline(aes(xintercept = 5654)) +
  geom_density(aes(x = number.na.runs))

nrow(na.runs.count %>% filter(number.na.runs <= 5654))
nrow(na.runs.count %>% filter(number.na.runs > 5654))
  

angle.plot = ggplot(na.runs.count) +
  geom_vline(aes(xintercept = 5654)) +
  geom_point(aes(x = number.na.runs, y = distance.km, color = success.500), size = 1) +
  labs(x = "straight line movements of 5+ steps", 
       y = "distance (km) between path start and end", 
       shape = "", color = "") +
  scale_color_brewer(palette = "Set2", labels = c("did not get to Russian Altai", "arrived within 500km of Russian Altai")) +
  scale_x_continuous(labels = scales::comma) +
  #scale_y_continuous(labels = scales::label_number(scale_cut = scales::cut_short_scale())) +
  theme(text = element_text(size = 8), legend.position = "bottom")
plot(angle.plot)

ggsave(filename = here("figures", "straight-line-movement.png"), plot = angle.plot,
       dpi = 300, height = 3, width = 4)
