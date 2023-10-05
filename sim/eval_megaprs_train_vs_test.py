import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
import pandas as pd

# Define the models
models = ["lasso", "ridge", "bolt", "bayesr"]

# Initialize an empty list to store DataFrames for each model
dfs = []

# Loop through each model
for model in models:
    # Read the scores.profile file for the current model (test data)
    test_filename = f"megaprs/{model}/scores.profile"
    data_test = np.genfromtxt(test_filename, delimiter="\t", skip_header=1, usecols=(2, 4))
    
    # Read the train_scores.profile file for the current model (training data)
    train_filename = f"megaprs/{model}/train_scores.profile"
    data_train = np.genfromtxt(train_filename, delimiter="\t", skip_header=1, usecols=(2, 4))
    
    # Extract Phenotype and Profile_1 columns for test data
    phenotype_test = data_test[:, 0]
    profile_test = data_test[:, 1]
    
    # Extract Phenotype and Profile_1 columns for training data
    phenotype_train = data_train[:, 0]
    profile_train = data_train[:, 1]
    
    # Calculate correlation between Phenotype and Profile_1 for test and training data
    correlation_test = np.corrcoef(phenotype_test, profile_test)[0, 1]
    correlation_train = np.corrcoef(phenotype_train, profile_train)[0, 1]
    
    # Create a DataFrame for the current model
    df_model = pd.DataFrame({'Model': [model, model],
                             'Correlation': [correlation_test, correlation_train],
                             'Data': ['Test', 'Training']})
    
    # Append the DataFrame to the list
    dfs.append(df_model)

# Concatenate DataFrames for all models into a single DataFrame
df = pd.concat(dfs, ignore_index=True)

# Create a line plot with Seaborn
plt.figure(figsize=(12, 6))
sns.lineplot(data=df, x='Model', y='Correlation', hue='Data', palette='Set1', marker='o')
plt.xlabel('Model')
plt.ylabel('Correlation')
plt.title('Correlation between Phenotype and Profile_1 for Training and Test Data')
plt.ylim(0, 1)  # Set the y-axis range to 0 to 1 for correlation values
plt.grid(axis='y')

# Rotate x-axis labels for better readability (optional)
plt.xticks(rotation=45)

# Save the plot as an image file before displaying it
plt.savefig('results/megaprsperformanceTT.png', dpi=300, bbox_inches='tight')

# Display the plot
plt.show()