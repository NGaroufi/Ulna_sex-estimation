## Copyright (C) 2023 Nefeli Garoufi <nefeligar@biol.uoa.gr>
##
## This program is free software; you can redistribute it and/or modify it under
## the terms of the GNU General Public License as published by the Free Software
## Foundation; either version 3 of the License, or (at your option) any later
## version.
##
## This program is distributed in the hope that it will be useful, but WITHOUT
## ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
## FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
## details.
##
## You should have received a copy of the GNU General Public License along with
## this program; if not, see <http://www.gnu.org/licenses/>.

library(png)
library(grid)
library(gridExtra)

# Accuracy at 0.65
plot1 <- readPNG('./Figures/JustCV/Accuray_Graph_(0.65)_1.png')
plot2 <- readPNG('./Figures/JustCV/Accuray_Graph_(0.65)_2.png')
plot3 <- readPNG('./Figures/JustCV/Accuray_Graph_(0.65)_3.png')
plot4 <- readPNG('./Figures/JustCV/Accuray_Graph_(0.65)_4.png')

png(file = paste0("./Figures/JustCV/Accuracy_Graph_(0.65).png"),
    width=2100, height=1500, res=500)
grid.arrange(rasterGrob(plot1),rasterGrob(plot2),rasterGrob(plot3),
             rasterGrob(plot4),ncol=2, nrow=2,
             top = textGrob("Model Accuracy (65% training, 35% testing)",
                            gp=gpar(fontsize=5,font=2)))
dev.off()

# Accuracy at 0.60

plot1 <- readPNG('./Figures/JustCV/Accuray_Graph_(0.6)_1.png')
plot2 <- readPNG('./Figures/JustCV/Accuray_Graph_(0.6)_2.png')
plot3 <- readPNG('./Figures/JustCV/Accuray_Graph_(0.6)_3.png')
plot4 <- readPNG('./Figures/JustCV/Accuray_Graph_(0.6)_4.png')

png(file = paste0("./Figures/JustCV/Accuracy_Graph_(0.60).png"),
    width=2100, height=1500, res=500)
grid.arrange(rasterGrob(plot1),rasterGrob(plot2),rasterGrob(plot3),
             rasterGrob(plot4),ncol=2, nrow=2,
             top = textGrob("Model Accuracy (60% training, 40% testing)",
                            gp=gpar(fontsize=5,font=2)))
dev.off()

# Accuracy at 0.70

plot1 <- readPNG('./Figures/JustCV/Accuray_Graph_(0.7)_1.png')
plot2 <- readPNG('./Figures/JustCV/Accuray_Graph_(0.7)_2.png')
plot3 <- readPNG('./Figures/JustCV/Accuray_Graph_(0.7)_3.png')
plot4 <- readPNG('./Figures/JustCV/Accuray_Graph_(0.7)_4.png')

png(file = paste0("./Figures/JustCV/Accuracy_Graph_(0.70).png"),
    width=2100, height=1500, res=500)
grid.arrange(rasterGrob(plot1),rasterGrob(plot2),rasterGrob(plot3),
             rasterGrob(plot4),ncol=2, nrow=2,
             top = textGrob("Model Accuracy (70% training, 30% testing)",
                            gp=gpar(fontsize=5,font=2)))
dev.off()


## GAM arrangements ##

#Males
plot1 <- readPNG('./Figures/GAM_1_Males.png')
plot2 <- readPNG('./Figures/GAM_2_Males.png')
plot3 <- readPNG('./Figures/GAM_3_Males.png')
plot4 <- readPNG('./Figures/GAM_4_Males.png')
plot5 <- readPNG('./Figures/GAM_5_Males.png')
plot6 <- readPNG('./Figures/GAM_6_Males.png')
plot7 <- readPNG('./Figures/GAM_7_Males.png')
plot8 <- readPNG('./Figures/GAM_8_Males.png')
plot9 <- readPNG('./Figures/GAM_9_Males.png')
plot10 <- readPNG('./Figures/GAM_10_Males.png')
plot11 <- readPNG('./Figures/GAM_11_Males.png')
plot12 <- readPNG('./Figures/GAM_12_Males.png')
plot13 <- readPNG('./Figures/GAM_13_Males.png')
plot14 <- readPNG('./Figures/GAM_14_Males.png')
plot15 <- readPNG('./Figures/GAM_15_Males.png')
plot16 <- readPNG('./Figures/GAM_16_Males.png')
plot17 <- readPNG('./Figures/GAM_17_Males.png')
plot18 <- readPNG('./Figures/GAM_18_Males.png')
plot19 <- readPNG('./Figures/GAM_19_Males.png')
plot20 <- readPNG('./Figures/GAM_20_Males.png')
plot21 <- readPNG('./Figures/GAM_21_Males.png')
plot22 <- readPNG('./Figures/GAM_22_Males.png')
plot23 <- readPNG('./Figures/GAM_23_Males.png')
plot24 <- readPNG('./Figures/GAM_24_Males.png')

rl <- list(plot1, plot2, plot3, plot4, plot5, plot6, plot7, plot8, plot9, plot10,
           plot11, plot12, plot13, plot14, plot15, plot16, plot17, plot18, plot19,
           plot20, plot21, plot22, plot23, plot24)
gl <- lapply(rl, grid::rasterGrob)


png(file = paste0("./Figures/GAM_Males(1).png"),
    width=2100, height=1500, res=500)
grid.arrange(grobs=gl,
             ncol=6, nrow=4, as.table = FALSE,
             top = textGrob("GAM models - Males (Part 1)",
                            gp=gpar(fontsize=5,font=2)))
dev.off()

#Males _ B
plot1 <- readPNG('./Figures/GAM_25_Males.png')
plot2 <- readPNG('./Figures/GAM_26_Males.png')
plot3 <- readPNG('./Figures/GAM_27_Males.png')
plot4 <- readPNG('./Figures/GAM_28_Males.png')
plot5 <- readPNG('./Figures/GAM_29_Males.png')
plot6 <- readPNG('./Figures/GAM_30_Males.png')
plot7 <- readPNG('./Figures/GAM_31_Males.png')
plot8 <- readPNG('./Figures/GAM_32_Males.png')
plot9 <- readPNG('./Figures/GAM_33_Males.png')
plot10 <- readPNG('./Figures/GAM_34_Males.png')
plot11 <- readPNG('./Figures/GAM_35_Males.png')
plot12 <- readPNG('./Figures/GAM_36_Males.png')
plot13 <- readPNG('./Figures/GAM_37_Males.png')
plot14 <- readPNG('./Figures/GAM_38_Males.png')
plot15 <- readPNG('./Figures/GAM_39_Males.png')
plot16 <- readPNG('./Figures/GAM_40_Males.png')
plot17 <- readPNG('./Figures/GAM_41_Males.png')
plot18 <- readPNG('./Figures/GAM_42_Males.png')
plot19 <- readPNG('./Figures/GAM_43_Males.png')
plot20 <- readPNG('./Figures/GAM_44_Males.png')
plot21 <- readPNG('./Figures/GAM_45_Males.png')
plot22 <- readPNG('./Figures/GAM_46_Males.png')
plot23 <- readPNG('./Figures/GAM_47_Males.png')
plot24 <- readPNG('./Figures/GAM_48_Males.png')

rl <- list(plot1, plot2, plot3, plot4, plot5, plot6, plot7, plot8, plot9, plot10,
           plot11, plot12, plot13, plot14, plot15, plot16, plot17, plot18, plot19,
           plot20, plot21, plot22, plot23, plot24)
gl <- lapply(rl, grid::rasterGrob)


png(file = paste0("./Figures/GAM_Males(2).png"),
    width=2100, height=1500, res=500)
grid.arrange(grobs=gl,
             ncol=6, nrow=4, as.table = FALSE,
             top = textGrob("GAM models - Males (Part 2)",
                            gp=gpar(fontsize=5,font=2)))
dev.off()

#Females
plot1 <- readPNG('./Figures/GAM_1_Females.png')
plot2 <- readPNG('./Figures/GAM_2_Females.png')
plot3 <- readPNG('./Figures/GAM_3_Females.png')
plot4 <- readPNG('./Figures/GAM_4_Females.png')
plot5 <- readPNG('./Figures/GAM_5_Females.png')
plot6 <- readPNG('./Figures/GAM_6_Females.png')
plot7 <- readPNG('./Figures/GAM_7_Females.png')
plot8 <- readPNG('./Figures/GAM_8_Females.png')
plot9 <- readPNG('./Figures/GAM_9_Females.png')
plot10 <- readPNG('./Figures/GAM_10_Females.png')
plot11 <- readPNG('./Figures/GAM_11_Females.png')
plot12 <- readPNG('./Figures/GAM_12_Females.png')
plot13 <- readPNG('./Figures/GAM_13_Females.png')
plot14 <- readPNG('./Figures/GAM_14_Females.png')
plot15 <- readPNG('./Figures/GAM_15_Females.png')
plot16 <- readPNG('./Figures/GAM_16_Females.png')
plot17 <- readPNG('./Figures/GAM_17_Females.png')
plot18 <- readPNG('./Figures/GAM_18_Females.png')
plot19 <- readPNG('./Figures/GAM_19_Females.png')
plot20 <- readPNG('./Figures/GAM_20_Females.png')
plot21 <- readPNG('./Figures/GAM_21_Females.png')
plot22 <- readPNG('./Figures/GAM_22_Females.png')
plot23 <- readPNG('./Figures/GAM_23_Females.png')
plot24 <- readPNG('./Figures/GAM_24_Females.png')

rl <- list(plot1, plot2, plot3, plot4, plot5, plot6, plot7, plot8, plot9, plot10,
           plot11, plot12, plot13, plot14, plot15, plot16, plot17, plot18, plot19,
           plot20, plot21, plot22, plot23, plot24)
gl <- lapply(rl, grid::rasterGrob)


png(file = paste0("./Figures/GAM_Females(1).png"),
    width=2100, height=1500, res=500)
grid.arrange(grobs=gl,
             ncol=6, nrow=4, as.table = FALSE,
             top = textGrob("GAM models - Females (Part 1)",
                            gp=gpar(fontsize=5,font=2)))
dev.off()

#Females _ B
plot1 <- readPNG('./Figures/GAM_25_Females.png')
plot2 <- readPNG('./Figures/GAM_26_Females.png')
plot3 <- readPNG('./Figures/GAM_27_Females.png')
plot4 <- readPNG('./Figures/GAM_28_Females.png')
plot5 <- readPNG('./Figures/GAM_29_Females.png')
plot6 <- readPNG('./Figures/GAM_30_Females.png')
plot7 <- readPNG('./Figures/GAM_31_Females.png')
plot8 <- readPNG('./Figures/GAM_32_Females.png')
plot9 <- readPNG('./Figures/GAM_33_Females.png')
plot10 <- readPNG('./Figures/GAM_34_Females.png')
plot11 <- readPNG('./Figures/GAM_35_Females.png')
plot12 <- readPNG('./Figures/GAM_36_Females.png')
plot13 <- readPNG('./Figures/GAM_37_Females.png')
plot14 <- readPNG('./Figures/GAM_38_Females.png')
plot15 <- readPNG('./Figures/GAM_39_Females.png')
plot16 <- readPNG('./Figures/GAM_40_Females.png')
plot17 <- readPNG('./Figures/GAM_41_Females.png')
plot18 <- readPNG('./Figures/GAM_42_Females.png')
plot19 <- readPNG('./Figures/GAM_43_Females.png')
plot20 <- readPNG('./Figures/GAM_44_Females.png')
plot21 <- readPNG('./Figures/GAM_45_Females.png')
plot22 <- readPNG('./Figures/GAM_46_Females.png')
plot23 <- readPNG('./Figures/GAM_47_Females.png')
plot24 <- readPNG('./Figures/GAM_48_Females.png')

rl <- list(plot1, plot2, plot3, plot4, plot5, plot6, plot7, plot8, plot9, plot10,
           plot11, plot12, plot13, plot14, plot15, plot16, plot17, plot18, plot19,
           plot20, plot21, plot22, plot23, plot24)
gl <- lapply(rl, grid::rasterGrob)


png(file = paste0("./Figures/GAM_Females(2).png"),
    width=2100, height=1500, res=500)
grid.arrange(grobs=gl,
             ncol=6, nrow=4, as.table = FALSE,
             top = textGrob("GAM models - Females (Part 2)",
                            gp=gpar(fontsize=5,font=2)))
dev.off()




