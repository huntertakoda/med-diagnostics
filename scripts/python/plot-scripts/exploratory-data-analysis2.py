import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import train_test_split

# loading

df = pd.read_csv("med-diagnos-data-export.csv")

# generate primarycondition from diagnosis

df['primarycondition'] = df['diagnosis'].apply(
    lambda x: 'Diabetes' if 'diabetes' in str(x).lower() else
              'Hypertension' if 'hypertension' in str(x).lower() else
              'Asthma' if 'asthma' in str(x).lower() else
              'Heart Disease' if 'heart disease' in str(x).lower() else
              'Other'
)

# creating the 'dosage_in_mg' column by converting 'dosage' to numeric

df['dosage_in_mg'] = df['dosage'].apply(lambda x: pd.to_numeric(x.replace('mg', '').replace('g', '').strip(), errors='coerce'))

# correlation heatmap for numeric variables

corr = df[['age', 'visitid', 'testvalue', 'dosage_in_mg']].corr()
plt.figure(figsize=(10,6))
sns.heatmap(corr, annot=True, cmap='coolwarm', fmt='.2f', linewidths=0.5)
plt.title('Correlation Heatmap')
plt.show()

# pairplot for numerical features

sns.pairplot(df[['age', 'visitid', 'testvalue', 'dosage_in_mg']])
plt.show()

# scatter plot for age vs test value

plt.figure(figsize=(10,6))
sns.scatterplot(data=df, x='age', y='testvalue', hue='primarycondition', palette='Set2', s=100)
plt.title('Age vs Test Value')
plt.xlabel('Age')
plt.ylabel('Test Value')
plt.show()

# scatter plot with regression line

plt.figure(figsize=(10,6))
sns.regplot(data=df, x='age', y='dosage_in_mg', scatter_kws={'s':20}, line_kws={'color':'red'})
plt.title('Age vs Medication Dosage (Regression Line)')
plt.xlabel('Age')
plt.ylabel('Medication Dosage (mg)')
plt.show()

# convert 'testdate' to datetime format

df['testdate'] = pd.to_datetime(df['testdate'], errors='coerce')

# line plot for test value over time

plt.figure(figsize=(12,6))
sns.lineplot(data=df, x='testdate', y='testvalue', ci=None, color='blue')
plt.title('Test Value Over Time')
plt.xlabel('Test Date')
plt.ylabel('Test Value')
plt.show()

# encoding categorical variables (e.g., primarycondition)

df_encoded = pd.get_dummies(df, columns=['primarycondition'], drop_first=True)

# defining features and target

X = df_encoded.drop(columns=['testvalue', 'patientid', 'name', 'testdate'])
y = df_encoded['testvalue']  # or any other target variable you want to analyze

# splitting the data

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# fitting the model

rf = RandomForestClassifier()
rf.fit(X_train, y_train)

# feature importance plot

plt.figure(figsize=(10,6))
sns.barplot(x=rf.feature_importances_, y=X.columns)
plt.title('Feature Importance')
plt.show()
