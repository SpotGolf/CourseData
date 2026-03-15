import Foundation
import CoreLocation

public enum PolygonGeometry {
    public static func centroid(of polygon: [Coordinate]) -> Coordinate {
        guard !polygon.isEmpty else {
            return Coordinate(latitude: 0, longitude: 0)
        }
        guard polygon.count > 1 else {
            return polygon[0]
        }

        var cx = 0.0, cy = 0.0, area = 0.0
        let n = polygon.count
        for i in 0..<n {
            let j = (i + 1) % n
            let cross = polygon[i].latitude * polygon[j].longitude - polygon[j].latitude * polygon[i].longitude
            area += cross
            cx += (polygon[i].latitude + polygon[j].latitude) * cross
            cy += (polygon[i].longitude + polygon[j].longitude) * cross
        }
        area /= 2.0
        guard abs(area) > 1e-10 else {
            let lat = polygon.map(\.latitude).reduce(0, +) / Double(n)
            let lon = polygon.map(\.longitude).reduce(0, +) / Double(n)
            return Coordinate(latitude: lat, longitude: lon)
        }
        cx /= (6.0 * area)
        cy /= (6.0 * area)
        return Coordinate(latitude: cx, longitude: cy)
    }

    public static func area(of polygon: [Coordinate]) -> Double {
        guard polygon.count >= 3 else { return 0 }
        var area = 0.0
        let n = polygon.count
        for i in 0..<n {
            let j = (i + 1) % n
            area += polygon[i].latitude * polygon[j].longitude
            area -= polygon[j].latitude * polygon[i].longitude
        }
        return abs(area / 2.0)
    }

    public static func nearestPoint(on polygon: [Coordinate], to reference: Coordinate) -> Coordinate {
        guard !polygon.isEmpty else {
            return Coordinate(latitude: 0, longitude: 0)
        }
        let refLocation = reference.clLocation
        return polygon.min(by: {
            $0.clLocation.distance(from: refLocation) < $1.clLocation.distance(from: refLocation)
        })!
    }

    public static func farthestPoint(on polygon: [Coordinate], to reference: Coordinate) -> Coordinate {
        guard !polygon.isEmpty else {
            return Coordinate(latitude: 0, longitude: 0)
        }
        let refLocation = reference.clLocation
        return polygon.max(by: {
            $0.clLocation.distance(from: refLocation) < $1.clLocation.distance(from: refLocation)
        })!
    }

    /// Computes the squared Euclidean distance from a point to a line segment in flat
    /// latitude/longitude space.
    ///
    /// Projects the point onto the infinite line defined by the segment, clamps the
    /// parameter to `[0, 1]`, and returns the squared distance to the clamped point.
    /// Squared distance is used to avoid an unnecessary `sqrt` when only relative
    /// comparisons are needed.
    ///
    /// - Parameters:
    ///   - point: The reference point.
    ///   - segStart: The first endpoint of the segment.
    ///   - segEnd: The second endpoint of the segment.
    /// - Returns: The squared distance from `point` to the nearest location on the segment.
    public static func squaredDistanceToSegment(_ point: Coordinate, segStart: Coordinate, segEnd: Coordinate) -> Double {
        let sx = segEnd.latitude - segStart.latitude
        let sy = segEnd.longitude - segStart.longitude
        let lengthSq = sx * sx + sy * sy

        // Degenerate segment (both endpoints are the same point)
        guard lengthSq > 1e-20 else {
            let dx = point.latitude - segStart.latitude
            let dy = point.longitude - segStart.longitude
            return dx * dx + dy * dy
        }

        // Project point onto the line, clamped to [0, 1]
        let t = max(0, min(1, ((point.latitude - segStart.latitude) * sx + (point.longitude - segStart.longitude) * sy) / lengthSq))
        let projLat = segStart.latitude + t * sx
        let projLon = segStart.longitude + t * sy
        let dx = point.latitude - projLat
        let dy = point.longitude - projLon
        return dx * dx + dy * dy
    }

    public static func contains(_ point: Coordinate, in polygon: [Coordinate]) -> Bool {
        guard polygon.count >= 3 else { return false }
        var inside = false
        let n = polygon.count
        var j = n - 1
        for i in 0..<n {
            let yi = polygon[i].latitude, xi = polygon[i].longitude
            let yj = polygon[j].latitude, xj = polygon[j].longitude
            if ((yi > point.latitude) != (yj > point.latitude)) &&
                (point.longitude < (xj - xi) * (point.latitude - yi) / (yj - yi) + xi) {
                inside.toggle()
            }
            j = i
        }
        return inside
    }
}
