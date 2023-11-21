{{
    config(
        materialized='table',
        database='jobseeker',
        schema='serving'
    )
}}
select
    e."employerName",
    count(*) as total_jobs,
    sum("applications") as total_applications,
    round(avg("minimumSalary"),0) as avg_min_salary,
    round(avg("maximumSalary"),0) as avg_max_salary,
    min("minimumSalary") as total_min_salary,
    max("maximumSalary") as total_max_salary   
from {{ ref('fact_jobs') }} j
left join {{ ref('dim_employer') }} e
    on j."employerId" = e."employerId"
left join {{ ref('dim_salary') }} s
    on j.job_key = s.job_key and s."yearlySalary"='Y'
group by e."employerName"
order by count(*) desc