{{ config(materialized='table') }}

with trips_data as (
    select * from {{ ref('dim_taxi_trips') }}
),
quarterly_revenue as (
    select service_type, pickup_year, pickup_quarter, pickup_year_quarter, 
            sum(total_amount) as quarterly_revenue
    from trips_data
    where pickup_year in (2019, 2020)
    group by service_type, pickup_year, pickup_quarter, pickup_year_quarter
),
previous_quarter_revenue as (
    select service_type, pickup_year, pickup_quarter, pickup_year_quarter, 
            lag(sum(total_amount)) over(partition by service_type, pickup_quarter order by pickup_year) as previous_quarter_revenue
    from trips_data
    where pickup_year in (2019, 2020)
    group by service_type, pickup_year, pickup_quarter, pickup_year_quarter
),
all_quarter_revenue as (
    select q.service_type, q.pickup_year_quarter, q.quarterly_revenue, pq.previous_quarter_revenue     
    from quarterly_revenue q 
    left join previous_quarter_revenue pq 
        on q.service_type = pq.service_type 
        and q.pickup_year_quarter = pq.pickup_year_quarter
)

select service_type, pickup_year_quarter, 
        round((quarterly_revenue - previous_quarter_revenue)/ previous_quarter_revenue * 100, 2) || '%' as YoY_growth
from all_quarter_revenue
where previous_quarter_revenue is not null 
order by 1,2


