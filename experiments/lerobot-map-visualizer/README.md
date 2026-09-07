# LeRobot map visualizer — planning package

**Status:** product design approved; implementation not started. This directory contains documentation only.

## Goal

Extend the public [LeRobot Dataset Visualizer](https://github.com/huggingface/lerobot-dataset-visualizer) so a geospatial robot dataset can show, in the same episode view:

- the synchronized camera streams;
- state and action charts;
- an interactive basemap with the complete episode trajectory; and
- a live robot marker driven by the same playback clock as the videos and charts.

The first target is [`robotcom/R-KNav_sample`](https://huggingface.co/datasets/robotcom/R-KNav_sample). The design must remain generic enough to propose upstream rather than hard-code a Robot.com-only screen.

## Approved product decision

The map belongs inside the existing **Episodes** view. It is not a separate top-level tab, because hiding the videos or charts would defeat the main requirement: inspect visual evidence, commands, measured motion, and location together.

```text
┌──────────────────────── cameras ───────────────────────┐
│ main · left · right · rear                            │
├─────────────────────────┬──────────────────────────────┤
│ episode information     │ interactive map              │
│ and language task       │ route + live robot marker    │
├─────────────────────────┴──────────────────────────────┤
│ synchronized action and observation.state charts      │
├────────────────────────────────────────────────────────┤
│ shared playback bar                                    │
└────────────────────────────────────────────────────────┘
```

Responsive layouts may stack the map below the cameras. The map remains visible in the episode flow and uses the existing playback controls.

## Documents

| Document | Purpose |
|---|---|
| [product-spec.md](product-spec.md) | Approved behavior, interaction, states, and acceptance criteria |
| [technical-plan.md](technical-plan.md) | Upstream architecture, proposed data flow, synchronization, and map integration |
| [implementation-plan.md](implementation-plan.md) | Ordered work packages, test strategy, delivery path, and agent handoff |
| [research-notes.md](research-notes.md) | Verified upstream and R-KNav findings, including `stats.json` limitations |
| [proposed-map-contract.yaml](proposed-map-contract.yaml) | Proposed feature-discovery and runtime parameters; specification only |

## Scope boundaries

- Do not copy R-KNav data into the visualizer repository.
- Do not publish tokens or gated-dataset-derived assets.
- Do not add OSRM to the first implementation. The first map shows the recorded track on an OSM-derived basemap.
- Do not reinterpret the video as a Nav2 input.
- Do not implement a second playback clock.
- Do not silently assume every two-element feature is GPS.

## Relationship to the roadmap

This package expands experiment 1, [GPS map](../../knowledge/experiments/gps-map.md), from a standalone plot into a synchronized LeRobot visualization. A standalone proof of the coordinates may still be useful during implementation, but the approved user-facing result is the integrated episode view.

## Upstream baseline

Research was checked on 2026-09-06 against `huggingface/lerobot-dataset-visualizer` `main` at commit `dc59887796fd41f37040c0df6b10e6f6a30a1854`. Re-check upstream before implementation because the application is active.

