import pandas as pd
import matplotlib.pyplot as plt

df = pd.read_csv("simulation/taggings/her.tagging", sep=" ")

# Create a scatter plot for all SNPs
plt.figure(figsize=(12, 6))
plt.scatter(df["Predictor"], df["Exp_Heritability"], color='skyblue', marker='o')
plt.xlabel('Predictor')
plt.ylabel('Exp_Heritability')
plt.title('Expected Heritability for All SNPs')
plt.xticks(rotation=45)  # Rotate x-axis labels for readability
plt.tight_layout()

# Save the plot as an image file before displaying it
plt.savefig('results/HERITABILITY.png', dpi=300, bbox_inches='tight')

# Show the plot
plt.show()