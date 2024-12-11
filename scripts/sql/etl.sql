create table summary_medical_data AS
select
    p.patientid,
    p.name,
    p.age,
    h.visitdate,
    h.diagnosis,
    l.testtype,
    l.testvalue,
    m.medicationname,
    m.dosage
from cleaned_patients_data p
join cleaned_hospital_visits h ON p.patientid = h.patientid
join cleaned_lab_results l ON p.patientid = l.patientid
join cleaned_medications_data m ON p.patientid = m.patientid
where h.visitdate >= '2024-01-01'
;

select *
from summary_medical_data smd 
;

