import SwiftUI

public struct TimerButton: View {

    let action: () -> Void

    public init(action: @escaping () -> Void) {
        self.action = action
    }

    public var body: some View {
        GenericOptionButton(imageName: "timer", action: action)
    }

}
