# Capture pipeline (according to Robot.com)

How the data was born. This lab does not reimplement the capture; it does have to respect the meaning of each field.

```
R-Kiwi fleet (ROS 2)
  custom Nav2  or  teleoperator   →  /cmd_vel
  4 cameras, GPS/RTK, IMU, odom
        ↓
   rosbag (hours)
        ↓  trimming by motion, GPS, turns
   episode MCAP + YAML (instruction, weather, surface)
        ↓  adapted Rosetta + topic contract
   LeRobot v3  (parquet + mp4, 10 fps)
        ↓  VLM over the front camera
   natural-language task
```

Synchronization: *as-of-nearest* against the front camera timestamp (H.264 compression and sensors running at different rates).

Production autonomy: Nav2 + GPS/RTK (RTCM over cellular/Wi-Fi) + OSM mesh. Collection for this set: open campuses with good GPS. The factory LiDAR is not published.

Rosetta: [knowledge/tools/rosetta.md](../tools/rosetta.md).
