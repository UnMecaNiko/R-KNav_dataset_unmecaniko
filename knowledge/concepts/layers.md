# Three layers (do not mix the tools)

The usual confusion: treating Rosetta, Nav2, the visualizer and training as one single pipe. They are not.

```
┌─────────────────────────────────────────────────────────┐
│  ROBOT / SIM                                            │
│  ROS 2 topics: /camera, /odom, /cmd_vel, GPS            │
│  Nav2  = one possible writer of /cmd_vel                │
│  RViz  = a window onto those topics                     │
│  TurtleBot in Gazebo = another body, same Twist types   │
└───────────────────────────┬─────────────────────────────┘
                            │ rosbag / MCAP
                            ▼
┌─────────────────────────────────────────────────────────┐
│  ROSETTA  (translator)                                  │
│  YAML contract: ROS 2 topic  ↔  LeRobot feature         │
│  Forward:  bag → parquet + mp4                          │
│  Back (optional): policy → /cmd_vel                     │
│  It does not "plug into Nav2". Nav2 is a Twist source.  │
└───────────────────────────┬─────────────────────────────┘
                            ▼
┌─────────────────────────────────────────────────────────┐
│  LEROBOT DATASET                                        │
│  observation.image.*  observation.state  action  task   │
│  HF Visualizer = inspection (includes the "jerky" tag)  │
└───────────────────────────┬─────────────────────────────┘
                            │  only if training happens
                            ▼
┌─────────────────────────────────────────────────────────┐
│  POLICY (ACT, SmolVLA, …)                               │
│  in: video + state (+ text) → out: Twist                │
│  It replaces Nav2 at the wheel, it does not go inside.  │
└─────────────────────────────────────────────────────────┘
```

**Nav2 + images:** classic Nav2 uses a map, odom, often laser/costmap. It does not consume R-KNav's MP4 files. Vision + Nav2 is a different stack. In this lab, Nav2 comes in **following a route** (GPS mapped into a local frame), not the video.

**Video → model:** the LeRobot thread, later. It does not block GPS, odom or TurtleBot.
