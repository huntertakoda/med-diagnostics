using CSV
using DataFrames
using Dates

hospital_visits_path = "C:/medicaldiagnostics/data/hospital-visits.csv"
lab_results_path = "C:/medicaldiagnostics/data/lab-results.csv"
medications_data_path = "C:/medicaldiagnostics/data/medications-data.csv"
patients_data_path = "C:/medicaldiagnostics/data/patients-data.csv"

# loading

hospital_visits = CSV.File(hospital_visits_path) |> DataFrame
lab_results = CSV.File(lab_results_path) |> DataFrame
medications_data = CSV.File(medications_data_path) |> DataFrame
patients_data = CSV.File(patients_data_path) |> DataFrame

# no negative-ages

patients_data.Age = clamp.(patients_data.Age, 0, 120)

# standardizing

hospital_visits.Diagnosis = lowercase.(hospital_visits.Diagnosis)
hospital_visits.DischargeStatus = lowercase.(hospital_visits.DischargeStatus)

lab_results.TestType = lowercase.(lab_results.TestType)

medications_data.MedicationName = lowercase.(medications_data.MedicationName)

patients_data.PrimaryCondition = lowercase.(patients_data.PrimaryCondition)

# removing impossible values

medications_data = filter(row -> row.Dosage != "0mg", medications_data)

# displaying

println("Cleaned Hospital Visits Data:")
println(first(hospital_visits, 5))

println("\nCleaned Lab Results Data:")
println(first(lab_results, 5))

println("\nCleaned Medications Data:")
println(first(medications_data, 5))

println("\nCleaned Patients Data:")
println(first(patients_data, 5))
