#!/usr/bin/env bash
set -euo pipefail
N="${1:?usage: run_cpu_par.sh N}"
CPU_ITERS="${CPU_ITERS:-80000000}"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

pids=()
for i in $(seq 1 "$N"); do
  "$ROOT_DIR/bin/cpu_task" "$i" "$CPU_ITERS" >/dev/null &
  pids+=("$!")
done

for pid in "${pids[@]}"; do
  wait "$pid"
done
