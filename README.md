# CourseData
A repository of JSON files for golf course that are sourced by the community and built using the [CourseBuilder](https://github.com/SpotGolf/CourseBuilder) macOS app.

# Contributing
To contribute a file, follow these steps:

1. Download the CourseBulider app
2. Build the course you want to add
3. Export the course to JSON
4. Fork this repository and add the file to your fork
5. Open a PR and include a link to the courses website in the PR

## Index

The root `index.json` file lists every course in the repository so clients can search and find nearby courses without a backend. A companion `index.version` file contains an incremental integer — clients compare it against their cached version to know when to re-download the index.

Each entry looks like:

```json
{
  "name": "Broadlands Golf Course",
  "coordinate": { "latitude": 39.956543, "longitude": -105.040375 },
  "holes": 18,
  "path": "US/CO/Broomfield/Broadlands-Golf-Course.json"
}
```

When you add or remove a course, update `index.json` and increment the number in `index.version`.

## Structure

Your fork should use these structure and naming conventions:

* Files should be named based on the course name (CourseBuilder has good defaults and since no cities have duplicate names that we know of, collisions shouldn't be an issue)
* Place the file in the correct country, state/province/locality, and city folders
* Countries are ISO 3166-1 two-letter codes (i.e. US)
* States/province/locality are ISO 3166-2 codes
* Cities are the full name (capital case)
* Course names should exclude prefixes such as "the" (it makes it simpler to find things)

An example:

US/CO/Broomfield/Broadlands-Golf-Course.json
