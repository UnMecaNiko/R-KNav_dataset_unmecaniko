# VLM and VLA

**VLM (Vision-Language Model):** it sees images (or video) and talks. Input: a picture + a question. Output: text. Examples: GPT-4o, Gemini, LLaVA, Qwen-VL. An LLM only reads text; a VLM adds vision.

In R-KNav the VLM **was not driving**. After recording, using the front camera and a prompt, it wrote:

- the instruction (`task`: "Turn left at the white van…")
- surface, weather, road type (according to the card)

**VLA (Vision-Language-Action):** same kind of input (vision + text) but the output is a **robot action** (`linear.x`, `angular.z`). That is what Robot.com invites people to train. The VLM describes; the VLA acts.

This lab does not start with a VLA. The sample is far too small for a foundation model. The vision thread sits at the end of the [roadmap](../experiments/roadmap.md).
