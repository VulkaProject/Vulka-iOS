import Foundation
import SwiftData

@Model
final class GradesStorageItem {
    class Grade: Identifiable, Codable {
        enum AdditionalGradeTypes: Codable {
            case final
            case finalProposal
            case semestral
            case semestralProposal
        }
        
        var grade: String
        var weight: UInt64
        var comment: String?
        var semester: UInt8
        var category: String
        var teacher: String
        var subject: String
        var date: Date
        var type: AdditionalGradeTypes?

        init(grade: String, weight: UInt64, comment: String?, semester: UInt8, category: String, teacher: String, subject: String, date: Date, type: AdditionalGradeTypes? = nil) {
            self.grade = grade
            self.weight = weight
            self.comment = comment
            self.semester = semester
            self.category = category
            self.teacher = teacher
            self.subject = subject
            self.date = date
            self.type = type
        }
    }
    
    var grades: [String : [Grade]]
    
    init(grades: [String : [Grade]]) {
        self.grades = grades
    }
}
