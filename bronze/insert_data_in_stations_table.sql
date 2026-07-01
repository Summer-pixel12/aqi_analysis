BULK INSERT bronze.stations
FROM 'C:\Users\harsh\Downloads\india_aqi\stations.csv'
WITH (
FIRSTROW=2,
FIELDTERMINATOR=',',
ROWTERMINATOR = '\n'
)
