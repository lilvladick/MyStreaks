import SwiftUI
import SwiftData

struct MainScreenView: View {
    @Environment(\.modelContext) private var modelContext: ModelContext
    @Query var streaks: [Streak]
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(streaks) {streak in
                        NavigationLink(destination: StreakDetailedView(streak: streak)) {
                            StreakCellView(streak: streak)
                        }
                    }.onDelete(perform: deleteStreak)
                }
            }
            .navigationTitle("All your streaks")
            .toolbar {
                ToolbarItem(placement: .topBarLeading, content: {
                    Button(action: {
                        
                    }, label: {
                        Image(systemName: "gearshape")
                    })
                })
                ToolbarItem(placement: .topBarTrailing, content: {
                    Button(action: {
                        
                    }, label: {
                        Image(systemName: "plus")
                    })
                })
            }
        }
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
    }
}

#Preview {
    let container = try! ModelContainer(for: Streak.self)
    let modelContext = container.mainContext
    
    let streaks = [
        Streak(name: "Car", goal: 1000, moneyCount: 800.60, streakDescription: "My Dream Car"),
        Streak(name: "House", goal: 10000, moneyCount: 1924, streakDescription: "My Dream House")
    ]
    
    streaks.forEach {modelContext.insert($0)}
    
    return MainScreenView().modelContainer(container)
}
