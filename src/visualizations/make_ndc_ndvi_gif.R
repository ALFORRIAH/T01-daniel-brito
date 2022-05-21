library(raster)
library(ggplot2)
library(rcartocolor)
library(glue)
library(lubridate)
library(gifski)

make_gif <- function(img_folder, nome_indice, limit_low, limit_high){
        
        img_list <- list.files(img_folder,
                                  pattern = ".*tif",
                                  full.names = TRUE)
        
        for(i in seq(length(img_list))){
                r <- raster(img_list[i])
                img_date <- substr(img_list[i], 29, 36)
                
                df <- as.data.frame(r, xy=T)
                names(df)[3] <- "raster"
                
                p <- ggplot(df, aes(x = x, y = y, fill= raster)) +
                        scale_fill_carto_c(palette ="Sunset", direction = -1,
                                           limits=c(limit_low, limit_high))
                        geom_tile() +
                        theme_minimal() +
                        labs(title = glue("{nome_indice} em {ymd(img_date)}"),
                             fill=nome_indice)
                
                png(paste0(img_folder, "/plots/", img_date, ".jpeg"))
                print(p)
                dev.off()
        }
        
        jpeg_files <- list.files(paste0(img_folder, "/plots/"), full.names = TRUE)
        
        animation <- gifski(jpeg_files,
               gif_file = paste0("reports/seminario/figures/", nome_indice, "_animation.gif"),
               width = 800,
               height = 600,
               delay = .3)
        
        return(animation)
}

make_gif(img_folder = "data/processed/gee-gif/ndvi",
         nome_indice = "NDVI",limit_low = -1, limit_high = 1)


make_gif(img_folder = "data/processed/gee-gif/ndci",
         nome_indice = "NDCI",limit_low = -.3, limit_high = 1)