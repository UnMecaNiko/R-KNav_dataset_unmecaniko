# Download R-KNav locally

Use this procedure after cloning the GitHub repository on a new computer. Dataset files are deliberately absent from Git: the R-KNav license forbids redistribution and `data/` is git-ignored.

Official sources, checked on 2026-09-06:

- Sample: [robotcom/R-KNav_sample](https://huggingface.co/datasets/robotcom/R-KNav_sample)
- Gated dataset: [robotcom/R-KNav_dataset](https://huggingface.co/datasets/robotcom/R-KNav_dataset)
- Hugging Face CLI: [CLI guide](https://huggingface.co/docs/huggingface_hub/guides/cli)

## Canonical local layout

```text
data/
└── raw/
    └── robotcom/
        ├── R-KNav_sample/
        └── R-KNav_dataset/
```

Never remove `data/` from `.gitignore`, commit dataset files, or copy them into `experiments/`.

## 1. Create a Python environment

From the repository root:

```bash
python -m venv .venv
```

Activate it on Windows PowerShell:

```powershell
.\.venv\Scripts\Activate.ps1
python -m pip install --upgrade pip huggingface_hub
```

Or on Linux/macOS:

```bash
source .venv/bin/activate
python -m pip install --upgrade pip huggingface_hub
```

The environment is local and git-ignored. Installing `datasets` is optional; the download itself only needs `huggingface_hub`.

## 2. Download the public sample

```bash
hf download robotcom/R-KNav_sample \
  --repo-type dataset \
  --local-dir data/raw/robotcom/R-KNav_sample
```

The command is resumable: running it again checks the local files and downloads what is missing. Authentication is optional for the public sample, although an authenticated session may have better Hub rate limits.

If video downloads stall on Windows, retry serially over standard HTTP:

```powershell
$env:HF_HUB_DISABLE_XET = "1"
hf download robotcom/R-KNav_sample `
  --repo-type dataset `
  --local-dir data/raw/robotcom/R-KNav_sample `
  --max-workers 1
```

This reuses completed files and partial downloads. It was the stable method on the lab's Windows machine on 2026-09-06.

## 3. Access the gated dataset

First request and receive access on the [dataset page](https://huggingface.co/datasets/robotcom/R-KNav_dataset). Then authenticate locally:

```bash
hf auth login
hf auth whoami
```

Paste a personal read token when prompted. Do not put the token in this repository, a Markdown file, a committed `.env`, or a command that may remain in shell history.

The full gated dataset is approximately 732 GiB according to its Hub card. Check free disk space before downloading it. Do not download it merely to run the first experiments; start with the sample.

When the full dataset is actually required:

```bash
hf download robotcom/R-KNav_dataset \
  --repo-type dataset \
  --local-dir data/raw/robotcom/R-KNav_dataset
```

Use the CLI's `--include` option to fetch a known subset instead of the entire repository when possible. Inspect the current Hub file tree before choosing patterns; do not guess file names.

## 4. Verify the download

Windows PowerShell:

```powershell
Get-ChildItem data/raw/robotcom/R-KNav_sample -Recurse -File |
  Measure-Object -Property Length -Sum
```

Linux/macOS:

```bash
du -sh data/raw/robotcom/R-KNav_sample
```

Also confirm that Git ignores the files:

```bash
git check-ignore data/raw/robotcom/R-KNav_sample
git status --short
```

The first command must report the path as ignored, and dataset files must not appear in `git status`.

For an exact integrity check, run `hf download` again with the same arguments. A successful run returns the local path after comparing the snapshot with the Hub manifest.

## Why not use only `load_dataset`?

This works for Python-side loading:

```python
from datasets import load_dataset

ds = load_dataset("robotcom/R-KNav_sample")
```

However, `load_dataset` normally manages files in the Hugging Face cache rather than in this repository's canonical `data/raw/` layout. Use `hf download --local-dir ...` for a predictable, agent-readable local copy. Experiment code can then read from the canonical path without embedding an absolute machine-specific path.
