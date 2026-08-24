# "Jerky" in the visualizer

It is not a dataset field. It is a label from the [LeRobot Dataset Visualizer](https://huggingface.co/spaces/lerobot/visualize_dataset), Filtering tab.

It looks at `action` frame by frame (`twist.linear.x`, `twist.angular.z`) and computes

\[\Delta a_t = a_t - a_{t-1}\]

At 10 fps that is the command jump over 0.1 s. If the jumps are large, the dimension comes out **jerky**. If it barely changes, **low movement**.

In the sample (inspected 2026-08-23) the Space flagged Overall: Jerky on both twist dimensions, with the roughest episodes around 7, 2 and 1.

It does not mean "broken dataset". On a sidewalk it is expected: teleop stick, Nav2 braking, pedestrians. Before filtering, open the episode video. Integrating \(v,\omega\) against GPS ([dead-reckoning-vs-gps](../experiments/dead-reckoning-vs-gps.md)) explains part of those spikes better than blindly dropping episodes.

The visualizer suggests *shorter action chunks* and outlier filtering: a lab-arm recipe. Here a rover *has* to brake hard. Do not copy that recipe without watching the video.
