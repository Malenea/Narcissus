import SwiftUI
import Shared

struct CameraOptionsButton: View {

    var action: () -> Void

    var body: some View {
        GenericOptionButton(imageName: "option", customInset: 14.0, action: action)
    }

}
