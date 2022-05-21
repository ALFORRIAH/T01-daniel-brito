# create location map
# https://www.davidsolito.com/post/a-rayshader-base-tutortial-bonus-hawaii/

library(rayshader)
library(raster)
library(png)

# Get data
# https://www.youtube.com/watch?v=-7s03AzEvag
untar("data/external/opentopography/rasters_COP30.tar.gz",
      exdir = "data/external/opentopography")

elevation_raster <- raster("data/external/opentopography/output_COP30.tif")

elevation_matrix <- matrix(extract(elevation_raster,
                                    extent(elevation_raster),
                                    buffer = 1000),
                            nrow = ncol(elevation_raster),
                            ncol = nrow(elevation_raster))

my_z <- 1

elevation_texture_map <- readPNG("data/external/opentopography/guaiba_texture.png")
#elevation_amb_shade <- ambient_shade(elevation_matrix, zscale = my_z)
#elevation_ray_shade <- ray_shade(elevation_matrix, sunangle=35, z_scale = my_z)

elevation_matrix %>% 
  sphere_shade(sunangle = 35, texture = "desert", zscale = my_z) %>%
  add_overlay(elevation_texture_map, alphacolor = NULL,
              alphalayer=0.9) %>%  
  add_water(detect_water(elevation_matrix), color = "desert") %>% 
  plot_map()