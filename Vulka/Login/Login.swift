import Foundation
import Synergia_Swift

extension AppContext {
    @MainActor func logIn(login: String, password: String) async throws {
        self.lClient = try await self.operation(
            synergia: {
                return try await SynergiaClient(login: login, password: password)
            }
        )
    }
}

extension LoginView {
    @MainActor func logIn() async throws {
        try await self.appContext.logIn(login: self.login, password: self.password)
    }
    
    func resetSettings() -> Bool {
        _ = Keychain.deletePassword(login: self.login)
        if self.appSettings.count > 0 {
            modelContext.delete(self.appSettings[0])
        }
        
        let appSettings = AppSettingsStorage(schoolSystem: self.schoolSystem, credentialsSavedInKeychain: false)
        guard Keychain.savePassword(login: self.login, password: self.password) else {
            return false
        }
        
        appSettings.login = self.login
        appSettings.credentialsSavedInKeychain = true
        modelContext.insert(appSettings)
        return true
    }
    
    func getPassword() -> String {
        return Keychain.getPassword(login: self.appSettings[0].login ?? "")!
    }
}
