#!/usr/bin/env bash
# Fetches dbt-labs/dbt-fusion CHANGELOG.md and prints one version tag per line,
# sorted ascending. The pre-release label may be a single word (v2.0.0-beta.5,
# v2.0.0-preview.171) or hyphenated (v2.0.0-preview-nightly.176), so the label
# is matched as [a-z][a-z-]* rather than [a-z]+.
# Exits 1 if no versions are found (likely a CHANGELOG format change).

set -euo pipefail

VERSIONS=$(curl -sf \
  "https://raw.githubusercontent.com/dbt-labs/dbt-fusion/main/CHANGELOG.md" \
  | grep -oP '(?<=## )\d+\.\d+\.\d+-[a-z][a-z-]*\.\d+' \
  | sort -uV \
  | sed 's/^/v/')

if [ -z "$VERSIONS" ]; then
  echo "No versions found — CHANGELOG format may have changed" >&2
  exit 1
fi

echo "$VERSIONS"
