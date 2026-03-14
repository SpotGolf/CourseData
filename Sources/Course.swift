import Foundation

public struct TeeInformation: Codable, Equatable, Hashable {
    public var rating: Double?
    public var slope: Int?
    public var totalYards: Int?
    public var parTotal: Int?

    public init(rating: Double? = nil, slope: Int? = nil, totalYards: Int? = nil, parTotal: Int? = nil) {
        self.rating = rating
        self.slope = slope
        self.totalYards = totalYards
        self.parTotal = parTotal
    }
}

public struct SubCourseTee: Codable, Equatable, Hashable {
    public var male: TeeInformation?
    public var female: TeeInformation?

    public init(male: TeeInformation? = nil, female: TeeInformation? = nil) {
        self.male = male
        self.female = female
    }
}

public struct SubCourse: Identifiable, Codable, Equatable, Hashable {
    public let id: UUID
    public var name: String
    public var holes: [Hole]
    public var tees: [String: SubCourseTee]

    public init(
        id: UUID = UUID(),
        name: String,
        holes: [Hole] = [],
        tees: [String: SubCourseTee] = [:]
    ) {
        self.id = id
        self.name = name
        self.holes = holes
        self.tees = tees
    }
}

public struct TeeDefinition: Codable, Equatable, Hashable, Identifiable {
    public var id: String { name }
    public var name: String
    public var color: String

    public init(name: String, color: String) {
        self.name = name
        self.color = color
    }

    enum CodingKeys: String, CodingKey {
        case name, color
    }

    public static func defaultColor(for teeName: String) -> String {
        switch teeName.lowercased() {
        case "black": "#000000"
        case "gold": "#FFD700"
        case "blue": "#0000FF"
        case "white": "#FFFFFF"
        case "silver": "#C0C0C0"
        case "red": "#FF0000"
        case "green": "#008000"
        default: "#808080"
        }
    }
}

public struct CourseLocation: Codable, Equatable, Hashable {
    public var address: String
    public var city: String
    public var state: String
    public var country: String
    public var coordinate: Coordinate

    enum CodingKeys: String, CodingKey {
        case address, city, state, country
        case coordinate = "coordinates"
    }

    public init(address: String, city: String, state: String, country: String, coordinate: Coordinate) {
        self.address = address
        self.city = city
        self.state = state
        self.country = country
        self.coordinate = coordinate
    }
}

public struct Course: Identifiable, Codable, Equatable, Hashable {
    public let id: UUID
    public var name: String
    public var clubName: String
    public var golfCourseAPIIds: [Int]
    public var location: CourseLocation
    public var tees: [TeeDefinition]
    public var features: [Feature]
    public var subCourses: [SubCourse]

    public var nextFeatureID: Int {
        (features.map(\.id).max() ?? 0) + 1
    }

    public init(
        id: UUID = UUID(),
        name: String,
        clubName: String = "",
        golfCourseAPIIds: [Int] = [],
        location: CourseLocation,
        tees: [TeeDefinition] = [],
        features: [Feature] = [],
        subCourses: [SubCourse] = []
    ) {
        self.id = id
        self.name = name
        self.clubName = clubName
        self.golfCourseAPIIds = golfCourseAPIIds
        self.location = location
        self.tees = tees
        self.features = features
        self.subCourses = subCourses
    }
}
