import SwiftUI
import SwiftData

struct AttendanceView: View {
    @Query var attendance: [AttendancesStorage]
    
    var body: some View {
        if self.attendance.count > 0 {
            List {
                ForEach(self.attendance[0].attendances.keys.sorted(by: { $0 > $1 }), id: \.self) { key in
                    let val = self.attendance[0].attendances[key]!
                    
                    DisclosureGroup(key) {
                        ForEach(val, id: \.lessonNo) {
                            AttendanceEntryCard(attendanceEntry: $0)
                        }
                    }
                }
            }
        }
    }
}

private struct AttendanceEntryCard: View {
    var attendanceEntry: AttendancesStorage.AttendanceEntry
    
    var body: some View {
        HStack {
            Text("\(self.attendanceEntry.typeShort)")
            Spacer()
            VStack {
                HStack {
                    Text("\(local("lesson_no")): \(self.attendanceEntry.lessonNo)")
                    Spacer()
                }
                HStack {
                    Text("\(local("grade_added_by")): \(self.attendanceEntry.addedBy)")
                    Spacer()
                }
            }
            Spacer()
        }
    }
}
