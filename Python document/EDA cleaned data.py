# -*- coding: utf-8 -*-
"""
Created on Thu Feb 13 19:38:08 2025

@author: G Thirumala Vasu
"""

# -*- coding: utf-8 -*-
"""
Created on Mon Feb 10 06:08:43 2025

@author: G Thirumala Vasu
"""

import pandas as pd

data = pd.read_csv(r"C:\Users\G Thirumala Vasu\OneDrive\Desktop\Cleaned data demand 1.csv")

data.info()
# Four Business Decision Moments

def EDA(num_column_name):
    if num_column_name in data.columns:
        #Fisrt moment business decision(mean , median , mode)
        mean = data[num_column_name].mean()
        median = data[num_column_name].median()
        mode = data[num_column_name].mode()
        
        print(f"Mean value of {num_column_name} is {mean}")
        print(f"Median value of {num_column_name} is {median}")
        print(f"Mode value of {num_column_name} is {mode}")
        print("")
        
        
        #Second moment Business Decision(Variance, Standard deviation , Range)
        variance = data[num_column_name].var()
        std = data[num_column_name].std()
        datarange = data[num_column_name].max() - data[num_column_name].min()
        
        print(f"Variance of {num_column_name} is {variance}")
        print(f"Standard deviation of {num_column_name} is {std}")
        print(f"Range of {num_column_name} is {datarange}")
        print("")
        
        
        #Third moment Business Decision(skewness)
        skewness = data[num_column_name].skew()
        
        print(f"Skewness of {num_column_name} is {skewness}")
        print("")
        
        
        # Forth moment Business Decision(kurtosis)
        kurtosis = data[num_column_name].kurt()
        
        print(f"Kurtosis of {num_column_name} is {kurtosis}")
        print("")
    
    else:
        print("Column not found")

EDA("Order_Quantity")
EDA("Inventory_Level")
EDA("Lead_Time_Days")
EDA("Delay_Days")    


def mode(cat_column_name):
    if cat_column_name in data.columns:
        mode = data[cat_column_name].mode()
        print(f"Mode of {cat_column_name} is {mode}") 
    else:
        print("Column not found")
        
mode("Warehouse")     
mode("Dealer")    
mode("Customer_ID")  
mode("Machine_ID")  
mode("Machine_Type")  
mode("Production_Status")
mode("Change_Type")      
mode("Order_Volatility")

        
        
        
        
        
        
        