import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt

test_scores = pd.read_csv('simulation/scores/test_scores.profile', sep='\t')
phenotypes = pd.read_csv('simulation/pheno/pheno.pheno',header=None,sep=' ')
phenotypes.columns = ['IND','IND_','PHENO','blank']
phenotypes.drop('blank',axis=1,inplace=True)
# Extract the ground truth phenotype values
ground_truth_phenotype = phenotypes['PHENO'].values

profile_columns = ['ID1','Profile_1', 'Profile_2', 'Profile_3', 'Profile_4', 'Profile_5', 'Profile_6', 'Profile_7','PHENO']
test_scores['PHENO'] = phenotypes['PHENO']
test_scores = test_scores[profile_columns]
# Calculate the correlation between each profile and PHENO
correlations = test_scores.iloc[:, 1:-1].corrwith(test_scores['PHENO']).abs()

# Find the pzrofile with the highest correlation
most_similar_profile = correlations.idxmax()
highest_correlation = correlations.max()

print(f"The most similar profile to PHENO is '{most_similar_profile}' with a correlation of {highest_correlation:.2f}")