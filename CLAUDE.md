# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This repository contains two things:

1. **A Swift library** (`CourseData`) providing data models for golf courses — `Course`, `Hole`, `Feature`, `Coordinate`, and related types.
2. **A data directory** (`Data/`) of community-sourced golf course JSON files built using the [CourseBuilder](https://github.com/SpotGolf/CourseBuilder) macOS app.

The data is **not** bundled as a Swift package resource. The `Data/` directory lives in the repo alongside the package but is independent of it.

## Build & Test

```bash
swift build
swift test
```

The project targets macOS 14+ and iOS 17+ and uses CoreLocation.

## Directory Structure

### Swift Package

```
Sources/          # Library source files
Tests/            # Test target
Package.swift     # Swift package manifest
```

### Course Data Convention

Course files are organized geographically under `Data/`:

```
Data/{Country}/{State}/{City}/{Course-Name}.json.gz
```

- **Country**: ISO 3166-1 two-letter code (e.g., `US`)
- **State/Province**: ISO 3166-2 code (e.g., `CO`)
- **City**: Full name, capital case (e.g., `Broomfield`)
- **Course name**: Hyphenated, excluding prefixes like "the" (e.g., `Broadlands-Golf-Course.json.gz`)

Example: `Data/US/CO/Broomfield/Broadlands-Golf-Course.json.gz`

These files are gzipped using the maximum compression.

## Index and Version Files

The repository maintains two files under `Data/` for client-side course discovery:

- **`Data/index.json`** — An array of all courses with metadata for search and proximity lookup.
- **`Data/index.version`** — A single incremental integer. Clients compare this against their cached version to decide whether to re-download `index.json`.

**Index entry format:**
```json
{
  "name": "Broadlands Golf Course",
  "coordinate": { "latitude": 39.956543, "longitude": -105.040375 },
  "holes": 18,
  "path": "US/CO/Broomfield/Broadlands-Golf-Course.json.gz"
}
```

City, state, and country are derived from the `path` field.

**Maintenance rules:**
- When a course JSON file is added, removed, or renamed, update `Data/index.json` accordingly and increment the integer in `Data/index.version`.
- Keep `Data/index.json` sorted alphabetically by `path`.

## Contribution Process

Contributions come via pull requests. Each PR should include a link to the course's website. Course JSON files are exported from the CourseBuilder macOS app.

## License

- **Code** (Swift library): MIT — see [LICENSE](LICENSE)
- **Data** (course JSON files): CC0 1.0 Universal — see [Data/LICENSE](Data/LICENSE)
