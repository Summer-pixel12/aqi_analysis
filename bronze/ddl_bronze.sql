CREATE DATABASE aqi_report;
USE aqi_report;

CREATE SCHEMA bronze;
CREATE SCHEMA silver;
CREATE SCHEMA gold;

IF OBJECTID('bronze.data','U') IS NOT NULL
  DROP TABLE bronze.data;

CREATE TABLE bronze.data(
station_code NVARCHAR(50),
pm25 NVARCHAR(50),
pm10 NVARCHAR(50),
no NVARCHAR(50),
no2 NVARCHAR(50),
so2 NVARCHAR(50),
co NVARCHAR(50),
nox NVARCHAR(50),
ozone NVARCHAR(50),
at NVARCHAR(50),
rh NVARCHAR(50),
ws NVARCHAR(50),
vws NVARCHAR(50),
wd NVARCHAR(50),
bp NVARCHAR(50),
timestamp NVARCHAR(30),
nh3 NVARCHAR(50),
benzene NVARCHAR(50),
eth_benzene NVARCHAR(50),
toluene NVARCHAR(50),
mp_xylene NVARCHAR(50),
xylene NVARCHAR(50)
)

IF OBJECTID('bronze.stations','U') IS NOT NULL
  DROP TABLE bronze.stations;

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
