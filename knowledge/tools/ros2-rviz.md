# ROS 2, RViz y Nav2

Nicolas ya usó la idea en **ROS 1** (TurtleBot). Ahora el entorno de estudio es **ROS 2 Jazzy** en Ubuntu 24.04 / WSL 2 (metapaquete desktop). Mapa de tutoriales oficiales (no reescribirlos): [ros2-jazzy-tutorials.md](https://github.com/UnMecaNiko/unmecaniko-projects/blob/main/knowledge/robotics/ros2-jazzy-tutorials.md) en el repo principal.

## ROS 2

Bus de mensajes: nodos publican/escuchan **topics**. En un rover tipo R-Kiwi, de forma típica (nombres reales de su flota: no publicados en el sample):

| Idea | Mensaje | En LeRobot |
|---|---|---|
| Cámaras | `sensor_msgs/Image` | `observation.image.*` |
| Odometría | `nav_msgs/Odometry` | `observation.state` (twist medido) |
| Comando | `geometry_msgs/Twist` (`/cmd_vel`) | `action` |
| GPS | `sensor_msgs/NavSatFix` | `observation.state.waypoints` (si confirma WGS84) |
| TF | `tf2` | hay que reconstruirlo en sim |

R-KNav se grabó en ROS 2 y luego se aplanó. Ver un episodio en RViz es **reconstruir topics**, no “abrir el parquet con RViz”.

## RViz

Visor 3D. No entrena. Displays: Image, Odometry, Path, TF, marcadores de Twist. El Space de Hugging Face enseña vídeo + curvas 2D. RViz enseña el mismo instante en el **marco del robot**. Guía: [RViz — Jazzy](https://docs.ros.org/en/jazzy/Tutorials/Intermediate/RViz/RViz-Main.html).

## Nav2

Stack de navegación de ROS 2: mapa, planificador, controlador, recoveries. Docs: [docs.nav2.org](https://docs.nav2.org/). El R-Kiwi autónomo usa una versión custom + GPS/RTK + OSM. Nav2 **no** está en los tutoriales básicos de Jazzy.

Replay de un episodio enseña lo que el robot **hizo**, no la decisión interna de Nav2.

En este lab, Nav2 entra cuando haya una **ruta** (GPS → frame local → `nav_msgs/Path`) para que un TurtleBot la siga. No se le pasan los MP4.

## TurtleBot en sim

Replay en lazo abierto: publicar `/cmd_vel` del episodio. Sirve para aprender ROS 2, Gazebo y RViz. **No** recrea el campus (otro robot, otra escala, sin acera). El camino se parecerá un rato y luego el drift — el mismo fenómeno que odom vs GPS.

TurtleBot 4 es el objetivo natural en Jazzy; TurtleBot 3 también tiene material de comunidad. Elegir uno y documentarlo en el experimento cuando se implemente.
