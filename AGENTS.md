# AGENTS.md — Main repository context

> **This is the main context file.** Every agent (Claude Code, Copilot, Cursor, chatbot) and every human working here must read it first. `CLAUDE.md` and `.github/copilot-instructions.md` only point to it.

## What this repository is

Working lab of **Nicolas Velasquez Lopez (`unmecaniko`)** on the **[R-KNav](https://huggingface.co/datasets/robotcom/R-KNav_dataset)** dataset from [Robot.com](https://www.robot.com/) (formerly Kiwibot): real sidewalk navigation data from the R-Kiwi fleet, published in LeRobot format.

The goal is not to republish the dataset. It is to **study it, analyze it and build experiments** (maps, odometry, TurtleBot replay, Nav2, later on vision policies) in order to learn robotics and Physical AI tooling, with public artifacts that close gaps in the profile.

Nicolas's identity, career history and global rules live in the main repository:

**[github.com/UnMecaNiko/unmecaniko-projects](https://github.com/UnMecaNiko/unmecaniko-projects)** — start with its [`AGENTS.md`](https://github.com/UnMecaNiko/unmecaniko-projects/blob/main/AGENTS.md).

This repo does **not** replace that base. Only the R-KNav lab context lives here. Short profile: [context/about-unmecaniko.md](context/about-unmecaniko.md). Links: [context/related-repositories.md](context/related-repositories.md).

## Architecture

A single working layer (English). It does not feed unmecaniko.com.

| Folder | What it is |
|---|---|
| `context/` | Who Nicolas is (summary), related repos, purpose of this lab. |
| `knowledge/` | Source of truth for *this* project: dataset, concepts, tools, experiment design. |
| `experiments/` | Code and notebooks for the experiments. Each one links its design note in `knowledge/experiments/`. |
| `harness/` | The agent harness: feature contract, tests, architecture invariants, progress log, bootstrap. |
| `planning/` | Changelog and open items for **this** repository. |
| `data/` | Local dataset downloads. **Git-ignored.** Do not commit. |

- **Content in English.** Working language of this repository.
- **Folder and file names in English.**
- The original dataset stays on Hugging Face. Only notes, scripts and lightweight results (tables, small plots) go here.

## Rules for agents

### 1. No secrets and no dataset redistribution

The repository may be public. Any file here is treated as published.

- Do not commit tokens, real `.env` files, or large model weights.
- **Do not commit** parquet, mp4, mcap, or any copy of R-KNav. The [license](https://huggingface.co/datasets/robotcom/R-KNav_dataset) is non-commercial and **forbids redistributing** the dataset. Reference `robotcom/R-KNav_sample` and `robotcom/R-KNav_dataset` instead.
- Own code: publishable. Models trained on R-KNav, if published, inherit the non-commercial restriction and the *Robot.com R-KNav Dataset* attribution.

### 2. Language and format

- Narrative → Markdown. Inventories and parameters → YAML.
- Unknowns: `> ⏳ TODO: <what is missing and how to get it>`. Never invent numbers about the dataset or about Robot.com.

### 3. Reference GitHub and Hugging Face, never local paths

Writing `C:\Users\...` as a way to locate knowledge is forbidden. Dataset: Hub URL. Identity: `unmecaniko-projects`. Exception: documenting where a secret lives when it cannot be in git.

### 4. Three layers that do not mix

```
Robot / sim          ROS 2, Nav2, RViz, /cmd_vel
Recording            rosbag → Rosetta → LeRobot (parquet + mp4)
Learning             LeRobot / PyTorch  (video → policy)
```

- **Nav2** writes `/cmd_vel` in the classic stack. It does not eat MP4.
- **Rosetta** translates ROS 2 ↔ LeRobot. It is not a Nav2 plugin.
- **LeRobot Dataset Visualizer** inspects the Hub. Do not train there.
- **Training on video** is a separate thread (`lerobot`). It does not block maps or TurtleBot.
- **Isaac Sim/Lab** is the useful NVIDIA family (same format / `twist` action). **Alpamayo** (a car VLA) is not the first experiment: different vehicle, different sensors.

Detail: [knowledge/concepts/layers.md](knowledge/concepts/layers.md).

### 5. Technical facts: validate and cite

When in doubt about the LeRobot format, Nav2, OSRM or the dataset: find the official source, cite the URL and the date. The Hugging Face README overrides memories of past conversations.

### 6. Living planning

When finishing a piece of work, update [planning/changelog.md](planning/changelog.md) and [planning/todo.md](planning/todo.md). A resolved item is deleted from the todo list and recorded in the changelog.

### 6b. The harness

[harness/](harness/) is the working loop of this repository, built on the published harness-engineering guidance ([Anthropic](https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents), [OpenAI](https://openai.com/index/harness-engineering/), [Fowler](https://martinfowler.com/articles/harness-engineering.html)). Rules that bind every agent:

- **Start by reading [harness/progress.md](harness/progress.md)**, then [harness/feature-list.json](harness/feature-list.json).
- **Read [harness/architecture.md](harness/architecture.md) before changing code.** Its invariants are not enforced by any linter.
- **Never set `passes: true` without running that feature's stated verification.** A green `bun test` is not evidence for a feature whose method is `browser`. `passes: false` means "not verified this way yet", and the `note` says why.
- **Finish by appending to [harness/progress.md](harness/progress.md)** and updating the feature list, the changelog and the todo list.
- Before committing code, the gate is `bun run validate` in the fork: type-check, lint, format check, tests.

### 7. Git workflow

- Automatic commits, no authorization needed, on `main` or a branch.
- `git pull` when starting a session.
- Automatic `git push` to `origin` after every commit.
- `main` by default. A `type/purpose` branch only when isolation is required.
- Merging to `main` requires explicit authorization; then fast-forward, no PR, delete the remote branch.
- Commit identity: `Nicolas Velasquez Lopez <unmecaniko@gmail.com>`.

## Repository map

```
AGENTS.md                 ← you are here
CLAUDE.md                 only references AGENTS.md
README.md                 index for humans
context/                  who, what for, related repos
knowledge/
  dataset/                what R-KNav is, access, schema, license, pipeline
  concepts/               layers, VLM/VLA, jerky, teleop vs autonomous
  tools/                  visualizer, Rosetta, ROS 2/RViz, OSRM, NVIDIA
  experiments/            design of each experiment (no code yet)
experiments/              design + results per experiment
harness/                  feature-list.json, features.md, tests.md,
                          architecture.md, progress.md, init.sh
planning/                 changelog.md, todo.md
data/                     local, git-ignored
```

## Minimum reading for a new agent

1. This file.
2. [harness/progress.md](harness/progress.md) — where the work actually stands.
3. [harness/feature-list.json](harness/feature-list.json) — what is built and what is verified.
4. [context/repository-purpose.md](context/repository-purpose.md)
5. [knowledge/dataset/overview.md](knowledge/dataset/overview.md)
6. [knowledge/experiments/roadmap.md](knowledge/experiments/roadmap.md)
7. Before touching code: [harness/architecture.md](harness/architecture.md)
8. If identity or career context is needed: [unmecaniko-projects](https://github.com/UnMecaNiko/unmecaniko-projects)

## Common flows

| I want to… | Then… |
|---|---|
| Understand the dataset | [knowledge/dataset/overview.md](knowledge/dataset/overview.md) |
| Download it or request access | [knowledge/dataset/access.md](knowledge/dataset/access.md) |
| Recreate the local dataset on another computer | [knowledge/dataset/local-download.md](knowledge/dataset/local-download.md) |
| See the sample in the visualizer | [knowledge/tools/lerobot-visualizer.md](knowledge/tools/lerobot-visualizer.md) |
| Know which experiment is next | [knowledge/experiments/roadmap.md](knowledge/experiments/roadmap.md) |
| ROS 2 / RViz / Nav2 | [knowledge/tools/ros2-rviz.md](knowledge/tools/ros2-rviz.md) — official tutorials, do not rewrite them |
| Know who Nicolas is | [context/about-unmecaniko.md](context/about-unmecaniko.md) and the main repo |
| See what changed here | [planning/changelog.md](planning/changelog.md) |
| Know what is built and verified | [harness/features.md](harness/features.md) |
| Run the tests | [harness/tests.md](harness/tests.md) |
| Set up a machine from scratch | `./harness/init.sh setup` |
