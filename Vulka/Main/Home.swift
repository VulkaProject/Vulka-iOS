import Foundation
import SwiftData

extension HomeView {
    struct FetchedData {
        var userInfo: UserInfo
        var luckyNumber: UInt8
        var grades: [String : [GradesStorageItem.Grade]]
        var attendances: [String: [AttendancesStorage.AttendanceEntry]]
    }
    
    func fetchData() async throws -> FetchedData? {
        try await self.appContext.logIn(login: self.login, password: self.password)
        
        guard let userInfo = try await self.appContext.operation(
            synergia: {
                let synUserInfo = try await self.appContext.lClient!.getMe()
                return UserInfo(
                    name: synUserInfo.name,
                    usersClass: synUserInfo.Class.name,
                    semester: synUserInfo.Class.endFirstSemester < Date() ? 2 : 1
                )
            }
        ) else { return nil }
        
        guard let luckyNumber = try await self.appContext.operation(
            synergia: {
                try await self.appContext.lClient!.getLuckyNumber()
            }
        ) else { return nil }
        
        guard let grades = try await self.appContext.operation(
            synergia: {
                let grades = try await self.appContext.lClient!.getGrades()
                return grades.reduce(into: [String: [GradesStorageItem.Grade]]()) { arr, dict in
                    if arr[dict.key] == nil {
                        arr[dict.key] = []
                    }
                    
                    dict.value.forEach {
                        arr[dict.key]!.append(GradesStorageItem.Grade(
                            grade: $0.grade,
                            weight: $0.weight,
                            comment: $0.comment,
                            semester: $0.semester,
                            category: $0.category,
                            teacher: $0.teacher,
                            subject: $0.subject,
                            date: $0.date
                        ))
                    }
                }
            }
        ) else { return nil }
        
        guard let attendances = try await self.appContext.operation(
            synergia: {
                let attendances = try await self.appContext.lClient!.getAttendances()
                return attendances.reduce(into: [String: [AttendancesStorage.AttendanceEntry]]()) { vulkaAtten, synAtten in
                    vulkaAtten[synAtten.key] = synAtten.value.reduce(into: [AttendancesStorage.AttendanceEntry]()) { dst, src in
                        dst.append(
                            AttendancesStorage.AttendanceEntry(
                                lessonNo: src.lessonNo,
                                typeFull: src.typeFull,
                                typeShort: src.typeShort,
                                addedBy: src.addedBy,
                                color: src.colorRgb
                            )
                        )
                    }
                }
            }
        ) else { return nil }
        
        return FetchedData(
            userInfo: userInfo,
            luckyNumber: luckyNumber,
            grades: grades,
            attendances: attendances
        )
    }
    
    func deleteModel(_ models: [any PersistentModel]) {
        models.forEach {
            modelContext.delete($0)
        }
    }
    
    func saveData(_ data: FetchedData) {
        self.deleteModel(self.userInfo)
        modelContext.insert(data.userInfo)
        
        self.deleteModel(self.luckyNumberStorage)
        modelContext.insert(LuckyNumberStorage(data.luckyNumber))
        
        self.deleteModel(self.grades)
        modelContext.insert(GradesStorageItem(grades: data.grades))
        
        self.deleteModel(self.attendances)
        modelContext.insert(AttendancesStorage(attendances: data.attendances))
    }
    
    func fetchDataTask() async {
        do {
            guard let data = try await self.fetchData() else {
                return
            }
            
            self.saveData(data)
        } catch {
            print(error)
        }
    }
    
    func fetchDataTask() {
        Task { await self.fetchDataTask() }
    }
}
