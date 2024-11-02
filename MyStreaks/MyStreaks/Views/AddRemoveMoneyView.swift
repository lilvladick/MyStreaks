import SwiftUI
import SwiftData

struct AddRemoveMoneyView: View {
    @Environment(\.modelContext) private var modelContext: ModelContext
    @Environment(\.dismiss) private var dismiss
    @Bindable var streak: Streak
    @State private var money: String = ""
    @State private var isAddingMoney: Bool = false
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Money", text: $money)
                    .textContentType(.oneTimeCode)
                    .keyboardType(.decimalPad)
                    .autocapitalization(.none)
                    .autocorrectionDisabled(true)
                    .font(.title)
                    .bold()
                    .padding()
                
                Spacer()
                
                HStack {
                    Button("-") {
                        isAddingMoney = false
                        updateStreakMoney()
                    }
                    Button("+") {
                        isAddingMoney = true
                        updateStreakMoney()
                    }
                }
                .buttonStyle(CustomButtonStyle())
                .font(.title)
                .bold()
                .padding(.vertical)
            }
            .navigationTitle("Add/Remove money")
            .alert(isPresented: $showError) {
                Alert(title: Text("Error"), message: Text(errorMessage))
            }
        }
        .padding()
    }
    
    func updateStreakMoney() {
        guard let moneyValue = Float(money) else {
            showError = true
            errorMessage = "Invalid money value"
            return
        }
        
        if isAddingMoney {
            streak.moneyCount += moneyValue
        } else {
            streak.moneyCount -= moneyValue
        }
        
        do {
            try modelContext.save()
            dismiss()
        } catch {
            showError = true
            errorMessage = error.localizedDescription
        }
    }
}


#Preview {
    AddRemoveMoneyView(streak: Streak(name: "big car", goal: 10000, moneyCount: 1000, streakDescription: "My dream"))
}
