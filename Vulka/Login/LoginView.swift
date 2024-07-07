import SwiftUI
import SwiftData

struct LoginView: View {
    @Environment(\.modelContext) var modelContext
    @Query var appSettings: [AppSettingsStorage]
    
    @EnvironmentObject var appContext: AppContext
    var schoolSystem: SchoolSystem
    
    @State var login = ""
    @State var password = ""
    
    var body: some View {
        if self.appSettings.count > 0 && self.appSettings[0].credentialsSavedInKeychain {
            HomeView(login: self.appSettings[0].login!, password: self.getPassword())
                .onAppear {
                    self.appContext.system = self.appSettings[0].schoolSystem
                }
        } else {
            if case .vulcan = schoolSystem {
                Text(local("vulcan_unsupported"))
            } else {
                List {
                    TextField(local("login"), text: self.$login)
                    SecureField(local("password"), text: self.$password)
                    Button(local("login_message")) {
                        Task {
                            do {
                                try await self.logIn()
                                print(self.resetSettings())
                            } catch {
                                print(error)
                            }
                        }
                    }
                }
            }
        }
    }
}
