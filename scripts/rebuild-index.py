#!/usr/bin/env python3
"""Rebuild Data/index.json and increment Data/index.version from course files."""

import gzip
import json
import os
import sys

DATA_DIR = os.path.join(os.path.dirname(__file__), "..", "Data")


def extract_course_metadata(filepath, rel_path):
    with gzip.open(filepath, "rt", encoding="utf-8") as f:
        course = json.load(f)

    name = course.get("name", "")

    coords = course.get("location", {}).get("coordinates", [])
    coordinate = None
    if len(coords) == 2:
        coordinate = {"latitude": coords[0], "longitude": coords[1]}

    holes = sum(len(sc.get("holes", [])) for sc in course.get("subCourses", []))

    return {
        "name": name,
        "coordinate": coordinate,
        "holes": holes,
        "path": rel_path,
    }


def main():
    entries = []

    for root, _, files in os.walk(DATA_DIR):
        for filename in files:
            if not filename.endswith(".json.gz"):
                continue
            filepath = os.path.join(root, filename)
            rel_path = os.path.relpath(filepath, DATA_DIR)
            try:
                entry = extract_course_metadata(filepath, rel_path)
                entries.append(entry)
            except Exception as e:
                print(f"Warning: failed to process {rel_path}: {e}", file=sys.stderr)

    entries.sort(key=lambda e: e["path"])

    index_path = os.path.join(DATA_DIR, "index.json")
    with open(index_path, "w", encoding="utf-8") as f:
        json.dump(entries, f, indent=2)
        f.write("\n")

    version_path = os.path.join(DATA_DIR, "index.version")
    try:
        with open(version_path, "r") as f:
            version = int(f.read().strip())
    except (FileNotFoundError, ValueError):
        version = 0
    version += 1
    with open(version_path, "w") as f:
        f.write(f"{version}\n")

    print(f"Indexed {len(entries)} course(s). Version: {version}")


if __name__ == "__main__":
    main()
