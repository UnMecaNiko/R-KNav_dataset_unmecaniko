# Teleoperation vs autonomy

Robot.com recorded **both modes** during real deliveries. Each frame's `action` is written by whoever had control:

- **Autonomous:** custom Nav2 + GPS/RTK + OSM.
- **Remote:** an operator sending the same `Twist`.

The cameras are always the rover's. What changes is the driver.

The sample does **not** carry a `teleop` / `autonomous` flag. There is no way to filter "autonomous only" with the current schema. The English `task` strings are added by a VLM afterwards; they are not what Nav2 or the operator was reading.

Mixing command styles also feeds the jerky metric.
