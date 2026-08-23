# NVIDIA (Isaac sí, Alpamayo no como primer paso)

R-KNav es un **rover de acera**, 10 fps, 4 cámaras chicas, sin LiDAR, acción `Twist`.

**Isaac Sim / Isaac Lab / Cosmos** son la familia NVIDIA que encaja *de lejos*: simulación de un diferencial, mismo tipo de acción, LeRobot se está integrando con Isaac Lab Arena. Arena hoy está muy orientada a humanoides; un rover hay que armarlo. Cosmos puede retexturizar vídeo de sim. **No** se “meten” los MP4 de R-KNav dentro de Isaac como si fueran la escena. El cruce útil es: mismo formato LeRobot + comparar histogramas de acción real vs sim.

**Alpamayo / AlpaSim / DRIVE** son VLA de **auto** (trayectoria de vehículo, LiDAR, calles). Otro dominio. Un paper de domain gap, no el primer laboratorio.

Hardware: Isaac y Cosmos quieren GPU NVIDIA de verdad. Sin ella, el techo es el sample + ROS 2 en WSL/Gazebo.

En el roadmap, NVIDIA queda **después** de GPS, odom y TurtleBot, salvo que Nicolas decida subir Isaac como experimento explícito.
