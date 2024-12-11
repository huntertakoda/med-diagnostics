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

# check for missing values

println("Missing values in Hospital Visits Data:")
for col in names(hospital_visits)
    println("Column $col: $(sum(ismissing, hospital_visits[!, col])) missing values")
end

println("\nMissing values in Lab Results Data:")
for col in names(lab_results)
    println("Column $col: $(sum(ismissing, lab_results[!, col])) missing values")
end

println("\nMissing values in Medications Data:")
for col in names(medications_data)
    println("Column $col: $(sum(ismissing, medications_data[!, col])) missing values")
end

println("\nMissing values in Patients Data:")
for col in names(patients_data)
    println("Column $col: $(sum(ismissing, patients_data[!, col])) missing values")
end

# remove duplicates

hospital_visits = unique(hospital_visits)
lab_results = unique(lab_results)
medications_data = unique(medications_data)
patients_data = unique(patients_data)

# displaying

println("Hospital Visits Data (after removing duplicates):")
println(first(hospital_visits, 5))

println("\nLab Results Data (after removing duplicates):")
println(first(lab_results, 5))

println("\nMedications Data (after removing duplicates):")
println(first(medications_data, 5))

println("\nPatients Data (after removing duplicates):")
println(first(patients_data, 5))

# checking, adjusting

println("Hospital Visits Data Types:")
println(eltype.(hospital_visits))

println("\nLab Results Data Types:")
println(eltype.(lab_results))

println("\nMedications Data Types:")
println(eltype.(medications_data))

println("\nPatients Data Types:")
println(eltype.(patients_data))

# adjusting data types

hospital_visits.VisitID = Int64.(hospital_visits.VisitID)
hospital_visits.PatientID = Int64.(hospital_visits.PatientID)
hospital_visits.VisitDate = Date.(hospital_visits.VisitDate)

lab_results.LabID = Int64.(lab_results.LabID)
lab_results.PatientID = Int64.(lab_results.PatientID)
lab_results.TestValue = Float64.(lab_results.TestValue)
lab_results.TestDate = Date.(lab_results.TestDate)

medications_data.MedicationID = Int64.(medications_data.MedicationID)
medications_data.PatientID = Int64.(medications_data.PatientID)
medications_data.StartDate = Date.(medications_data.StartDate)
medications_data.EndDate = Date.(medications_data.EndDate)

patients_data.PatientID = Int64.(patients_data.PatientID)
patients_data.Age = Int64.(patients_data.Age)

println("\nData types adjusted successfully.")