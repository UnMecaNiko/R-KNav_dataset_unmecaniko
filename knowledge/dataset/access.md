# Access

## Sample (always start here)

Repo: [`robotcom/R-KNav_sample`](https://huggingface.co/datasets/robotcom/R-KNav_sample)  
Public, no gate. ~2.3 GB.

Inspection without downloading everything: [LeRobot Dataset Visualizer](https://huggingface.co/spaces/lerobot/visualize_dataset) → paste `robotcom/R-KNav_sample`.

Local download (when code needs it): `datasets` / `huggingface_hub` library, target `data/` (git-ignored). Do not push those files.

## 300 h gated

[`robotcom/R-KNav_dataset`](https://huggingface.co/datasets/robotcom/R-KNav_dataset) — `gated: manual`.

The form asks for company, country, responsible person, institutional email, intended use (Research / Education / Other), interest in FoMo and in the 10k h, and acceptance of **non-commercial use** + LICENSE.

Until approval comes through, every experiment uses the **sample**.

## 10,000 h

Email `airobotics@kiwicampus.com`. Not the first step.

## Hugging Face account

A Hub account is required for the gate (and sometimes for the Space). Do not store tokens in this repo; keep a local git-ignored `.env`.
