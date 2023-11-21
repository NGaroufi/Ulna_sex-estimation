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


## RBF SVM model training and plotting code ##

# Loading the necessary libraries for the code
library(readr) # for importing the csv files
library(caret) # for the partition of the dataset
library(e1071) # for the svm training
library(ggplot2) # for the plots

# Importing the Pooled Sample dataset (left and right measurements)
data = read.csv("Pooled_sample.csv")
# Setting the variable "sex" as a factor
as.factor(data$sex)

## Eight different combinations were examined - all variables (1), the Max Distance
## and angle-65_80 with all the different cross-sectional variables (2-6), all the 
## variables that had an effect size over 2.500 at either anatomical side (7), and
## those with an es over 2 at both sides (8). 

# Save the variable names as a vector for easier indexing
variables = (names(data[2:50]))
csall = variables # Combination 1
sd = variables[c(1:6, 8:9, 11:12, 14:18, 20:21, 23:24, 26:27, 29:30, 32:36, 38:42,
                 44:45, 47:48)] #Combination 2
sd_ba = variables[c(1:6, 8:9, 11:12, 14:18, 20:21, 23:24, 26:27, 29:30, 32:34, 36, 38:42,
                    44:45, 47:48)] #Combination 3
age = variables[c(1,19,22,26,28,31,37,41,43:49 )] # Combination 4

# Store the different combinations in a list
idx = list(csall, sd, sd_ba, age)
partition_vector = c(0.6, 0.65, 0.7) #examine different partitions
prt = 0 # Initiliazing the partition counter for the for-loop

for (prt in partition_vector)
{ # In creating the folds we specify the dependent variable and 
  # the number of folds. We also set a seed for reproducibility.
  # We want the partition to be made based on sex (stratification), 20 different
  # times, with the training sample being the 70% of the original sample
  set.seed(1997)
  partition = createDataPartition(data$sex, times = 20, p=prt)

  # Initializing the counters and vectors that will be used in the for-loops
  k = 0 #Counter for the different variable combinations 
  m = 0 #Counter for the different models (different gamma and cost parameters)
  y = 0 #Vector for the accuracy of the model on the testing dataset (20-folds)
  og = 0 #Vector for the accuracy of the model on the training dataset (20-folds)
  
  for (var in idx) #For-loop for the examination of every stored combination
    { c=c(0.1, 0.5, 1, 2, 3.5, 5, 7.5, 10) #Cost values
      g=c(0.5/(length(var)-1), 1/(length(var)-1), 1.5/(length(var)-1),
          2/(length(var)-1)) #Gamma values
  
      res_y=matrix(data=NA, nrow=1, ncol=3, byrow=TRUE) #Matrix for storing the cv results
      res_og=matrix(data=NA, nrow=1, ncol=3, byrow=TRUE) #Matrix for storing the og results
  
      k = k+1
      for (j in g) #For-loop for the different gamma values
        {
          for (i in c) #For-loop for the cost values
            { m = m+1
              # In the cv we are going to apply a created function to our 20 folds
              cv = lapply(partition, function(x) { # start of function
                # Next we separate the dataset to training and test
                training = data[x, c(var)] # Keeping only the rows in the fold and
                                          # the correct variables
                training = na.omit(training) # Omitting the NA values
                #print(nrow(training))
                test = data[-x, c(var)] # Keeping the rows NOT in the fold and
                                        # the correct variables
                test = na.omit(test) # Omitting the NA values
                #print(nrow(test))
                # Apply the RBF SVM classifier on the training sample and store the model
                set.seed(1997) # Set a seed here as well. Important.
                classifier = svm(formula = sex ~ ., # Utilizing all the vars / combo
                          data = training,
                          type = 'C-classification',
                          kernel = 'radial',
                          cost = i, # Cost value
                          gamma = j, # Gamma value
                          scale = TRUE, # Scaling the variables
                          probability = TRUE) # Compute the probability of each choice
                # Calculate the predictions and confusion matrices for the
                # testing and training (original) datasets with the model
                y_pred = predict(classifier, newdata = test[-1], probability = TRUE)
                t_pred = predict(classifier, newdata = training[-1])
                #print(length(y_pred))
                sex_y = test[,1] # Same vector length with y_pred
                sex_t = training[,1] # Same vector length with t_pred
                #print(length(sex))
                ## Construct the two confusion matrices and calculate the accuracy
                ## of the classifier
                # Confusion matrix and accuracy for the testing dataset
                cm_y = table(sex_y, y_pred)
                accuracy = (cm_y[1,1] + cm_y[2,2]) / (cm_y[1,1] + cm_y[2,2] + 
                                                      cm_y[1,2] + cm_y[2,1])
                # Confusion matrix and accuracy for the training dataset
                cm_t = table(sex_t, t_pred)
                original = (cm_t[1,1] + cm_t[2,2]) / (cm_t[1,1] + cm_t[2,2] + 
                                                      cm_t[1,2] + cm_t[2,1])
                # Save the classifier as an rds object with the specific parameters 
                saveRDS(classifier, paste0("./SVM_models/Model_(", prt, ")_", m, ".rds"))
                return(list(accuracy, original)) # Store the two calculated accuracies
              })
            for (s in 1:20) # For-loop to store accuracies of each 20 resamplings
            {
              y[s] = cv[[s]][1] # Accuracy for the testing dataset
              og[s] = cv[[s]][2] # Accuracy for the trained dataset
            }
          # Store the gamma, cost, and accuracy values of each model
          res_y = rbind(res_y, c(j, i, mean(as.numeric(y)))) # Testing dataset
          res_og = rbind(res_og, c(j, i, mean(as.numeric(og)))) # Original dataset
        }
      }
      # Omit the first row (NAs) from the two matrices and set column names
      res_y=na.omit(res_y)
      res_og=na.omit(res_og)
      colnames(res_y) = c("Gamma", "Cost", "Mean Accuracy")
      colnames(res_og) = c("Gamma", "Cost", "Mean Accuracy")
      # Exporting the results to the corresponding csv file for each var combo
      write.csv(res_y, paste0("./SVM_results/SVM_CV_(", prt, ")_", k, ".csv"))
      write.csv(res_og, paste0("./SVM_results/SVM_OG_(", prt,")_", k, ".csv"))
      print(k)
    }
    print(prt)
    remove(partition)
  }

rm(list = ls()) # Clear the workspace

## Plotting the accuracy ~ the cost and gamma values for each variable
## combination separately

# List of graph titles per variablecombination
gr_titles = list("All variables", 
                 "Sexually dimorphic variables",
                 "Sexually dimorphic variables (corrected for BA)",
                 "Not ss correlation with age")
partition_vector = c(0.6, 0.65, 0.7)

# Plotting both accuracies on the same plot
for (j in partition_vector)
  {
  for (i in 1:4) # For each variable combination
    {
      data = read.csv(paste0("./SVM_results/SVM_CV_(", j, ")_", i, ".csv")) #Testing results
      data_og = read.csv(paste0("./SVM_results/SVM_OG_(", j, ")_", i, ".csv")) #OG results
  
      png(file = paste0("./Figures/Accuray_Graph_(", j, ")_", i, ".png"),
          width=600, height=350) # png properties
      # Facet plot for original (blue, triangles) and testing (green, circles) accuracy
      # with gamma values on the x axis, with the % Mean Accuracy on the y axis 
      # and the facets ~ cost value 
      print(ggplot() +
        geom_point(data = data_og, aes(x = Gamma*100, y = Mean.Accuracy*100, 
                                     color="Original", 
                                     shape="Original"), size = 2.5) +
        geom_point(data = data, aes(x = Gamma*100, y = Mean.Accuracy*100, 
                                  color="Cross-validated", 
                                  shape="Cross-validated"), size = 2.5) +
        scale_color_manual(name = "Dataset",
                         labels = c("Cross-validated","Original"),
                         values = c("Original" ="deepskyblue2", 
                                    "Cross-validated"= "chartreuse3"))+
        scale_shape_manual(name = "Dataset", 
                         labels = c("Cross-validated","Original"),
                         values = c("Original" = 17, "Cross-validated" = 19)) +
        facet_grid(~ Cost, labeller = label_both) +  
        theme_bw() + 
        labs(x = bquote('Gamma '~(10^-2)), y ="Mean Accuracy (%)", color="Dataset", shape="Dataset") + 
        ggtitle(gr_titles[[i]]) +
        theme(strip.background  = element_rect(fill="coral3")))
      dev.off()
    }
  }

# Plotting only CV accuracy
for (j in partition_vector)
  {
    for (i in 1:4) # For each variable combination
    {
      data = read.csv(paste0("./SVM_results/SVM_CV_(", j, ")_", i, ".csv")) # Testing accuracy
  
      png(file = paste0("./Figures/JustCV/Accuray_Graph_(", j, ")_", i, ".png"),
          width=600, height=350)
      # Facet plot for testing accuracy
      # with gamma values on the x axis, with the % Mean Accuracy on the y axis 
      # and the facets ~ cost value 
      print(ggplot(data = data, aes(x = Gamma*100, y = Mean.Accuracy*100)) +
              geom_point(color = "slateblue4", shape=17, size = 2.5) +
              ylim(min(data$Mean.Accuracy*100)-0.5, max(data$Mean.Accuracy*100)+0.5)+
              facet_grid(~ Cost, labeller = label_both) +  
              theme_bw() +
              labs(x = bquote('Gamma '~(10^-2)), y ="Mean Accuracy (%)") + 
              ggtitle(gr_titles[[i]]) +
              theme(strip.background  = element_rect(fill="seashell1")))
      dev.off()
    }
}
