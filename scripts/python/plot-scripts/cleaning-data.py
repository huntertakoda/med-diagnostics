import pandas as pd

# loading

df = pd.read_csv('med-diagnos-data-export.csv')

#  previewing

print(df.head())

# drop rows with missing values in essential columns

df.dropna(subset=['patientid', 'visitdate', 'diagnosis', 'medicationname'], inplace=True)

# convert 'visitdate' and 'testdate' to datetime

df['visitdate'] = pd.to_datetime(df['visitdate'], errors='coerce')
df['testdate'] = pd.to_datetime(df['testdate'], errors='coerce')

# handle missing or invalid dates

df.dropna(subset=['visitdate', 'testdate'], inplace=True)

# handling duplicates

df.drop_duplicates(subset=['patientid', 'visitid'], inplace=True)

# normalize text data 

df['diagnosis'] = df['diagnosis'].str.lower()
df['medicationname'] = df['medicationname'].str.lower()

# fill missing 'age' values with the median

df['age'] = df['age'].fillna(df['age'].median())

# reset index after cleaning

df.reset_index(drop=True, inplace=True)

# exporting

df.to_csv('cleaned_med_diagnos_data.csv', index=False)

# displaying

print(df.head())
