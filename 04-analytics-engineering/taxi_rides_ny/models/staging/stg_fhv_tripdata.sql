{{
    config(
        materialized='view'
    )
}}

with tripdata as (
    select * 
    from {{ source('staging', 'fhv_tripdata') }}
    where dispatching_base_num is not null
)

select
        dispatching_base_num,
        pickup_datetime,
        dropoff_datetime,
        pulocationid,
        dolocationid,
        sr_flag,
        affiliated_base_number

from tripdata 
    
