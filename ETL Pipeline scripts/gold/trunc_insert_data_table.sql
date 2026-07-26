-- This stored procedure is used to insert the data from silver.data into gold.data 
-- To execute this procedure use the below query
-- EXEC truncate_and_insert_into_gold_layer_data

--Below are the calculations and transformations done for the gold layer
--1.In this step the daily aqi for each station is calculated 
--2.If the AQI is crossing the maximum 500 mark then the AQI is capped to 500
--3.The names of the columns have been updated to meaningful and understandable names

CREATE OR ALTER PROCEDURE truncate_and_insert_into_gold_layer_data AS
BEGIN
    DECLARE @start_time DATETIME;
	DECLARE @end_time DATETIME;
	SET @start_time=GETDATE();

    TRUNCATE TABLE gold.data;


    INSERT INTO gold.data (
        station_code, date, aqi,
        pm25_avg, pm25_max, pm10_avg, pm10_max,
        no_avg, no_max, no2_avg, no2_max, so2_avg, so2_max,
        co_avg, co_max, nox_avg, nox_max, ozone_avg, ozone_max,
        nh3_avg, nh3_max, benzene_avg, benzene_max,
        eth_benzene_avg, eth_benzene_max, toluene_avg, toluene_max,
        mp_xylene_avg, mp_xylene_max, xylene_avg, xylene_max,
        atmospheric_temperature_avg, atmospheric_temperature_max,
        relative_humidity_avg, relative_humidity_max,
        wind_speed_avg, wind_speed_max,
        vertical_wind_shear_avg, vertical_wind_shear_max,
        wind_direction_avg, wind_direction_max,
        barometric_pressure_avg, barometric_pressure_max
    )
    SELECT 
        org.station_code,
        org.date,
        CAST(CASE 
            WHEN mx.max_raw_index > 500 THEN 500 
            ELSE mx.max_raw_index 
        END AS INT) AS aqi,
        org.pm25_avg, org.pm25_max, org.pm10_avg, org.pm10_max,
        org.no_avg, org.no_max, org.no2_avg, org.no2_max, org.so2_avg, org.so2_max,
        org.co_avg, org.co_max, org.nox_avg, org.nox_max, org.ozone_avg, org.ozone_max,
        org.nh3_avg, org.nh3_max, org.benzene_avg, org.benzene_max,
        org.eth_benzene_avg, org.eth_benzene_max, org.toluene_avg, org.toluene_max,
        org.mp_xylene_avg, org.mp_xylene_max, org.xylene_avg, org.xylene_max,
        org.at_avg AS atmospheric_temperature_avg,
        org.at_max AS atmospheric_temperature_max,
        org.rh_avg AS relative_humidity_avg,
        org.rh_max AS relative_humidity_max,
        org.ws_avg AS wind_speed_avg,
        org.ws_max AS wind_speed_max,
        org.vws_avg AS vertical_wind_shear_avg,
        org.vws_max AS vertical_wind_shear_max,
        org.wd_avg AS wind_direction_avg,
        org.wd_max AS wind_direction_max,
        org.bp_avg AS barometric_pressure_avg,
        org.bp_max AS barometric_pressure_max
    FROM silver.data org

    CROSS APPLY (
        SELECT MAX(v) FROM (VALUES         
            -- PM2.5 AQI Calculation
            (CASE 
                WHEN org.pm25_avg >= 0   AND org.pm25_avg <= 30   THEN 1.0 * (50-0)    / (30-0)      * (org.pm25_avg-0)   + 0
                WHEN org.pm25_avg > 30   AND org.pm25_avg <= 60   THEN 1.0 * (100-51)  / (60-30)     * (org.pm25_avg-30)  + 51
                WHEN org.pm25_avg > 60   AND org.pm25_avg <= 90   THEN 1.0 * (200-101) / (90-60)     * (org.pm25_avg-60)  + 101
                WHEN org.pm25_avg > 90   AND org.pm25_avg <= 120  THEN 1.0 * (300-201) / (120-90)    * (org.pm25_avg-90)  + 201
                WHEN org.pm25_avg > 120  AND org.pm25_avg <= 250  THEN 1.0 * (400-301) / (250-120)   * (org.pm25_avg-120) + 301
                WHEN org.pm25_avg > 250                           THEN 1.0 * (500-401) / (500-250)   * (org.pm25_avg-250) + 401
             END),
            -- PM10 AQI Calculation
            (CASE 
                WHEN org.pm10_avg >= 0   AND org.pm10_avg <= 50   THEN 1.0 * (50-0)    / (50-0)      * (org.pm10_avg-0)   + 0
                WHEN org.pm10_avg > 50   AND org.pm10_avg <= 100  THEN 1.0 * (100-51)  / (100-50)    * (org.pm10_avg-50)  + 51
                WHEN org.pm10_avg > 100  AND org.pm10_avg <= 250  THEN 1.0 * (200-101) / (250-100)   * (org.pm10_avg-100) + 101
                WHEN org.pm10_avg > 250  AND org.pm10_avg <= 350  THEN 1.0 * (300-201) / (350-250)   * (org.pm10_avg-250) + 201
                WHEN org.pm10_avg > 350  AND org.pm10_avg <= 430  THEN 1.0 * (400-301) / (430-350)   * (org.pm10_avg-350) + 301
                WHEN org.pm10_avg > 430                           THEN 1.0 * (500-401) / (500-430)   * (org.pm10_avg-430) + 401
             END),
            -- CO AQI Calculation
            (CASE 
                WHEN org.co_avg >= 0     AND org.co_avg <= 1.0    THEN 1.0 * (50-0)    / (1.0-0)     * (org.co_avg-0)    + 0
                WHEN org.co_avg > 1.0    AND org.co_avg <= 2.0    THEN 1.0 * (100-51)  / (2.0-1.0)   * (org.co_avg-1.0)  + 51
                WHEN org.co_avg > 2.0    AND org.co_avg <= 10.0   THEN 1.0 * (200-101) / (10-2.0)    * (org.co_avg-2.0)  + 101
                WHEN org.co_avg > 10.0   AND org.co_avg <= 17.0   THEN 1.0 * (300-201) / (17-10.0)   * (org.co_avg-10.0) + 201
                WHEN org.co_avg > 17.0   AND org.co_avg <= 34.0   THEN 1.0 * (400-301) / (34-17.0)   * (org.co_avg-17.0) + 301
                WHEN org.co_avg > 34.0                            THEN 1.0 * (500-401) / (50-34.0)   * (org.co_avg-34.0) + 401
             END),
            -- Ozone AQI Calculation
            (CASE 
                WHEN org.ozone_avg >= 0  AND org.ozone_avg <= 50  THEN 1.0 * (50-0)    / (50-0)      * (org.ozone_avg-0)   + 0
                WHEN org.ozone_avg > 50  AND org.ozone_avg <= 100 THEN 1.0 * (100-51)  / (100-50)    * (org.ozone_avg-50)  + 51
                WHEN org.ozone_avg > 100 AND org.ozone_avg <= 168 THEN 1.0 * (200-101) / (168-100)   * (org.ozone_avg-100) + 101
                WHEN org.ozone_avg > 168 AND org.ozone_avg <= 208 THEN 1.0 * (300-201) / (208-168)   * (org.ozone_avg-168) + 201
                WHEN org.ozone_avg > 208 AND org.ozone_avg <= 748 THEN 1.0 * (400-301) / (748-208)   * (org.ozone_avg-208) + 301
                WHEN org.ozone_avg > 748                          THEN 1.0 * (500-401) / (1000-748)  * (org.ozone_avg-748) + 401
             END),
            -- NO2 AQI Calculation
            (CASE 
                WHEN org.no2_avg >= 0    AND org.no2_avg <= 40   THEN 1.0 * (50-0)    / (40-0)      * (org.no2_avg-0)   + 0
                WHEN org.no2_avg > 40    AND org.no2_avg <= 80   THEN 1.0 * (100-51)  / (80-40)     * (org.no2_avg-40)  + 51
                WHEN org.no2_avg > 80    AND org.no2_avg <= 180  THEN 1.0 * (200-101) / (180-80)    * (org.no2_avg-80)  + 101
                WHEN org.no2_avg > 180   AND org.no2_avg <= 280  THEN 1.0 * (300-201) / (280-180)   * (org.no2_avg-180) + 201
                WHEN org.no2_avg > 280   AND org.no2_avg <= 400  THEN 1.0 * (400-301) / (400-280)   * (org.no2_avg-280) + 301
                WHEN org.no2_avg > 400                           THEN 1.0 * (500-401) / (500-400)   * (org.no2_avg-400) + 401
             END),
            -- SO2 AQI Calculation
            (CASE 
                WHEN org.so2_avg >= 0    AND org.so2_avg <= 40   THEN 1.0 * (50-0)    / (40-0)      * (org.so2_avg-0)   + 0
                WHEN org.so2_avg > 40    AND org.so2_avg <= 80   THEN 1.0 * (100-51)  / (80-40)     * (org.so2_avg-40)  + 51
                WHEN org.so2_avg > 80    AND org.so2_avg <= 380  THEN 1.0 * (200-101) / (380-80)    * (org.so2_avg-80)  + 101
                WHEN org.so2_avg > 380   AND org.so2_avg <= 800  THEN 1.0 * (300-201) / (800-380)   * (org.so2_avg-380) + 201
                WHEN org.so2_avg > 800   AND org.so2_avg <= 1600 THEN 1.0 * (400-301) / (1600-800)  * (org.so2_avg-800) + 301
                WHEN org.so2_avg > 1600                          THEN 1.0 * (500-401) / (2000-1600) * (org.so2_avg-1600) + 401
             END),
            -- NH3 AQI Calculation
            (CASE 
                WHEN org.nh3_avg >= 0    AND org.nh3_avg <= 200  THEN 1.0 * (50-0)    / (200-0)     * (org.nh3_avg-0)    + 0
                WHEN org.nh3_avg > 200   AND org.nh3_avg <= 400  THEN 1.0 * (100-51)  / (400-200)   * (org.nh3_avg-200)  + 51
                WHEN org.nh3_avg > 400   AND org.nh3_avg <= 800  THEN 1.0 * (200-101) / (800-400)   * (org.nh3_avg-400)  + 101
                WHEN org.nh3_avg > 800   AND org.nh3_avg <= 1200 THEN 1.0 * (300-201) / (1200-800)  * (org.nh3_avg-800)  + 201
                WHEN org.nh3_avg > 1200  AND org.nh3_avg <= 1800 THEN 1.0 * (400-301) / (1800-1200) * (org.nh3_avg-1200) + 301
                WHEN org.nh3_avg > 1800                          THEN 1.0 * (500-401) / (2400-1800) * (org.nh3_avg-1800) + 401
             END)
        ) AS dt(v)
    ) mx(max_raw_index)
     WHERE org.station_code NOT LIKE 'UN%';

    SET @end_time=GETDATE();

	PRINT 'Time Taken: ' + CAST( DATEDIFF(second,@start_time,@end_time) AS NVARCHAR );

END;


