SELECT 
  g.gps_id,
  g.video_id,
  g.latitude,
  g.longitude,
  g.timestamp AS detection_time,
  w.temperature,
  t.flag,
  t.visual_cue,
  t.risk_reason
FROM gps_data g
JOIN weather_data w ON g.gps_id = w.gps_id
JOIN test_results t ON g.gps_id = t.gps_id
ORDER BY g.gps_id;
