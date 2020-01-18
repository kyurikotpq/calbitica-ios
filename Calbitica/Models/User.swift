// Handles JWT and basic Google Profile Information

import Foundation

struct User: Codable {
    struct CalbiticaData : Codable {
        var jwt: String
        var displayName: String
        var thumbnail: String
    }
    var data: CalbiticaData
}
