import SwiftUI

public struct BouncyButton: ButtonStyle {

    public init() {}

    @ViewBuilder
    public func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(x: configuration.isPressed ? 0.95 : 1.0, y: configuration.isPressed ? 0.9 : 1.0)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
            .opacity(configuration.isPressed ? 0.5 : 1)
    }

}
