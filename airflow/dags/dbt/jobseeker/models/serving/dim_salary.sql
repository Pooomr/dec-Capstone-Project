{{
    config(
        materialized='incremental',
        database='jobseeker',
        unique_key='JOB_KEY',
        schema='serving'
    )
}}
select
    job_key,
    "minimumSalary",
    "maximumSalary",
    "currency",
    case when "maximumSalary" > 10000 and "minimumSalary" > 10000 and "maximumSalary" < 500000 then 'Y'
    else 'N' end as "yearlySalary"
from {{ ref('jobs_categorized_unique') }}
