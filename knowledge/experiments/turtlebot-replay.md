# Experiment: TurtleBot replay

**Goal.** Publish an episode's `action` values as `/cmd_vel` to a simulated TurtleBot (Gazebo) and watch it in RViz.

**Honest expectation.** The same *family* of motion (differential drive), not the R-Kiwi campus. Drift just like in dead reckoning. Useful for ROS 2 craft, not for validating Nav2.

**Do not use.** The MP4 files in this experiment. Nor Nav2 (that is the next one).

**Tools.** ROS 2 Jazzy, the chosen TurtleBot sim, RViz. A script that reads parquet/LeRobot and publishes `geometry_msgs/Twist` at 10 Hz using the episode timestamps (or a fixed fps).

**Output.** `experiments/turtlebot-replay/` + a screenshot or launch instructions. No huge bags in git.

**Status.** Pending. Choose TurtleBot 3 vs 4 when implementing.
