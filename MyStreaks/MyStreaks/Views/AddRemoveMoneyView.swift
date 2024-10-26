import SwiftUI
import SwiftData

struct AddRemoveMoneyView: View {
    @Environment(\.modelContext) private var modelContext: ModelContext
    @State var streak: Streak
    @State private var moneyCount: Float
    @State private var money: String = ""
    
    init(streak: Streak) {
        _streak = State(initialValue: streak)
        _moneyCount = State(initialValue: streak.moneyCount)
    }
    
    var body: some View {
        VStack{
            TextField("Money", text: $money)
                .textContentType(.oneTimeCode)
                .keyboardType(.numberPad)
                .autocapitalization(.none)
                .autocorrectionDisabled(true)
            
            Spacer()
            
            HStack {
                Button("Remove"){
                    
                }
                Button("Add"){
                    
                }
            }
        }
        
        .padding()
    }
}

#Preview {
    AddRemoveMoneyView(streak: Streak(name: "big car", goal: 100000, moneyCount: 1000, streakDescription: "My dream"))
}
