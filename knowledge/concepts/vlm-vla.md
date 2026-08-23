# VLM y VLA

**VLM (Vision-Language Model):** ve imágenes (o vídeo) y habla. Entrada: foto + pregunta. Salida: texto. Ejemplos: GPT-4o, Gemini, LLaVA, Qwen-VL. Un LLM solo lee texto; el VLM añade visión.

En R-KNav el VLM **no conducía**. Después de grabar, con la cámara frontal y un prompt, escribió:

- la instrucción (`task`: “Turn left at the white van…”)
- superficie, clima, tipo de vía (según el card)

**VLA (Vision-Language-Action):** misma idea de entrada (visión + texto) pero la salida es **acción de robot** (`linear.x`, `angular.z`). Eso es lo que Robot.com invita a entrenar. El VLM describe; el VLA actúa.

Este lab no empieza por un VLA. El sample es demasiado pequeño para un foundation model. El hilo de visión queda al final del [roadmap](../experiments/roadmap.md).
