import pandas as pd
from sklearn.preprocessing import LabelEncoder

# loading

df = pd.read_csv('med-diagnos-data-export.csv')

# convert dates to datetime

df['visitdate'] = pd.to_datetime(df['visitdate'])
df['testdate'] = pd.to_datetime(df['testdate'])

# time-derived features

df['days_between'] = (df['testdate'] - df['visitdate']).dt.days
df['visit_day_of_week'] = df['visitdate'].dt.day_name()
df['visit_month'] = df['visitdate'].dt.month

# patient behavior features

df['visits_per_patient'] = df.groupby('patientid')['visitid'].transform('count')
df['avg_test_value'] = df.groupby('patientid')['testvalue'].transform('mean')
df['test_value_std'] = df.groupby('patientid')['testvalue'].transform('std')

# diagnosis-related features

df['diagnosis_frequency'] = df.groupby('diagnosis')['patientid'].transform('count')

# medication-derived features

df['unique_meds'] = df.groupby('patientid')['medicationname'].transform('nunique')

# categorical encoding

le = LabelEncoder()
df['gender_encoded'] = le.fit_transform(df['gender'])
df['discharge_status_encoded'] = le.fit_transform(df['dischargestatus'])

# interaction features

df['age_test_interaction'] = df['age'] * df['testvalue']

# binary features

df['critical_test_value'] = df['testvalue'].apply(lambda x: 1 if x > 100 else 0)

# saving

df.to_csv('engineered_features.csv', index=False)

# print summary of engineered features

print("feature engineering completed. the following features were added:")
print([
    'days_between', 'visit_day_of_week', 'visit_month',
    'visits_per_patient', 'avg_test_value', 'test_value_std',
    'diagnosis_frequency', 'unique_meds', 'gender_encoded',
    'discharge_status_encoded', 'age_test_interaction', 'critical_test_value'
])
