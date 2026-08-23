# Experimento: policy sobre vídeo (más adelante)

**Objetivo.** Entrenar un policy pequeño (ACT / Diffusion / SmolVLA en LeRobot) que, dadas cámaras (+ estado), prediga `action`.

**Realidad.** El sample (~30 min, 14 episodios) sirve para **cerrar el loop de código** (dataset → train → checkpoint). Overfit esperado. Un modelo que merezca FoMo o las 300 h gated es otra fase.

**No empieza ahora.** No bloquea mapas ni TurtleBot. Rosetta no hace falta hasta que el checkpoint deba publicarse en `/cmd_vel` de un robot ROS 2.

**Salida futura.** `experiments/lerobot-policy/` + tarjeta de modelo en el Hub con licencia no comercial y atribución R-KNav.

**Estado.** Aparcado.
