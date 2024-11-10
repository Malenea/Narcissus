import SwiftUI
import Shared

//public struct CameraModeSelector: View {
//
//    @Environment(\.colorScheme) var colorScheme
//    var currentMode: Binding<CameraMode>
//
//    let isRecording: Bool
//    let color: Color = .indigo
//    let lastIndex: Int = CameraMode.allCases.count - 1
//    let action: (CameraMode) -> Void
//
//    public init(currentMode: Binding<CameraMode>, isRecording: Bool, action: @escaping (CameraMode) -> Void) {
//        self.currentMode = currentMode
//        self.isRecording = isRecording
//        self.action = action
//    }
//
//    public var body: some View {
//        VStack {
//            innerContent
//                .padding(12)
//                .background {
//                    Color(.systemBackground)
//                        .opacity(0.6)
//                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
//                        .overlay(RoundedRectangle(cornerRadius: 18)
//                            .stroke(Color.primary.opacity(colorScheme == .dark ? 0.15 : 0.08), lineWidth: 1.2)
//                        )
//                }
//                .padding(.horizontal, 25)
//                .animation(.smooth, value: currentMode.wrappedValue)
//        }
//    }
//
//    private var innerContent: some View {
//        HStack(spacing: .zero) {
//            ButtonsFactory
//        }
//        .frame(maxWidth: .infinity)
//        .padding(.horizontal, 2)
//        .background {
//            GeometryReader { proxy in
//                let caseCount = CameraMode.allCases.count
//                Color.white.opacity(0.6)
//                    .clipShape(RoundedRectangle(cornerRadius: 10))
//                    .frame(width: proxy.size.width / CGFloat(caseCount))
//                    .offset(x: proxy.size.width / CGFloat(caseCount) * CGFloat(currentMode.wrappedValue.index))
//            }
//        }
//    }
//
//    private var ButtonsFactory: some View {
//        ForEach(CameraMode.allCases, id: \.id) { mode in
//            VStack {
//                Button {
//                    /// This is to prevent changing mode while recording is active
//                    guard currentMode.wrappedValue != mode && !isRecording else {
//                        return
//                    }
//                    currentMode.wrappedValue = mode
//                    action(mode)
//                } label: {
//                    HStack(spacing: 4) {
//                        Image(systemName: mode.imageName)
//                            .font(.caption)
//                        Text("\(mode.title)")
//                            .font(.caption)
//                    }
//                    .frame(maxWidth: .infinity)
//                    .padding(8)
//                    .contentShape(Rectangle())
//                }
//                .buttonStyle(BouncyButton())
//                .foregroundStyle(mode == currentMode.wrappedValue ? .black : .white.opacity(0.4))
//            }
//        }
//    }
//
//}
