import pandas as pd
from sklearn.cluster import KMeans
from sklearn.preprocessing import StandardScaler
import matplotlib.pyplot as plt
import seaborn as sns

# loading

df = pd.read_csv("med-diagnos-data-export.csv")

# creating the 'dosage_in_mg' column by converting 'dosage' to numeric

df['dosage_in_mg'] = df['dosage'].apply(lambda x: pd.to_numeric(x.replace('mg', '').replace('g', '').strip(), errors='coerce'))

# selecting relevant features

features = df[['age', 'dosage_in_mg', 'testvalue']]  

# standardize the data

scaler = StandardScaler()
scaled_features = scaler.fit_transform(features)

# apply k-means clustering

kmeans = KMeans(n_clusters=3, random_state=42)
df['cluster'] = kmeans.fit_predict(scaled_features)

# plot the clusters

plt.figure(figsize=(10,6))
sns.scatterplot(data=df, x='age', y='testvalue', hue='cluster', palette='Set2', s=100)
plt.title('k-means clustering of patients')
plt.xlabel('age')
plt.ylabel('test value')
plt.legend(title='cluster')
plt.show()
