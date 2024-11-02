import SwiftUI

struct StreakCellView: View {
    let streak: Streak

    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(streak.name).font(.title3)
                    Text(streak.streakDescription ?? "").font(.caption).foregroundStyle(Color.gray)
                }.bold()
                Spacer()
                
                Text("\(streak.goal) $").bold().font(.title3).padding(.leading, 10)
            }.padding(.horizontal)
            
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 30)
                    .frame(height: 15)
                    .opacity(0.3)
                    .foregroundColor(.gray)
                
                RoundedRectangle(cornerRadius: 30)
                    .frame(
                        width: (CGFloat(streak.moneyCount) / CGFloat(streak.goal)) * UIScreen.main.bounds.width * 0.7,
                        height: 15
                    )
                    .foregroundColor(.blue)
                    .transition(.move(edge: .trailing))
                    .animation(.interpolatingSpring().delay(0.5), value: streak.moneyCount)
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    StreakCellView(streak: Streak(name: "My Streak", goal: 1000, moneyCount: 421.0, streakDescription: "My Dream"))
}
