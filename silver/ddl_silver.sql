CREATE TABLE silver.data(
station_code VARCHAR(10),
pm25 FLOAT,
pm10 FLOAT,
no FLOAT,
no2 FLOAT,
so2 FLOAT,
co FLOAT,
nox FLOAT,
ozone FLOAT,
at FLOAT,
rh FLOAT,
ws FLOAT,
vws FLOAT,
wd FLOAT,
bp FLOAT,
date DATETIME ,
nh3 FLOAT,
benzene FLOAT,
eth_benzene FLOAT,
toluene FLOAT,
mp_xylene FLOAT,
xylene FLOAT
);

CREATE TABLE silver.stations(
	id INT,
	station_code NVARCHAR(50),
	city NAVARCHAR(50),
	state_code NVARCHAR(50),
	pin_code INT,
	latitude FLOAT,
	longitude FLOAT,
	elevation_m INT,
	topo_complexity FLOAT,
	coastal_proximity FLOAT,
	valley_factor FLOAT
);
