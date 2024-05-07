--Data cleaning.
--Checking if there are some duplicates.
SELECT *
FROM bank_churners.dataset
WHERE CLIENTNUM IN(
  SELECT CLIENTNUM
  FROM bank_churners.dataset
  GROUP BY CLIENTNUM
  HAVING COUNT(*)>1
);
--There aren't.
--Checking null values by column.
SELECT
  COUNTIF(CLIENTNUM IS NULL) AS Clientnum_missing,
  COUNTIF(Attrition_Flag IS NULL) AS Attrition_Flag_missing,
  COUNTIF(Customer_Age IS NULL) AS Customer_Age_missing,
  COUNTIF(Gender IS NULL) AS Gender_missing,
  COUNTIF(Dependent_Count IS NULL) AS Dependent_Count_missing,
  COUNTIF(education_level IS NULL) AS education_level_missing,
  COUNTIF(Marital_Status IS NULL) AS Marital_Status_missing,
  COUNTIF(Income_Category IS NULL) AS Income_Category_missing,
  COUNTIF(Card_Category IS NULL) AS Card_Category_missing,
  COUNTIF(Months_on_book IS NULL) AS Months_on_book_missing,
  COUNTIF(Total_Relationship_Count IS NULL) AS Total_Relationship_Count_missing,
  COUNTIF(Months_Inactive_12_mon IS NULL) AS Months_Inactive_12_mon_missing,
  COUNTIF(Contacts_Count_12_mon IS NULL) AS Contacts_Count_12_mon_missing,
  COUNTIF(Credit_Limit IS NULL) AS Credit_Limit_missing,
  COUNTIF(Total_Revolving_Bal IS NULL) AS Total_Revolving_Bal_missing,
  COUNTIF(Avg_Open_To_Buy IS NULL) AS Avg_Open_To_Buy_missing,
  COUNTIF(Total_Amt_Chng_Q4_Q1 IS NULL) AS Total_Amt_Chng_Q4_Q1_missing,
  COUNTIF(Total_Trans_Amt IS NULL) AS Total_Trans_Amt_missing,
  COUNTIF(Total_Trans_Ct IS NULL) AS Total_Trans_Ct_missing,
  COUNTIF(Total_Ct_Chng_Q4_Q1 IS NULL) AS Total_Ct_Chng_Q4_Q1_missing,
  COUNTIF(Avg_Utilization_Ratio IS NULL) AS Avg_Utilization_Ratio_missing
FROM bank_churners.dataset;
--There are no null values.
--Removing 2 last columns of the dataset because they are no needed.
CREATE TABLE bank_churners.dataset_2 AS
SELECT 
  Clientnum,
  Attrition_Flag,
  Customer_Age,
  Gender,
  Dependent_Count,
  education_level,
  Marital_Status,
  Income_Category,
  Card_Category,
  Months_on_book,
  Total_Relationship_Count,
  Months_Inactive_12_mon,
  Contacts_Count_12_mon,
  Credit_Limit,
  Total_Revolving_Bal,
  Avg_Open_To_Buy,
  Total_Amt_Chng_Q4_Q1,
  Total_Trans_Amt,
  Total_Trans_Ct,
  Total_Ct_Chng_Q4_Q1,
  Avg_Utilization_Ratio
FROM bank_churners.dataset;

ALTER TABLE bank_churners.dataset_2
RENAME TO dataset;
--Verify that the 'Attrition_Flag' column has only the expected values: 'Existing' and 'Attrited'.
SELECT Attrition_Flag
FROM bank_churners.dataset
WHERE Attrition_Flag NOT IN('Existing Customer', 'Attrited Customer');
--Everything allright.
--Verify that the 'Customer_Age' column has numeric values of no more than 2 digits.
SELECT Customer_Age
FROM bank_churners.dataset
WHERE Customer_Age>99;
--Everything allright.
--View the possible values for the column 'education_level'.
SELECT DISTINCT education_level
FROM bank_churners.dataset;
--'Uneducated', 'High School', 'College', 'Graduate', 'Doctorate', 'Post-Graduate', 'Unknown'.
--Verify that the 'Marital_Status' column has only the expected values: 'Married', 'Single','Divorced' 'Unknown'
SELECT COUNT(*)
FROM bank_churners.dataset
WHERE Marital_Status NOT IN('Married', 'Single', 'Divorced','Unknown');
--Everything allright.
--Verify that the 'Gender' column has only the expected values: 'M' and 'F'.
SELECT COUNT(*)
FROM bank_churners.dataset
WHERE Gender NOT IN ('M','F');
--Everything allright.
--View the possible values for the 'Income_Category' column.
SELECT DISTINCT Income_Category
FROM bank_churners.dataset;
--'Less than $40K', '$40K - $60K', '$60K - $80K', '$80K - $120K', '$120K +', 'Unknown'.
--View the possible values for the 'Card_Category' column.
SELECT DISTINCT Card_Category
FROM bank_churners.dataset;
--'Blue', 'Silver, 'Gold', 'Platinum'
--Verify that 'Months_Inactive_12_mon' and 'Contacts_Count_12_mon' columns have numeric values between 0 and 12
SELECT Months_Inactive_12_mon, Contacts_Count_12_mon
FROM bank_churners.dataset
WHERE (Months_Inactive_12_mon<0 or Months_Inactive_12_mon>12)
OR (Contacts_Count_12_mon <0 OR Contacts_Count_12_mon>12);
--Everything allright
--All set. Let's begin with the exploratory analysys
--Let's calculate mean, median, standard deviation, min and max for every numeric column
SELECT
AVG(Customer_Age) AS mean,
APPROX_QUANTILES(Customer_Age,2)[OFFSET(1)] AS median,
STDDEV(Customer_Age) AS standard_deviation,
MIN(Customer_Age) AS min,
MAX(Customer_Age) AS max
FROM bank_churners.dataset;
--Mean=median=46, stdd_dev=8, min=26,max=73
SELECT
AVG(Dependent_Count) AS mean,
APPROX_QUANTILES(Dependent_Count,2)[OFFSET(1)] AS median,
STDDEV(Dependent_Count) AS standard_deviation,
MIN(Dependent_Count) AS min,
MAX(Dependent_Count) AS max
FROM bank_churners.dataset;
--Mean=2.35, median=2, stdd_dev=1.3, min=0, max=5
SELECT
AVG(Months_on_book) AS mean,
APPROX_QUANTILES(Months_on_book,2)[OFFSET(1)] AS median,
STDDEV(Months_on_book) AS standard_deviation,
MIN(Months_on_book) AS min,
MAX(Months_on_book) AS max
FROM bank_churners.dataset;
--mean=median=36, stdd_dev=8, min=13, max=56

SELECT
AVG(Total_Relationship_Count) AS mean,
APPROX_QUANTILES(Total_Relationship_Count,2)[OFFSET(1)] AS median,
STDDEV(Total_Relationship_Count) AS standard_deviation,
MIN(Total_Relationship_Count) AS min,
MAX(Total_Relationship_Count) AS max
FROM bank_churners.dataset;
--mean=3.8, median=4, stdd_dev=1.55, min=1, max=6
SELECT
AVG(Months_Inactive_12_mon) AS mean,
APPROX_QUANTILES(Months_Inactive_12_mon,2)[OFFSET(1)] AS median,
STDDEV(Months_Inactive_12_mon) AS standard_deviation,
MIN(Months_Inactive_12_mon) AS min,
MAX(Months_Inactive_12_mon) AS max
FROM bank_churners.dataset;
--mean=2.34, median=2, stdd_dev=1, min=0, max=6
SELECT
AVG(Contacts_Count_12_mon) AS mean,
APPROX_QUANTILES(Contacts_Count_12_mon,2)[OFFSET(1)] AS median,
STDDEV(Contacts_Count_12_mon) AS standard_dev,
MIN(Contacts_Count_12_mon) AS min,
MAX(Contacts_Count_12_mon) AS max
FROM bank_churners.dataset;
--mean=2.46, median=2, stdd_dev=1.11, min=0, max=6
SELECT
AVG(Credit_Limit) AS mean,
APPROX_QUANTILES(Credit_Limit,2)[OFFSET(1)] AS median,
STDDEV(Credit_Limit) AS stdd_dev,
MIN(Credit_Limit) AS min,
MAX(Credit_Limit) AS max
FROM bank_churners.dataset;
--mean=8631.95, median=4549, stdd_dev=9088.78, min=1438.3, max=34516
SELECT
AVG(Total_Revolving_Bal) AS mean,
APPROX_QUANTILES(Total_Revolving_Bal,2)[OFFSET(1)] AS median,
STDDEV(Total_Revolving_Bal) AS stdd_dev,
MIN(Total_Revolving_Bal) AS min,
MAX(Total_Revolving_Bal) AS max
FROM bank_churners.dataset;
--mean=1162.81, median=1258, stdd_dev=814.99, min=0, max=2517
SELECT
AVG(Avg_Open_To_Buy) AS mean,
APPROX_QUANTILES(Avg_Open_To_Buy,2)[OFFSET(1)] AS median,
STDDEV(Avg_Open_To_Buy) AS stdd_dev,
MIN(Avg_Open_To_Buy) AS min,
MAX(Avg_Open_To_Buy) AS max
FROM bank_churners.dataset;
--mean=7469.14, median=3439, stdd_dev=9090.69, min=3, max=34516
SELECT
AVG(Total_Amt_Chng_Q4_Q1) AS mean,
APPROX_QUANTILES(Total_Amt_Chng_Q4_Q1,2)[OFFSET(1)] AS median,
STDDEV(Total_Amt_Chng_Q4_Q1) AS stdd_dev,
MIN(Total_Amt_Chng_Q4_Q1) AS min,
MAX(Total_Amt_Chng_Q4_Q1) AS max
FROM bank_churners.dataset;
--mean=0.76, median=0.73, stdd_dev=0.22, min=0. max=3.4
SELECT
AVG(Total_Trans_Amt) AS mean,
APPROX_QUANTILES(Total_Trans_Amt,2)[OFFSET(1)] AS median,
STDDEV(Total_Trans_Amt) AS stdd_dev,
MIN(Total_Trans_Amt) AS min,
MAX(Total_Trans_Amt) AS max
FROM bank_churners.dataset;
--mean=4404.09, median=3895, stdd_dev=3397.13, min=510, max=18484
SELECT
AVG(Total_Trans_Ct) AS mean,
APPROX_QUANTILES(Total_Trans_Ct,2)[OFFSET(1)] AS median,
STDDEV(Total_Trans_Ct) AS stdd_dev,
MIN(Total_Trans_Ct) AS min,
MAX(Total_Trans_Ct) AS max
FROM bank_churners.dataset;
--mean=64.86, median=67, stdd_dev=23.47, min=10, max=139
SELECT
AVG(Total_Ct_Chng_Q4_Q1) AS mean,
APPROX_QUANTILES(Total_Ct_Chng_Q4_Q1,2)[OFFSET(1)] AS median,
STDDEV(Total_Ct_Chng_Q4_Q1) AS stdd_dev,
MIN(Total_Ct_Chng_Q4_Q1) AS min,
MAX(Total_Ct_Chng_Q4_Q1) AS max
FROM bank_churners.dataset;
--mean=0.71, median=0.7, stdd_dev=0.24, min=0, max=3.71
SELECT
AVG(Avg_Utilization_Ratio) AS mean,
APPROX_QUANTILES(Avg_Utilization_Ratio,2)[OFFSET(1)] AS median,
STDDEV(Avg_Utilization_Ratio) AS stdd_dev,
MIN(Avg_Utilization_Ratio) AS min,
MAX(Avg_Utilization_Ratio) AS max
FROM bank_churners.dataset;
--mean=0.27, median=0.17, stdd_dev=0.28, min=0, max=1
--Now let's work with non numerical variables
  SELECT Attrition_Flag,
  COUNT(*) AS quantity
  FROM bank_churners.dataset
  GROUP BY Attrition_Flag;
--Existing Customers=8500, Attrited Customers=1627
  SELECT Gender,
  COUNT(*) AS quantity
  FROM bank_churners.dataset
  GROUP BY Gender;
--M=4769, F=5358
  SELECT education_level,
  COUNT(*) AS quantity
  FROM bank_churners.dataset
  GROUP BY education_level;
--Uneducated=1487, High School=2013, College=1013, Graduate=3128, Doctorate=451, Post-Graduate=516, Unknown=1519
  SELECT Marital_Status,
  COUNT(*) AS quantity
  FROM bank_churners.dataset
  GROUP BY Marital_Status;
--Unknown=749, Married=4687, Single=3943, Divorced=748
  SELECT Income_Category,
  COUNT(*) AS quantity
  FROM bank_churners.dataset
  GROUP BY Income_Category;
--Less than $40K=3561, $40K - $60K=1790, $60K - $80K=1402, $80K - $120K=1535, $120K +=727, Unknown=1112
  SELECT Card_Category,
  COUNT(*) AS quantity
  FROM bank_churners.dataset
  GROUP BY Card_Category;
--Blue=9436, Silver=555, Gold=116, Platinum=20
  SELECT Clientnum, Customer_Age
  FROM bank_churners.dataset;

EXPORT DATA
OPTIONS(
  uri='gs://cyclistic_bucket_jg/dataset_*.csv',
  format='CSV',
  overwrite=true,
  header=true
) AS
SELECT *
FROM bank_churners.dataset;
--After exploratory analysis, let's find the variables that explain the probability of being an 'Attrited Customer'
--The database has 10127 observations, with 1627 'Attrited Customer', 8500 'Existing Customer', and 19 variables that will try to explain the probability for a client of being an 'Attrited Customer'.
--Given the characteristics of the database, I decided to build a multiple regression model including all 19 variables that could be significant in explaining the dependent variable, in order to make the model more robust and avoid the risk of omitting relevant variables. I will then test each beta coefficient to ensure it is a significant variable to include in the model. Otherwise, it will be removed and the model adjusted until reaching the optimal version.
--As the model cannot be built directly with a function in BigQuery, it will be built in R studio. You can consult the codes in another note.


