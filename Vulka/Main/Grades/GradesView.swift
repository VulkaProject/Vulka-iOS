import SwiftUI
import SwiftData

struct GradesView: View {
    @Query var grades: [GradesStorageItem]
    @Query var userInfo: [UserInfo]
    @State var selectedGrade: GradesStorageItem.Grade?
    @State var showGradeInfo: Bool = false
    
    var body: some View {
        List {
            if self.grades.count > 0 && self.userInfo.count > 0 {
                ForEach(Array(self.grades[0].grades.keys).sorted(), id: \.self) { key in
                    let val = self.grades[0].grades[key]!
                    
                    DisclosureGroup(key) {
                        ForEach([1, 2], id: \.self) { semester in
                            DisclosureGroup("\(local("semester")) \(semester)") {
                                ForEach(
                                    val
                                    .filter({ $0.semester == semester })
                                    .sorted(by: { $0.date.compare($1.date) == .orderedAscending })
                                ) { grade in
                                    GradeView(grade: grade, onMore: { self.openGradeInfo(grade) })
                                }
                            }
                        }
                    }
                }
            }
        }
        
        .sheet(isPresented: self.$showGradeInfo) {
            List {
                if let grade = self.selectedGrade {
                    Text("\(local("grade_value")): \(grade.grade)")
                    Text("\(local("grade_weight")): \(grade.weight)")
                    Text("\(local("grade_added_by")): \(grade.teacher)")
                    Text("\(local("grade_subject")): \(grade.subject)")
                    Text("\(local("grade_category")): \(grade.category)")
                    if let comment = grade.comment {
                        Text("\(local("grade_description")): \(comment)")
                    }
                    Text("\(local("grade_date")): \(grade.date)")
                }
                Button(local("close")) { self.showGradeInfo = false }
            }
        }
    }
    
    func openGradeInfo(_ grade: GradesStorageItem.Grade) {
        self.showGradeInfo = true
        self.selectedGrade = grade
    }
}

private struct GradeView: View {
    var grade: GradesStorageItem.Grade
    var onMore: () -> ()
    
    var body: some View {
        HStack {
            Text("\(grade.grade)")
            Spacer()
            VStack {
                Text(grade.teacher)
                Text(grade.category)
            }
            Spacer()
            Button(local("more")) { Task { self.onMore() } }
            .buttonStyle(.plain)
            .foregroundStyle(Color.blue)
        }
    }
}
