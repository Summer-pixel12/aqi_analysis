INSERT INTO silver.stations(
id,station_code,city,state_code,pin_code,latitude,longitude,elevation_m,topo_complexity,coastal_proximity,valley_factor
)
SELECT
*
FROM bronze.stations
WHERE station_code NOT LIKE 'UN%'
