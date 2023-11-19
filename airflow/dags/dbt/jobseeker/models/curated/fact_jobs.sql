{{
    config(
        materialized='incremental',
        database='jobseeker',
        unique_key='JOB_KEY',
        schema='curated'
    )
}}
select
    "_airbyte_extracted_at" as last_updated,
    job_key,
    "jobId",
    jobcategory
from {{ ref('jobs_categorized_unique') }}
