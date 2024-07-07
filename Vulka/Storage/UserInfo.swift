import Foundation
import SwiftData

@Model
final class UserInfo {
    public var name: String
    public var usersClass: String
    public var semester: UInt8
    
    init(name: String, usersClass: String, semester: UInt8) {
        self.name = name
        self.usersClass = usersClass
        self.semester = semester
    }
}
