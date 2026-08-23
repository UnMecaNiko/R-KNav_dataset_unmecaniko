# Experimento: replay TurtleBot

**Objetivo.** Publicar los `action` de un episodio como `/cmd_vel` a un TurtleBot en simulación (Gazebo) y verlo en RViz.

**Expectativa honesta.** Misma *familia* de movimiento (diferencial), no el campus de R-Kiwi. Drift igual que en dead reckoning. Sirve para oficio ROS 2, no para validar Nav2.

**No usar.** Los MP4 en este experimento. Nav2 tampoco (eso es el siguiente).

**Herramientas.** ROS 2 Jazzy, sim del TurtleBot que se elija, RViz. Script que lea parquet/LeRobot y publique `geometry_msgs/Twist` a 10 Hz con los timestamps del episodio (o a fps fijo).

**Salida.** `experiments/turtlebot-replay/` + captura o instrucciones de lanzado. Sin bags enormes en git.

**Estado.** Pendiente. Elegir TurtleBot 3 vs 4 al implementar.
