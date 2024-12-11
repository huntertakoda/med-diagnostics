# calculating the number of visits per patient within each month

create view visits_per_month as
select 
    p.patientid,
    date_format(h.visitdate, '%Y-%m') as month,
    count(distinct h.visitid) as visits
from cleaned_patients_data p
join cleaned_hospital_visits h on p.patientid = h.patientid
group by p.patientid, month
;

select *
from visits_per_month vpm 
;

# calculating the running total of visits per patient across time

create view running_total_visits as
select 
    patientid,
    month,
    visits,
    sum(visits) over (partition by patientid order by month) as running_total
from visits_per_month
;

select *
from running_total_visits rtv 
;

# calculating the moving average of visits per patient for the past 3 months

create view moving_avg_visits as
select 
    patientid,
    month,
    visits,
    avg(visits) over (partition by patientid order by month rows between 2 preceding and current row) as moving_avg
from visits_per_month
;

select *
from moving_avg_visits mav 
;

# calculating the first visit date for each patient

create view first_visit_date as
select 
    p.patientid,
    min(h.visitdate) as first_visit_date
from cleaned_patients_data p
join cleaned_hospital_visits h on p.patientid = h.patientid
group by p.patientid
;

select *
from first_visit_date fvd 
;

# calculating the time difference between first and most recent visit

create view visit_duration as
select 
    p.patientid,
    datediff(max(h.visitdate), min(h.visitdate)) as visit_duration_days
from cleaned_patients_data p
join cleaned_hospital_visits h on p.patientid = h.patientid
group by p.patientid
;

select *
from visit_duration vd 
;

# calculating the total visits per condition in the last 6 months

create view condition_visits_last_6_months as
select 
    p.patientid,
    p.primarycondition,
    sum(case when h.visitdate >= curdate() - interval 6 month then 1 else 0 end) as recent_visits
from cleaned_patients_data p
join cleaned_hospital_visits h on p.patientid = h.patientid
group by p.patientid, p.primarycondition
;

select *
from condition_visits_last_6_months cvlm 
;
