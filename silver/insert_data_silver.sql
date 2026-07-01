CREATE OR ALTER PROCEDURE truncate_and_insert_into_silver_layer AS
BEGIN
	DECLARE @start_time DATETIME;
	DECLARE @end_time DATETIME;
	SET @start_time=GETDATE();

	TRUNCATE TABLE silver.data;

	INSERT INTO silver.data
	(station_code,pm25,pm10,no,no2,so2,co,nox,ozone,at,rh,ws,vws,wd,bp,date,nh3,benzene,eth_benzene,toluene,mp_xylene,xylene)
	SELECT 
		station_code,
		CASE 
			WHEN pm25='nan' THEN NULL
			ELSE CAST(pm25 AS FLOAT)
			END AS pm25,
		CASE 
			WHEN pm10='nan' THEN NULL
			ELSE CAST(pm10 AS FLOAT)
			END AS pm10,
		CASE 
			WHEN no='nan' THEN NULL
			ELSE CAST(no AS FLOAT)
			END AS no,
		CASE 
			WHEN no2='nan' THEN NULL
			ELSE CAST(no2 AS FLOAT)
			END AS no2,
		CASE 
			WHEN so2='nan' THEN NULL
			ELSE CAST(so2 AS FLOAT)
			END AS so2,
		CASE 
			WHEN co='nan' THEN NULL
			ELSE CAST(co AS FLOAT)
			END AS co,
		CASE 
			WHEN nox='nan' THEN NULL
			ELSE CAST(nox AS FLOAT)
			END AS nox,
		CASE 
			WHEN ozone='nan' THEN NULL
			ELSE CAST(ozone AS FLOAT)
			END AS ozone,
		CASE 
			WHEN at='nan' THEN NULL
			ELSE CAST(at AS FLOAT)
			END AS at,
		CASE 
			WHEN rh='nan' THEN NULL
			ELSE CAST(rh AS FLOAT)
			END AS rh,
		CASE 
			WHEN ws='nan' THEN NULL
			ELSE CAST(ws AS FLOAT)
			END AS ws,
		CASE 
			WHEN vws='nan' THEN NULL
			ELSE CAST(vws AS FLOAT)
			END AS vws,
		CASE 
			WHEN wd='nan' THEN NULL
			ELSE CAST(wd AS FLOAT)
			END AS wd,
		CASE 
			WHEN bp='nan' THEN NULL
			ELSE CAST(bp AS FLOAT)
			END AS bp,
		CAST(timestamp AS DATETIME) AS date,
		CASE 
			WHEN nh3='nan' THEN NULL
			ELSE CAST(nh3 AS FLOAT)
			END AS nh3,
		CASE 
			WHEN benzene='nan' THEN NULL
			ELSE CAST(benzene AS FLOAT)
			END AS benzene,
		CASE 
			WHEN eth_benzene='nan' THEN NULL
			ELSE CAST(eth_benzene AS FLOAT)
			END AS eth_benzene,
		CASE 
			WHEN toluene='nan' THEN NULL
			ELSE CAST(toluene AS FLOAT)
			END AS toluene,
		CASE 
			WHEN mp_xylene='nan' THEN NULL
			ELSE CAST(mp_xylene AS FLOAT)
			END AS mp_xylene,
		CASE 
			WHEN xylene='nan' THEN NULL
			ELSE CAST(xylene AS FLOAT)
			END AS xylene
	FROM bronze.data

	SET @end_time=GETDATE();

	PRINT 'Time Taken: ' + CAST( DATEDIFF(second,@start_time,@end_time) AS NVARCHAR );

END
