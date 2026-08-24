# Experiment: Nav2 follows the route

**Goal.** Turn the track (GPS or local waypoints) into a `nav_msgs/Path` and have Nav2 follow it in sim with a TurtleBot.

**What it is not.** Feeding the cameras into Nav2. Nav2 navigates with map/costmap/odom. The video belongs to the LeRobot thread.

**Dependency.** The map experiment (local frame, units). Some TurtleBot replay work so the sim is ready.

**Output.** `experiments/nav2-path/` launch files + a note on how well it tracks the polyline.

**Status.** Pending; after GPS + TurtleBot.
