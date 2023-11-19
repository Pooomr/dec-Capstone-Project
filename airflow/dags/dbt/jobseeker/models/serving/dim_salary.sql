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
    "currency"
from {{ ref('jobs_categorized_unique') }}
