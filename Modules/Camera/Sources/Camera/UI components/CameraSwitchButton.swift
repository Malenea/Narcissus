import SwiftUI
import Shared

struct CameraSwitchButton: View {

    let action: () -> Void

    var body: some View {
        GenericOptionButton(imageName: "arrow.trianglehead.2.clockwise.rotate.90", action: action)
    }
    
}
