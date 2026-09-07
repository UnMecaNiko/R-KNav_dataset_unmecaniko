# Implementation plan and agent handoff

This is an execution plan, not implementation. No visualizer source code is stored in this directory.

## Repository strategy

The visualizer should live in a separate fork, for example under the user's GitHub account, rather than as vendored source inside this R-KNav lab. Reasons:

- preserve a clean relationship with upstream;
- make upstream rebases and pull requests practical;
- avoid mixing an Apache-2.0 application with dataset-lab experiment files;
- keep this repository focused on R-KNav knowledge, test cases, and results.

This folder remains the product and engineering source of truth. When implementation begins, record the fork URL and pinned commit here without copying dataset files.

## Phase 0 — refresh and reproduce upstream

Deliverables:

- re-read upstream `README.md`, `CLAUDE.md`, package scripts, and changed files;
- record current upstream commit;
- fork/clone the visualizer in its own workspace;
- run the unmodified app and open `robotcom/R-KNav_sample`;
- run upstream type checks, lint, format check, tests, and build;
- capture the baseline episode layout and network requests.

Exit condition: the unchanged upstream application is reproducible and all available validation commands are understood.

## Phase 1 — lock the data contract

Deliverables:

- implement and unit-test explicit geographic feature resolution;
- support `observation.state.waypoints` as `[longitude, latitude]`;
- reject missing, ambiguous, non-numeric, malformed, or out-of-range mappings;
- extract a typed route from full current-episode rows;
- retain timestamps and frame indices;
- expose invalid-row counts;
- add fixture datasets without geography and with local-frame coordinates.

Exit condition: a unit test can recover the expected first/last coordinates and point count for representative R-KNav-shaped fixture data without using the private local dataset copy.

## Phase 2 — static episode map

Deliverables:

- add Leaflet as a lazy client-side dependency;
- render configurable raster tiles with attribution;
- render route, start, and end;
- fit episode bounds once;
- implement reset view and basemap failure state;
- implement responsive sizing.

Exit condition: the correct static route appears for all 14 public sample episodes, and datasets without geography show no regression.

## Phase 3 — shared-clock synchronization

Deliverables:

- subscribe in the map leaf component to `TimeProvider`;
- map current time to the nearest route sample;
- move the current marker without re-rendering `EpisodeViewerInner` on each tick;
- display completed versus remaining route;
- seek via route interaction;
- handle pause, playback seek, chart seek, URL `?t=`, episode changes, and end-of-episode reset;
- provide follow-mode behavior without overriding deliberate user pans.

Exit condition: start/middle/end checks agree among video, chart cursor, text timestamp, and map coordinate for several episodes.

## Phase 4 — robustness and performance

Deliverables:

- measure initial-load and playback behavior with four videos and map active;
- confirm no extra Parquet download is introduced;
- test invalid rows, repeated GPS fixes, stationary intervals, sparse points, and discontinuities;
- test a route longer than the chart's 4,000-point sampling cap;
- test keyboard navigation and reduced-motion behavior;
- verify tile attribution and policy compliance;
- verify gated access does not leak credentials or derived data.

Exit condition: performance is stable during playback and error states are explicit.

## Phase 5 — delivery decision

Choose after the prototype works:

1. Maintain a public UnMecaNiko fork with documented deployment.
2. Submit a generic upstream pull request.
3. Do both: keep the fork for demonstration while proposing the generic feature upstream.

The recommended path is option 3, provided the geographic mapping is configurable and existing datasets are unaffected.

## Test matrix

| Area | Required cases |
|---|---|
| Resolver | explicit mapping, recognized R-KNav key, ambiguous vector, reversed order, invalid range, missing feature |
| Extraction | all valid, null/NaN, repeated coordinate, timestamp gap, out-of-order row |
| Time mapping | exact timestamp, between samples, before start, after end, seek backward |
| Episode lifecycle | first episode, next/previous, direct URL, rapid switching |
| Layout | desktop, narrow viewport, map resize, hidden/visible transition |
| Compatibility | v3 with geography, v3 without geography, supported older format if upstream still supports it |
| Network | tile success, tile failure, gated dataset success/failure |
| Regression | video sync, chart seek, playback bar, keyboard shortcuts, lazy panels |

## Manual validation set for the public sample

- Episode 0: verify the first point near `[-92.01927, 30.21245]` and route endpoint near `[-92.02083, 30.21085]`.
- Episode 1: verify the route begins at the next MP4 segment but map time begins at zero.
- Episode 7: exercise the longest sample episode, 3,289 frames.
- Episode 12: inspect a short and nearly stationary-looking geographic range.
- Episode 13: verify final frame, end marker, and end-of-playback behavior.

These values are validation references only. Do not copy the dataset into the visualizer repository.

## Documentation deliverables in the implementation repository

- feature overview and screenshot/GIF;
- geographic configuration reference;
- local development instructions;
- tile-provider and attribution configuration;
- dataset privacy/licensing note;
- architecture note explaining shared-clock synchronization;
- tests and validation results;
- upstream divergence or pull-request link.

## Definition of done

The platform increment is done when:

- all product acceptance criteria pass;
- automated and manual tests pass;
- the application runs from a clean clone;
- no dataset or secret is committed;
- public documentation identifies upstream provenance and licenses;
- the R-KNav lab links to a reproducible public result;
- `planning/todo.md` and `planning/changelog.md` are updated.

## Instructions for the implementing agent

1. Read this repository's `AGENTS.md` and every document in this folder.
2. Refresh upstream before editing; do not assume the pinned research commit is current.
3. Work in the separate visualizer fork, not inside `data/` or by vendoring it here.
4. Preserve existing upstream behavior and validation commands.
5. Implement the smallest vertical slice first: resolve R-KNav coordinates, show a static route, then connect time.
6. Keep the feature generic and opt-in; never label an arbitrary two-vector as GPS.
7. Fetch datasets from their original Hub repositories; never commit R-KNav artifacts.
8. Record decisions and deviations in the appropriate repository documentation.

