CREATE TABLE summary_medical_data AS
SELECT
    p.patientid,
    p.name,
    p.age,
    h.visitdate,
    h.diagnosis,
    l.testtype,
    l.testvalue,
    m.medicationname,
    m.dosage
FROM cleaned_patients_data p
JOIN cleaned_hospital_visits h ON p.patientid = h.patientid
JOIN cleaned_lab_results l ON p.patientid = l.patientid
JOIN cleaned_medications_data m ON p.patientid = m.patientid
WHERE h.visitdate >= '2024-01-01'
;

select *
from summary_medical_data smd 
;

