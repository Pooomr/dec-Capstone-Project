{{
    config(
        materialized='table',
        database='jobseeker',
        schema='staging'
    )
}}
select
    {{ dbt_utils.generate_surrogate_key(['"jobId"', 'JOBCATEGORY']) }} as JOB_KEY,
    max("_airbyte_extracted_at") "_airbyte_extracted_at",
    JOBCATEGORY,
    "jobId",
    "jobTitle",
    "date",
    "expirationDate",
    "locationName",
    "minimumSalary",
    "maximumSalary",
    "currency",
    "employerId",
    "employerName",
    "applications",
    "jobDescription",
    "jobUrl"
from {{ ref('jobs_categorized') }}
group by JOBCATEGORY, "jobId", "jobTitle", "date", "expirationDate", "locationName", "minimumSalary", "maximumSalary", "currency", "employerId", "employerName", "applications", "jobDescription", "jobUrl"