# Rosetta

A **ROS 2 ⇄ LeRobot** bridge. Name: the Rosetta Stone (two languages). Repo: [iblnkn/rosetta](https://github.com/iblnkn/rosetta). Announcement: [ROS Discourse](https://discourse.ros.org/t/announcing-rosetta-a-ros-2-lerobot-bridge/50657).

ROS 2 speaks nested topics (`geometry_msgs/Twist` on `/cmd_vel`). LeRobot speaks flat vectors (`action = [vx, wz]`) and mp4. Rosetta uses a **YAML contract**: this topic is this feature, at this fps, with this alignment rule (`asof`, etc.).

Robot.com used an **adapted** version for the forward direction: bag/MCAP → dataset. The front camera's `as-of-nearest` rule comes from there, not from visualizer magic.

The original package can also:

1. Record episodes to rosbag  
2. Convert them to LeRobot with the same contract  
3. Train  
4. **PolicyBridge:** the policy reads observations and publishes `/cmd_vel`

It is not a model, not RViz, and not a Nav2 plugin. Nav2 (or the human) can be what **produces** the Twist that Rosetta packages. When deploying a policy, the bridge **publishes** Twist the way Nav2 would.

In this lab **Rosetta is not needed at the start**. The data is already in LeRobot format. It would be needed:

- to **republish** an episode as topics (unless a minimal node of our own is written), or  
- the day a trained policy has to talk to TurtleBot/ROS 2.

A simple `action` → `/cmd_vel` replay on a TurtleBot can be done with a Python/ROS 2 script without Rosetta.
