{{
    config(
        materialized='table',
        database='jobseeker',
        schema='serving'
    )
}}
select
    l.location_name,
    count(*) as total_jobs,
    l.latitude,
    l.longitude
from {{ ref('fact_jobs') }} j
inner join {{ source('dim_locations','dim_locations')}} l
    on j."locationName" = l.location_name
group by l.location_name, l.latitude, l.longitude
order by count(*) desc
