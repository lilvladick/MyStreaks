import SwiftUI

struct CustomButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
    }
}
