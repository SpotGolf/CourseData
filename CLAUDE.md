# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a **data-only repository** — no application code, build system, tests, or linting. It stores golf course JSON files contributed by the community using the [CourseBuilder](https://github.com/SpotGolf/CourseBuilder) macOS app.

## Directory Structure Convention

Course files are organized geographically:

```
{Country}/{State}/{City}/{Course-Name}.json
```

- **Country**: ISO 3166-1 two-letter code (e.g., `US`)
- **State/Province**: ISO 3166-2 code (e.g., `CO`)
- **City**: Full name, capital case (e.g., `Broomfield`)
- **Course name**: Hyphenated, excluding prefixes like "the" (e.g., `Broadlands-Golf-Course.json`)

Example: `US/CO/Broomfield/Broadlands-Golf-Course.json`

## Index and Version Files

The repository maintains two root-level files for client-side course discovery:

- **`index.json`** — An array of all courses with metadata for search and proximity lookup.
- **`index.version`** — A single incremental integer. Clients compare this against their cached version to decide whether to re-download `index.json`.

**Index entry format:**
```json
{
  "name": "Broadlands Golf Course",
  "coordinate": { "latitude": 39.956543, "longitude": -105.040375 },
  "holes": 18,
  "path": "US/CO/Broomfield/Broadlands-Golf-Course.json"
}
```

City, state, and country are derived from the `path` field.

**Maintenance rules:**
- When a course JSON file is added, removed, or renamed, update `index.json` accordingly and increment the integer in `index.version`.
- Keep `index.json` sorted alphabetically by `path`.

## Contribution Process

Contributions come via pull requests. Each PR should include a link to the course's website. Course JSON files are exported from the CourseBuilder macOS app.

## License

CC0 1.0 Universal — public domain.
