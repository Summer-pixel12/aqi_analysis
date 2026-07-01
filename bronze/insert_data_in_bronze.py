import pandas as pd
import glob
import os
import pyodbc

# ==========================================
# 1. DATABASE CONFIGURATION (MS SQL SERVER)
# ==========================================
conn_str = (
    r'DRIVER={ODBC Driver 17 for SQL Server};'
    r'SERVER=localhost\SQLEXPRESS;' 
    r'DATABASE=aqi_report;'   
    r'Trusted_Connection=yes;'
)

conn = pyodbc.connect(conn_str)
cursor = conn.cursor()

# ==========================================
# 2. DISCOVER STATION CSV FILES RECURSIVELY
# ==========================================
main_folder_path = r"C:\Users\harsh\Downloads\india_aqi" 

search_pattern = os.path.join(main_folder_path, "**", "*.csv")
all_files = glob.glob(search_pattern, recursive=True)

# Ignore 'stations.csv' lookup file
all_station_files = [f for f in all_files if "stations.csv" not in os.path.basename(f).lower()]

print(f"Found {len(all_station_files)} station files across state folders.")
print("Initiating raw NVARCHAR bulk staging transfer...\n")

# ==========================================
# 3. ETL PIPELINE AND BULK INGESTION LOOP
# ==========================================
for i, filename in enumerate(all_station_files):
    station_id = os.path.basename(filename).split('.')[0]
    
    # Load CSV as pure strings right from the start
    df = pd.read_csv(filename, dtype=str)
    
    # Structural column alignment
    expected_csv_cols = [
        'pm2.5', 'pm10', 'no', 'no2', 'so2', 'co', 'nox', 'ozone', 'at', 'rh', 
        'ws', 'vws', 'wd', 'bp', 'timestamp', 'nh3', 'benzene', 'eth_benzene', 
        'toluene', 'mp_xylene', 'xylene'
    ]
    df = df.reindex(columns=expected_csv_cols)
    
    # Prepend the station code
    df.insert(0, 'station_code', station_id)
    
    # Convert Pandas NaNs to Python None objects
    df = df.where(pd.notnull(df), None)
    
    # Convert to a list of tuples
    raw_records = [tuple(x) for x in df.to_numpy()]
    
    # 🌟 CRITICAL FIX: Explicitly cast every non-null value to a standard string primitive.
    # This strips away any underlying numpy float behaviors that trick the ODBC driver.
    records = []
    for row in raw_records:
        cleaned_row = tuple((None if val is None or val == "nan" else str(val)) for val in row)
        records.append(cleaned_row)
    
    # Construct parameterized insert query (22 columns)
    query = f"INSERT INTO bronze.data VALUES ({','.join(['?']*22)})"
    
    # Fire fast batch loading mechanism
    cursor.fast_executemany = True
    cursor.executemany(query, records)
    conn.commit()
    
    if (i + 1) % 5 == 0:
        print(f"Progress: Successfully staged {i + 1} / {len(all_station_files)} files.")

cursor.close()
conn.close()
