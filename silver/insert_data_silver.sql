CREATE OR ALTER PROCEDURE truncate_and_insert_into_silver_layer AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @start_time DATETIME;
	DECLARE @end_time DATETIME;
	DECLARE @current_date DATE;
	DECLARE @max_date DATE;
	SET @start_time=GETDATE();

	SELECT
		@current_date=CAST(MIN(timestamp) AS DATE ),
		@max_date=CAST(MAX(timestamp) AS DATE )
		FROM bronze.data;

	
		TRUNCATE TABLE silver.data;

	WHILE @current_date <= @max_date
    BEGIN
		PRINT '===============================================================';
        PRINT 'Processing data for date: ' + CAST(@current_date AS VARCHAR(10));
		PRINT '===============================================================';


			WITH correct_datatype_data_bronze_data AS (
			SELECT 
				station_code,
				CAST(timestamp AS DATETIME) AS date,
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
			WHERE CAST(timestamp AS DATE) BETWEEN DATEADD(day, -2, @current_date) AND @current_date
			),
			rolling_avg AS(
			SELECT 
			station_code,
			date,
			pm25,
			pm10,
			no,
			no2,
			so2,
			co,
			AVG(co) OVER(PARTITION BY station_code ORDER BY date ROWS BETWEEN 3 PRECEDING AND CURRENT ROW) AS rolling_co_1h,
			nox,
			ozone,
			AVG(ozone) OVER(PARTITION BY station_code ORDER BY date ROWS BETWEEN 31 PRECEDING AND CURRENT ROW) AS rolling_ozone_8h,
			at,
			rh,
			ws,
			vws,
			wd,
			bp,
			nh3,
			benzene,
			eth_benzene,
			toluene,
			mp_xylene,
			xylene
			FROM correct_datatype_data_bronze_data
			)



		INSERT INTO silver.data
		(station_code,date,pm25_avg,pm25_max,pm10_avg,pm10_max,no_avg,no_max,no2_avg,no2_max,so2_avg,
		so2_max,co_avg,co_max,nox_avg,nox_max,ozone_avg,ozone_max,at_avg,at_max,rh_avg,rh_max,ws_avg,ws_max,
		vws_avg,vws_max,wd_avg,wd_max,bp_avg,bp_max,nh3_avg,nh3_max,benzene_avg,benzene_max,
		eth_benzene_avg,eth_benzene_max,toluene_avg,toluene_max,mp_xylene_avg,mp_xylene_max,
		xylene_avg,xylene_max )
		SELECT
		station_code,
		CAST(date AS DATE) AS date,
		AVG(pm25),
		MAX(pm25),
		AVG(pm10),
		MAX(pm10),
		AVG(no),
		MAX(no),
		AVG(no2),
		MAX(no2),
		AVG(so2),
		MAX(so2),
		MAX(rolling_co_1h),
		MAX(co),
		AVG(nox),
		MAX(nox),
		MAX(rolling_ozone_8h),
		MAX(ozone),
		AVG(at),
		MAX(at),
		AVG(rh),
		MAX(rh),
		AVG(ws),
		MAX(ws),
		AVG(vws),
		MAX(vws),
		AVG(wd),
		MAX(wd),
		AVG(bp),
		MAX(bp),
		AVG(nh3),
		MAX(nh3),
		AVG(benzene),
		MAX(benzene),
		AVG(eth_benzene),
		MAX(eth_benzene),
		AVG(toluene),
		MAX(toluene),
		AVG(mp_xylene),
		MAX(mp_xylene),
		AVG(xylene),
		MAX(xylene)
		FROM rolling_avg
		WHERE CAST(date AS DATE) = @current_date
		GROUP BY station_code,CAST(date AS DATE)

		SET @current_date = DATEADD(day, 1, @current_date);
	END


	SET @end_time=GETDATE();

	PRINT 'Time Taken: ' + CAST( DATEDIFF(second,@start_time,@end_time) AS NVARCHAR );

END
