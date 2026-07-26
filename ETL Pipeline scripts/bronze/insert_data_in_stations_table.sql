--This is the query to insert data into the bronze.stations table in ms sql server
BULK INSERT bronze.stations
FROM 'C:\Users\harsh\Downloads\india_aqi\stations.csv'
WITH (
FIRSTROW=2,
FIELDTERMINATOR=',',
ROWTERMINATOR = '\n'
)
