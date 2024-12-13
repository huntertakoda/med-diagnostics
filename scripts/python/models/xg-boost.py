import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score, classification_report
from sklearn.preprocessing import LabelEncoder
from xgboost import XGBClassifier

# loading

df = pd.read_csv('med-diagnos-data-export.csv')

# convert date columns to datetime

df['visitdate'] = pd.to_datetime(df['visitdate'])
df['testdate'] = pd.to_datetime(df['testdate'])

# create numerical features from date columns

df['visit_year'] = df['visitdate'].dt.year
df['visit_month'] = df['visitdate'].dt.month
df['visit_day'] = df['visitdate'].dt.day
df['test_year'] = df['testdate'].dt.year
df['test_month'] = df['testdate'].dt.month
df['test_day'] = df['testdate'].dt.day
df['days_between'] = (df['testdate'] - df['visitdate']).dt.days

# drop the original date columns

df = df.drop(['visitdate', 'testdate'], axis=1)

# clean the dosage column

df['dosage'] = df['dosage'].str.extract(r'(\d+)')  # extract numeric part
df['dosage'] = pd.to_numeric(df['dosage'], errors='coerce')  # convert to numeric
df['dosage'] = df['dosage'].fillna(0)

# encode categorical columns

categorical_cols = ['gender', 'dischargestatus', 'diagnosis', 'testtype', 'medicationname']
le = LabelEncoder()
for col in categorical_cols:
    df[col] = le.fit_transform(df[col])

# train / test split

X = df.drop(['dischargestatus', 'name', 'visitid'], axis=1)  # replace 'dischargestatus' with your target column
y = df['dischargestatus']
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# initializing xgboost classifier

xgb_model = XGBClassifier(random_state=42, use_label_encoder=False, eval_metric='logloss')

# training

xgb_model.fit(X_train, y_train)

# predicting

y_pred = xgb_model.predict(X_test)

# evaluating

print("Accuracy:", accuracy_score(y_test, y_pred))
print("\nClassification Report:\n", classification_report(y_test, y_pred))

import matplotlib.pyplot as plt
plt.barh(X_train.columns, xgb_model.feature_importances_)
plt.title('Feature Importance')
plt.show()

import joblib
joblib.dump(xgb_model, 'xgboost_model.pkl')
