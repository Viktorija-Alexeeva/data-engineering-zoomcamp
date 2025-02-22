{{ config(materialized='table') }}

with trips_data as (
    select * from {{ ref('dim_taxi_trips') }}
),
filtered_data as (
    select service_type, pickup_year, pickup_month, fare_amount
    from trips_data
    where fare_amount > 0
        and trip_distance > 0
        and lower(payment_type_description) in ('cash', 'credit card')
        and pickup_year = 2020
        and pickup_month = 4 
), 
percentile as (
    select service_type, pickup_year, pickup_month,
            PERCENTILE_CONT(fare_amount, 0.97) OVER (PARTITION BY service_type, pickup_year, pickup_month) AS p97_fare,
            PERCENTILE_CONT(fare_amount, 0.95) OVER (PARTITION BY service_type, pickup_year, pickup_month) AS p95_fare,
            PERCENTILE_CONT(fare_amount, 0.90) OVER (PARTITION BY service_type, pickup_year, pickup_month) AS p90_fare
    from filtered_data 
) 
select distinct *
from percentile 

 