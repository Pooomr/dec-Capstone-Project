{{
    config(
        materialized='table',
        database='jobseeker',
        schema='serving'
    )
}}
select 
    "ID" as LOCATION_ID,
    "locationName" as LOCATION_NAME,
    "Latitude" as LATITUDE,
    "Longitude" as LONGITUDE
from raw."location_coordinates"
