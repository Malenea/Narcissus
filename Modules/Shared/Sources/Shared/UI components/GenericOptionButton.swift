import SwiftUI

public struct GenericOptionButton: View {

    let imageName: String
    let customInset: CGFloat
    var action: () -> Void

    public init(imageName: String, customInset: CGFloat = 10.0, action: @escaping () -> Void) {
        self.imageName = imageName
        self.customInset = customInset
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            Circle()
                .foregroundColor(Color.gray.opacity(0.2))
                .frame(width: 48, height: 48, alignment: .center)
                .overlay(
                    Image(systemName: imageName)
                        .resizable()
                        .scaledToFit()
                        .padding(customInset)
                        .font(Font.title.weight(.light))
                        .foregroundStyle(.white)
                )
        }
    }

}
