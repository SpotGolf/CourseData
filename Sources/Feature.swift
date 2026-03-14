import Foundation

public enum FeatureType: String, Codable, CaseIterable, Hashable {
    case fairway
    case green
    case tee
    case bunker
    case water
    case rough
}

public struct Feature: Identifiable, Codable, Equatable, Hashable {
    public let id: Int
    public let type: FeatureType
    public var polygon: [Coordinate]

    public init(id: Int, type: FeatureType, polygon: [Coordinate]) {
        self.id = id
        self.type = type
        self.polygon = polygon
    }
}
