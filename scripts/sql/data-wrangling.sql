# cleaning missing data and normalizing patient conditions

create view normalized_patient_conditions as
select 
    patientid,
    case 
        when primarycondition like '%diabetes%' then 'Diabetes'
        when primarycondition like '%hypertension%' then 'Hypertension'
        when primarycondition like '%asthma%' then 'Asthma'
        when primarycondition like '%heart disease%' then 'Heart Disease'
        else 'Other'
    end as primarycondition,
    name,
    age,
    gender
from cleaned_patients_data
;

select *
from normalized_patient_conditions npc 
;

# adding patient visit counts

create view patient_visit_counts as
select 
    p.patientid,
    count(distinct h.visitid) as visit_count
from normalized_patient_conditions p
join cleaned_hospital_visits h on p.patientid = h.patientid
group by p.patientid
;

select *
from patient_visit_counts pvc 
;

# join avg visit length and visit count to create a patient summary table

create view patient_summary as
select 
    p.patientid,
    p.name,
    p.age,
    p.gender,
    avgvl.avg_visit_length,
    pvc.visit_count
from normalized_patient_conditions p
join avg_visit_length_per_patient avgvl on p.patientid = avgvl.patientid
join patient_visit_counts pvc on p.patientid = pvc.patientid
;

select *
from patient_summary ps 
;

# normalizing medication dosage units (e.g., converting all dosages to mg)

create view normalized_medication_dosage as
select 
    m.medicationid,
    m.patientid,
    m.medicationname,
    case 
        when m.dosage like '%mg%' then cast(substring_index(m.dosage, 'mg', 1) as float)
        when m.dosage like '%g%' then cast(substring_index(m.dosage, 'g', 1) as float) * 1000
        else null
    end as dosage_in_mg
from cleaned_medications_data m
;

select *
from normalized_medication_dosage nmd 
;

# combining medication data with patient summary

create view patient_medication_summary as
select 
    ps.patientid,
    ps.name,
    ps.age,
    ps.gender,
    ps.avg_visit_length,
    ps.visit_count,
    md.medicationname,
    md.dosage_in_mg
from patient_summary ps
join normalized_medication_dosage md on ps.patientid = md.patientid
;

select *
from patient_medication_summary pms 
;
