# Product specification

## Problem

The current LeRobot Dataset Visualizer synchronizes multi-camera video and numeric time-series charts, but it does not give mobile robots a geographic view. In R-KNav, this forces an investigator to mentally connect camera content, commanded/measured velocities, and longitude/latitude.

## Primary user story

As a robotics learner or dataset investigator, I want to play an episode while watching the robot move along its recorded route, so I can relate turns, stops, commands, measured motion, and visual context to a real place.

## Required episode experience

The existing episode selector, videos, language instruction, charts, playback bar, keyboard controls, and URL time parameter remain functional. When a valid geographic feature is available, the Episodes view additionally shows:

1. An interactive basemap fitted to the current episode.
2. A polyline for the full valid route.
3. Distinct start and end markers.
4. A live robot marker at the playback position.
5. A completed-route segment visually distinct from the remaining route.
6. Current timestamp, frame, longitude, and latitude.
7. A map-point interaction that seeks the shared episode clock.
8. A reset-view control that returns to the episode bounds.
9. Visible basemap attribution.

## Synchronization behavior

- Video playback remains the primary time source already used by the application.
- The map subscribes to the shared time context.
- Seeking from the playback bar or a chart updates the map marker.
- Selecting a route point calls the existing shared `seek` operation, updating videos and charts.
- Changing episode replaces the route, resets the marker, and fits the new bounds once.
- Panning or zooming manually disables automatic re-centering until the user enables follow mode or resets the view.

## Geographic feature discovery

R-KNav uses `observation.state.waypoints` with shape `[2]` and order `[longitude, latitude]`. That name is not a universal LeRobot convention. The feature must therefore be resolved in this order:

1. Explicit application configuration.
2. A future dataset metadata convention, if LeRobot adopts one.
3. A small documented list of recognized names, including the R-KNav key.
4. No map, with an informative empty state, if the result is ambiguous.

Automatic detection must validate finite numbers and geographic ranges. Range validation establishes that coordinates are plausible, not that a formal CRS declaration exists.

## Empty and error states

| State | User-visible behavior |
|---|---|
| No geographic feature | Map region is omitted; existing visualizer behavior is unchanged |
| Ambiguous two-component features | Ask for explicit mapping; do not guess |
| Invalid coordinate rows | Skip invalid rows, show their count, preserve valid route segments |
| Fewer than two valid points | Show the valid point without a route, or an explanatory empty state |
| Basemap unavailable | Keep route and marker on a neutral canvas; show a tile-loading message |
| Entire route outside lon/lat ranges | Treat as a possible local frame; do not place it on a geographic basemap |
| Crossing longitude discontinuity | Split the polyline rather than drawing across the world |

## Responsive behavior

- Desktop: map and episode information may share a row beneath the cameras.
- Narrow screens: stack map below videos and above charts.
- The map requires a stable minimum height and must invalidate its rendered size after layout or tab changes.
- Playback controls remain reachable without horizontal scrolling.

## Accessibility

- Map controls have text labels or accessible names.
- Start, end, and current markers are distinguishable without relying only on color.
- Current coordinates and time are exposed as text.
- Route-point seeking has a keyboard-accessible alternative through the existing playback slider.
- Respect reduced-motion preferences for marker or camera-follow animations.

## First-release acceptance criteria

The release is acceptable when:

- R-KNav sample episodes show the correct recorded route over a real basemap.
- The marker position agrees with the selected episode frame at start, middle, and end.
- Play, pause, playback-bar seek, chart seek, URL `?t=`, and episode navigation keep the map synchronized.
- Clicking a route position seeks all synchronized views.
- Datasets without a geographic feature render exactly as before.
- Invalid or local-frame data cannot silently appear at a false world location.
- The application retains visible map attribution and does not prefetch map tiles.
- Existing upstream validation, type checks, lint, formatting, and tests pass.

## Explicit non-goals for the first release

- OSRM routing or map matching.
- Comparing planned and driven routes.
- Editing GPS points.
- Offline basemap downloads.
- Heatmaps across the full dataset.
- Elevation profiles.
- Heading estimation from camera images.
- Using `stats.json` as the route source.

