# NVIDIA (Isaac yes, Alpamayo not as a first step)

R-KNav is a **sidewalk rover**, 10 fps, four small cameras, no LiDAR, `Twist` actions.

**Isaac Sim / Isaac Lab / Cosmos** are the NVIDIA family that fits *at a distance*: simulating a differential-drive robot, same action type, and LeRobot is being integrated with Isaac Lab Arena. Arena today is heavily humanoid-oriented; a rover has to be assembled. Cosmos can retexture sim video. R-KNav's MP4 files are **not** "loaded into" Isaac as if they were the scene. The useful overlap is: same LeRobot format + comparing real vs sim action histograms.

**Alpamayo / AlpaSim / DRIVE** are **car** VLAs (vehicle trajectory, LiDAR, streets). A different domain. A domain-gap paper, not the first lab.

Hardware: Isaac and Cosmos want a real NVIDIA GPU. Without one, the ceiling is the sample + ROS 2 on WSL/Gazebo.

In the roadmap, NVIDIA comes **after** GPS, odom and TurtleBot, unless Nicolas decides to promote Isaac to an explicit experiment.
