import SwiftUI
import Shared

struct FilterOptionsButton: View {

    var action: () -> Void

    var body: some View {
        GenericOptionButton(imageName: "camera.filters", action: action)
    }

}
