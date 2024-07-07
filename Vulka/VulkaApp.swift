import SwiftUI
import SwiftData

@main
struct VulkaApp: App {
   var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(AppContext())
        }
        .modelContainer(for: [
            AppSettingsStorage.self,
            UserInfo.self,
            LuckyNumberStorage.self,
            GradesStorageItem.self
        ])
    }
}
