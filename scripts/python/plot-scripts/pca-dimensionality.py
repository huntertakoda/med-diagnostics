import pandas as pd
from sklearn.decomposition import PCA
from sklearn.preprocessing import StandardScaler
import matplotlib.pyplot as plt
import seaborn as sns

# loading

df = pd.read_csv("med-diagnos-data-export.csv")

# select numeric columns only

numeric_features = ['age', 'testvalue']  # add relevant numeric columns
df_numeric = df[numeric_features].dropna()  # drop rows with missing values

# standardize the data

scaler = StandardScaler()
scaled_features = scaler.fit_transform(df_numeric)

# apply pca

pca = PCA(n_components=2)
pca_components = pca.fit_transform(scaled_features)

# create a dataframe with pca results

df_pca = pd.DataFrame(data=pca_components, columns=['PCA1', 'PCA2'])

# visualize the pca results

plt.figure(figsize=(10, 6))
sns.scatterplot(x='PCA1', y='PCA2', data=df_pca, color='blue', s=100)
plt.title('PCA: Dimensionality Reduction to 2D')
plt.xlabel('PCA1')
plt.ylabel('PCA2')
plt.show()

# check explained variance

explained_variance = pca.explained_variance_ratio_
print(f"Explained variance by PCA components: {explained_variance}")
