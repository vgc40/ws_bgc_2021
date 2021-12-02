rm(list=ls());graphics.off();

# Load libraries
library(ggplot2)
# Setting directories
home.dir = "C:/Users/gara009/OneDrive - PNNL/Documents/GitHub/ws_bgc_2021/" 
data.dir = paste0(home.dir,"Data/")
output.dir = paste0(home.dir,"Output/")

setwd(data.dir) # Set working directory

# Load data

data = read.csv("Figure_1.csv", skip = 1)

# Make the plots

ggplot(data, aes(x = Year, fill = Study_type)) + 
  coord_cartesian() +  geom_histogram(alpha = 0.5, bins = 50) + 
 geom_vline(aes(xintercept = 2007), colour="black") +
 labs(x = paste0("Year"), y = "Number of papers")+ theme_bw() + theme(text = element_text(size=12, color="black"),axis.text = element_text(color = "black"), axis.ticks = element_line(color = "black"),panel.background = element_blank(), panel.grid = element_blank()) + scale_fill_manual(values = c("blue","red"))

ggsave(paste0(output.dir,"Figure_1_",Sys.Date(),".pdf"))


