create table aggregated_patient_data as
select
    p.patientid,
    count(distinct h.visitid) as visit_count,
    avg(p.age) as avg_age,
    sum(case when p.primarycondition = 'Hypertension' then 1 else 0 end) as hypertension_count
from cleaned_patients_data p
join cleaned_hospital_visits h on p.patientid = h.patientid
group by p.patientid
;

select *
from aggregated_patient_data apd 
;

update aggregated_patient_data apd
join (
    select patientid, avg(visit_count) as avg_visits_per_patient
    from aggregated_patient_data
    group by patientid
) as subquery
on apd.patientid = subquery.patientid
set apd.avg_visits_per_patient = subquery.avg_visits_per_patient;
;

create table partitioned_hospital_visits (
    visitid int not null,
    patientid int not null,
    visitdate date not null,
    diagnosis varchar(50),
    dischargestatus varchar(50),
    primary key (visitid, visitdate)
)
partition by range (year(visitdate)) (
    partition p_before_2020 values less than (2020),
    partition p_2020_2021 values less than (2022),
    partition p_2022_2023 values less than (2024),
    partition p_after_2023 values less than maxvalue
)
;

insert into partitioned_hospital_visits
select * from cleaned_hospital_visits
;

select *
from partitioned_hospital_visits phv 
;

# missing or null values in hospital visits check

select count(*) as missing_values
from cleaned_hospital_visits
where visitid is null or patientid is null or visitdate is null or diagnosis is null or dischargestatus is null
;

# ensurance of foreign key consistency between hospital visits and patients data

select count(*) as foreign_key_issues
from cleaned_hospital_visits h
left join cleaned_patients_data p on h.patientid = p.patientid
where p.patientid is null
;

# verification that all visit dates are in a valid range (example: before 2025)

select count(*) as invalid_dates
from cleaned_hospital_visits
where visitdate < '2020-01-01' or visitdate > '2025-12-31'
;

# validating that patient age is within a reasonable range (e.g., 0-120)

select count(*) as invalid_age
from cleaned_patients_data
where age < 0 or age > 120
;

# checking if primary condition is one of the expected values

select primarycondition, count(*) as condition_count
from cleaned_patients_data
group by primarycondition
having primarycondition not in ('Diabetes', 'Hypertension', 'Heart Disease', 'Asthma', 'Healthy')
;

# all clear

# 1. total number of visits per primary condition, along with the average age of patients in each condition

create view aggregated_condition_visits as
select 
    p.primarycondition,
    count(distinct h.visitid) as total_visits,
    avg(p.age) as avg_age
from 
    cleaned_patients_data p
join 
    cleaned_hospital_visits h on p.patientid = h.patientid
group by 
    p.primarycondition
;

# 2. monthly visit count per diagnosis type for trend analysis
   
create view monthly_diagnosis_trends as
select 
    date_format(h.visitdate, '%Y-%m') as month,
    h.diagnosis,
    count(distinct h.visitid) as visit_count
from 
    cleaned_hospital_visits h
group by 
    month, h.diagnosis
;

# 3. total medication usage count for each patient condition and average dosage

create view aggregated_medication_usage as
select 
    p.primarycondition,
    count(distinct m.medicationid) as medication_count,
    avg(cast(m.dosage as double)) as avg_dosage
from 
    cleaned_patients_data p
join 
    cleaned_medications_data m on p.patientid = m.patientid
group by 
    p.primarycondition
;

# 4. top 5 most common diagnoses across all patients, ordered by frequency
   
create view top_5_diagnoses as
select 
    h.diagnosis,
    count(distinct h.visitid) as visit_count
from 
    cleaned_hospital_visits h
group by 
    h.diagnosis
order by 
    visit_count desc
limit 5
;

# 5. average number of visits for each patient condition

create view avg_visits_per_condition as
select 
    patient_visits.primarycondition,
    avg(patient_visits.visit_count) as avg_visits
from
    (select 
        h.patientid,
        count(distinct h.visitid) as visit_count,
        p.primarycondition
    from 
        cleaned_patients_data p
    join 
        cleaned_hospital_visits h on p.patientid = h.patientid
    group by 
        h.patientid, p.primarycondition) as patient_visits
group by 
    patient_visits.primarycondition
;

select *
from aggregated_condition_visits acv 
;

select *
from aggregated_medication_usage amu 
;

select *
from avg_visits_per_condition avpc 
;

select *
from monthly_diagnosis_trends mdt 
;

select *
from top_5_diagnoses td 
;

