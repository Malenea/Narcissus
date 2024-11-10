import SwiftUI
import Shared

struct CameraOptionsButton: View {

    let action: () -> Void

    var body: some View {
        GenericOptionButton(imageName: "option", customInset: 14, action: action)
    }

}
