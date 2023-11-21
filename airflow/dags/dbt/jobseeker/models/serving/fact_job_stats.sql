{{
    config(
        materialized='table',
        database='jobseeker',
        schema='serving'
    )
}}
select 
    jobcategory,
    count(*) as total_jobs,
    round(avg("applications"),2) as avg_applications,
    round(avg("minimumSalary"),0) as avg_min_salary,
    round(avg("maximumSalary"),0) as avg_max_salary,
    min("minimumSalary") as total_min_salary,
    max("maximumSalary") as total_max_salary
from {{ ref('fact_jobs') }} j
inner join {{ ref('dim_salary') }} s
    on j.job_key = s.job_key and s."yearlySalary" = 'Y' and s."currency" = 'GBP'
group by jobcategory
order by count(*) desc
