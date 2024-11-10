import SwiftUI

public struct ShareButton: View {

    public init() {}

    public var body: some View {
        GenericOptionButton(imageName: "square.and.arrow.up", action: {})
            .disabled(true)
    }

}
