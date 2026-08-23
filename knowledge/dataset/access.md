# Acceso

## Sample (empezar siempre aquí)

Repo: [`robotcom/R-KNav_sample`](https://huggingface.co/datasets/robotcom/R-KNav_sample)  
Público, sin gate. ~2,3 GB.

Inspección sin bajar todo: [LeRobot Dataset Visualizer](https://huggingface.co/spaces/lerobot/visualize_dataset) → pegar `robotcom/R-KNav_sample`.

Descarga local (cuando haga falta código): librería `datasets` / `huggingface_hub`, destino `data/` (gitignored). No subir esos archivos.

## 300 h gated

[`robotcom/R-KNav_dataset`](https://huggingface.co/datasets/robotcom/R-KNav_dataset) — `gated: manual`.

El formulario pide empresa, país, responsable, correo institucional, uso (Research / Education / Other), interés en FoMo y en las 10k h, y aceptación de **uso no comercial** + LICENSE.

Hasta tener aprobación, todo experimento usa el **sample**.

## 10 000 h

Correo a `airobotics@kiwicampus.com`. No es el primer paso.

## Cuenta Hugging Face

Hace falta usuario en el Hub para el gate (y a veces para el Space). No guardar tokens en este repo; `.env` local gitignored.
