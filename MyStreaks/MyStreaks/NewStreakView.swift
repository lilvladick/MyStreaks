import SwiftUI
import SwiftData
import PhotosUI

struct NewStreakView: View {
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var image: Image?
    
    var body: some View {
        NavigationStack {
            VStack {
                image?
                    .resizable()
                    .scaledToFit()
                Form {
                    
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    PhotosPicker(
                        selection: $selectedPhoto,
                        matching: .any(of: [.images, .videos])
                    ) {
                        Image(systemName: "photo")
                    }
                }
            }
            .onChange(of: selectedPhoto) { oldPhoto, newPhoto in
                Task {
                    if let photo = newPhoto {
                        image = try? await photo.loadTransferable(type: Image.self)
                    }
                }
            }
        }
    }
}

#Preview {
    NewStreakView()
}
