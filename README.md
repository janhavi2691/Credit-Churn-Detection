# Credit-Churn-Detection
# About:
This project is all about classifying bank clients to churners and non churners by training two different classification models: Decision Tree and Random Forest. The results of both models can be analysed in detail. I have provided some background knowledge to the absolute beginners.

# Dataset: bank_marketing_dataset.csv 
            Number of observations = 4522, Number of Attributes = 17
            Data is a combination of numerical as well as categorical attributes  


## Working of Random Forest: Classification (binary + multiclass) and regression (linear i.e. predict continuous values)
Following steps are followed when we call randomForest library of R 
### We create bootstrap datasets with replacement (bootstrapping)
#1. every bootstrap contains same no. observations as that of original data
#2. every bootstrap generates one tree (DT)
#3. every bootstrap contains 2/3rd unique observations as that of original data
#4. remaining 1/3rd observations are used for testing
#5. aggregating all observations which are used for testing will regenerate entire data again
#6. testing of almost all observations in done in RF
#7. Prediction of RF for classification is done using concept of maximum votes
#8. Prediction of RF for regression is done using concept of average
#9. Accuracy for RF classification is checked using Confusion Matrix
#10. Accuracy for RF regression is checked using RMSE value
#11. Error is called Out of Bag Error (OOB)
#12. By default in R or Python (for RF) number of bootstraps created are 500, but we may change


## if acc of Random forest is > 60% we use that model for prediction 

#random forest takes random no of columns in every tree E.g. In our case:
#defaulter ~ EMP + ADD + BEDINC +CREDDEBT +OtherBebts + Gender +CS +Salary 
#5000 observations 
#every bootstrap it will contain 5000 rows and randomly selected columns 
#this is done to identify importance of that column 

## eg we are generating 500 trees; 
#400 trees contains EMP 
#100 trees exclude column EMP 
#we will calculate accuracy of 400 trees  : 80%
#we will calculate accuracy of 100 trees : 70%
#EMP is important column and adds accuracy of 10% in overall model 
#we will calculate accuracy of 400 trees  : 80%
#we will calculate accuracy of 100 trees : 70%
#EMP is important column and adds accuracy of 10% in overall model 
#400 trees that contain gender = 82%
#100 trees that does not contain gender  = 82%

## Mtry randomization: optimization for selecting best splitting variable for each tree generation
#no of variables randomly selected at every decision node 
#defaulter ~ EMP + ADD + BEDINC +CREDDEBT +OtherBebts + Gender +CS +Salary 
#1 . defaulter ~ EMP+ADD +CREDDEBT +OtherBebts + Gender +CS +Salary 
#mtry = sqrt(ncol(data)) : 2-3 
#variable having lowest entropy or variable producing highest gain is splitted first 
#variables having least value of p for chi sq is splitted first 
