import SwiftUI
import SwiftData

struct GradesView: View {
    @Query var grades: [GradesStorageItem]
    @Query var userInfo: [UserInfo]
    
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
                                    GradeView(grade: grade)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

private struct GradeView: View {
    var grade: GradesStorageItem.Grade
    @State var showGradeInfo: Bool = false
    
    var body: some View {
        HStack {
            Text("\(grade.grade)")
            Spacer()
            VStack {
                Text(grade.teacher)
                Text(grade.category)
            }
            Spacer()
            Button(local("more")) { self.showGradeInfo = true }
            .buttonStyle(.plain)
            .foregroundStyle(Color.blue)
        }
        
        .sheet(isPresented: self.$showGradeInfo) {
            List {
                Text("\(local("grade_value")): \(self.grade.grade)")
                Text("\(local("grade_weight")): \(self.grade.weight)")
                Text("\(local("grade_added_by")): \(self.grade.teacher)")
                Text("\(local("grade_subject")): \(self.grade.subject)")
                Text("\(local("grade_category")): \(self.grade.category)")
                if let comment = self.grade.comment {
                    Text("\(local("grade_description")): \(comment)")
                }
                Text("\(local("grade_date")): \(self.grade.date)")
                Button(local("close")) { self.showGradeInfo = false }
            }
        }
    }
}
