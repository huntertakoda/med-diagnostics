using CSV
using DataFrames

hospital_visits_path = "C:/medicaldiagnostics/data/hospital-visits.csv"
lab_results_path = "C:/medicaldiagnostics/data/lab-results.csv"
medications_data_path = "C:/medicaldiagnostics/data/medications-data.csv"
patients_data_path = "C:/medicaldiagnostics/data/patients-data.csv"

# exporting

CSV.write("C:/medicaldiagnostics/data/cleaned_hospital_visits.csv", hospital_visits)
CSV.write("C:/medicaldiagnostics/data/cleaned_lab_results.csv", lab_results)
CSV.write("C:/medicaldiagnostics/data/cleaned_medications_data.csv", medications_data)
CSV.write("C:/medicaldiagnostics/data/cleaned_patients_data.csv", patients_data)

println("Cleaned data exported successfully.")
