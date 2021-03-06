rm(list=ls());graphics.off();

# # #load libraries 
# install.packages("sf")
# install.packages("spData")
# install.packages("ggplot2")
# install.packages("ggspatial")
# install.packages('ggmap')

library(sf)
library(spData)
library(ggplot2)
library(ggspatial)
library(ggmap)
library(ggsn)
library(cowplot)



# Setting directories
home.dir = "C:/Users/gara009/OneDrive - PNNL/Documents/GitHub/ws_bgc_2021/" 
data.dir = paste0(home.dir,"Data/")
output.dir = paste0(home.dir,"Output/")

setwd(data.dir) # Set working directory

# Load data

#load in metadata
df = read.csv("DNRA_data.csv")

#create bounding box for world map
bbox <- c(left = -160, bottom = 15, right = 135, top = 70)

#plot the world map (with whondrs lat/long)
world_map = ggmap(get_stamenmap(bbox,maptype = "terrain-background", zoom = 5))+
  geom_point(data = df, aes(x = Longitude_decimal_degrees, y = Latitude_decimal_degrees, color = Field_or_Lab), 
             size = 1.5)+
  geom_point(data = df, aes(x = Longitude_decimal_degrees, y = Latitude_decimal_degrees), 
             pch= 21, size = 2, color = "black")+
  theme(axis.text = element_text(size = 10, colour = 1),
        panel.grid = element_line(colour = NA))+
  labs(x = "Longitude", y = "Latitude", color = "Legend")+ 
  theme(legend.position="bottom")
 
#add scale bar to world map
anchor_vector = c(x = -155, y = 22)
world_map_scale = world_map + 
                  ggsn::scalebar(x.min = -160, x.max = 135, 
                                 y.min = 15, y.max = 70, dist = 2000, dist_unit = "km",
                                 transform = TRUE, model = "WGS84",location = "bottomleft", 
                                 height = 0.05, st.bottom = TRUE, st.dist = 0.07, anchor = anchor_vector)

#add north arrow to world map
pdf(file = paste0(output.dir,"Map_world.pdf"))
north2(world_map_scale, 0.95, 0.65, symbol = 10)
dev.off()



#plot inset plot 
inset_plot <- ggplotGrob(
  ggmap(get_stamenmap(world_bbox,maptype = "terrain-background", zoom = 3))+
    geom_path(data = temp, aes(x = long, y = lat), size = 1, color = "red") +
    theme_bw() + 
    #theme(axis.title.x  = element_blank(),
     #     axis.title.y  = element_blank(),
      #    axis.line = element_line(colour = "black"),
       #   panel.grid = element_rect(colour = "black", fill=NA, size=5))+
  blank()
)

#plot us map with inset plot and add north arrow 
gg_inset_map1 = ggdraw() +
  draw_plot(us_map_scale) +
  draw_plot(inset_plot, x = 0.72, y = 0.72, width = 0.25, height = 0.3)
north2(gg_inset_map1, 0.09, 0.17, symbol = 10)
