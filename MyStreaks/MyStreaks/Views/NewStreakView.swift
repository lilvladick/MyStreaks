import SwiftUI
import SwiftData
import PhotosUI

struct NewStreakView: View {
    @Environment(\.modelContext) private var modelContext: ModelContext
    @Environment(\.dismiss) private var dismiss
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var image: Image?
    @State private var uiImage: UIImage?
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
            }
            .textFieldStyle(CustomTextFieldStyle())
            .padding()
            .toolbar {
                Button("Save") {
                    saveStreak()
                }.disabled(name.isEmpty && goal.isEmpty)
            }
            .onChange(of: selectedPhoto) { oldPhoto, newPhoto in
                Task {
                    if let photo = newPhoto {
                        if let imageData = try? await photo.loadTransferable(type: Data.self),
                           let img = UIImage(data: imageData) {
                            uiImage = img
                            image = Image(uiImage: img)
                        } else {
                            print("Failed to load image")
                        }
                    }
                }
            }
            .navigationTitle("New Streak")
        }
    }
    
    func saveStreak() {
        guard let jpegImage: Data = convertImage(image: uiImage) else { return }

        guard let goalInt = Int(goal) else {
            print("Invalid goal value")
            return
        }
        
        let newStreak = Streak(name: name, goal: goalInt, moneyCount: 0, streakDescription: streakDescription, image: jpegImage)
        
        modelContext.insert(newStreak)
        
        do {
            try modelContext.save()
            dismiss()
        } catch {
            print("Error saving streak: \(error.localizedDescription)")
        }
    }

    
    @MainActor
    func convertImage(image: UIImage?) -> Data? {
        guard let image = image else { return nil }
        return image.jpegData(compressionQuality: 1.0) 
    }
}

#Preview {
    NewStreakView()
}
