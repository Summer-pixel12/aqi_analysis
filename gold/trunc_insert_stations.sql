--This procedure is used to insert the data from silver.stations into gold.stations 
--To execute this procedure use the below query
--EXEC truncate_and_insert_into_gold_layer_stations

--Additionally the state was determined from the state_code in this step

CREATE PROCEDURE truncate_and_insert_into_gold_layer_stations AS
BEGIN
	DECLARE @start_time DATETIME;
	DECLARE @end_time DATETIME;
	SET @start_time=GETDATE();

	TRUNCATE TABLE gold.stations;

	INSERT INTO gold.stations(
	station_code ,
	city ,
	state_code ,
	state ,
	pin_code ,
	latitude ,
	longitude ,
	elevation_m ,
	topo_complexity ,
	coastal_proximity ,
	valley_factor 
	)
	SELECT
	station_code ,
	city ,
	state_code ,
	CASE state_code 
		WHEN 'AP' THEN 'Andhra Pradesh' 
		WHEN 'AS' THEN 'Assam'
		WHEN 'BR' THEN 'Bihar'
		WHEN 'CG' THEN 'Chhattisgarh'
		WHEN 'DL' THEN 'Delhi'
		WHEN 'GJ' THEN 'Gujarat'
		WHEN 'HR' THEN 'Haryana'
		WHEN 'JH' THEN 'Jharkhand'
		WHEN 'KA' THEN 'Karnataka'
		WHEN 'KL' THEN 'Kerala'
		WHEN 'MH' THEN 'Maharashtra'
		WHEN 'MP' THEN 'Madhya Pradesh'
		WHEN 'OR' THEN 'Odisha'
		WHEN 'PB' THEN 'Punjab'
		WHEN 'RJ' THEN 'Rajasthan'
		WHEN 'TG' THEN 'Telangana'
		WHEN 'TN' THEN 'Tamil Nadu'
		WHEN 'UP' THEN 'Uttar Pradesh'
		WHEN 'WB' THEN 'West Bengal'
	END AS state,
	pin_code ,
	latitude ,
	longitude ,
	elevation_m ,
	topo_complexity ,
	coastal_proximity ,
	valley_factor 

	FROM silver.stations

	SET @end_time=GETDATE();

	PRINT 'Time Taken: ' + CAST( DATEDIFF(second,@start_time,@end_time) AS NVARCHAR );

END;
