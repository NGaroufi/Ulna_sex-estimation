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


## Examining the relationship of the variables with age separately for the ##
## two sexes with GAM models ##

# Loading the necessary libraries for the code
library(readr) # for importing the csv files
library(mgcv) # for the GAM functions
library(ggplot2) # for the plots

# Storing the sexes as strings in a list to call the csv files more easily
sex = list("Males", "Females")
point_col = list("darkslateblue", "firebrick4")

for (j in 1:2) # For-loop for the csv files of the two sexes

  {
    data_L <- read_csv(paste0("LeftSide - ", sex[j], ".csv"))
    data_R <- read_csv(paste0("RightSide - ", sex[j], ".csv"))

    mydata <- rbind(data_L, data_R) # Combine the two sides in a pooled dataframe


    variables = (names(mydata[5:52])) # Save the variable names
    
    # Initialize the model parameters of each for-loop
    sm = 0 # Summary of each model
    r = 0 # R^2 adjusted
    dev = 0 # Deviance explained
    chi = 0 # Chi-square value
    pv = 0 # P-value

    for (i in 1:length(variables)) # for each variable in the dataset
      {
        age = mydata[!is.na(mydata[,c(i+4)]),3] # Length of vector specific per var
                                                # +4 because of the demographics
        var = na.omit(mydata[ , c(i+4)]) # Omit the NAs of each variable
        data = as.data.frame(cbind(age, var)) # Df with specific length per var
        mod = gam(age ~ s(as.numeric(unlist(var))), data=data, method = "REML")
        sm = summary(mod)
        # Store the statistics mentioned above
        r[i] = sm$r.sq
        dev[i] = sm$dev.expl
        chi[i] = sm$chi.sq[[1]]
        pv[i] = sm$s.pv
        
        data[,2]=as.numeric(data[,2])
        
        png(paste0("./Figures/GAM_", i, "_", sex[j], ".png"), 
            width=1500, height=1500, res=300)
        print(ggplot(data = data, aes(age, data[,2])) + 
                geom_point(size=1, color=point_col[j]) + 
                geom_smooth(method = "gam", formula = y ~ s(x)) +
                ggtitle(variables[i]) +
                labs(x = "Age (years)", y =variables[i]) +
                theme(axis.title.x = element_text(size=8), 
                      axis.text.x = element_text(size=7), 
                      axis.title.y = element_text(size=8), 
                      axis.text.y = element_text(size=7)))
        dev.off()
        
        rm(age,var,data) # Clear age, variable, and data per for-loop
        
        }
    #Creating a matrix with the statistical metrics 
    statistics.table=cbind(r, dev, chi, round(pv,3))
    colnames(statistics.table)=c("R2_adj", "Dev. Explained", "F-stat", "p-value")
    rownames(statistics.table)=variables
    
    # Export in the corresponding csv file per sex
    write.csv(statistics.table, file=paste0("GAM_Statistics_", sex[j], ".csv"))
    
    # Clear the workspace except the "sex" object
    rm(list=ls()[!ls() %in% c("sex", "point_col")])
}