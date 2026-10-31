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

### Course File Format

Each course file is a gzipped JSON object with these top-level fields:

| Field | Description |
|---|---|
| `id` | Unique ID (UUID) |
| `name`, `clubName` | Course and club names |
| `location` | Address, city, state, country, and `coordinate` (`lat`, `lon`, `ele` in meters) |
| `tees` | Tee sets, each with a `name` and `color` |
| `comboTees` | Combination tee sets, each with a `name` and the `tees` it mixes |
| `features` | Map shapes, each with an `id`, `type` (`tee`, `fairway`, `green`, `bunker`, `water`, or `centerline`), and `polygon` |
| `subCourses` | Groups of holes (e.g., Front and Back nines), with par and yardage totals per tee and gender |
| `golfCourseAPIIds` | Optional IDs for the course in GolfCourseAPI |

Each hole in `subCourses[].holes` has a `number`, `par`, `maleHandicap`, `femaleHandicap`, `yardages` per tee, the tee used for each combo tee, the IDs of its `features`, and the ID of its `centerline` feature.

A `polygon` is stored as `{"values": [...]}`, three numbers per point: latitude and longitude in 1/365,000 of a degree, and elevation in feet. The first point's numbers are stored as-is. Each later number is the difference from the same number in the previous point. A missing elevation is `null`.

Short example (with most features and holes removed):

```json
{
  "id": "7173C487-C2E7-4D02-9623-754C55D4486C",
  "name": "Broadlands Golf Course",
  "clubName": "Broadlands Golf Course",
  "location": {
    "address": "4380 W 144th Ave, Broomfield, CO 80023, USA",
    "city": "Broomfield",
    "state": "CO",
    "country": "United States",
    "coordinate": { "lat": 39.956545, "lon": -105.040375, "ele": 1622.9 }
  },
  "tees": [
    { "name": "Black", "color": "#000000" },
    { "name": "Gold", "color": "#FFD700" }
  ],
  "comboTees": [
    { "name": "Black/Gold", "tees": ["Black", "Gold"] }
  ],
  "features": [
    { "id": 1, "type": "tee", "polygon": { "values": [14590299, -38331072, 5324, -17, 10, -2, -5, -32, 1, 21, -9, 2] } },
    { "id": 2, "type": "green", "polygon": { "values": [14590518, -38330868, 5327, 53, -10, 1, -1, 30, -1, -28, 13, 0] } },
    { "id": 3, "type": "centerline", "polygon": { "values": [14590291, -38331057, 5323, 93, 203, -1, 158, -2, 5] } }
  ],
  "subCourses": [
    {
      "id": "FDE2B683-5B0A-440B-9E6F-393C16B95B9F",
      "name": "Front",
      "tees": {
        "Black": { "male": { "parTotal": 36, "totalYards": 3656 } },
        "Gold": { "male": { "parTotal": 36, "totalYards": 3383 } }
      },
      "comboTees": {
        "Black/Gold": { "male": { "parTotal": 36, "totalYards": 3510 } }
      },
      "holes": [
        {
          "number": 1,
          "par": 4,
          "maleHandicap": 13,
          "femaleHandicap": 9,
          "yardages": { "Black": 405, "Gold": 380 },
          "comboTees": { "Black/Gold": "Gold" },
          "features": [1, 2],
          "centerline": 3
        }
      ]
    }
  ]
}
```

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
