import SwiftUI

struct ProgressCircleView: View {
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    let streaks: [Streak]
    @Binding var totalMoneyCount: Float
    @Binding var totalGoal: Float
    
    var body: some View {
        HStack{
            ZStack {
                Circle()
                    .stroke(Color.gray, lineWidth: 15)
                    .opacity(0.3)
                    .frame(width: min(screenWidth, screenHeight) * 0.25, height: min(screenWidth, screenHeight) * 0.25)
                Circle()
                    .trim(from: 0, to: min(CGFloat(totalMoneyCount) / CGFloat(totalGoal), 1.0))
                    .stroke(Color.blue, style: StrokeStyle(lineWidth: 15, lineCap: .round, lineJoin: .round))
                    .frame(width: min(screenWidth, screenHeight) * 0.25, height: min(screenWidth, screenHeight) * 0.25)
                    .rotationEffect(Angle(degrees: -90))
            }
            
            VStack(alignment: .leading) {
                Text("Great results")
                    .font(.title2).bold()
                Text("\(String(format: "%.2f", totalMoneyCount))$ of \(String(format: "%.0f", totalGoal))$")
            }
            .padding(.horizontal, 20).bold()
            
        }
    }
}

#Preview {
    @Previewable @State var totalMoneyCount:Float = 0
    @Previewable @State var totalGoal:Float = 0
    ProgressCircleView(streaks: [Streak(name: "My Streak", goal: 1000, moneyCount: 421.0, streakDescription: "My Dream"),Streak(name: "My Streak", goal: 1000, moneyCount: 421.0, streakDescription: "My Dream")], totalMoneyCount: $totalMoneyCount, totalGoal: $totalGoal)
}
