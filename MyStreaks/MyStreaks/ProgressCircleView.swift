import SwiftUI

struct ProgressCircleView: View {
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    let streaks: [Streak]
    @State private var totalMoneyCount: Float = 0
    @State private var totalGoal: Float = 0
    
    var body: some View {
        HStack{
            ZStack {
                Circle().stroke(Color.gray, lineWidth: 15)
                    .frame(width: min(screenWidth, screenHeight) * 0.25, height: min(screenWidth, screenHeight) * 0.25)
                Circle().trim(from: 0, to: min(CGFloat(totalMoneyCount) / CGFloat(totalGoal), 1.0))
                    .stroke(Color.blue, style: StrokeStyle(lineWidth: 15, lineCap: .round, lineJoin: .round))
                    .frame(width: min(screenWidth, screenHeight) * 0.25, height: min(screenWidth, screenHeight) * 0.25)
                    .rotationEffect(Angle(degrees: -90))
            }
            
            VStack(alignment: .leading) {
                Text("Great results")
                    .font(.title2).bold()
                Text("\(String(format: "%.2f", totalMoneyCount))$ of \(String(format: "%.2f", totalGoal))$")
            }.padding(.horizontal, 20).bold()
            
        }.onAppear {
            totalMoneyCount = streaks.reduce(0) { $0 + $1.moneyCount }
            totalGoal = Float(streaks.reduce(0) { $0 + $1.goal })
        }
    }
}

#Preview {
    ProgressCircleView(streaks: [Streak(name: "My Streak", goal: 1000, moneyCount: 421.0, streakDescription: "My Dream"),Streak(name: "My Streak", goal: 1000, moneyCount: 421.0, streakDescription: "My Dream")])
}
