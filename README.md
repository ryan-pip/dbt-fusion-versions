# dbt-fusion-versions

Version tracking repo for [dbt Fusion](https://github.com/dbt-labs/dbt-fusion) — powers the aqua package [`getdbt.com/dbt-fusion`](https://github.com/aquaproj/aqua-registry).

## How it works

A scheduled GitHub Action runs every 6 hours and parses the [`CHANGELOG.md`](https://github.com/dbt-labs/dbt-fusion/blob/main/CHANGELOG.md) from `dbt-labs/dbt-fusion`. For each version found, it creates a matching git tag in this repo if one doesn't already exist.

This gives [aqua](https://aquaproj.github.io/) a `version_source: github_tag` to enumerate available versions, since `dbt-labs/dbt-fusion` has no GitHub releases or tags of its own.
