# Dataset map — iteration 2 plan

Design only. No code. Iteration 1 is [here](dataset-map-iteration-1.md).

Requested by Nicolas on 2026-09-08:

1. a density heatmap when zoomed out — "10 episodes in this circle, 15 in that one";
2. routes coloured by time of day — day, night, midday;
3. hover a route to see the episode, the time of day, and the distance driven in metres;
4. as the end product, statistics: metres driven per zone, and the most-travelled points;
5. all of it sized for the full dataset, not the 14-episode sample.

## Data gate, resolved before designing anything

**The dataset already classifies time of day. It publishes two values, not three.**

`observation.state.time_of_day` is a per-frame string column in the data parquet. Measured across all 18,054 frames of the public sample:

| Value | Episodes |
|---|---|
| `Daytime` | 0, 1, 2, 4, 8, 10, 13 |
| `Night` | 3, 5, 6, 7, 9, 11, 12 |

Two properties matter for the design:

- **It is constant within an episode.** All 14 episodes carry exactly one value. That makes it an episode-level attribute, cheap to index and cheap to colour by.
- **There is no midday category.** The dataset card documents the column as a free string and gives `Daytime` as its example, without enumerating the domain. The sample contains only these two.

There is no way to derive a third bucket from the data as it stands: `timestamp` is episode-local and restarts at 0.0 in every episode, so the dataset carries **no absolute wall-clock time**. Midday cannot be computed from coordinates alone either, without a date.

**Design consequence — do not hardcode three categories, and do not hardcode two.** Discover the distinct values at load time and build the legend and palette from what the dataset actually contains. The gated 300 h split may well publish more values (`Dusk`, `Dawn`, and so on); a runtime-discovered enum handles that without a code change, and a hardcoded one would silently mislabel or drop them.

> ⏳ TODO: Read the distinct `observation.state.time_of_day` values from the gated `robotcom/R-KNav_dataset` and record them here. Access is confirmed; the data has not been downloaded.

**Three other columns are available and unused**, all per-frame strings, all worth surfacing in the same interaction: `observation.state.weather` (`Sunny`, `Snowy`, `Rainy`), `observation.state.road_type` (`Sidewalk`, `Crossroad`), `observation.state.surface` (`Pavers`, `Zebra_crossing`, `Asphalt`). Unlike `time_of_day`, these vary *within* an episode, so they classify segments, not routes.

## Distance in metres

The hover readout and every statistic depend on one number per route, so define it once.

Compute the haversine sum over the **full recorded points, before simplification**, in the data layer. Two reasons it cannot be computed from the drawn geometry: simplification removes vertices and would under-report by whatever the tolerance allowed, and the component never receives the full track anyway.

One caveat to state in the UI or the docs: float32 quantization puts positions on a ~0.6 m grid, and summing many short segments accumulates that noise upward. The honest treatment is to sum over the **radially filtered** track rather than every frame — the filter already removes sub-tolerance jitter, which is exactly the noise that inflates a naive sum. Record both figures once, compare them, and document the difference rather than picking one silently.

## Work packages

### A. Route attributes

Extend the loader's column projection to include `observation.state.time_of_day`, and add to `EpisodeRoute`: `timeOfDay: string | null`, `lengthMeters: number`.

Read the attribute from the episode's first row and verify it is constant across the slice; if it is not, record `mixed` rather than silently taking the first. `DatasetRoutes` gains `timeOfDayValues: string[]`, the discovered enum.

Cost: one more string column, dictionary-encoded to near nothing.

### B. Colour by category, with a legend

Assign palette entries by index over the discovered enum. Requirements the episode map already set: distinguishable in the dark UI, and **not colour alone** — pair each category with a dash pattern so the map stays readable without colour vision. A legend lists each category, its colour, its dash, and its route count, and doubles as a filter.

### C. Hover

Leaflet's canvas renderer supports mouse events on `interactive: true` paths, so this does not force a return to SVG. Hit tolerance needs widening — a 3 px line is hard to hit — which in canvas means a wider transparent companion path, the same trick the episode map uses for click-to-seek.

Tooltip contents, as requested: episode index, time of day, distance in metres. Add frame count, because it is free and answers "is this a long recording or a short one".

Keyboard and screen-reader equivalent: the tooltip cannot be the only route to this information. A route list beside the map, focusable, showing the same fields, is the accessible form — and it is also the fastest way to find a specific episode, which the map alone does not give.

### D. Heatmap when zoomed out

The requested unit is **episodes per area**, not points per area — "10 episodes in this circle". That is a distinct-episode count per cell, and it is not the same as a point-density heatmap, which would weight a long recording more heavily than a short one.

Proposed approach:

- Bin each route's points into a fixed geographic grid, at a cell size chosen per zoom level.
- Per cell keep a **set** of episode indices; render the set's size.
- Below a zoom threshold, draw cells as circles labelled with the count; above it, cross-fade to the routes themselves.

Aggregation belongs in the pure geometry module and must be unit-testable without a map. It is derived from the same reduced routes, so it costs no extra fetch.

The cross-fade threshold is a judgement call that should be made against real data, at the point where individual routes stop being distinguishable — measure it, do not guess it.

### E. Statistics

The end product. Two questions, both answerable from the aggregates in D:

- **Metres driven per zone.** Sum `lengthMeters` per grid cell, or per named region if a region definition ever exists. Attribute a route's distance to the cell it falls in; for routes crossing cells, split by the fraction of segment length in each — stating the method matters, because "distance per zone" is ambiguous otherwise.
- **Most-travelled points.** Highest distinct-episode count per cell. Present as a ranked table beside the map, each row linking to the cell.

Both are cross-episode summaries, and both belong next to the map rather than inside it.

### F. Scaling to the full dataset

This is the package that decides whether the tab survives the gated split, and it should be built **before** D and E are pointed at thousands of episodes.

Iteration 1 reads every sampled episode's shard up front. That is right for hundreds and wrong for thousands. The replacement is a level-of-detail loader:

| Level | Source | Cost | Used for |
|---|---|---|---|
| 1 — extents | `meta/episodes` per-episode waypoint `min`/`max` | one metadata read, no data shard | zoomed-out heatmap, deciding what is on screen |
| 2 — geometry | data shards, three columns, viewport-scoped | one fetch per shard actually needed | drawn routes, hover, distance |

Level 1 is the key: **the per-episode waypoint `min`/`max` in `meta/episodes` were verified exact** during the 2026-09-07 round. A bounding box per episode is enough to place it, count it in a cell, and decide whether to fetch it. Note the companion finding from that round — the stored `mean` falls outside the stored min/max in 12 of 14 episodes, so use min/max and recompute anything else.

Distance cannot come from Level 1; a bounding box does not know path length. Either accept that per-zone distance requires Level 2 geometry for the episodes in view, or cache computed lengths per episode after the first fetch. The second is better and should be measured.

## Sequencing

A → B → C are independent of scale and can be built and verified on the sample. **F before D and E**, so the aggregates are built on the loader that will survive. Each package lands with unit tests for its pure part and an entry in [feature-list.json](../../harness/feature-list.json) that stays `passes: false` until verified by its stated method.

## Open questions for Nicolas

1. **Midday.** The dataset offers only `Daytime` and `Night`. Options: ship the two the data has; or wait until the gated split is inspected in case it publishes more. Inventing a midday bucket is not on the table — there is no absolute timestamp to derive it from.
2. **Zones.** Are they the arbitrary grid cells proposed in D, or something meaningful — city, site, state? The sample's 9 distinct sites suggest "site" is the natural unit, and it could be derived by clustering rather than a grid.
3. **Weather, road type and surface** are available and vary within an episode. Worth colouring segments by, or is time of day enough for now?
