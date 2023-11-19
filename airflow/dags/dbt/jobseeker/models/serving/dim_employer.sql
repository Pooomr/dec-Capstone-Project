{{
    config(
        materialized='incremental',
        database='jobseeker',
        unique_key='"employerId"',
        schema='serving'
    )
}}
select distinct
    "employerId",
    "employerName"
from {{ ref('jobs_categorized_unique') }}
