--These are the indexes to be created on the bronze layer tables so that the queries 
--run efficiently and also the storage is efficient

--Clustered columnstore index on the table bronze.data 
CREATE CLUSTERED COLUMNSTORE INDEX CCI_bronze_data 
ON bronze.data;

--Nonclustered index on bronze.data on the column timestamp including station_code
CREATE NONCLUSTERED INDEX IX_BronzeData_Date 
ON bronze.data (timestamp) 
INCLUDE (station_code);
