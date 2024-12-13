import pandas as pd
from sklearn.model_selection import train_test_split

# loading

df = pd.read_csv('med-diagnos-data-export.csv')

# define features (x) and target (y)

X = df.drop(['dischargestatus', 'name', 'visitid'], axis=1)
y = df['dischargestatus']

# split

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# check split

print("Training set size:", X_train.shape)
print("Testing set size:", X_test.shape)
