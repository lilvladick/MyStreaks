import SwiftUI

struct StreakCellView: View {
    let streak: Streak
    
    var body: some View {
        HStack {
            Image(systemName: "car").padding(.trailing, 10)
            VStack(alignment: .leading) {
                Text(streak.name).font(.title3)
                ZStack(alignment: .leading) {
                    // Background rectangle
                    Rectangle()
                        .frame(width: .infinity, height: 10)
                        .opacity(0.3)
                        .foregroundColor(.gray)
                    
                    // Progress rectangle
                    Rectangle()
                        .frame(
                            width: CGFloat(streak.moneyCount) / CGFloat(streak.goal) * UIScreen.main.bounds.width * 0.7, // Adjust the multiplier as needed
                            height: 10
                        )
                        .foregroundColor(.blue)
                }
            }.bold()
            Spacer()
            
            Text("\(streak.goal) $").bold().font(.title2)
        }
    }
}

#Preview {
    StreakCellView(streak: Streak(name: "My Streak", goal: 1000, moneyCount: 121.0, streakDescription: "My Dream"))
}
