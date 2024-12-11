# selection testing

select *
from cleaned_hospital_visits chv 
limit 5
;
select * 
from cleaned_lab_results clr 
limit 5
;
select *
from cleaned_medications_data cmd 
limit 5
;
select *
from cleaned_patients_data cpd 
limit 5
;

# count conditions

select primarycondition, count(*) as condition_count
from cleaned_patients_data cpd 
group by primarycondition 
;

# patient visit count

select patientid, count(*) as visit_count
from cleaned_hospital_visits chv 
group by patientid
;

# join hospital visits + lab results

select chv.patientid, chv.visitid, chv.diagnosis, clr.testtype, clr.testvalue
from cleaned_hospital_visits chv 
join cleaned_lab_results clr on chv.patientid = clr.patientid
;

# multiple medications per patient

select patientid, count(distinct medicationid) as medication_count
from cleaned_medications_data
group by patientid
having medication_count > 1
;

# conditions with specific tests

select p.name, p.primarycondition, lr.testtype, lr.testvalue
from cleaned_patients_data p
join cleaned_lab_results lr on p.patientid = lr.patientid
where lr.testtype = 'blood glucose'
;

# patient diagnosis and test type analysis

select p.name, p.primarycondition, lr.testtype, avg(lr.testvalue) as avg_test_value
from cleaned_patients_data p
join cleaned_lab_results lr on p.patientid = lr.patientid
group by p.name, p.primarycondition, lr.testtype
;

# condition-based medication analysis

select p.primarycondition, m.medicationname, count(*) as num_prescriptions
from cleaned_patients_data p
join cleaned_medications_data m on p.patientid = m.patientid
group by p.primarycondition, m.medicationname
;

# age group / condition relation

select case
           when age <= 20 then '0-20'
           when age between 21 and 40 then '21-40'
           when age between 41 and 60 then '41-60'
           when age between 61 and 80 then '61-80'
           else '81+' end as age_group, primarycondition, count(*) as condition_count
from cleaned_patients_data
group by age_group, primarycondition
;

# visits and diagnosis over time

select visitid, patientid, diagnosis, visitdate, 
       row_number() over (partition by patientid order by visitdate) as visit_rank
from cleaned_hospital_visits
;

# top 5 most common diagnosis

select diagnosis, count(*) as diagnosis_count
from cleaned_hospital_visits
group by diagnosis
order by diagnosis_count desc
limit 5
;

# condition / medication trends

select patientid, 'medication' as source, medicationname as data
from cleaned_medications_data
union
select patientid, 'condition' as source, primarycondition as data
from cleaned_patients_data
;

# patient diagnoses / test type CTE

with patient_diagnosis_tests as (
    select p.patientid, p.name, p.primarycondition, lr.testtype, avg(lr.testvalue) as avg_test_value
    from cleaned_patients_data p
    join cleaned_lab_results lr on p.patientid = lr.patientid
    group by p.patientid, p.name, p.primarycondition, lr.testtype
)
select * from patient_diagnosis_tests
;

# visit ranks by date

select patientid, visitid, visitdate, diagnosis,
       row_number() over (partition by patientid order by visitdate desc) as visit_rank
from cleaned_hospital_visits
;

# medication count by condition

select p.primarycondition, m.medicationname, count(m.medicationid) as medication_count
from cleaned_patients_data p
join cleaned_medications_data m on p.patientid = m.patientid
group by p.primarycondition, m.medicationname
order by medication_count desc
;

# diagnosis and medication data

select patientid, 'Diagnosis' as data_type, primarycondition as data
from cleaned_patients_data
union all
select patientid, 'Medication' as data_type, medicationname as data
from cleaned_medications_data
;

## ending query -- patient condition analysis w/ lab results & medication insights

with patient_diagnosis_tests as (
    select p.patientid, p.name, p.primarycondition, lr.testtype, avg(lr.testvalue) as avg_test_value
    from cleaned_patients_data p
    join cleaned_lab_results lr on p.patientid = lr.patientid
    group by p.patientid, p.name, p.primarycondition, lr.testtype
),
medication_counts as (
    select p.primarycondition, m.medicationname, count(m.medicationid) as medication_count
    from cleaned_patients_data p
    join cleaned_medications_data m on p.patientid = m.patientid
    group by p.primarycondition, m.medicationname
)
select dt.primarycondition, dt.name, dt.testtype, dt.avg_test_value, mc.medicationname, mc.medication_count
from patient_diagnosis_tests dt
join medication_counts mc on dt.primarycondition = mc.primarycondition
where mc.medication_count >= 2
order by dt.avg_test_value desc
limit 3
;






