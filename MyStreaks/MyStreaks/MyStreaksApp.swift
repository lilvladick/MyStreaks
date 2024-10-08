import SwiftUI
import SwiftData

@main
struct MyStreaksApp: App {
    let container: ModelContainer
        
    init() {
        do {
            container = try ModelContainer(for: Streak.self)
        } catch {
            fatalError("Initialize error: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            MainScreenView()
        }
        .modelContainer(container)
    }
}
