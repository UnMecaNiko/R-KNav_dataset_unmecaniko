# Dataset map — iteration 1

**Scope agreed with Nicolas:** place the map, the new tab, and the drawn paths. Everything else — heatmap, time-of-day colouring, hover detail, distance statistics — is [iteration 2](dataset-map-iteration-2-plan.md).

**Status: built 2026-09-08, automated sensors green, not yet verified in a browser.**

## What was built

A **Map** tab, second in the bar, immediately after Episodes. It draws every loaded episode's recorded route on one basemap, framed so all of them are visible, and pans and zooms across the whole extent. Each route keeps the start and end symbols from the episode map — a green triangle and a red square, distinguishable by shape rather than colour.

| Module | Role |
|---|---|
| `src/utils/datasetRoutes.ts` | Route geometry reduction. Pure, framework-free, 30 unit tests. |
| `src/utils/geoMarkers.ts` | Start/end/current symbols, extracted from `episode-map.tsx` so both maps share one definition. |
| `src/components/dataset-map.tsx` | Leaflet leaf for the tab. Canvas renderer, viewport-scoped endpoint markers. |
| `loadAllEpisodeRoutes` in `fetch-data.ts` | Reads episode ranges, groups by shard, projects three columns, reduces geometry. |
| `episode-viewer.tsx` | Tab wiring; loads on demand like the other cross-episode tabs. |

## The scalability decisions, and why they are in iteration 1

The sample is 14 episodes. The gated dataset is ~300 h — order 10^7 frames. Building iteration 1 against the sample's size would have produced something to throw away, so the reduction path was built now even though nothing today needs it.

**Column projection.** Parquet is columnar, so the loader reads `index`, `episode_index` and the coordinate column and skips state, action and video paths entirely. The two integer columns are nearly free on the wire: `episode_index` is a long run of repeats, `index` is monotonic.

**One fetch per shard.** Episodes are grouped by the data file that holds them, so a shard shared by fifty episodes is downloaded once.

**Geometry reduced before React sees it.** Four stages, cheapest first:

```
radial filter  →  input cap  →  Douglas-Peucker  →  vertex cap
   O(n)          10k points      keeps corners      400/route
```

Douglas-Peucker rather than sampling every Nth frame, because sampling destroys corners — precisely the information a route map exists to show.

## Measured on the public sample

| Measure | Value |
|---|---|
| Rows read (3 columns of an 18,054-row shard) | 34–55 ms |
| Geometry for all 14 routes | 11–14 ms |
| Frames in | 18,054 |
| Distinct consecutive positions | 5,340 (matches the figure measured independently on 2026-09-07) |
| Vertices drawn | **620** |
| Route shape retained | episode 0: 47 vertices · episode 4: 158 · episode 7: 80 |
| Episode page bundle | 56.7 kB → 58.1 kB |
| Shared bundle | 103 kB, unchanged — Leaflet stays code-split |

## Two problems found while building, both by measurement

**A 3 m tolerance destroyed the routes.** The first tolerance reduced episode 0 from 1,663 frames to **2 vertices** — a straight line where the recording has a bend. A sweep across 0.25–10 m showed the knee, and the tolerance was set to **50 cm**: the float32 quantization floor, below which simplification only preserves storage noise. Total vertices went from 67 (unusable) to 620 (faithful).

**Douglas-Peucker's quadratic worst case is reachable.** A unit test fed it 60,000 points where every vertex is a corner. It took **61 seconds** — the test timed out and failed. No real sidewalk route looks like that, but a map built for a 300 h dataset cannot assume the data is well behaved, and one bad episode freezing the tab is not an acceptable failure mode. Fixed with the radial pre-pass and a 10,000-point input cap; the test now asserts the work stays under 4 seconds.

The second one is the better argument for writing the test first: the defect existed in code that had already passed type-check, lint and every other test.

## Verification

| Sensor | Result |
|---|---|
| `bun run validate` | **247 pass, 0 fail**, 2,004 assertions (157 upstream unchanged + 60 geoTrack + 30 datasetRoutes) |
| `bun run build` | exit 0 |
| Data check against the real parquet | route geometry and endpoints as tabulated above |

**Not verified: anything visual.** There is no browser sensor in this project. The previous round found five defects that only appeared in a browser — a map stealing a keyboard shortcut, a fit silently undone, a kill switch never called — so "the tests pass" is not evidence the tab looks right. The corresponding entries in [feature-list.json](../../harness/feature-list.json) stay at `passes: false` until someone opens it.

## Deliberately not done

- **No hover, no click-through to an episode.** Both belong to iteration 2's interaction design, and the polylines are currently non-interactive.
- **No colour by time of day, no heatmap, no statistics.** Iteration 2.
- **No viewport-driven loading.** The loader reads every sampled episode up front. That is fine for hundreds of episodes and wrong for thousands; the fix is designed in the [iteration 2 plan](dataset-map-iteration-2-plan.md).

## Open items

> ⏳ TODO: Verify the Map tab in a browser and update `feature-list.json`.

> ⏳ TODO: Confirm the Map tab is absent, and says why, on a dataset with no geographic feature.

> ⏳ TODO: The fork still has no `origin` remote.
