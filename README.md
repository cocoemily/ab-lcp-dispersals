# ab-lcp-dispersals

Agent-based least cost paths for dispersals and mobility in Central Asia

## Model Code
NetLogo files are available in the net-logo-code folder. This includes versions of the model that were run on the HPC with absolute file paths (designated with _hpc suffixes) and versions that are configured to run locally with relative file paths (designated with _local suffixes). 

#### Local model run set up
1) clone GitHub repository locally
2) download the ASCII cost raster files from [OSF](https://osf.io/rfqut)
3) put the entire ascii-files folder in ../cost-rasters/model-input-costs/
4) create an outputs folder and a v2-outputs folder in the parent ab-lcp-dispersals folder
5) open NetLogo file, set parameters, and run model

#### Producing output routes
1) run model 
2) create a routes folder in the parent ab-lcp-dispersals folder with this structure:
    ab-lcp-dispersals/
    |
    +--routes/
       |
       +--Caucasus-north/
       +--Caucasus-south/
       +--changing/

3) in the analysis-scripts folder, run path-output-analysis.R and V2_path-output-analysis.R
4) visualize paths on top of cost rasters in an external GIS environment