import Foundation

public struct Hole: Identifiable, Codable, Equatable, Hashable {
    public var id: Int { number }
    public let number: Int
    public var par: Int
    public var maleHandicap: Int
    public var femaleHandicap: Int
    public var yardages: [String: Int]
    public var features: [Int]
    public var tees: [String: Int]
    public var centerline: [Coordinate]

    public init(
        number: Int,
        par: Int,
        maleHandicap: Int = 0,
        femaleHandicap: Int = 0,
        yardages: [String: Int] = [:],
        features: [Int] = [],
        tees: [String: Int] = [:],
        centerline: [Coordinate] = []
    ) {
        self.number = number
        self.par = par
        self.maleHandicap = maleHandicap
        self.femaleHandicap = femaleHandicap
        self.yardages = yardages
        self.features = features
        self.tees = tees
        self.centerline = centerline
    }

    public func renumbered(to newNumber: Int) -> Hole {
        Hole(
            number: newNumber,
            par: par,
            maleHandicap: maleHandicap,
            femaleHandicap: femaleHandicap,
            yardages: yardages,
            features: features,
            tees: tees,
            centerline: centerline
        )
    }

    public static func splitIntoSubCourses(_ holes: [Hole], names: [String]) -> [(name: String, holes: [Hole])] {
        guard holes.count > 1, names.count >= 2, holes.count % names.count == 0 else {
            let renumbered = holes.enumerated().map { $1.renumbered(to: $0 + 1) }
            return [(names.first ?? "Front", renumbered)]
        }

        let groupSize = holes.count / names.count
        guard groupSize > 0 else {
            let renumbered = holes.enumerated().map { $1.renumbered(to: $0 + 1) }
            return [(names.first ?? "Front", renumbered)]
        }

        var groups: [(name: String, holes: [Hole])] = []
        for (i, name) in names.enumerated() {
            let start = i * groupSize
            let end = (i == names.count - 1) ? holes.count : start + groupSize
            let slice = Array(holes[start..<end])
            let renumbered = slice.enumerated().map { $1.renumbered(to: $0 + 1) }
            groups.append((name, renumbered))
        }
        return groups
    }
}
