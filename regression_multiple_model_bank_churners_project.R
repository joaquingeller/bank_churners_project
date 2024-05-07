install.packages("rmarkdown")
install.packages("bigrquery")
library(bigrquery)

dataset<-bq_table_download(bq_project_query("tangential-span-405818", "SELECT * FROM bank_churners.dataset"))
#Let's create a multiple regression model to calculate the probability for a client of being an 'Attrited Customer'
install.packages("glmnet")
library(glmnet)
#Convert column 'Attrition Flag' into a binary variable (0 for 'Existing Customer' and 1 for 'Attrited Customer')
dataset$Attrition_Flag<-as.numeric(dataset$Attrition_Flag=='Attrited Customer')
formula <- Attrition_Flag ~ Customer_Age + Gender + Dependent_Count + education_level + Marital_Status + Income_Category + Card_Category + Months_on_book + Total_Relationship_Count + Months_Inactive_12_mon + Contacts_Count_12_mon + Credit_Limit + Total_Revolving_Bal + Avg_Open_To_Buy + Total_Amt_Chng_Q4_Q1 + Total_Trans_Amt + Total_Trans_Ct + Total_Ct_Chng_Q4_Q1 + Avg_Utilization_Ratio
model<-glm(formula,data=dataset, family=binomial)
summary(model)
#Create a second formula, including only those variables who proved that are significant to the model
formula_2<-Attrition_Flag~Gender+Dependent_Count+Marital_Status+Income_Category+Card_Category+Total_Relationship_Count+Months_Inactive_12_mon+Contacts_Count_12_mon+Credit_Limit+Total_Revolving_Bal+ Total_Amt_Chng_Q4_Q1 + Total_Trans_Amt + Total_Trans_Ct + Total_Ct_Chng_Q4_Q1
model_2<-glm(formula_2,data=dataset, family=binomial)
summary(model_2)
#Analyze collinearity between explanatory variables
install.packages("car")
library(car)
vif_results<-vif(model_2)
print(vif_results)
#No collinearity problems found
#After comparing both models, it is concluded that although both show similar yields, the second model is preferable because it is a simplified version, since certain variables that were not significant have been eliminated.
#Let's train the model and measure it performance
install.packages("caret")
library(caret)
install.packages("pROC")
library(pROC)
set.seedpROCset.seed(123)
indexes<-createDataPartition(dataset$Attrition_Flag, p=0.8, list = FALSE)
train_data<-dataset[indexes,]
test_data<-dataset[-indexes,]
predictions<-predict(model_2, newdata = test_data, type = "response")
predicted_classes<-ifelse(predictions>0.5,1,0)
accuracy<-mean(predicted_classes==test_data$Attrition_Flag)
roc_auc<-pROC::auc(roc(test_data$Attrition_Flag, predictions))
roc_curve <- roc(test_data$Attrition_Flag, predictions)
plot(roc_curve, main = "Curva ROC", col = "blue")
lines(roc_curve, col = "red")
text(0.5, 0.5, paste("AUC =", round(roc_auc, 2)), adj = c(0.8, 0.2), cex = 1.2)

