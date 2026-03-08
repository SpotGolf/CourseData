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

## Contribution Process

Contributions come via pull requests. Each PR should include a link to the course's website. Course JSON files are exported from the CourseBuilder macOS app.

## License

CC0 1.0 Universal — public domain.
