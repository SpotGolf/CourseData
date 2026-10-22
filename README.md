# CourseData

A community-sourced repository of golf course JSON files built using the [CourseBuilder](https://github.com/SpotGolf/CourseBuilder) macOS app.

## Contributing Course Data

Course JSON files live in the `Data/` directory, organized geographically, and gzipped to save space and network traffic:

```
Data/{Country}/{State}/{City}/{Course-Name}.json.gz
```

To contribute a course:

1. Download the [CourseBuilder](https://github.com/SpotGolf/CourseBuilder) app
2. Build the course you want to add
3. Export the course to JSON
4. Fork this repository and add the file to your fork
5. Open a PR and include a link to the course's website in the PR

### Naming Conventions

- **Country**: ISO 3166-1 two-letter code (e.g., `US`)
- **State/Province**: ISO 3166-2 code (e.g., `CO`)
- **City**: Full name, capital case (e.g., `Broomfield`)
- **Course name**: Hyphenated, excluding prefixes like "the" (e.g., `Broadlands-Golf-Course.json`)

### Index

The `Data/index.json` file lists every course in the repository so clients can search and find nearby courses without a backend. A companion `Data/index.version` file contains an incremental integer — clients compare it against their cached version to know when to re-download the index.

Each entry looks like:

```json
{
  "name": "Broadlands Golf Course",
  "coordinate": { "latitude": 39.956543, "longitude": -105.040375 },
  "holes": 18,
  "path": "US/CO/Broomfield/Broadlands-Golf-Course.json"
}
```

When you add or remove a course, update `Data/index.json` and increment the number in `Data/index.version`.
