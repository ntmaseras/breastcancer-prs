import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt
import os


#p_values = ['1', '0.1', '1e-2', '1e-3', '1e-4', '1e-5', '1e-6', '1e-7', '5e-8']
p_values = ['5e-8', '1e-7', '1e-6', '1e-5', '1e-4', '1e-3', '1e-2', '0.1', '1']
score_1_values_filtered = []
score1_values = []
# Loop through each p-value file and extract Score_1 values
for p in p_values:
    file_name = f"simulation/thintops_scores/test_scores{p}.cors"
    try:
        data = pd.read_csv(file_name, sep='\t')
        score_1 = data[data["Profile"] == "Score_1"]["Correlation"].values[0]
        
        # Append Score_1 value to the list
        score_1_values_filtered.append(score_1)
    except FileNotFoundError:
        print(f"File {file_name} not found. Skipping.")

for p in p_values:
    file_name = f"simulation/thintops_scores/train_scores{p}.cors"
    try:
        data = pd.read_csv(file_name, sep='\t')
        score_1 = data[data["Profile"] == "Score_1"]["Correlation"].values[0]
        
        # Append Score_1 value to the list -> THE ONE USING ALL PVALUES PREV FILTERED
        score1_values.append(score_1)
    except FileNotFoundError:
        print(f"File {file_name} not found. Skipping.")



# Create a line plot
plt.figure(figsize=(10, 6))
plt.plot(p_values, score_1_values_filtered, marker='o', linestyle='-', color='b',label = "Test")
plt.plot(p_values, score1_values, marker='o', linestyle='-', color='r',label = "Training")
plt.xlabel('P-Value')
plt.ylabel('Score_1')
plt.ylim(0,1)
plt.grid(True)
plt.legend()
plt.savefig('results/thintops_scores_plot.png')

