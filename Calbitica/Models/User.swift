// Handles JWT and basic Google Profile Information

import Foundation

struct User: Codable {
    var jwt: String
    var displayName: String
    var thumbnail: String
}
