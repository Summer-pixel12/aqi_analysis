CREATE CLUSTERED COLUMNSTORE INDEX CCI_bronze_data 
ON bronze.data;

CREATE NONCLUSTERED INDEX IX_BronzeData_Date 
ON bronze.data (timestamp) 
INCLUDE (station_code);
