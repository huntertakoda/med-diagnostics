import pandas as pd

# loading

file_path = 'med-diagnos-data-export.csv'
data = pd.read_csv(file_path)

# previewing

print(data.head())

# clean data (i.e. drop missing values)

data_cleaned = data.dropna()

# [potential] conversion

data_cleaned['visitdate'] = pd.to_datetime(data_cleaned['visitdate'])

# summary statistics

print(data_cleaned.describe())
