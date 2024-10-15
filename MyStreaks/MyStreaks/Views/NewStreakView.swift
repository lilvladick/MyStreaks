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
                Form {
                    Section("Main information"){
                        TextField("Streak Name", text: $name)
                        TextField("Streak Goal", text: $goal)
                            .textContentType(.oneTimeCode)
                            .keyboardType(.numberPad)
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
                    //saveStreak()
                }
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
    /*
    func saveStreak() {
        let newStreak = Streak(name: name, goal: goal, moneyCount: 0, streakDescription: streakDescription, image: <#T##Data?#>)
    }
    
    func convertImage() {
        if let image = image {
            let renderer = ImageRenderer(content: image)
            if let uiImage = renderer.uiImage {
                if let data = uiImage.pngData() {
                   imageData = data
                   print("Image converted to PNG data")
               } else if let data = uiImage.jpegData(compressionQuality: 1.0) {
                   imageData = data
                   print("Image converted to JPEG data")
               }
            }
        }
    }*/
}

#Preview {
    NewStreakView()
}
