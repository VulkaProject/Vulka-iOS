import SwiftUI
import SwiftData

struct ContentView: View {
    @Query var appSettingsArr: [AppSettingsStorage]
    let schoolSystems: [String: SchoolSystem] = [
        "Librus Synergia": .lSynergia,
        "Vulcan": .vulcan
    ]
    
    var body: some View {
        if appSettingsArr.count > 0 {
            let appSettings = appSettingsArr[0]
            LoginView(schoolSystem: appSettings.schoolSystem)
        } else {
            NavigationSplitView {
                List {
                    ForEach(Array(self.schoolSystems.keys), id: \.self) { key in
                        NavigationLink(
                            key,
                            destination: LoginView(schoolSystem: self.schoolSystems[key]!)
                        )
                    }
                }
                .navigationTitle(local("login_message"))
            } detail: {
                
            }
        }
    }
}

//#Preview {
//    ContentView()
//        .environmentObject(AppContext())
//        .modelContainer(for: [AppSettingsStorage.self], inMemory: true)
//}
