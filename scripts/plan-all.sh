#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

find "$ROOT/live/accounts" -mindepth 2 -maxdepth 2 -type f -name backend.tf | sort | while read -r backend; do
  dir="$(dirname "$backend")"
  echo "============================================================"
  echo "Planning: ${dir#$ROOT/}"
  echo "============================================================"
  (
    cd "$dir"
    terraform init -input=false
    terraform validate
    terraform plan -input=false
  )
done
