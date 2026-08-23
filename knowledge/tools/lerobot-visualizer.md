# LeRobot Dataset Visualizer

Space: [huggingface.co/spaces/lerobot/visualize_dataset](https://huggingface.co/spaces/lerobot/visualize_dataset)  
Código: [huggingface/lerobot-dataset-visualizer](https://github.com/huggingface/lerobot-dataset-visualizer)

Sirve para **inspeccionar** un dataset LeRobot v2+/v3 en el navegador: vídeo sincronizado con curvas, Overview, Filtering (jerky / low movement), Action Insights. Pestaña 3D URDF: brazos SO-100/101, **no** el R-Kiwi.

No hay tutorial largo ni vídeo dedicado al Space (búsqueda 2026-08-23). Docs cortas: [Using Dataset Tools](https://huggingface.co/docs/lerobot/en/using_dataset_tools). Vídeos de LeRobot (LeLab, Trossen) mencionan “visualizar” de pasada, casi siempre con un brazo.

R-KNav sample se abre pegando `robotcom/R-KNav_sample`. El set de 300 h pide login y gate.

CLI distinto (Rerun/Foxglove, no esta UI):

```bash
lerobot-dataset-viz --repo-id robotcom/R-KNav_sample --episode-index 0
```

Esto **no entrena**. Para elegir qué episodio mirar a mano (p.ej. uno suave vs el más jerky) está bien. No rehacer sus gráficos en un notebook: no aporta.
