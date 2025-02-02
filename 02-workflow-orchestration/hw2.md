#homework 2

-- How many rows are there for the Yellow Taxi data for all CSV files in the year 2020?
SELECT count(*) as count_rows 
FROM `ny-rides-viktorija.de_zoomcamp.yellow_tripdata` 
WHERE filename like '%2020%' ;

-- How many rows are there for the Green Taxi data for all CSV files in the year 2020?
SELECT count(*) as count_rows 
FROM `ny-rides-viktorija.de_zoomcamp.green_tripdata` 
WHERE filename like '%2020%' ;

-- How many rows are there for the Yellow Taxi data for the March 2021 CSV file?
SELECT count(*) as count_rows 
FROM `ny-rides-viktorija.de_zoomcamp.yellow_tripdata` 
WHERE filename like '%2021-03%' ;
