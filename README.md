# dbt-fusion-versions

Version tracking repo for [dbt Fusion](https://github.com/dbt-labs/dbt-fusion) — powers the aqua package [`getdbt.com/dbt-fusion`](https://github.com/aquaproj/aqua-registry).

## How it works

A scheduled GitHub Action runs every 6 hours and reads dbt Fusion's [`versions.json`](https://public.cdn.getdbt.com/fs/versions.json) manifest — the same file the official [install script](https://public.cdn.getdbt.com/fs/install/install.sh) uses to resolve which version to download. It's a map of release channels (`latest`, `stable`, `dev`, `nightly`, `canary`, `extended`, `fallback`, `st-monday`/`st-wednesday`/`st-thursday`, …) to the version tag each currently points at. For every distinct tag found, the action creates a matching git tag in this repo if one doesn't already exist.

The pre-release channels `dev`, `nightly`, and `canary` are excluded: a git tag carries no channel metadata, so aqua can't distinguish a bleeding-edge build from a real release and would otherwise offer it as an installable version. All other channels are promoted/stable pointers and are kept. (The exclusion list lives in `parse-versions.sh`.)

This gives [aqua](https://aquaproj.github.io/) a `version_source: github_tag` to enumerate available versions, since `dbt-labs/dbt-fusion` has no GitHub releases or tags of its own.

> **Note:** an earlier version of this repo parsed `dbt-labs/dbt-fusion`'s `CHANGELOG.md`. dbt-labs moved release distribution to the CDN manifest and stopped keeping that CHANGELOG current on `main`, so the sync switched to `versions.json`. Because the manifest exposes channel tips rather than a full history, intermediate preview builds that no channel points at are not tagged.

## Files

- `.github/scripts/parse-versions.sh` — fetches `versions.json` and prints the distinct version tags; shared by both workflows so the parsing logic lives in one place
- `.github/workflows/sync.yml` — scheduled job (every 6 hours) that calls the script and creates any new tags
- `.github/workflows/validate.yml` — PR check that calls the script dry-run to confirm parsing still works before merging
