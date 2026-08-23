# Rosetta

Puente **ROS 2 ⇄ LeRobot**. Nombre: Piedra de Rosetta (dos idiomas). Repo: [iblnkn/rosetta](https://github.com/iblnkn/rosetta). Anuncio: [ROS Discourse](https://discourse.ros.org/t/announcing-rosetta-a-ros-2-lerobot-bridge/50657).

ROS 2 habla topics anidados (`geometry_msgs/Twist` en `/cmd_vel`). LeRobot habla vectores planos (`action = [vx, wz]`) y mp4. Rosetta usa un **contract YAML**: este topic es esta feature, a este fps, con esta regla de alineación (`asof`, etc.).

Robot.com usó una versión **adaptada** para la ida: bag/MCAP → dataset. El `as-of-nearest` de la cámara frontal es esa regla, no magia del visualizador.

El paquete original también puede:

1. Grabar episodios a rosbag  
2. Convertirlos a LeRobot con el mismo contract  
3. Entrenar  
4. **PolicyBridge:** el policy lee observaciones y publica `/cmd_vel`

No es un modelo, ni RViz, ni un plugin de Nav2. Nav2 (o el humano) puede ser quien **produzca** el Twist que Rosetta empaqueta. Al desplegar un policy, el bridge **publica** Twist como haría Nav2.

En este lab **no hace falta Rosetta al inicio**. Los datos ya están en LeRobot. Haría falta:

- para **publicar** un episodio otra vez como topics (si no escribimos un nodo mínimo nuestro), o  
- el día que un policy entrenado tenga que hablar con TurtleBot/ROS 2.

Replay simple de `action` → `/cmd_vel` en TurtleBot se puede hacer con un script Python/ROS 2 sin Rosetta.
