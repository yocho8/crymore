#!/usr/bin/env bash
set -euo pipefail

WORKLOAD="${1:?usage: benchmark.sh cpu|io seq|par 1cpu|2cpu}"
MODE="${2:?usage: benchmark.sh cpu|io seq|par 1cpu|2cpu}"
CPU_LABEL="${3:?usage: benchmark.sh cpu|io seq|par 1cpu|2cpu}"
MAX_N="${MAX_N:-20}"
REPS="${REPS:-10}"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RESULTS_DIR="$ROOT_DIR/results"
mkdir -p "$RESULTS_DIR"

case "$WORKLOAD" in
  cpu|io) ;;
  *) echo "WORKLOAD must be cpu or io" >&2; exit 2 ;;
esac
case "$MODE" in
  seq|par) ;;
  *) echo "MODE must be seq or par" >&2; exit 2 ;;
esac

RUNNER="$ROOT_DIR/scripts/run_${WORKLOAD}_${MODE}.sh"
OUT="$RESULTS_DIR/${WORKLOAD}_${MODE}_${CPU_LABEL}.csv"

echo "n,rep,time_sec,max_rss_kb" > "$OUT"

for n in $(seq 1 "$MAX_N"); do
  for rep in $(seq 1 "$REPS"); do
    if [[ "$WORKLOAD" == "io" ]]; then
      "$ROOT_DIR/scripts/reset_io_work.sh" "$n"
    fi

    tmp="$(mktemp)"
    /usr/bin/time -f "%e,%M" -o "$tmp" "$RUNNER" "$n"
    measurement="$(cat "$tmp")"
    rm -f "$tmp"

    printf '%s,%s,%s\n' "$n" "$rep" "$measurement" >> "$OUT"
    printf '%s %s %s: N=%s rep=%s time,rss=%s\n' "$WORKLOAD" "$MODE" "$CPU_LABEL" "$n" "$rep" "$measurement"
  done
done

printf 'saved: %s\n' "$OUT"
