import SwiftUI
import Shared

struct FlashSwitchButton: View {

    let isOn: Bool
    let action: () -> Void

    var body: some View {
        GenericOptionButton(imageName: isOn ? "lightbulb.fill" : "lightbulb", action: action)
    }

}
