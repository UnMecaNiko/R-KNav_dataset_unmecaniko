# Implementation results

Executed on 2026-09-06/07 against upstream `huggingface/lerobot-dataset-visualizer` `main` at `dc59887796fd41f37040c0df6b10e6f6a30a1854` — re-checked at the start of implementation and still the current `main`, so the [research notes](research-notes.md) needed no refresh.

**Status: implemented, verified, and running.** Phases 0–4 of the [implementation plan](implementation-plan.md) are complete. Phase 5 (delivery) is pending a decision, see [Open items](#open-items).

## Where the code lives

A working clone of the visualizer, on branch `feat/episode-route-map`, one commit ahead of upstream `dc59887`. Following the plan, it is **not** vendored into this lab: this repository keeps the product design, the data ground truth, and the verification results.

> ⏳ TODO: Push the branch to a public fork under `github.com/UnMecaNiko/` and record the URL and pinned commit here. `gh` was not authenticated during implementation, so the fork could not be created from the session.

The feature's own documentation — configuration reference, architecture note, licensing note, known limits — lives with the code in `EPISODE_MAP.md`.

## What was built

| Module | Role |
|---|---|
| `src/utils/geoTrack.ts` | Feature resolution, extraction, validation, time lookup, polyline construction. Pure, framework-free, unit-tested. |
| `src/utils/geoConfig.ts` | Environment-backed configuration. |
| `src/components/episode-map.tsx` | Leaflet leaf component, lazily loaded, client-only. |
| `src/utils/__tests__/geoTrack.test.ts` | 60 unit tests. |
| `fetch-data.ts` | Builds `EpisodeData.geoTrack` from full v3 rows, before chart downsampling. |
| `episode-viewer.tsx` | Mounts the map between the language instruction and the charts. |

2,014 lines added across 12 files. Leaflet 1.9.4 is the only new runtime dependency, and it is code-split into a single lazy 148 KB chunk absent from every shared bundle.

## Verified R-KNav data contract

Measured directly from `data/chunk-000/file-000.parquet`, not taken from `stats.json`:

- `observation.state.waypoints` is **one** column, Arrow `fixed_size_list<float>[2]`, order `[longitude, latitude]`. `info.json` declares no `names` for it, so the order is only inferable from value ranges — which is exactly why the resolver refuses to guess.
- **0 invalid rows** in all 18,054 frames: no nulls, no NaN, no infinities, nothing outside geographic range. Invalid-row handling is therefore covered by synthetic fixtures in the unit tests, not by the sample.
- Timestamps strictly increase in every episode and restart at 0.0; dt stays within float32 noise of 0.1 s; no gap exceeds 0.15 s.
- The 14 episodes sit at **9 geographically distinct sites** across the continental US. Consecutive episodes are up to 2,900 km apart, which is why bounds are fitted per episode and never dataset-wide.
- float32 storage quantizes position onto a ~0.6 m longitude grid. **70.4% of consecutive frames are exact repeats**, so 18,054 frames reduce to 5,340 drawn polyline vertices. This is also why the drawn line visibly stair-steps at deep zoom — it is the data, not a rendering fault.
- Episode 12 spans 16 m with a bbox aspect ratio of about 19:1 — the worst `fitBounds` case in the sample, and the reason for the zoom ceiling.

### A `meta/episodes` caveat, beyond the one already recorded

[research-notes.md](research-notes.md) documents unreliable quantiles in `meta/stats.json`. Direct comparison found the same class of problem in the per-episode stats block: `stats/observation.state.waypoints/min` and `/max` are **exact** in all 14 episodes, but the stored `mean` falls **outside** the stored min/max for 12 of the 14. Use min/max if convenient; recompute anything else.

## Verification

All figures below are measured, and every browser check ran against the **production build** (`bun run build` + `bun run start`), not the dev server.

### Automated suites

| Suite | Result |
|---|---|
| `bun run validate` — type-check, lint, format check, tests | **217 tests pass, 0 fail** (157 upstream unchanged + 60 new) |
| Episode sweep, all 14 episodes | **196/196 checks pass** |
| Robustness — regression, layout, tile failure, network, performance | **40/40 checks pass** |
| Map controls — pan, zoom, follow, reset, keyboard | **10/10 checks pass** |

The upstream baseline was established first: type-check, lint and 157 tests pass on an untouched checkout. `format:check` initially failed on 75 untouched files, which turned out to be a Windows CRLF artifact of `core.autocrlf=true`, not an upstream defect; normalising the clone to LF made it pass.

### Per-episode checks, against parquet ground truth

For each of the 14 episodes, in a real browser:

- at `t=0` the readout shows the episode's **exact** first recorded fix and frame 0;
- the fitted viewport contains the entire route;
- the drawn route's pixel size matches **independently computed Web Mercator arithmetic** — a check that the map is scaled correctly, not merely that it looks plausible. Episode 0: predicted 221×264 px, observed 221×264 px at zoom 17.61. Episode 12: predicted 131×7 px, observed 131×7 px at the zoom ceiling;
- basemap tiles load and attribution is visible;
- start, end and current markers all render, and the start/end marker labels carry the true first and last fixes from the parquet;
- the marker agrees with the shared clock at five positions per episode — **5/5 exact in every episode**;
- completed and remaining route are drawn in distinct colours;
- clicking the end marker seeks exactly to the last recorded fix;
- clicking the route seeks the shared clock;
- no uncaught page errors.

The manual validation references in the [implementation plan](implementation-plan.md) are all confirmed: episode 0 begins at `[-92.019272, 30.212450]` and ends at `[-92.020828, 30.210846]`; episode 7 has 3,289 frames; episode 12 has the smallest range; episode 13 is the last.

### Regression: datasets without geography

Loaded `youliangtan/so101-table-cleanup` and `rabhishek100/so100_train_dataset` through the app. Both render videos, charts and the playback bar as before, with **no map element**, **zero Leaflet requests**, and no page errors.

### Cost: an A/B measurement, not an assumption

The same build was measured twice — once with `NEXT_PUBLIC_MAP_ENABLED=false`, once enabled:

| Measure | Map off | Map on |
|---|---|---|
| Total parquet-related requests | 30 | **30** |
| `data/chunk-000/file-000.parquet` fetches | 10 | **10** |
| Horizontal overflow at 390×844 | 430 px | **430 px** |
| ArrowDown episode navigation | `/2` → `/episode_3` | **same** |
| Third-party hosts | 4 | same 4, **+ the tile server only** |

So the map introduces **no additional data fetch** and **no host beyond the tile server**. It also showed that the narrow-viewport horizontal overflow and the `github.com` requests are pre-existing upstream behaviour, not regressions — worth stating plainly, because both looked like new faults until measured.

### Defects found and fixed during verification

Verification earned its keep; five real problems surfaced only in the browser.

1. **The initial fit was immediately undone.** Follow mode re-centred on the marker right after `fitBounds`, so every episode opened off-centre with the route running off-screen. Follow now re-centres only when the robot would actually leave the viewport, and the post-fit apply does not pan at all.
2. **`fitBounds` left up to 2× slack.** Leaflet snaps to integer zoom by default and rounds down. `zoomSnap: 0` makes the fit exact.
3. **Very short routes were unreadable.** Episode 12's 16 m route drew about 60 px wide at the OSM maximum native zoom. One step of bounded overzoom now frames it properly.
4. **The documented kill switch did nothing.** `NEXT_PUBLIC_MAP_ENABLED` was implemented but never called — the map rendered regardless. Now wired.
5. **The map silently stole a global keyboard shortcut.** Leaflet focuses its container on click and binds arrow keys to panning, so a single click anywhere on the map — including a click to seek — broke the app's advertised ↑↓ prev/next-episode shortcut until the user clicked elsewhere. Leaflet's keyboard handler is now off; mouse, touch and the focusable zoom control still work.

A sixth was fixed pre-emptively from the same evidence: a drag starting on the route did not pan, because the invisible click-target line suppressed event bubbling and swallowed the mousedown.

## Deviation from the approved spec

The mapped feature is **removed from the charts** by default. Longitude and latitude share a numeric scale with the action series — `groupByScale` merges them — and render as two flat, unreadable lines; shipping both a map and a knowingly meaningless chart would be worse than shipping either. It is configurable via `NEXT_PUBLIC_GEO_HIDE_CHART=false`, and it only ever triggers for a feature the map is actually drawing, so datasets without geography are unaffected.

## Acceptance criteria

Every criterion in [product-spec.md](product-spec.md) is met. Two are worth qualifying rather than simply ticking:

- *"Invalid or local-frame data cannot silently appear at a false world location."* Enforced in code and covered by unit-test fixtures. The public sample contains **zero** invalid rows, so this path has not been exercised against real R-KNav data — no such data exists in the sample to exercise it with.
- *"The application does not prefetch map tiles."* Measured: 14 tile requests for one episode view, at a single zoom level, with `keepBuffer: 1`. Leaflet fetches the viewport plus a one-tile margin; that is normal on-demand loading, not prefetching.

## Open items

> ⏳ TODO: Create the public fork under `github.com/UnMecaNiko/`, push `feat/episode-route-map`, and record the URL and pinned commit above.

> ⏳ TODO: Decide the delivery path (plan Phase 5). The plan recommends option 3 — keep the fork for demonstration and propose the generic feature upstream. The implementation was kept generic and opt-in specifically to allow that.

> ⏳ TODO: Choose a production tile provider before any public deployment. The OSM Standard endpoint is a development default; see the [OSMF tile usage policy](https://operations.osmfoundation.org/policies/tiles/).

> ⏳ TODO: Ask upstream whether it would prefer a metadata convention, an environment variable, or a UI control for geographic feature mapping. The implementation supports the first two; a `names`-based convention is the one it would be easiest for LeRobot to adopt.

> ⏳ TODO: Narrow viewports (below ~1024 px) scroll horizontally. This is pre-existing upstream behaviour, measured identically with the map disabled, and out of scope here — but worth reporting upstream.
