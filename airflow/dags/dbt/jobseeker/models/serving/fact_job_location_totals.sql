{{
    config(
        materialized='table',
        database='jobseeker',
        schema='serving'
    )
}}
select
    l.location_name,
    l.latitude,
    l.longitude,
    count(*) as total_jobs
from {{ ref('fact_jobs') }} as j
inner join {{ source('dim_locations','dim_locations') }} as l
    on j."locationName" = l.location_name
group by l.location_name, l.latitude, l.longitude
order by count(*) desc
