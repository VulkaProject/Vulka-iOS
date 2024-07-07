import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) var modelContext
    @Query var userInfo: [UserInfo]
    @Query var luckyNumberStorage: [LuckyNumberStorage]
    @Query var grades: [GradesStorageItem]
    @EnvironmentObject var appContext: AppContext
    
    var login: String
    var password: String
    
    var body: some View {
        TabView {
            StartView().tabItem {
                Label(local("start_page"), systemImage: "restart.circle")
            }
            
            GradesView().tabItem {
                Label(local("oceny"), systemImage: "1.square")
            }
        }
        .refreshable(action: { await self.fetchDataTask() })
        
        .onAppear(perform: self.fetchDataTask)
    }
}
