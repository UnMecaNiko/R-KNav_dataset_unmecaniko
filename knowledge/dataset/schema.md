# Schema (sample, LeRobot v3)

Fuente: `meta/info.json` del sample, leído 2026-08-23. Si el Hub cambia, gana el archivo remoto.

- `codebase_version`: v3.0  
- `robot_type`: rover  
- `fps`: 10  
- `total_episodes`: 14  
- `total_frames`: 18054  
- `total_tasks`: 13  
- Vídeo: H.264, 360×640, 10 fps, sin audio  

## Features

| Nombre | Tipo | Shape | Notas |
|---|---|---|---|
| `observation.image.main` | video | 360×640×3 | Frontal (master de sync) |
| `observation.image.left` | video | 360×640×3 | |
| `observation.image.right` | video | 360×640×3 | |
| `observation.image.rear` | video | 360×640×3 | |
| `observation.state.waypoints` | float32 | [2] | Ficha: (long, lat). **El ejemplo `[1.48, -0.03]` no parece WGS84 de un campus US.** Validar en parquet antes de OSM/OSRM. |
| `observation.state` | float32 | [2] | `twist.twist.linear.x`, `twist.twist.angular.z` — odometría medida |
| `action` | float32 | [2] | `twist.linear.x`, `twist.angular.z` — comando (teleop o Nav2) |
| `observation.state.road_type` | string | [1] | p.ej. sidewalk |
| `observation.state.surface` | string | [1] | p.ej. asphalt |
| `observation.state.weather` | string | [1] | p.ej. sunny |
| `observation.state.time_of_day` | string | [1] | p.ej. daytime |
| `timestamp`, `frame_index`, `episode_index`, `index`, `task_index` | índices | | |
| Task (instrucción) | string | | Generada por VLM; ejemplos en el README del Hub |

No hay columna de modo teleop/autónomo. El README menciona IMU alineada; en `info.json` del sample no aparece como feature aparte — confirmar en parquet.

`action` ≠ `observation.state`. El primero es lo mandado; el segundo, lo medido. Integrarlos por separado (experimento odom vs GPS).
