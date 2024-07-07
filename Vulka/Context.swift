import Foundation
import Synergia_Swift

@MainActor
class AppContext: ObservableObject {
    @Published var system: SchoolSystem?
    @Published var lClient: SynergiaClient?
    @Published var vClient: Any?
    
    @MainActor func operation<T>(synergia: (() async throws -> T)? = nil, vulcan: (() async throws -> T)? = nil) async throws -> T? {
        if let system = self.system {
            switch system {
            case .lSynergia:
                return try await synergia?()
            case .vulcan:
                return try await vulcan?()
            }
        }
        
        return nil
    }
}
