#!/usr/bin/env bash
# Fetches dbt-labs/dbt-fusion CHANGELOG.md and prints one version tag per line
# (e.g. v2.0.0-preview.171), sorted ascending.
# Exits 1 if no versions are found (likely a CHANGELOG format change).

set -euo pipefail

VERSIONS=$(curl -sf \
  "https://raw.githubusercontent.com/dbt-labs/dbt-fusion/main/CHANGELOG.md" \
  | grep -oP '(?<=## )\d+\.\d+\.\d+-[a-z]+\.\d+' \
  | sort -uV \
  | sed 's/^/v/')

if [ -z "$VERSIONS" ]; then
  echo "No versions found — CHANGELOG format may have changed" >&2
  exit 1
fi

echo "$VERSIONS"
