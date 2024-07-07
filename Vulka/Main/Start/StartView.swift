import SwiftUI
import SwiftData

struct StartView: View {
    @Query var userInfo: [UserInfo]
    @Query var luckyNumberStorage: [LuckyNumberStorage]
    
    var body: some View {
        List {
            if self.userInfo.count > 0 {
                Section(local("user_information")) {
                    VStack {
                        HStack {
                            Text(self.userInfo[0].name)
                                .font(Font.system(size: 30))
                            Spacer()
                        }
                        
                        HStack {
                            Text(self.userInfo[0].usersClass)
                            Spacer()
                        }
                    }
                }
            }
            
            if self.luckyNumberStorage.count > 0 {
                Section(local("lucky_number")) {
                    HStack {
                        Text("\(local("lucky_number_is")) \(self.luckyNumberStorage[0].luckyNumber)")
                    }
                }
            }
        }
    }
}
