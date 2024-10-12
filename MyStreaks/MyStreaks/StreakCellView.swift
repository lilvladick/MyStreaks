import SwiftUI

struct StreakCellView: View {
    @State var progress: CGFloat = 0
    let streak: Streak
    @State private var maxProgress: CGFloat

    init(streak: Streak) {
        self.streak = streak
        self._maxProgress = State(initialValue: CGFloat(streak.goal))
    }
    
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
                    .frame(width: .infinity, height: 15)
                    .opacity(0.3)
                    .foregroundColor(.gray)
                
                RoundedRectangle(cornerRadius: 30)
                    .frame(
                        width: progress / maxProgress * UIScreen.main.bounds.width * 0.7,
                        height: 15
                    )
                    .foregroundColor(.blue)
                    .transition(.move(edge: .trailing))
                    .onAppear {
                        withAnimation(.interpolatingSpring().delay(0.5)) {
                            progress = CGFloat(streak.moneyCount)
                        }
                    }
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    StreakCellView(streak: Streak(name: "My Streak", goal: 1000, moneyCount: 421.0, streakDescription: "My Dream"))
}
