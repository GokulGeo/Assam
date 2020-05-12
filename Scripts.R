library(rayshader)
library(sp)
library(raster)
library(scales)
library(rgdal)

elevation <- raster("C:\\Users\\Lenovo\\Desktop\\Cover\\Additional data\\cdng46e_v3r1\\DEM_prj.tif")

height_shade(raster_to_matrix(elevation)) %>%
  plot_map()

#assam_r <- raster("C:\\Users\\Lenovo\\Desktop\\Cover\\Additional data\\l3g46e0605nov14\\L3-NG46E06-112-052-05Nov14-BAND4.tif")
#assam_g <- raster("C:\\Users\\Lenovo\\Desktop\\Cover\\Additional data\\l3g46e0605nov14\\L3-NG46E06-112-052-05Nov14-BAND3.tif")
#assam_b <- raster("C:\\Users\\Lenovo\\Desktop\\Cover\\Additional data\\l3g46e0605nov14\\L3-NG46E06-112-052-05Nov14-BAND2.tif")

assam_r <- raster("C:\\Users\\Lenovo\\Desktop\\Cover\\Additional data\\l3g46e0605nov14\\L3-NG46E06-112-052-05Nov14-BAND3.tif")
assam_g <- raster("C:\\Users\\Lenovo\\Desktop\\Cover\\Additional data\\l3g46e0605nov14\\L3-NG46E06-112-052-05Nov14-BAND2.tif")

assam_b <- raster("C:\\Users\\Lenovo\\Desktop\\Cover\\Additional data\\Landsat\\Clipped_landsat_band2.tif")
assam_b <- resample(assam_b,assam_r,method="ngb")
  
assam_rgb = raster::stack(assam_r, assam_g, assam_b)
plotRGB(assam_rgb,
        r = 1, g = 2, b = 3, 
        scale=800,
        stretch = "lin")

#check projection
raster::crs(elevation)
raster::crs(assam_rgb)

#Assam raster reproject
assam_rgb_utm = raster::projectRaster(assam_rgb, crs = crs(elevation), method = "bilinear")
crs(assam_rgb_utm)

names(assam_rgb_utm) = c("r","g","b")

assam_r_utm = rayshader::raster_to_matrix(assam_rgb_utm$r)
assam_g_utm = rayshader::raster_to_matrix(assam_rgb_utm$g)
assam_b_utm = rayshader::raster_to_matrix(assam_rgb_utm$b)

assamel_matrix = rayshader::raster_to_matrix(elevation)

assam_rgb_array = array(0,dim=c(nrow(assam_r_utm),ncol(assam_r_utm),3))

assam_rgb_array[,,1] = assam_r_utm/255 #Red layer
assam_rgb_array[,,2] = assam_g_utm/255 #Blue layer
assam_rgb_array[,,3] = assam_b_utm/255 #Green layer

assam_rgb_array = aperm(assam_rgb_array, c(2,1,3))

plot_map(zion_rgb_array)

assam_rgb_contrast = scales::rescale(assam_rgb_array,to=c(0,1))

plot_map(assam_rgb_contrast)

plot_3d(assam_rgb_contrast, assamel_matrix, windowsize = c(1100,900), zscale = 15, shadowdepth = -50,
        zoom=0.5, phi=25,theta=-25,fov=70, background = "#F2E1D0", shadowcolor = "#523E2B")
render_snapshot(title_text = "Assam, Subansiri river | Imagery: LISS 3 | DEM: 30m Cartodem",
                title_bar_color = "#1f5214", title_color = "white", title_bar_alpha = 1)

