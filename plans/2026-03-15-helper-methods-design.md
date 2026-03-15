# Helper Methods for Course Data Models

## Overview

Add convenience methods to `Course`, `Hole`, and `Feature` for common lookups: finding features by ID, resolving hole references, determining greens, hit-testing coordinates against fairway/green polygons, computing feature geometry relative to the direction of play, and a new `Vector2D` type to represent direction vectors.

## Documentation

All public methods, properties, and types must have Swift doc comments (`///`) that describe:
- What the method does
- Parameter semantics (including whether indices are 0-based or 1-based)
- Return value, including when `nil` is returned
- Any notable behavior (e.g., flat-earth approximation, vertex-only results)

## New Type

### `Vector2D`

A lightweight struct representing a 2D direction vector, used for front/back calculations relative to the centerline. Conforms to `Sendable` for Swift 6 concurrency compatibility.

```swift
public struct Vector2D: Equatable, Hashable, Sendable {
    public var dx: Double
    public var dy: Double

    public func normalized() -> Vector2D
}
```

`Vector2D` is ephemeral (not persisted), so no `Codable` conformance.

## Course Extensions

### `findFeature(id:) -> Feature?`

Looks up a single feature by its integer ID from the course's `features` array.

### `features(for:) -> [Feature]`

Takes a `Hole` and returns all resolved `Feature` objects whose IDs appear in `hole.features`. Bridges the gap between the hole's `[Int]` feature ID list and the course's `[Feature]` array.

### `hole(subCourseIndex:number:) -> Hole?`

`subCourseIndex` is a zero-based index into `subCourses`. `number` matches the hole's `number` property (1-based, typically 1–9 or 1–18). Returns `nil` if the sub-course index is out of bounds or no hole matches the number.

### `holeFromIndices(subCourse:hole:) -> Hole?`

Both parameters are zero-based array indices. Returns `nil` if either index is out of bounds.

## Hole Extensions

### `green(from:) -> Feature?`

Takes the course's full `[Feature]` array. Filters to this hole's feature IDs and returns the first feature with `.type == .green`.

### `vector(for:from:) -> Vector2D?`

Takes a feature ID and the course's `[Feature]` array. Returns the direction of play at the feature's location as a unit `Vector2D`. Returns `nil` if the feature can't be found or the centerline has fewer than 2 points. The feature does not need to belong to this hole — any feature can be projected against this hole's centerline.

Algorithm:
1. Resolve the feature by ID from the provided features array
2. Compute the feature's centroid via `PolygonGeometry.centroid`
3. For each consecutive pair of points (segment) in `self.centerline`, compute the minimum distance from the centroid to that segment using point-to-segment projection (perpendicular distance, clamped to segment endpoints)
4. Return the direction vector of the closest segment, normalized to a unit vector

Point-to-segment distance formula: project the point onto the infinite line defined by the segment, clamp the parameter `t` to `[0, 1]`, and compute the Euclidean distance to the clamped point. This will be implemented as a static method on `PolygonGeometry`.

### `onFairway(_:from:) -> Bool`

Takes a `Coordinate` and the course's full `[Feature]` array. Filters to this hole's features with `.type == .fairway` and returns `true` if the coordinate is inside any of those fairway polygons. Uses `PolygonGeometry.contains` for the point-in-polygon test.

### `onGreen(_:from:) -> Bool`

Takes a `Coordinate` and the course's full `[Feature]` array. Filters to this hole's features with `.type == .green` and returns `true` if the coordinate is inside the green polygon. Uses `PolygonGeometry.contains` for the point-in-polygon test.

## Feature Extensions

### `center: Coordinate` (computed property)

Returns the centroid of the feature's polygon using `PolygonGeometry.centroid`.

### `front(vector:) -> Coordinate`

Projects all polygon vertices onto the given `Vector2D` direction. Returns the vertex with the smallest projection value (closest to tee / start of the vector direction).

### `middle() -> Coordinate`

Alias for `center`. Named for symmetry with `front` and `back`.

### `back(vector:) -> Coordinate`

Projects all polygon vertices onto the given `Vector2D` direction. Returns the vertex with the largest projection value (farthest from tee / along the vector direction).

## Projection Math

All geometry uses a flat-earth approximation — latitude and longitude are treated as Cartesian coordinates. At the scale of golf course features (tens of meters), the error from ignoring the latitude-dependent distortion of longitude is negligible. Both the vector computation and the front/back projection use the same raw lat/lon space, so any distortion is consistent.

For `front` and `back`, the projection of a coordinate onto a vector is the dot product:

```
projection = point.latitude * vector.dx + point.longitude * vector.dy
```

The vertex with the minimum projection is the "front" (nearest to the origin of play), and the maximum is the "back."

Note: results are polygon vertices, not interpolated boundary points. For the polygon densities produced by CourseBuilder, this is sufficient.
