import requests
import psycopg2
from datetime import datetime
from dateutil import parser

# PostgreSQL DB connection
db_params = {
    "dbname": "video_storage",
    "user": "replace",
    "password": "replace", 
    "host": "replace",
    "port": #replace
}

def get_gps_data():
    conn = psycopg2.connect(**db_params)
    cursor = conn.cursor()
    cursor.execute("SELECT gps_id, latitude, longitude, timestamp FROM gps_data;")
    rows = cursor.fetchall()
    conn.close()
    return rows

def get_weather(lat, lon, ts):
    # Format date and extract hour
    date_str = ts.strftime('%Y-%m-%d')
    hour_str = ts.strftime('%H:00')

    # Open-Meteo API URL
    url = (
        f"https://archive-api.open-meteo.com/v1/archive?"
        f"latitude={lat}&longitude={lon}"
        f"&start_date={date_str}&end_date={date_str}"
        f"&hourly=temperature_2m&timezone=auto"
    )

    response = requests.get(url)
    if response.status_code != 200:
        print(f"API request failed: {response.status_code}")
        return None

    data = response.json()
    times = data.get("hourly", {}).get("time", [])
    temps = data.get("hourly", {}).get("temperature_2m", [])

    for t, temp in zip(times, temps):
        if hour_str in t:
            return temp  # in Celsius

    return None

def insert_weather_data(gps_id, temperature, timestamp):
    conn = psycopg2.connect(**db_params)
    cursor = conn.cursor()
    cursor.execute("""
        INSERT INTO weather_data (gps_id, temperature, timestamp)
        VALUES (%s, %s, %s)
        ON CONFLICT (gps_id) DO NOTHING;
    """, (gps_id, temperature, timestamp))
    conn.commit()
    conn.close()

def main():
    gps_rows = get_gps_data()
    for gps_id, lat, lon, ts in gps_rows:
        print(f"Getting weather for GPS ID {gps_id} at ({lat}, {lon}) — {ts}")
        temp = get_weather(lat, lon, ts)
        if temp is not None:
            f_temp = round((temp * 9/5) + 32, 1)
            print(f"Temperature: {f_temp}°F — inserting into DB...")
            insert_weather_data(gps_id, f_temp, ts)

            insert_weather_data(gps_id, temp, ts)
        else:
            print(f"Skipped GPS ID {gps_id} — no temperature data found.")

if __name__ == "__main__":
    main()
