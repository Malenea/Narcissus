import SwiftUI
import Shared

struct ShareButton: View {

    var body: some View {
        GenericOptionButton(imageName: "square.and.arrow.up", action: {})
            .disabled(true)
    }

}
