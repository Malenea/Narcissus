import SwiftUI
import Shared

public struct SnapButton: View {

    @Binding var currentMode: CameraMode
    @State var isPressed: Bool = false

    let isLoading: Bool
    let isRecording: Bool

    public enum VideoAction {
        case start
        case finish
    }
    public var action: ((CameraMode) -> Void)?
    var videoButtonInnerCircleWidth: CGFloat {
        isRecording ? 34 : 57
    }

    public var body: some View {
        outerCircleButton
    }

    private var outerCircleButton: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 4)
                .foregroundStyle(.white)
                .frame(width: 65, height: 65)
            innerButton
        }
        .animation(.spring, value: isRecording)
        .padding(20)
    }

    private var innerButton: some View {
        ZStack {
            Button(action: {
                action?(currentMode.isPhoto ? .photo : .video(isRecording))
            }, label: {
                ZStack {
                    photoButton.opacity(currentMode.isPhoto ? 1 : .zero).animation(.spring, value: currentMode.isPhoto)
                    videoButton.opacity(currentMode.isPhoto ? .zero : 1).animation(.spring, value: currentMode.isPhoto)
                }
            })
            .disabled(isLoading)
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: currentMode.isPhoto ? .black : .white))
            }
        }
    }

    @ViewBuilder
    private var photoButton: some View {
        Circle()
            .foregroundStyle(.white)
            .frame(width: 57)
    }

    @ViewBuilder
    private var videoButton: some View {
        RoundedRectangle(cornerRadius: isRecording ? 8 : videoButtonInnerCircleWidth / 2)
            .foregroundStyle(.red)
            .frame(width: videoButtonInnerCircleWidth, height: videoButtonInnerCircleWidth)
    }

}
