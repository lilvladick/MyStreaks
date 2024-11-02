import SwiftUI
import SwiftData

struct MainScreenView: View {
    @Environment(\.modelContext) private var modelContext: ModelContext
    @Query var streaks: [Streak]
    @State private var totalMoneyCount: Float = 0
    @State private var totalGoal: Float = 0
    @State private var isPresentingAddStreak: Bool = false
    @State private var selectedStreak: Streak?
    
    var body: some View {
        NavigationStack {
            if !streaks.isEmpty {
                ProgressCircleView(streaks: streaks, totalMoneyCount: $totalMoneyCount, totalGoal: $totalGoal)
                    .padding(.vertical)
            }
            VStack {
                List {
                    ForEach(streaks) { streak in
                        NavigationLink(destination: StreakDetailedView(streak: streak)) {
                            StreakCellView(streak: streak)
                        }
                        .swipeActions(edge: .leading, allowsFullSwipe: true) {
                            Button("Add/Remove") {
                                selectedStreak = streak
                            }
                        }
                    }
                    .onDelete(perform: deleteStreak)
                }
                .listStyle(.plain)
            }
            .navigationTitle("All your streaks")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        // Settings action
                    } label: {
                        Image(systemName: "gearshape")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isPresentingAddStreak.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                    .sheet(isPresented: $isPresentingAddStreak, onDismiss: { progressringUpdate() }) {
                        NewStreakView()
                    }
                }
            }
            .sheet(item: $selectedStreak, onDismiss: { progressringUpdate() }) { streak in
                AddRemoveMoneyView(streak: streak)
                    .presentationDetents([.fraction(0.4)])
            }
        }
        .onAppear {
            progressringUpdate()
        }
    }
    
    func progressringUpdate() {
        totalMoneyCount = streaks.reduce(0) { $0 + $1.moneyCount }
        totalGoal = Float(streaks.reduce(0) { $0 + $1.goal })
    }
    
    func deleteStreak(at offsets: IndexSet) {
        for index in offsets {
            let streak = streaks[index]
            modelContext.delete(streak)
        }
        
        do {
            try modelContext.save()
        } catch {
            print(error)
        }
        
        progressringUpdate()
    }
}

#Preview {
    let container = try! ModelContainer(for: Streak.self)
    let modelContext = container.mainContext
    
    let streaks = [
        Streak(name: "Car", goal: 1000, moneyCount: 800.60, streakDescription: "My Dream Car"),
        Streak(name: "House", goal: 5000, moneyCount: 1924, streakDescription: "My Dream House")
    ]
    
    streaks.forEach {modelContext.insert($0)}
    
    return MainScreenView().modelContainer(container)
}
