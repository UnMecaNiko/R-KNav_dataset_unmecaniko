# LeRobot Dataset Visualizer

Space: [huggingface.co/spaces/lerobot/visualize_dataset](https://huggingface.co/spaces/lerobot/visualize_dataset)  
Code: [huggingface/lerobot-dataset-visualizer](https://github.com/huggingface/lerobot-dataset-visualizer)

It is there to **inspect** a LeRobot v2+/v3 dataset in the browser: video synchronized with curves, Overview, Filtering (jerky / low movement), Action Insights. The 3D URDF tab covers SO-100/101 arms, **not** the R-Kiwi.

There is no long tutorial or dedicated video for the Space (searched 2026-08-23). Short docs: [Using Dataset Tools](https://huggingface.co/docs/lerobot/en/using_dataset_tools). LeRobot videos (LeLab, Trossen) mention "visualizing" in passing, almost always with an arm.

The R-KNav sample opens by pasting `robotcom/R-KNav_sample`. The 300 h set requires login and the gate.

A different CLI (Rerun/Foxglove, not this UI):

```bash
lerobot-dataset-viz --repo-id robotcom/R-KNav_sample --episode-index 0
```

This does **not** train anything. It is fine for picking which episode to look at by hand (e.g. a smooth one vs the jerkiest). Do not redo its plots in a notebook: no added value.
