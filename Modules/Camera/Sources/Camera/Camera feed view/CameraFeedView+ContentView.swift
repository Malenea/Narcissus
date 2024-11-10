import SwiftUI
import AVFoundation
import Shared

public extension CameraFeedView {

    struct ContentView: View {

        let currentMode: Binding<CameraMode>
        let isLoading: Bool
        let isRecording: Bool
        let session: AVCaptureSession
        let showSettingAlert: Binding<Bool>
        let showModeOptions: Bool
        let onEvent: (Event) -> Void

        var cameraFeedPreview: CameraFeedPreview

        init(
            session: AVCaptureSession,
            isLoading: Bool,
            currentMode: Binding<CameraMode>,
            isRecording: Bool,
            showSettingAlert: Binding<Bool>,
            showModeOptions: Bool,
            onEvent: @escaping (Event) -> Void
        ) {
            self.session = session
            self.currentMode = currentMode
            self.isLoading = isLoading
            self.isRecording = isRecording
            self.showSettingAlert = showSettingAlert
            self.showModeOptions = showModeOptions
            self.onEvent = onEvent

            cameraFeedPreview = CameraFeedPreview(session: session)
        }

        public var body: some View {
            contentView
                .onAppear {
                    onEvent(.didAppear)
                }
                .alert(isPresented: showSettingAlert) {
                    Alert(
                        title: Text("Warning"),
                        message: Text("Application doesn't have all permissions to use camera and microphone, please change privacy settings."),
                        dismissButton: .default(Text("Go to settings"), action: {
                            onEvent(.openSettings)
                        })
                    )
                }
        }

        private var contentView: some View {
            GeometryReader { geometry in
                ZStack {
                    Color.black.edgesIgnoringSafeArea(.all)

                    cameraFeedPreview
                        .ignoresSafeArea(.all)
                    VStack(spacing: .zero) {
                        Spacer()
                        if showModeOptions {
                            ModeSelector(currentMode: currentMode.wrappedValue.toModeSelectorItem, modes: CameraMode.allModeSelectorCases, isDisabled: isRecording) {
                                onEvent(.switchModeOption($0.isPhoto ? .photo : .video(false)))
                            }
                            .padding(.vertical, 16)
                            .transition(.slide)
                        }
                        HStack {
                            CameraOptionsButton {
                                onEvent(.showModeOptions)
                            }
                            .padding(.leading, 24.0)
                            .padding(.trailing, 16.0)
                            Spacer()
                            SnapButton(
                                currentMode: currentMode,
                                isLoading: isLoading,
                                isRecording: isRecording
                            ) { mode in
                                onEvent(.tappedOnSnapButton(mode))
                            }
                            .padding(.horizontal, 16)
                            Spacer()
                            CameraSwitchButton {
                                onEvent(.switchCamera)
                            }
                            .padding(.leading, 16.0)
                            .padding(.trailing, 24.0)
                        }
                        .frame(height: 104.0)
                        .frame(maxWidth: .infinity)
                        .background(Color.black.opacity(0.6))
                    }
                }
            }
        }

    }

}
