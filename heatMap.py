import folium
from folium.plugins import HeatMap
import psycopg2

# Connect to PostgreSQL
conn = psycopg2.connect(
    dbname="video_storage",
    user="your_username",
    password="your_password",
    host="localhost",
    port="5432"
)
cursor = conn.cursor()

# Fetch GPS + temperature data for the heatmap
cursor.execute("""
    SELECT latitude, longitude, temperature
    FROM gps_data
    JOIN weather_data ON gps_data.gps_id = weather_data.gps_id;
""")
rows = cursor.fetchall()
conn.close()

# Normalize temperature to control heatmap intensity
def normalize_temp(temp, min_temp=70, max_temp=110):
    return max(0.1, min(1.0, (temp - min_temp) / (max_temp - min_temp)))

# Create the heatmap points list: [lat, lon, weight]
heat_data = [
    [lat, lon, normalize_temp(temp)]
    for lat, lon, temp in rows
]

# Center the map around Tucson, AZ
map_center = [32.2217, -110.9265]
heatmap = folium.Map(location=map_center, zoom_start=12)

# Add the heat layer
HeatMap(heat_data, radius=15).add_to(heatmap)

# Save map to HTML file
heatmap.save("heatmap.html")
