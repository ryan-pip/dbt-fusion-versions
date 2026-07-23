#!/usr/bin/env bash
# Fetches dbt Fusion's versions.json manifest — the same file the official
# install script (public.cdn.getdbt.com/fs/install/install.sh) reads — and
# prints one git tag per line, sorted ascending, e.g.:
#   v2.0.0-preview.202
#
# versions.json is a map of release channels (latest, stable, dev, nightly,
# canary, extended, fallback, st-monday, st-wednesday, st-thursday, ...) to
# { "tag": "v...", "date": "..." }. dbt-labs stopped publishing releases as
# git tags/releases and no longer keeps CHANGELOG.md on main current, so this
# manifest is the authoritative list of downloadable versions. We emit every
# distinct tag it points at so this repo mirrors each channel tip as a git tag
# for aqua to enumerate.
#
# The pre-release channels below are excluded: a git tag carries no channel
# metadata, so aqua would surface a bleeding-edge dev/nightly/canary build as
# if it were a normal release. Everything else (latest, stable, extended,
# fallback, the st-* scheduled trains, ...) is a promoted/stable pointer and is
# kept. To exclude another channel, add its key to EXCLUDE_CHANNELS.
#
# The manifest URL can be overridden via DBT_FUSION_VERSIONS_URL (used by tests).
# Exits 1 if no versions are found (likely a manifest URL or format change).

set -euo pipefail

VERSIONS_URL="${DBT_FUSION_VERSIONS_URL:-https://public.cdn.getdbt.com/fs/versions.json}"

EXCLUDE_CHANNELS='["dev","nightly","canary"]'

VERSIONS=$(curl -sf "$VERSIONS_URL" \
  | jq -r --argjson exclude "$EXCLUDE_CHANNELS" \
      'to_entries[] | select(.key | IN($exclude[]) | not) | .value | objects | .tag? // empty' \
  | grep -E '^v[0-9]+\.[0-9]+\.[0-9]+' \
  | sort -uV)

if [ -z "$VERSIONS" ]; then
  echo "No versions found — versions.json URL or format may have changed" >&2
  echo "  URL: $VERSIONS_URL" >&2
  exit 1
fi

echo "$VERSIONS"
