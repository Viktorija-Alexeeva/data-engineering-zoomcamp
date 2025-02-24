{{ config(materialized='table') }}

with trips_data as (
    select * from {{ ref('dim_fhv_trips') }}
),
duration as (
    select *, 
        PERCENTILE_CONT(trip_duration, 0.90) OVER (PARTITION BY pickup_year, pickup_month, pickup_locationid, dropoff_locationid) AS p90_duration
    from 
        (select pickup_year, pickup_month, pickup_locationid, pickup_zone, dropoff_locationid, dropoff_zone, 
            TIMESTAMP_DIFF(dropoff_datetime, pickup_datetime, second) as trip_duration
        from trips_data)
),
filtered_data as (
    select pickup_zone, dropoff_zone, trip_duration, round(p90_duration, 1) as p90_duration
    from duration
    where lower(pickup_zone) in ('newark airport', 'soho', 'yorkville east') 
        and pickup_year = 2019
        and pickup_month = 11
),
rank_p90 as (
    select * , 
            DENSE_RANK() OVER (PARTITION BY pickup_zone ORDER BY p90_duration DESC) AS rank_order
    from filtered_data
)
select distinct pickup_zone, dropoff_zone, p90_duration, rank_order
from rank_p90
where rank_order = 2



