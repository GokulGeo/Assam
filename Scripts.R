library(rayshader)
library(sp)
library(raster)
library(scales)
library(rgdal)

elevation <- raster("C:\\Users\\Lenovo\\Desktop\\Cover\\Additional data\\cdng46e_v3r1\\DEM.tif")

height_shade(raster_to_matrix(elevation)) %>%
  plot_map()
assam_r <- raster("C:\\Users\\Lenovo\\Desktop\\Cover\\Additional data\\l3g46e0605nov14\\L3-NG46E06-112-052-05Nov14-BAND4.tif")
assam_g <- raster("C:\\Users\\Lenovo\\Desktop\\Cover\\Additional data\\l3g46e0605nov14\\L3-NG46E06-112-052-05Nov14-BAND3.tif")
assam_b <- raster("C:\\Users\\Lenovo\\Desktop\\Cover\\Additional data\\l3g46e0605nov14\\L3-NG46E06-112-052-05Nov14-BAND2.tif")

assam_rgb = raster::stack(assam_r, assam_g, assam_b)
plotRGB(assam_rgb,
        r = 1, g = 2, b = 3, 
        scale=800,
        stretch = "lin")

