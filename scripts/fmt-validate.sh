#!/usr/bin/env bash
set -euo pipefail

terraform fmt -recursive
find live/accounts -mindepth 2 -maxdepth 2 -type f -name backend.tf | sort | while read -r backend; do
  dir="$(dirname "$backend")"
  (
    cd "$dir"
    terraform init -backend=false -input=false
    terraform validate
  )
done
