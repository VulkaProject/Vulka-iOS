import Foundation
import SwiftData

@Model
final class LuckyNumberStorage {
    var luckyNumber: UInt8
    
    init(_ luckyNumber: UInt8) {
        self.luckyNumber = luckyNumber
    }
}
