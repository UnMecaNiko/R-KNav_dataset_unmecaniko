# Research notes

Checked on 2026-09-06. These notes preserve the evidence used to approve the product and technical plan.

## Visualizer feasibility

Upstream repository: [huggingface/lerobot-dataset-visualizer](https://github.com/huggingface/lerobot-dataset-visualizer). Checked `main`: `dc59887796fd41f37040c0df6b10e6f6a30a1854`.

Verified findings:

- The project is public and Apache-2.0 licensed.
- It is a Next.js 15 / React 19 / TypeScript application using Bun.
- It reads Parquet in the browser with `hyparquet`.
- `EpisodeViewer` wraps the episode in a shared `TimeProvider`.
- Videos and Recharts graphs already consume that shared time.
- The time context exposes both a state value and a subscription API designed for high-frequency leaf updates.
- V3 loading reads the episode's global row interval and per-camera video segment from episode metadata.
- Numeric one-dimensional features are flattened into chart data. A LeRobot shape `[2]` qualifies; R-KNav waypoints therefore arrive as two numeric components without a special-case parser.
- The loader reads full episode rows, then downsamples chart data to at most 4,000 points.
- The sample's longest episode is 3,289 frames, so none of its route points exceed that chart threshold. The map design still uses full rows to avoid hidden coupling.
- Existing top-level tabs include Episodes, Annotations, Statistics, Filtering, Frames, Action Insights, Doctor, and conditionally 3D Replay. No map component or map dependency exists.
- The Episodes view renders videos, language instruction, charts, and playback bar together. That is the correct integration point.

Conclusion: a synchronized map is a contained extension of existing mechanisms, not a rewrite.

## R-KNav sample evidence

Local snapshot verified against Hub revision `da0de1ce28a338ba10d4beda405e32ac1c41040e`:

- 13 repository files; 1,240,327,132 bytes.
- 14 episodes; 18,054 frames; 10 fps.
- Four concatenated video shards, one per camera in this sample.
- `observation.state.waypoints`: `float32[2]`.
- Dataset card order: `(longitude, latitude)`.
- Actual extents: longitude `[-118.417488, -68.669060]`, latitude `[30.209423, 47.921959]`.
- Episode 0 begins near `[-92.019272, 30.212450]`.

The sample values are geographically plausible for the stated US locations. The dataset metadata does not include a formal CRS tag.

## GPS/RTK, OSRM, and synchronization

Canonical dataset card: [robotcom/R-KNav_sample](https://huggingface.co/datasets/robotcom/R-KNav_sample).

The card says:

- each rover has onboard GPS/RTK for position;
- autonomous localization relies on GPS/RTK;
- RTK receives RTCM corrections over cellular or Wi-Fi;
- collection was restricted to open campuses with high-quality GPS;
- OSRM over enriched OpenStreetMap metadata generated pre-routed missions;
- episode extraction used, among other triggers, GPS accuracy;
- Rosetta converted ROS 2 telemetry into LeRobot;
- telemetry was aligned to the front-camera timeline using an as-of-nearest timestamp policy.

Therefore the recorded trajectory coordinates should be described as GPS/RTK-derived and temporally synchronized. OSRM created the planned mission route; the card does not say that OSRM map-matched or post-processed the recorded `waypoints`. Because the source topic contract and any onboard GPS filtering are not published, do not call the feature unfiltered raw GPS.

## `stats.json` findings

`meta/stats.json` contains global aggregates for numeric and video features. String features such as road type, surface, weather, and time of day are absent.

Each included feature has:

- `min`, `max`, `mean`, `std`, and `count`;
- `q01`, `q10`, `q50`, `q90`, and `q99`.

Shapes reflect the feature:

- `action`, `observation.state`, and `waypoints`: one statistic per vector component;
- scalar indices/timestamps: one-element arrays;
- RGB video: `[3, 1, 1]` values normalized to `[0, 1]`, suitable for channel-wise broadcasting.

The current official LeRobot implementation computes per-dimension numeric statistics and per-channel image statistics. Images are spatially downsampled/sampled to control cost. See [compute_stats.py](https://github.com/huggingface/lerobot/blob/main/src/lerobot/datasets/compute_stats.py).

### Verified quantile limitation in this snapshot

Direct comparison with all 18,054 frame rows found that several stored `qXX` values are not true global quantiles:

| Feature/component | Direct value | Stored value |
|---|---:|---:|
| waypoint longitude `q50` | `-92.019310` | `-90.127559` |
| global `index` `q01` | `180.53` | `8117.15` |
| `episode_index` `q50` | `7` | `6.683671` |

All stored `episode_index` quantiles are approximately the mean. This is consistent with a limitation of aggregating episode-level summaries: exact global quantiles cannot be recovered from per-episode quantiles alone. Current upstream LeRobot explicitly documents this limitation in its aggregation code, but the R-KNav snapshot may have been produced by an adapted or earlier pipeline. Do not claim a specific generating algorithm without its exact Rosetta revision.

Practical rule:

- use `min`, `max`, `mean`, `std`, and `count` with normal validation;
- recompute quantiles directly from Parquet for scientific analysis;
- never use `stats.json` to draw the route or locate the current frame.

## Map technology research

Leaflet provides interactive maps, raster tile layers, polylines, GeoJSON, markers, bounds, and controls. The recommended integration uses Leaflet directly in a lazy client component to avoid React-wrapper and server-rendering coupling. Reference: [Leaflet API](https://leafletjs.com/reference.html).

OpenStreetMap data is open, but the community Standard tile servers are capacity-limited. Their policy requires correct HTTPS URL, visible attribution, valid browser referrer, and cache compliance; it forbids bulk download and prefetch. Reference: [OSMF tile usage policy](https://operations.osmfoundation.org/policies/tiles/). A public deployment must allow tile-provider configuration.

OSRM is out of the initial rendering path. It may later support a separate comparison between recorded trajectory and a network-matched route.

## Unknowns to resolve during implementation

> ⏳ TODO: Check whether upstream changed its time/data interfaces after commit `dc598877`; refresh this plan before editing.

> ⏳ TODO: Ask upstream maintainers whether they prefer a metadata convention, environment variable, or UI control for geographic feature mapping.

> ⏳ TODO: Obtain Robot.com's adapted Rosetta topic contract or confirmation if a claim stronger than “GPS/RTK-derived coordinates” is required.

> ⏳ TODO: Select a production tile provider only after expected public traffic and hosting are known.

