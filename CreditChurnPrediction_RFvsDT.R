#Credit Churn Prediction using Decision Tree and Random Forest

install.packages("randomForest")
library(randomForest)


#Load data BankCreditCard

bank_marketing_data = read.csv("bank_marketing_dataset.csv",stringsAsFactors = TRUE)
View(bank_marketing_data)


#check for missing value
colSums(is.na(bank_marketing_data)) # no missing values

#change factor data to factors
summary(bank_marketing_data)

#consider job variable/column 1
summary(bank_marketing_data$job)
a <- table(bank_marketing_data$job)
prop.table(a) # gives % of data in particular table column job variable

#Combine few levels together for jobs variables
#job:   housemaid, student, unemployed, unknown = other
# entrepreneur , self-employed = self-employed
 
bank_marketing_data$job <- as.character(bank_marketing_data$job)    # important to convert into 
#character for level reduction otherwise the reduced levels will still remain with 0 or 1 observations
bank_marketing_data$job[bank_marketing_data$job =="housemaid"|bank_marketing_data$job=="student"|
                          bank_marketing_data$job=="unemployed"|
                          bank_marketing_data$job=="unknown"]<-"Other"
bank_marketing_data$job[bank_marketing_data$job=="entrepreneur"|
                     bank_marketing_data$job=="self-employed" ] <- "self-employed"
bank_marketing_data$job <- as.factor(bank_marketing_data$job) #convert back to factors

summary(bank_marketing_data$job)


#Consider campaign variable: next column
quantile(bank_marketing_data$campaign,probs = seq(0.9,1.0,0.01))
bank_marketing_data$campaign[bank_marketing_data$campaign > 6] <- 6
summary(bank_marketing_data$campaign)

bank_marketing_data$campaign <- as.factor(bank_marketing_data$campaign)


###########Create Decision Tree (DT) ####################
install.packages("rpart")
library(rpart)
install.packages("rpart.plot")
library(rpart.plot)
bank_marketing_DT <- rpart(y~.,data = bank_marketing_data)
rpart.plot(bank_marketing_DT,cex = 0.8)

summary(bank_marketing_DT)

pred_DT <- predict(bank_marketing_DT,bank_marketing_data,type = "class")
table(actual = bank_marketing_DT$y ,predicted = pred_DT)
accuracy = (3903+230) /nrow(bank_marketing_data);accuracy # 91.41 %
#yes accuracy
acc_Y = 3903/(3903+97);acc_Y   # 97.57 %
#no accuracy
acc_n = 230/(230+291);acc_n      # 44.14%
#huge difference between two categories accuracy bcoz data is biased and hence model is also biased

table(bank_marketing_data$y) # no obervations = 4000 and yes observations = 521 : Biased data

#Solution to this problem is Generate uniform data observations
# data that contain similar no of observations for "No" and "Yes"
# we will take all "YES" observations = 521 obs 
# we will randomly select similar no of obs ; i.e. 521 ; for category No
# we will implement model on uniform data and we will check accuracy of uniform mode.

set_yes <- subset(bank_marketing_data, bank_marketing_data$y == "yes")  
dim(set_yes) # 521  17
set_no <- subset(bank_marketing_data, bank_marketing_data$y =="no")
dim(set_no) # 4000   17

set.seed(300)
index <- sample(4000,550)
selected_no <- set_no[index,]
dim(selected_no) #550  17

uniform_data <- rbind(set_yes,selected_no)
dim(uniform_data) #1071   17

#Rebuilt DT model 
rev_unifrom_DT <- rpart(y~.,data =  uniform_data)
summary(rev_unifrom_DT)
rpart.plot(rev_unifrom_DT)
pred_uniform_DT <- predict(rev_unifrom_DT,uniform_data,type = "class") #class for classification
table(actual = uniform_data$y , predicted = pred_uniform_DT)
rev_acc = (439+446)/nrow(uniform_data) ;rev_acc #82.63
y_acc = 446/(446+75);y_acc #85.60 % : specificity
n_acc = 439/(439+111);n_acc # 79.81% : sensitivity
#As spec & sens are similar, model is not biased and hence we can use this model on entire data
pred_complete_DT <- predict(rev_unifrom_DT,bank_marketing_data,type = "class")

table(actual = bank_marketing_data$y, predicted = pred_complete_DT)

acc_complete = (3003+446)/nrow(bank_marketing_data);acc_complete # 0.76
acc_complete_y = 446/(446+75);acc_complete_y # 85.6
acc_complete_n = 3003/(3003+997);acc_complete_n # 75.07


#Note: For tree we need to check for uniform data 

#############Create Random Forest (RF) ###############
# if we implement random forest model on complete data ; 
# as the data biased ; results will be biased as we have seen in above case 
# so , we will implement random forest model on uniform data only 

bank_marketing_RF <- randomForest(y~.,data = uniform_data)
bank_marketing_RF
plot(bank_marketing_RF) #plotting RF amount of error for 500 decision trees
#red line represents no category error
#green line represents yes category error
#black line represents overall accuracy of RF
#For given data, the optimal no of trees required are 100 as after 100 error is almost constant
#we can using 100 DT
set.seed(300)
bank_marketing_RF_optimized <- randomForest(y~.,data = uniform_data, ntree = 100, importance = TRUE)
plot(bank_marketing_RF_optimized)
bank_marketing_RF_optimized
bank_marketing_RF_optimized$importance #importance gives you significance of variables in the model
#MeanDecreaseAcuracy gives us info about which variables are significant
#keep variables with +ve values of MeanDecreaseAcuracy and remove those variables with -ve values of MeanDecreaseAcuracy
#For default var MeanDecreaseAcuracy=  -0.0002223496, means by removing this var the accuracy of the
# model will increase by 0.0002223496 and it is negligible so it is not changing accuracy by huge ammount and hence  
#there is no need to revise the model


#make predictions on unifrom data
pred_unifrom_RF <- predict(bank_marketing_RF,uniform_data) #no need of passing type= class
head(pred_unifrom_RF)
table(actual = uniform_data$y,predicted = pred_unifrom_RF)
acc_RF = (550+521)/nrow(uniform_data);acc_RF #100%

#make predictions on complete data
pred_complete_RF <- predict(bank_marketing_RF,bank_marketing_data)
table(actual = bank_marketing_data$y,predicted = pred_complete_RF)
acc_complete_RF = (3272+521)/nrow(bank_marketing_data);acc_complete_RF #83.89
acc_complete_RF_y = 521/521; acc_complete_RF_y # 100%
acc_complete_RF_n = 3272/(3272+728);acc_complete_RF_n #81.8 %















