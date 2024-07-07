import Foundation
import SwiftData

enum SchoolSystem: Codable {
    case lSynergia
    case vulcan
}

@Model
final class AppSettingsStorage {
    var schoolSystem: SchoolSystem
    var credentialsSavedInKeychain: Bool
    var login: String?
    
    init(schoolSystem: SchoolSystem, credentialsSavedInKeychain: Bool) {
        self.schoolSystem = schoolSystem
        self.credentialsSavedInKeychain = credentialsSavedInKeychain
    }
}
