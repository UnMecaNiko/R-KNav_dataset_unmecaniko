# Purpose of this repository

**Name:** `R-KNav_dataset_unmecaniko`  
**Owner:** [UnMecaNiko](https://github.com/UnMecaNiko)  
**Born:** 2026-08-23, out of an exploration session on the dataset and the tools around it.

## What it is

A **versioned laboratory** for:

1. Preserving the dataset context (what it is, how to access it, what each field holds, license).
2. Designing and then running analysis and robotics experiments on top of that data.
3. Leaving artifacts (notes, scripts, later a replay or a map) that demonstrate ROS 2 and real fleet data, without faking a foundation-model paper.

The planned experiments, in order, are in [../knowledge/experiments/roadmap.md](../knowledge/experiments/roadmap.md). In short: GPS map ± OSRM → odometry vs GPS → TurtleBot in sim with the `twist` commands → Nav2 following the route (not the video) → much later a policy over the cameras.

## What it is not

- Not a fork or a mirror of Hugging Face. The data stays on the Hub.
- Not the portfolio website. If a publishable project ever comes out of it, it gets a card in `projects/` of [unmecaniko-projects](https://github.com/UnMecaNiko/unmecaniko-projects) using the English template.
- Not a job application to Robot.com. The lab can inform conversations; job postings live in `planning/career/` of the main repo.
- Not a place to train a 300 h VLA on day one. The sample is ~14 episodes / ~30 min; good for the loop, not for a serious model.
- It does not mix in Google Earth / Elevation API (discarded: not open enough for a pipeline; see [../knowledge/tools/elevation.md](../knowledge/tools/elevation.md)).

## Origin of the scope

The 2026-08-23 session closed like this, in Nicolas's words: analyze the dataset in several ways; plot GPS with maps and OSRM; integrate \(v,\omega\) and compare it against GPS; feed those commands into a simulated TurtleBot; learn Nav2 **without** forcing the images into it; leave video → model and Rosetta for when that layer comes.

That is the backlog. It is executed following the roadmap, not all at once.
