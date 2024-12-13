import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

# loading

df = pd.read_csv("med-diagnos-data-export.csv")

# printing

print(df.columns)

# generate primarycondition from diagnosis 

df['primarycondition'] = df['diagnosis'].apply(
    lambda x: 'Diabetes' if 'diabetes' in str(x).lower() else
              'Hypertension' if 'hypertension' in str(x).lower() else
              'Asthma' if 'asthma' in str(x).lower() else
              'Heart Disease' if 'heart disease' in str(x).lower() else
              'Other'
)

# plot histogram for age

plt.figure(figsize=(10,6))
plt.hist(df['age'], bins=20, color='skyblue', edgecolor='black')
plt.title('Age Distribution')
plt.xlabel('Age')
plt.ylabel('Frequency')
plt.show()

# bar plot for primary condition distribution

plt.figure(figsize=(10,6))
sns.countplot(data=df, x='primarycondition', palette='viridis')
plt.title('Primary Condition Distribution')
plt.xlabel('Primary Condition')
plt.ylabel('Frequency')
plt.xticks(rotation=45)
plt.show()

# histogram for age using seaborn

plt.figure(figsize=(10,6))
sns.histplot(df['age'], bins=20, kde=True, color='skyblue', edgecolor='black')
plt.title('Age Distribution with KDE')
plt.xlabel('Age')
plt.ylabel('Frequency')
plt.show()

# convert dosage to numeric and plot

df['dosage_in_mg'] = df['dosage'].apply(lambda x: pd.to_numeric(x.replace('mg', ''), errors='coerce'))

plt.figure(figsize=(10,6))
sns.histplot(df['dosage_in_mg'], bins=15, kde=True, color='lightgreen', edgecolor='black')
plt.title('Medication Dosage Distribution')
plt.xlabel('Dosage (mg)')
plt.ylabel('Frequency')
plt.show()

# boxplot for age by primary condition

plt.figure(figsize=(10,6))
sns.boxplot(data=df, x='primarycondition', y='age', palette='Set2')
plt.title('Age Distribution by Primary Condition')
plt.xlabel('Primary Condition')
plt.ylabel('Age')
plt.xticks(rotation=45)
plt.show()
