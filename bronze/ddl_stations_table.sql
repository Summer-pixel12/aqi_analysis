IF OBJECTID('bronze.stations','U') IS NOT NULL
  DROP TABLE bronze.stations

CREATE TABLE bronze.stations(
id INT,
station_code VARCHAR(10),
city VARCHAR(50),
state_code VARCHAR(3),
pin_code INT,
latitude FLOAT,
longitude FLOAT,
elevation_m FLOAT,
topo_complexity FLOAT,
coastal_proximity FLOAT,
valley_factor FLOAT
)
