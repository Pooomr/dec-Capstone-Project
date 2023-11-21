{{
    config(
        materialized='table',
        database='jobseeker',
        schema='serving'
    )
}}
select
    j.jobcategory,
    s."minimumSalary",
    s."maximumSalary"
from {{ ref('fact_jobs')}} j
inner join {{ ref('dim_salary')}} s
    on j.job_key = s.job_key and s."yearlySalary"='Y'
