# ROS 2, RViz and Nav2

Nicolas already used the idea in **ROS 1** (TurtleBot). The study environment now is **ROS 2 Jazzy** on Ubuntu 24.04 / WSL 2 (desktop metapackage). Map of the official tutorials (do not rewrite them): [ros2-jazzy-tutorials.md](https://github.com/UnMecaNiko/unmecaniko-projects/blob/main/knowledge/robotics/ros2-jazzy-tutorials.md) in the main repo.

## ROS 2

A message bus: nodes publish to and listen on **topics**. On an R-Kiwi-style rover, typically (their fleet's real topic names are not published in the sample):

| Idea | Message | In LeRobot |
|---|---|---|
| Cameras | `sensor_msgs/Image` | `observation.image.*` |
| Odometry | `nav_msgs/Odometry` | `observation.state` (measured twist) |
| Command | `geometry_msgs/Twist` (`/cmd_vel`) | `action` |
| GPS | `sensor_msgs/NavSatFix` | `observation.state.waypoints` (if WGS84 is confirmed) |
| TF | `tf2` | has to be rebuilt in sim |

R-KNav was recorded in ROS 2 and then flattened. Seeing an episode in RViz means **reconstructing topics**, not "opening the parquet with RViz".

## RViz

A 3D viewer. It does not train. Displays: Image, Odometry, Path, TF, Twist markers. The Hugging Face Space shows video + 2D curves. RViz shows the same instant in the **robot frame**. Guide: [RViz — Jazzy](https://docs.ros.org/en/jazzy/Tutorials/Intermediate/RViz/RViz-Main.html).

## Nav2

The ROS 2 navigation stack: map, planner, controller, recoveries. Docs: [docs.nav2.org](https://docs.nav2.org/). The autonomous R-Kiwi uses a custom version + GPS/RTK + OSM. Nav2 is **not** part of the basic Jazzy tutorials.

Replaying an episode shows what the robot **did**, not Nav2's internal decision.

In this lab, Nav2 comes in once there is a **route** (GPS → local frame → `nav_msgs/Path`) for a TurtleBot to follow. The MP4 files are not fed to it.

## TurtleBot in sim

Open-loop replay: publish the episode's `/cmd_vel`. Good for learning ROS 2, Gazebo and RViz. It does **not** recreate the campus (different robot, different scale, no sidewalk). The path will match for a while and then drift — the same phenomenon as odom vs GPS.

TurtleBot 4 is the natural target on Jazzy; TurtleBot 3 also has plenty of community material. Pick one and document it in the experiment when implementing it.
