# Pipeline de captura (según Robot.com)

Cómo nació el dato. Este lab no reimplementa la captura; sí debe respetar el sentido de cada campo.

```
Flota R-Kiwi (ROS 2)
  Nav2 custom  o  teleoperador   →  /cmd_vel
  4 cámaras, GPS/RTK, IMU, odom
        ↓
   rosbag (horas)
        ↓  recorte por movimiento, GPS, giros
   episodio MCAP + YAML (instrucción, clima, superficie)
        ↓  Rosetta adaptada + contrato de topics
   LeRobot v3  (parquet + mp4, 10 fps)
        ↓  VLM sobre cámara frontal
   task en lenguaje natural
```

Sincronización: *as-of-nearest* contra el timestamp de la cámara frontal (compresión H.264 y sensores a distinta tasa).

Autonomía de producción: Nav2 + GPS/RTK (RTCM por celular/Wi-Fi) + malla OSM. Recolección de este set: campus abiertos con buen GPS. LiDAR de fábrica no se publica.

Rosetta: [knowledge/tools/rosetta.md](../tools/rosetta.md).
