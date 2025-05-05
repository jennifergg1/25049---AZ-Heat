# 25049---AZ-Heat— Software System Overview

This software supports the AZ Heat Medicine project by processing drone-collected footage to detect individuals in high-temperature areas and assess potential heat stress or dehydration risk.

## 📦 What's Included

| File/Folder               | Description |
|--------------------------|-------------|
| `fetch_weather_data.py`  | Retrieves historical weather data using GPS and timestamps and stores it in `weather_data` table. |
| `codeTables.sql`      | Creates PostgreSQL tables: `videos`, `gps_data`, `weather_data`, and `test_results`. |
| `correlation_query.sql`  | SQL query that joins detection, weather, and risk assessment data into a unified view. |
| `heatMap.py`| Generates a heatmap showing high-temperature detection zones using Folium. |
| `README.md`              | Project documentation (this file). |

---

## 🧠 System Overview

The system follows this data flow:

1. **Video Upload** — Drone captures and uploads video to cloud storage (Google Drive).
2. **Metadata Insertion** — Video info, GPS, and timestamps are logged into a PostgreSQL database.
3. **YOLO Detection (Post-Flight)** — Object detection is performed after the flight to identify individuals in footage.
4. **Weather Retrieval** — Historical temperature data is pulled using coordinates and timestamps from Open-Meteo.
5. **Correlation Module** — Data from detection and weather is merged to assess risk (e.g., "Dehydrated").
6. **Test Results Table** — Flags each GPS detection with a visual cue and reasoning.

---

## 🗄️ Database Tables

- `videos`: Stores video URL, timestamp, and location
- `gps_data`: Logs GPS coordinates and timestamps for detections
- `weather_data`: Stores temperature data linked by GPS ID
- `test_results`: Flags detections as Dehydrated or Safe with cues and risk reasoning

---

For more details see SDD
