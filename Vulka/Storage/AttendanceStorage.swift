import Foundation
import SwiftData

@Model
final class AttendancesStorage {
    struct AttendanceEntry: Codable {
        var lessonNo: UInt64
        var typeFull: String
        var typeShort: String
        var addedBy: String
        var color: String
    }
    
    var attendances: [String: [AttendanceEntry]]
    
    init(attendances: [String : [AttendanceEntry]]) {
        self.attendances = attendances
    }
}
