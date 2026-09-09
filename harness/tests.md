# Tests

What is tested, how to run it, and — the part that matters most — what the suite provably cannot catch.

The code under test lives in the visualizer fork, not here. See [architecture.md](architecture.md).

## Running everything

```bash
cd <fork>                 # branch feat/episode-route-map
bun run validate          # type-check → lint → format check → unit tests
```

One command, four sensors, and it is the gate before any commit. Individually:

```bash
bun run type-check        # tsc over src and the test project
bun run lint              # next lint
bun run format:check      # prettier
bun test                  # bun's runner
bun test src/utils/__tests__/datasetRoutes.test.ts   # one file
```

## Inventory

Last run 2026-09-08: **247 pass, 0 fail, 2,004 assertions, 9 files.**

| Suite | Tests | Covers |
|---|---|---|
| Upstream suites | 157 | Everything the fork inherited, unchanged |
| `geoTrack.test.ts` | 60 | Feature resolution, coordinate validation, extraction, time lookup, polyline construction |
| `datasetRoutes.test.ts` | 30 | Metric→degree conversion, radial filtering, Douglas-Peucker, vertex capping, route building, bounds merging |

The upstream 157 are held at exactly 157: if that number moves, the fork has changed behaviour it was not supposed to touch.

## What the unit tests are for

Every pure decision that would be expensive to discover in a browser:

- **Refusing to guess.** R-KNav stores a twist pair and a longitude/latitude pair as the same `float32[2]`. Tests assert that shape alone resolves to *no map*.
- **Refusing a false location.** Coordinates outside geographic range mark a local/metric frame, and the track is dropped rather than drawn somewhere on Earth.
- **Geometry that keeps its shape.** A straight line collapses to two points; a corner beyond the tolerance survives; a wobble under it does not; endpoints are never lost.
- **Bounded work.** Douglas-Peucker is quadratic in the worst case. A test feeds it 60,000 corner-only points and asserts the route still builds in under 4 seconds, because that cap is the only thing standing between one bad episode and a frozen tab.

That last test is worth its own note: it was written after an earlier version of it *failed*, taking 61 seconds. The cap exists because the test found the problem, not the other way round.

## Data checks — against the dataset, not fixtures

Unit tests use synthetic fixtures. Claims about R-KNav itself are checked with throwaway scripts that read the real parquet under `data/raw/` (git-ignored; see [../knowledge/dataset/local-download.md](../knowledge/dataset/local-download.md)).

Measured this way, and reproducible:

- `observation.state.waypoints` is one Arrow `fixed_size_list<float>[2]`, ordered `[longitude, latitude]`.
- 0 invalid rows in all 18,054 frames of the sample.
- 5,340 distinct consecutive positions — 70% of frames repeat their predecessor, because float32 quantizes position onto a ~0.6 m grid.
- The 14 episodes sit at 9 geographically distinct sites; consecutive episodes can be 2,900 km apart.
- `observation.state.time_of_day` takes exactly two values in the sample: `Daytime` and `Night`.

Write these as scripts under the fork's root, run them with `bun`, and **delete them** — they are evidence-gathering, not fixtures. Record the numbers here or in the experiment's results note.

## What this suite cannot catch

Stated plainly, because the gap is real and has cost defects before.

Unit tests exercise pure functions. They do not open a browser, so they cannot see:

- a map layer stealing a global keyboard shortcut;
- an initial viewport fit being undone a frame later;
- a documented configuration switch that is never actually called;
- a route drawn at half the size the viewport allows;
- anything about tiles, layout, focus order, or contrast.

Every one of those was a real defect found by hand in the previous round. **There is no automated browser sensor in this repository yet.** Until there is, features whose verification method is `browser` stay at `passes: false` in [feature-list.json](feature-list.json) with a note, and no agent may mark them true from a passing `bun test`.

Closing this — Playwright MCP, or a Playwright suite in the fork — is tracked in [../planning/todo.md](../planning/todo.md).
