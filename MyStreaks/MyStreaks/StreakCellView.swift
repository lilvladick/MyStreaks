import SwiftUI

struct StreakCellView: View {
    let streak: Streak
    
    var body: some View {
        HStack {
            Image(systemName: "car").padding(.trailing, 10)
            VStack(alignment: .leading) {
                Text(streak.name).font(.title3)
                Text(streak.streakDescription ?? "").font(.caption).foregroundStyle(Color.gray)
            }.bold()
            Spacer()
            
            Text("\(streak.goal) $").bold().font(.title2)
        }
    }
}

#Preview {
    StreakCellView(streak: Streak(name: "My Streak", goal: 1000, moneyCount: 19.0, streakDescription: "My Dream"))
}
