import SwiftUI
import SwiftData

struct StreakDetailedView: View {
    @State var streak: Streak
    
    var body: some View {
        VStack {
            
        }
    }
}
#Preview {
    StreakDetailedView(streak: Streak(name: "big car", goal: 100000, moneyCount: 1000, streakDescription: "My dream"))
}
