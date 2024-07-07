import Foundation
import Security

class Keychain {
    static func savePassword(login: String, password: String) -> Bool {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: login,
            kSecAttrService: "Vulca",
            kSecValueData: password.data(using: .utf8)!
        ] as [String: Any]
        
        return SecItemAdd(query as CFDictionary, nil) == errSecSuccess
    }
    
    static func getPassword(login: String) -> String? {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: login,
            kSecAttrService: "Vulca",
            kSecMatchLimit: kSecMatchLimitOne,
            kSecReturnAttributes: true,
            kSecReturnData: true
        ] as [String: Any]
        
        var kItem: CFTypeRef?
        if SecItemCopyMatching(query as CFDictionary, &kItem) == errSecSuccess {
            guard
                let decoded = kItem as? [String: Any],
                let passwordData = decoded[kSecValueData as String] as? Data
            else {
                return nil
            }
            
            return String(decoding: passwordData, as: UTF8.self)
        }
        
        return nil
    }
    
    static func deletePassword(login: String) -> Bool {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: login,
            kSecAttrService: "Vulca",
            kSecReturnAttributes: true,
            kSecReturnData: true
        ] as [String: Any]
        
        return SecItemDelete(query as CFDictionary) == errSecSuccess
    }
}
