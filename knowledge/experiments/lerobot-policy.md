# Experiment: policy over video (later)

**Goal.** Train a small policy (ACT / Diffusion / SmolVLA in LeRobot) that, given the cameras (+ state), predicts `action`.

**Reality check.** The sample (~30 min, 14 episodes) is enough to **close the code loop** (dataset → train → checkpoint). Overfitting is expected. A model worthy of FoMo or of the gated 300 h is a different phase.

**Not starting now.** It does not block maps or TurtleBot. Rosetta is not needed until the checkpoint has to publish to a ROS 2 robot's `/cmd_vel`.

**Future output.** `experiments/lerobot-policy/` + a model card on the Hub with the non-commercial license and R-KNav attribution.

**Status.** Parked.
