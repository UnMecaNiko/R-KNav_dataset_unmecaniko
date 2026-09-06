# Changelog

Record for **this** repository (not for unmecaniko-projects).

## 2026-09-06

Downloaded and manifest-verified the public sample into the canonical git-ignored directory `data/raw/robotcom/R-KNav_sample/`. Added reproducible local download instructions for both Hugging Face dataset repositories, including cross-platform environment setup, gated-dataset authentication, disk-space warning, verification, Windows fallback, and the distinction between `hf download` and `load_dataset`. Linked the guide from the agent and human indexes. Access to the gated 300 h dataset is now confirmed, so the corresponding todo item was removed; experiments still begin with the public sample. Updated the former ~2.3 GB sample estimate to the current Hub manifest total: 13 files and 1,240,327,132 bytes at revision `da0de1c`, checked on 2026-09-06.

## 2026-08-23

Repository language switched to English: every Markdown file translated (AGENTS.md, README, `context/`, `knowledge/`, `experiments/`, `planning/`), `.gitignore` comments included. `planning/pendientes.md` renamed to `planning/todo.md`, and the unknown marker changed from `> ⏳ PENDIENTE` to `> ⏳ TODO`. The AGENTS.md rule "content in Spanish" is now "content in English"; file names remain in English as before.

Creation of the `R-KNav_dataset_unmecaniko` lab: AGENTS.md-style structure + a `CLAUDE.md` that only points to AGENTS, a `context/` folder, dataset and exploration-session knowledge (ROS/LeRobot/Rosetta/Nav2 layers, sample vs gated, FoMo, jerky, VLM vs VLA), and the experiment roadmap (GPS map, dead reckoning, TurtleBot, Nav2; policy and Isaac later; Google Earth discarded). No code yet. Dataset not versioned.
