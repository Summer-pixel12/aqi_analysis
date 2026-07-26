--This is the SQL for data definition for the bronze layer 
--These are to be executed first in order to create the necessary tables in ms sql server 


--creating the database inside ms sql server
CREATE DATABASE aqi_report;

--use the created DB 
USE aqi_report;

--Creating the necessary schemas
CREATE SCHEMA bronze;
CREATE SCHEMA silver;
CREATE SCHEMA gold;

--dropping the table with the same name if it exists
IF OBJECTID('bronze.data','U') IS NOT NULL
  DROP TABLE bronze.data;

--The main recording table is created here where the data will be extracteed
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

--dropping the table with the same name if it exists
IF OBJECTID('bronze.stations','U') IS NOT NULL
  DROP TABLE bronze.stations;

--creating the table for the information of the stations
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
