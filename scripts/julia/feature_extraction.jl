using CSV
using DataFrames
using StatsBase 

hospital_visits_path = "C:/medicaldiagnostics/data/hospital-visits.csv"
lab_results_path = "C:/medicaldiagnostics/data/lab-results.csv"
medications_data_path = "C:/medicaldiagnostics/data/medications-data.csv"
patients_data_path = "C:/medicaldiagnostics/data/patients-data.csv"

# loading

hospital_visits = CSV.File(hospital_visits_path) |> DataFrame
lab_results = CSV.File(lab_results_path) |> DataFrame
medications_data = CSV.File(medications_data_path) |> DataFrame
patients_data = CSV.File(patients_data_path) |> DataFrame

# feature extractions 

# 1. age groups

function categorize_age(age)
    if age <= 20
        return "0-20"
    elseif age <= 40
        return "21-40"
    elseif age <= 60
        return "41-60"
    elseif age <= 80
        return "61-80"
    else
        return "81+"
    end
end

patients_data.AgeGroup = map(categorize_age, patients_data.Age)

# 2. condition Counts

condition_counts = countmap(patients_data.PrimaryCondition)

# 3. unique diagnoses

unique_diagnoses = unique(hospital_visits.Diagnosis)

# output

println("\nCondition Counts:")
println(condition_counts)

println("\nUnique Diagnoses:")
println(unique_diagnoses)

println("\nPatients Data with Age Groups:")
println(first(patients_data, 5))