import SwiftData
import SwiftUI

@Model
final class Streak {
    var id = UUID()
    var name: String
    var goal: Int
    var moneyCount: Float = 0
    var streakDescription: String?
    var image: Data?
    
    init(id: UUID = UUID(), name: String, goal: Int, moneyCount: Float, streakDescription: String? = nil, image: Data? = nil) {
        self.id = id
        self.name = name
        self.goal = goal
        self.moneyCount = moneyCount
        self.streakDescription = streakDescription
        self.image = image
    }
}
