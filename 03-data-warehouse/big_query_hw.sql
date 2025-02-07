CREATE OR REPLACE EXTERNAL TABLE `ny-rides-viktorija.de_zoomcamp.yellow_tripdata_2024_ext`
OPTIONS (
  format = 'PARQUET',
  uris = ['gs://ny-rides-viktorija-bucket/yellow_tripdata_2024-*.parquet']
);

CREATE OR REPLACE TABLE `ny-rides-viktorija.de_zoomcamp.yellow_nonpartitioned_tripdata_2024`
AS SELECT * FROM `ny-rides-viktorija.de_zoomcamp.yellow_tripdata_2024_ext`;

SELECT count(*) FROM `ny-rides-viktorija.de_zoomcamp.yellow_nonpartitioned_tripdata_2024`;

SELECT COUNT(DISTINCT(PULocationID)) FROM `ny-rides-viktorija.de_zoomcamp.yellow_tripdata_2024_ext`;
SELECT COUNT(DISTINCT(PULocationID)) FROM `ny-rides-viktorija.de_zoomcamp.yellow_nonpartitioned_tripdata_2024`;

SELECT PULocationID FROM `ny-rides-viktorija.de_zoomcamp.yellow_nonpartitioned_tripdata_2024`;
SELECT PULocationID, DOLocationID FROM `ny-rides-viktorija.de_zoomcamp.yellow_nonpartitioned_tripdata_2024`;

SELECT count(*) FROM `ny-rides-viktorija.de_zoomcamp.yellow_nonpartitioned_tripdata_2024` where fare_amount = 0;

CREATE OR REPLACE TABLE `ny-rides-viktorija.de_zoomcamp.yellow_partitioned_tripdata_2024`
PARTITION BY DATE(tpep_dropoff_datetime)
CLUSTER BY VendorID AS (
  SELECT * FROM `ny-rides-viktorija.de_zoomcamp.yellow_tripdata_2024_ext`
);

SELECT distinct VendorID FROM  `ny-rides-viktorija.de_zoomcamp.yellow_nonpartitioned_tripdata_2024`
WHERE DATE(tpep_dropoff_datetime) BETWEEN '2024-03-01' AND '2024-03-15';

SELECT distinct VendorID FROM  `ny-rides-viktorija.de_zoomcamp.yellow_partitioned_tripdata_2024`
WHERE DATE(tpep_dropoff_datetime) BETWEEN '2024-03-01' AND '2024-03-15';
