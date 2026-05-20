#!/usr/bin/env bash
set -euo pipefail
FILES="${1:-20}"
NUMBERS_PER_FILE="${2:-400000}"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BASE_DIR="$ROOT_DIR/data/base"
mkdir -p "$BASE_DIR"

printf 'Preparing %s base files, %s integers in each file...\n' "$FILES" "$NUMBERS_PER_FILE"
for i in $(seq 1 "$FILES"); do
  file="$BASE_DIR/file_${i}.txt"
  seq 1 "$NUMBERS_PER_FILE" > "$file"
  printf 'created %s\n' "$file"
done
