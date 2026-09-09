#!/usr/bin/env bash
# Bootstrap the lab so an agent or a human can get to a running app and a green
# test suite without reading anything else first.
#
#   ./harness/init.sh          check the environment and report
#   ./harness/init.sh setup    also install dependencies
#   ./harness/init.sh verify   also run the full validation gate
#   ./harness/init.sh run      also start the production server
#
# The app is NOT in this repository. It lives in a fork of
# huggingface/lerobot-dataset-visualizer on branch feat/episode-route-map.
# Point VISUALIZER_DIR at it, or let this script look next door.

set -euo pipefail

MODE="${1:-check}"
LAB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
VISUALIZER_DIR="${VISUALIZER_DIR:-$(dirname "$LAB_DIR")/lerobot-dataset-visualizer-unmecaniko}"
BRANCH="feat/episode-route-map"
SAMPLE_DIR="$LAB_DIR/data/raw/robotcom/R-KNav_sample"

ok()   { printf '  \033[32mok\033[0m    %s\n' "$1"; }
warn() { printf '  \033[33mwarn\033[0m  %s\n' "$1"; }
fail() { printf '  \033[31mFAIL\033[0m  %s\n' "$1"; }

echo "Lab:        $LAB_DIR"
echo "Visualizer: $VISUALIZER_DIR"
echo

echo "Tooling"
command -v bun >/dev/null 2>&1 && ok "bun $(bun --version)" || fail "bun not found — https://bun.sh"
command -v git >/dev/null 2>&1 && ok "git present" || fail "git not found"
echo

echo "Code"
if [ -d "$VISUALIZER_DIR/.git" ]; then
  ok "fork found"
  current="$(git -C "$VISUALIZER_DIR" rev-parse --abbrev-ref HEAD)"
  [ "$current" = "$BRANCH" ] && ok "on $BRANCH" || warn "on '$current', expected '$BRANCH'"
  git -C "$VISUALIZER_DIR" remote get-url origin >/dev/null 2>&1 \
    && ok "origin remote set" \
    || warn "no origin remote — this code exists only on this machine"
  [ -d "$VISUALIZER_DIR/node_modules" ] && ok "dependencies installed" || warn "dependencies missing (run: $0 setup)"
else
  fail "fork not found. Clone huggingface/lerobot-dataset-visualizer next to this repo,"
  fail "check out $BRANCH, or set VISUALIZER_DIR."
  exit 1
fi
echo

echo "Data (optional — the app reads the Hub at runtime)"
if [ -f "$SAMPLE_DIR/data/chunk-000/file-000.parquet" ]; then
  ok "local R-KNav sample present"
else
  warn "no local sample; see knowledge/dataset/local-download.md"
fi
echo

if [ "$MODE" = "setup" ] || [ "$MODE" = "verify" ] || [ "$MODE" = "run" ]; then
  echo "Installing dependencies"
  (cd "$VISUALIZER_DIR" && bun install --frozen-lockfile)
  echo
fi

if [ "$MODE" = "verify" ] || [ "$MODE" = "run" ]; then
  echo "Validation gate: type-check, lint, format, tests"
  (cd "$VISUALIZER_DIR" && bun run validate)
  echo
fi

if [ "$MODE" = "run" ]; then
  echo "Building and starting on http://localhost:3000"
  echo "Map tab: http://localhost:3000/robotcom/R-KNav_sample/episode_0"
  (cd "$VISUALIZER_DIR" && bun run build && bun run start)
fi

echo "Next: harness/progress.md, then harness/feature-list.json"
