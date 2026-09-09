# Changelog

Record for **this** repository (not for unmecaniko-projects).

## 2026-09-08

Added a **Map** tab to the visualizer fork — iteration 1 of the dataset-wide route map. It sits second in the tab bar, after Episodes, and draws every loaded episode's recorded route on one basemap, framed to fit them all, keeping the start and end symbols from the episode map. Loads only when opened. Design and measurements: `experiments/lerobot-map-visualizer/dataset-map-iteration-1.md`.

Built for a dataset three orders of magnitude larger than the sample, deliberately, so the reduction path would not have to be rewritten later: the loader projects three parquet columns instead of every column, fetches one file per shard rather than one per episode, and reduces geometry — radial filter, input cap, Douglas-Peucker, vertex cap — before anything reaches React. Measured on the sample: 18,054 frames become 620 drawn vertices in 11–14 ms, with route shape retained. The episode page bundle grew 1.4 kB and the shared bundle did not move, so Leaflet is still code-split.

Two problems surfaced by measurement rather than by review. A 3 m simplification tolerance flattened episode 0 from 1,663 frames to 2 vertices — a straight line where the recording bends; a tolerance sweep set it to 50 cm, the float32 quantization floor. And a unit test caught Douglas-Peucker's quadratic worst case: 60,000 corner-only points took 61 seconds. Fixed with a radial pre-pass and a 10,000-point input cap, with the bound now asserted by the test.

The marker shapes moved to `utils/geoMarkers.ts` so the two maps cannot drift apart. Validation: 247 tests pass (157 upstream unchanged, 60 geoTrack, 30 new), type-check, lint, format and production build all clean. **Nothing visual has been verified** — there is no browser sensor in this project, and the tab has not been opened by a human yet.

Also added `ARG`/`ENV` for every `NEXT_PUBLIC_*` map variable to the fork's Dockerfile. The build-time env-var trap was documented in the previous round but the Dockerfile had no `ARG`, so the documented workaround could not actually be applied to that image — and Hugging Face Space Variables, which arrive as build-args, would have done nothing.

Created `harness/`, the agent harness for this repository, following the published harness-engineering guidance from Anthropic, OpenAI and Martin Fowler (all cited, retrieved 2026-09-08). It holds the machine-readable feature contract `feature-list.json` — Anthropic's convention of category, description, verification steps and a `passes` boolean that may only be set by an agent that ran the verification — plus `features.md`, `tests.md`, `architecture.md`, an append-only `progress.md` read at session start, and `init.sh`. AGENTS.md now points every agent at the progress log first and at the architecture invariants before any code change. The honest headline of that layer: there is **no automated browser sensor**, every defect found on 2026-09-07 was invisible to the unit tests, and closing that gap is the top harness item.

Recorded a data finding that changes an iteration 2 requirement: `observation.state.time_of_day` already exists in the dataset and is constant per episode, but publishes only two values in the sample, `Daytime` and `Night`. There is no midday category, and no absolute wall-clock timestamp to derive one from — `timestamp` restarts at 0.0 each episode. Iteration 2 therefore discovers the enum at runtime instead of hardcoding categories. `weather`, `road_type` and `surface` are also present and unused.

## 2026-09-07

Implemented and verified the synchronized episode map planned the previous day. The visualizer runs, the 14 public sample episodes all render their recorded route over a real basemap, and the marker tracks the shared playback clock. Code lives in a separate clone of `huggingface/lerobot-dataset-visualizer` on branch `feat/episode-route-map`, one commit ahead of upstream `dc59887` — not vendored here, as the plan required. Full write-up: `experiments/lerobot-map-visualizer/implementation-results.md`.

Three new modules (feature resolution and track extraction, configuration, and a Leaflet leaf component) plus hooks in the v3 data loader and the episode view; 2,014 lines across 12 files. The route is built from the full row set before chart downsampling, and the map subscribes to the time context's unthrottled channel so a moving marker triggers no React render. Feature identification refuses to guess: R-KNav stores both a twist pair and a longitude/latitude pair as `float32[2]`, so shape alone is never enough.

Verified on the production build, not the dev server: 217 unit tests (157 upstream unchanged, 60 new), 196/196 per-episode browser checks against values measured from the parquet, 40/40 robustness checks, 10/10 control checks. The fitted route's pixel size was checked against independently computed Web Mercator arithmetic rather than eyeballed. An A/B run with the map disabled proved it adds no parquet request and no host beyond the tile server, and that the narrow-viewport horizontal overflow is pre-existing upstream behaviour.

Verification found five real defects that unit tests could not: follow mode undoing the initial fit, `fitBounds` leaving up to 2x slack through integer zoom snapping, very short routes rendering unreadably small, the documented `NEXT_PUBLIC_MAP_ENABLED` kill switch never being called, and Leaflet silently stealing the app's advertised arrow-key episode shortcut on any map click. All fixed.

Recorded one new dataset caveat alongside the known `stats.json` quantile problem: in `meta/episodes`, the per-episode waypoint `min`/`max` are exact, but the stored `mean` falls outside them for 12 of the 14 episodes.

Deviation from the approved spec, deliberate and configurable: the mapped feature is dropped from the charts by default, because longitude and latitude share an axis with the action series and render as two flat, unreadable lines.

## 2026-09-06

Created `experiments/lerobot-map-visualizer/`, a documentation-only planning package for the approved synchronized episode experience: cameras, language context, velocity charts, an interactive route, and a live map marker sharing the existing visualizer clock. Recorded the verified upstream architecture, R-KNav data contract, product specification, technical design, proposed YAML contract, phased agent handoff, tests, licensing, tile-policy constraints, and `stats.json` quantile caveat. No application code was added. Resolved the waypoint data gate: the sample contains US-plausible `[longitude, latitude]` values from the GPS/RTK pipeline, without a formal CRS tag. Clarified that OSRM generated planned missions and is not documented as post-processing the recorded track.

Downloaded and manifest-verified the public sample into the canonical git-ignored directory `data/raw/robotcom/R-KNav_sample/`. Added reproducible local download instructions for both Hugging Face dataset repositories, including cross-platform environment setup, gated-dataset authentication, disk-space warning, verification, Windows fallback, and the distinction between `hf download` and `load_dataset`. Linked the guide from the agent and human indexes. Access to the gated 300 h dataset is now confirmed, so the corresponding todo item was removed; experiments still begin with the public sample. Updated the former ~2.3 GB sample estimate to the current Hub manifest total: 13 files and 1,240,327,132 bytes at revision `da0de1c`, checked on 2026-09-06.

## 2026-08-23

Repository language switched to English: every Markdown file translated (AGENTS.md, README, `context/`, `knowledge/`, `experiments/`, `planning/`), `.gitignore` comments included. `planning/pendientes.md` renamed to `planning/todo.md`, and the unknown marker changed from `> ⏳ PENDIENTE` to `> ⏳ TODO`. The AGENTS.md rule "content in Spanish" is now "content in English"; file names remain in English as before.

Creation of the `R-KNav_dataset_unmecaniko` lab: AGENTS.md-style structure + a `CLAUDE.md` that only points to AGENTS, a `context/` folder, dataset and exploration-session knowledge (ROS/LeRobot/Rosetta/Nav2 layers, sample vs gated, FoMo, jerky, VLM vs VLA), and the experiment roadmap (GPS map, dead reckoning, TurtleBot, Nav2; policy and Isaac later; Google Earth discarded). No code yet. Dataset not versioned.
