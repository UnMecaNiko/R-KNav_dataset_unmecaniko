# Experiment: dead reckoning vs GPS

**Goal.** Integrate velocities into a 2D pose and see the drift against the GPS track (or against the waypoint, if it is not WGS84: integrated waypoint vs command).

There are two twists:

- `action` — the command
- `observation.state` — measured odometry  

Integrate both at 10 fps (unicycle model: \(\dot x = v\cos\theta\), \(\dot y = v\sin\theta\), \(\dot\theta = \omega\)). Three curves: GPS/waypoints, integrated odom, integrated commands.

**Why.** It explains the jerkiness, the slippage, and how faithful `action` is to the real motion. It is the conceptual bridge to the TurtleBot replay (open loop = the command curve).

**Output.** Script + figure (three tracks). `experiments/dead-reckoning-vs-gps/`.

**Status.** Pending code.
