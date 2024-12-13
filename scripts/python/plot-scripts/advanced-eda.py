import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

# loading

df = pd.read_csv('med-diagnos-data-export.csv')

# check for missing values and handle

df['testvalue'].fillna(df['testvalue'].median(), inplace=True)
df['age'].fillna(df['age'].median(), inplace=True)
df['dosage_in_mg'] = pd.to_numeric(df['dosage'], errors='coerce')

# set up the plot grid with subplots

fig, axes = plt.subplots(2, 3, figsize=(18, 12))

# kde plot for 'age', 'testvalue', and 'dosage_in_mg'

sns.kdeplot(df['age'], ax=axes[0, 0], shade=True, color='skyblue', linewidth=2)
sns.kdeplot(df['testvalue'], ax=axes[0, 1], shade=True, color='green', linewidth=2)
sns.kdeplot(df['dosage_in_mg'], ax=axes[0, 2], shade=True, color='orange', linewidth=2)
axes[0, 0].set_title('KDE Plot for Age', fontsize=14)
axes[0, 1].set_title('KDE Plot for Test Value', fontsize=14)
axes[0, 2].set_title('KDE Plot for Medication Dosage (mg)', fontsize=14)

# boxplot for 'age', 'testvalue', and 'dosage_in_mg'

sns.boxplot(data=df[['age', 'testvalue', 'dosage_in_mg']], ax=axes[1, 0], palette='Set2')
axes[1, 0].set_title('Boxplot of Age, Test Value, and Dosage', fontsize=14)

# violin plot for 'age' and 'testvalue'

sns.violinplot(y=df['age'], ax=axes[1, 1], palette='muted')
axes[1, 1].set_title('Violin Plot for Age', fontsize=14)
sns.violinplot(y=df['testvalue'], ax=axes[1, 2], palette='muted')
axes[1, 2].set_title('Violin Plot for Test Value', fontsize=14)

# adjusting

plt.tight_layout()
plt.show()
