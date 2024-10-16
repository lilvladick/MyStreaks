import SwiftUI
import SwiftData
import PhotosUI

struct NewStreakView: View {
    @Environment(\.modelContext) private var modelContext: ModelContext
    @Environment(\.dismiss) private var dismiss
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var image: Image?
    @State private var name: String = ""
    @State private var streakDescription: String = ""
    @State private var goal: String = ""
    
    
    var body: some View {
        NavigationStack {
            VStack {
                image?
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.height * 0.3)
                    .padding()
                    .background(Color.clear)
                Form {
                    Section("Main information"){
                        TextField("Streak Name", text: $name)
                            .autocapitalization(.none)
                            .autocorrectionDisabled(true)
                        TextField("Streak Goal", text: $goal)
                            .textContentType(.oneTimeCode)
                            .keyboardType(.numberPad)
                            .autocapitalization(.none)
                            .autocorrectionDisabled(true)
                    }
                    Section(){
                        PhotosPicker(
                            selection: $selectedPhoto,
                            matching: .any(of: [.images, .screenshots])
                        ) {
                            Text("Upload Image")
                        }
                    }
                    Section("Description"){
                        TextEditor(text: $streakDescription)
                            .frame(height: 150)
                            .onReceive(streakDescription.publisher.collect()) {
                                self.streakDescription = String($0.prefix(150))
                            }
                    }
                }
            }
            .toolbar {
                Button("Save") {
                    saveStreak()
                }.disabled(name.isEmpty && goal.isEmpty)
            }
            .onChange(of: selectedPhoto) { oldPhoto, newPhoto in
                Task {
                    if let photo = newPhoto {
                        image = try? await photo.loadTransferable(type: Image.self)
                    }
                }
            }
            .navigationTitle("New Streak")
        }
    }
    
    func saveStreak() {
        guard let jpegImage: Data = convertImage(image: image) else { return }
        
        let newStreak = Streak(name: name, goal: Int(goal)!, moneyCount: 0, streakDescription: streakDescription, image: jpegImage)
        
        modelContext.insert(newStreak)
        
        do {
            try modelContext.save()
            dismiss()
        } catch {
            let alert = Alert(title: Text("Error"), message: Text(error.localizedDescription))
        }
    }
    
    @MainActor
    func convertImage(image: Image?) -> Data?{
        guard let image = image else { return nil }
        
        let renderer = ImageRenderer(content: image)
        renderer.scale = UIScreen.main.scale
        
        if let uiImage = renderer.uiImage {
            if let jpegData = uiImage.jpegData(compressionQuality: 1.0) {
                return jpegData
            }
        }
        
        return nil
    }
}

#Preview {
    NewStreakView()
}
