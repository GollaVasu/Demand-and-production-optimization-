# -*- coding: utf-8 -*-
"""
Created on Mon Feb 10 19:10:21 2025

@author: G Thirumala Vasu
"""

# Data preprocessing

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from sklearn.impute import SimpleImputer

data = pd.read_csv(r"C:/Users/G Thirumala Vasu/OneDrive/Desktop/Data_Demand_.csv")
data.shape          #(6814, 14)
data.describe()
data.info()

data = data.sort_values(by = "Order_ID")

# Typecasting
print(data.dtypes)
data["Date"] = pd.to_datetime(data["Date"], format = "%d-%m-%Y")

# Handling Duplicates
data["Order_ID"].duplicated().sum()   #546 duplicates
data = data.drop_duplicates(subset=['Order_ID'], keep='first')

data.duplicated().sum()   # (6268, 14)

# Outlier Treatment

#Boxplot to visualize outliers
sns.boxplot(data["Order_Quantity"])
plt.title("Box plot of Order_Quantity")

sns.boxplot(data["Inventory_Level"])
plt.title("Box plot of Inventory_Level")

sns.boxplot(data["Lead_Time_Days"])
plt.title("Box plot of Lead_Time_Days")

sns.boxplot(data["Delay_Days"])
plt.title("Box plot of Delay_Days")


#Detecting outliers using IQR method
columns = ["Order_Quantity", "Inventory_Level", "Lead_Time_Days"]

for col in columns:
    Q1 = data[col].quantile(0.25)
    Q3 = data[col].quantile(0.75)
    IQR = Q3 - Q1

    lower_bound = Q1 - 1.5 * IQR
    upper_bound = Q3 + 1.5 * IQR

    Outliers = data[(data[col] < lower_bound) | (data[col] > upper_bound)]
   
    # Replaceing the outliers with median value
    Median_value = data[col].median()
    data[col] = data[col].apply(lambda x : Median_value if(x < lower_bound or x > upper_bound) else x)


# Missing Values
data.isnull().sum()

# Order_ID
data = data.dropna(subset = "Order_ID")

# Date
data["Date"] = data["Date"].ffill()

# Replacing missing values in categorical columns with mode value
columns = ['Warehouse' , 'Dealer' , 'Customer_ID' , 'Machine_ID' , 'Machine_Type' ,
           'Production_Status' , 'Order_Volatility']

for col in columns:
    mode = data[col].mode() [0]
    data[col] = data[col].fillna(mode)

data = data.drop(columns = "Change_Type")

#Replacing missing values in numerical columns with mean or median
Mean_imputer = SimpleImputer(strategy = "mean")
Columns_to_impute = ["Order_Quantity" , "Inventory_Level" , "Lead_Time_Days", "Delay_Days"]
data[Columns_to_impute] = Mean_imputer.fit_transform(data[Columns_to_impute])



data.isnull().sum()  # Hence zero missing values 

sns.histplot(data["Order_Quantity"], bins = 20)
sns.histplot(data["Inventory_Level"] , bins = 20)
sns.histplot(data["Lead_Time_Days"], bins = 20)
sns.histplot(data["Delay_Days"] , bins = 20)

# Discretization 

data['Order_Quantity'] = data['Order_Quantity'].round(0).astype(int)
data['Inventory_Level'] = data['Inventory_Level'].round(0).astype(int)
data['Lead_Time_Days'] = data['Lead_Time_Days'].round(0).astype(int)
data['Delay_Days'] = data['Delay_Days'].round(0).astype(int)

print(data.dtypes)
# Transformation
# columns = ["Order_Quantity", "Inventory_Level", "Lead_Time_Days"]
# data[columns] = np.log(data[columns])

data.to_csv("Cleaned data demand 1.csv", index = False)
import os
print(os.getcwd())
