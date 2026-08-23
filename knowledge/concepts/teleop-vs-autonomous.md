# Teleoperación vs autonomía

Robot.com grabó **los dos modos** en entregas reales. El `action` de cada frame lo escribe quien tuviera el control:

- **Autónomo:** Nav2 custom + GPS/RTK + OSM.
- **Remoto:** un operador manda el mismo `Twist`.

Las cámaras son siempre las del rover. Cambia el conductor.

El sample **no** trae flag `teleop` / `autonomous`. No se puede filtrar “solo autónomo” con el schema actual. Las `task` en inglés las pone un VLM después; no son lo que leía Nav2 ni el operador.

Mezclar estilos de comando también alimenta la métrica jerky.
