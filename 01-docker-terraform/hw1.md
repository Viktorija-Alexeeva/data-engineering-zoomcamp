#homework 1

-- up to 1
select count(*) as trips_num
from public.green_taxi_data 
where 1=1
and lpep_dropoff_datetime between '2019-10-01 00:00:00' and '2019-10-31 23:59:59'
and trip_distance <= 1
;

-- >1 and <=3
select count(*) as trips_num
from public.green_taxi_data 
where 1=1
and lpep_dropoff_datetime between '2019-10-01 00:00:00' and '2019-10-31 23:59:59'
and trip_distance >1 and trip_distance <=3
;

-- >3 and <=7
select count(*) as trips_num
from public.green_taxi_data 
where 1=1
and lpep_dropoff_datetime between '2019-10-01 00:00:00' and '2019-10-31 23:59:59'
and trip_distance >3 and trip_distance <=7
;


-- >7 and <=10
select count(*) as trips_num
from public.green_taxi_data 
where 1=1
and lpep_dropoff_datetime between '2019-10-01 00:00:00' and '2019-10-31 23:59:59'
and trip_distance >7 and trip_distance <=10
;

-- >10
select count(*) as trips_num
from public.green_taxi_data 
where 1=1
and lpep_dropoff_datetime between '2019-10-01 00:00:00' and '2019-10-31 23:59:59'
and trip_distance >10
;

-- longest trip
select  lpep_pickup_datetime, trip_distance
from public.green_taxi_data
where 1=1
order by trip_distance desc
limit 1
;

--3 biggest pickup zones
select z."Zone", sum(total_amount) as sum_total_amount
from public.green_taxi_data d
left join public.taxi_zone_lookup z
	on d."PULocationID" = z."LocationID"
where 1=1
and lpep_pickup_datetime between '2019-10-18 00:00:00' and '2019-10-18 23:59:59'
group by "PULocationID", z."Zone"
having sum(total_amount) > 13.000
order by 2 desc
limit 3
;

-- largest tip 
select d.tip_amount, z2."Zone"
from public.green_taxi_data d
left join public.taxi_zone_lookup z
	on d."PULocationID" = z."LocationID"
left join public.taxi_zone_lookup z2
	on d."DOLocationID" = z2."LocationID"
where 1=1
and lpep_pickup_datetime between '2019-10-01 00:00:00' and '2019-10-31 23:59:59'
and z."Zone" = 'East Harlem North'
order by tip_amount desc
limit 1
;



