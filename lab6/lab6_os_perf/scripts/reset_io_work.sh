#!/usr/bin/env bash
set -euo pipefail
N="${1:?usage: reset_io_work.sh N}"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BASE_DIR="$ROOT_DIR/data/base"
WORK_DIR="$ROOT_DIR/work"
mkdir -p "$WORK_DIR"
rm -f "$WORK_DIR"/file_*.txt

for i in $(seq 1 "$N"); do
  src="$BASE_DIR/file_${i}.txt"
  dst="$WORK_DIR/file_${i}.txt"
  if [[ ! -f "$src" ]]; then
    echo "missing $src; run ./scripts/prepare_io_data.sh 20 400000 first" >&2
    exit 1
  fi
  cp "$src" "$dst"
done
