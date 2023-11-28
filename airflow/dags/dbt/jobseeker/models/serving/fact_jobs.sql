{{
    config(
        materialized='incremental',
        database='jobseeker',
        unique_key='job_key',
        schema='serving'
    )
}}
select
    "_airbyte_extracted_at" as last_updated,
    job_key,
    "jobId",
    jobcategory,
    "jobTitle",
    "date",
    "expirationDate",
    "locationName",
    "applications",
    "jobDescription",
    "jobUrl",
    "employerId"
from {{ ref('jobs_categorized_unique') }}
