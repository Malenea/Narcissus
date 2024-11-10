import SwiftUI
import AVFoundation

public extension CameraFeedView {

    @MainActor
    class ViewModel: ObservableObject {

        @ObservedObject var cameraManager: CameraManager = .init()
        @Published var currentMode: CameraMode = .photo
        @Published var isLoading: Bool = false
        @Published var isRecording: Bool = false
        @Published var isFlashOn: Bool = false
        @Published var showAlertError: Bool = false
        @Published var showSettingAlert: Bool = false
        @Published var showModeOptions: Bool = false
        @Published var isPermissionGranted: Bool = false

        var isFirstLaunch: Bool = true
        var session: AVCaptureSession = .init()
        private let onNavigationEvents: (NavigationEvent) -> Void

        init(
            onNavigationEvents: @escaping (NavigationEvent) -> Void
        ) {
            self.onNavigationEvents = onNavigationEvents
        }

        func handle(event: Event) async {
            switch event {
            case .didAppear:
                guard isFirstLaunch else { return }
                await initialLoad()
                isFirstLaunch = false

            case .tappedOnSnapButton(let mode):
                isLoading = true
                switch mode {
                case .photo:
                    cameraManager.captureImage { image in
                        guard let image else {
                            self.isLoading = false
                            return
                        }
                        self.isLoading = false
                        self.onNavigationEvents(.finishCapturingPhoto(image))
                    }
                case .video(let isRecording):
                    self.isRecording = isRecording
                    if isRecording {
                        cameraManager.startRecording { url, error in
                            guard let url else {
                                self.isLoading = false
                                return
                            }
                            self.isLoading = false
                            self.onNavigationEvents(.finishCapturingVideo(url))
                        }
                    } else {
                        cameraManager.stopRecording()
                    }
                }

            case .showModeOptions:
                withAnimation {
                    showModeOptions.toggle()
                }
            case .switchModeOption(let mode):
                currentMode = mode
                cameraManager.reconfigureCaptureSession(mode: currentMode)
            case .switchCamera:
                switchCamera()

            case .openSettings:
                openSettings()
            default: break
            }
        }

        private func initialLoad() async {
            session = cameraManager.session
            checkForDevicePermission()
        }

        private func checkForDevicePermission() {
            let videoStatus = AVCaptureDevice.authorizationStatus(for: .video)
            switch videoStatus {
            case .denied:
                isPermissionGranted = false
                showSettingAlert = true
            case .authorized, .restricted:
                isPermissionGranted = true
                configureCamera()
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { _ in })
            @unknown default:
                break
            }
        }

        private func configureCamera() {
            cameraManager.configureCaptureSession(mode: .photo)
        }

        private func switchCamera() {
            cameraManager.switchCamera()
        }

        func openSettings() {
            let settingsUrl = URL(string: UIApplication.openSettingsURLString)
            guard let url = settingsUrl else { return }
            UIApplication.shared.open(url, options: [:])
        }

    }

}
