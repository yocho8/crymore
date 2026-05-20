#!/usr/bin/env bash
set -euo pipefail
N="${1:?usage: run_io_par.sh N}"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

pids=()
for i in $(seq 1 "$N"); do
  "$ROOT_DIR/bin/io_task" "$ROOT_DIR/work/file_${i}.txt" >/dev/null &
  pids+=("$!")
done

for pid in "${pids[@]}"; do
  wait "$pid"
done
