import SwiftUI
import PhotosUI
import SwiftData

struct StreakDetailedView: View {
    @Environment(\.modelContext) private var modelContext: ModelContext
    @State var streak: Streak
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var name: String
    @State private var image: Data?
    @State private var goal: String
    @State private var streakDescription: String
    
    init(streak: Streak) {
        _streak = State(initialValue: streak)
        _name = State(initialValue: streak.name)
        _image = State(initialValue: streak.image)
        _goal = State(initialValue: String(streak.goal))
        _streakDescription = State(initialValue: streak.streakDescription ?? "")
    }
    
    var body: some View {
        NavigationStack{
            VStack {
                if let data = image, let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.height * 0.3)
                        .padding()
                }
                
                TextField("Streak Name", text: $name)
                    .autocapitalization(.none)
                    .autocorrectionDisabled(true)
                TextField("Streak Goal", text: $goal)
                    .textContentType(.oneTimeCode)
                    .keyboardType(.numberPad)
                    .autocapitalization(.none)
                    .autocorrectionDisabled(true)
                TextEditor(text: $streakDescription)
                    .frame(height: 150)
                    .onReceive(streakDescription.publisher.collect()) {
                        self.streakDescription = String($0.prefix(150))
                    }
                    .font(.title3.weight(.regular))
                    .padding(.vertical, 12)
                    .padding(.horizontal, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                
                PhotosPicker(
                    selection: $selectedPhoto,
                    matching: .any(of: [.images, .screenshots]),
                    photoLibrary: .shared()
                ) {
                    Text("Upload Image")
                }.buttonStyle(CustomButtonStyle())
                    
                Spacer()
            }.textFieldStyle(CustomTextFieldStyle())
                .padding()
            .toolbar {
                Button("Update") {
                    
                }.disabled(name.isEmpty && goal.isEmpty)
            }
            .navigationTitle("Streak details")
        }
        .onChange(of: selectedPhoto) { oldPhoto, newPhoto in
            Task {
                if newPhoto != nil {
                    let imageData = try await selectedPhoto?.loadTransferable(type: Data.self)
                       if let imageData = imageData {
                           self.image = imageData
                       }
                    } else {
                        print("Failed to load image")
                    }
                }
            }
        }
    private func updateStreak(){
        streak.name = name
        streak.goal = Int(goal)!
        streak.streakDescription = streakDescription
        streak.image = image
        
        do {
            try modelContext.save()
        } catch {
            _ = Alert(title: Text("Error"), message: Text(error.localizedDescription))
        }
    }
}
#Preview {
    StreakDetailedView(streak: Streak(name: "big car", goal: 100000, moneyCount: 1000, streakDescription: "My dream"))
}
