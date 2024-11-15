import SwiftUI
import AVFoundation
import Shared

public extension CameraFeedView {

    @MainActor
    class ViewModel<T: CameraManagerProtocol>: ObservableObject {

        @ObservedObject var cameraManager: T
        @Published var currentMode: CameraMode = .photo
        @Published var currentTimer: TimerMode = .instant
        @Published var isLoading: Bool = false
        @Published var isRecording: Bool = false
        @Published var isFlashOn: Bool = false
        @Published var showAlertError: Bool = false
        @Published var showSettingAlert: Bool = false
        @Published var showModeOptions: Bool = false
        @Published var showTimerOptions: Bool = false
        @Published var isPermissionGranted: Bool = false

        var isFirstLaunch: Bool = true
        var session: AVCaptureSession = .init()
        let onNavigationEvents: (NavigationEvent) -> Void

        init(
            cameraManager: T,
            onNavigationEvents: @escaping (NavigationEvent) -> Void
        ) {
            self.cameraManager = cameraManager
            self.onNavigationEvents = onNavigationEvents
        }

        func handle(event: Event) async {
            switch event {
            case .didAppear:
                guard isFirstLaunch else { return }
                await initialLoad()
                isFirstLaunch = false

            case .tappedOnSnapButton(let mode):
                switch mode {
                case .photo:
                    isLoading = true
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
                    if !isRecording {
                        self.isRecording = true
                        cameraManager.startRecording { url, error in
                            guard let url else {
                                self.isLoading = false
                                return
                            }
                            self.isLoading = false
                            self.onNavigationEvents(.finishCapturingVideo(url))
                        }
                    } else {
                        self.isRecording = false
                        cameraManager.stopRecording()
                        isLoading = true
                    }
                }

            case .switchFlash:
                isFlashOn.toggle()
                cameraManager.toggleTorch(torchIsOn: isFlashOn)
            case .showModeOptions:
                withAnimation {
                    showModeOptions.toggle()
                }
            case .switchModeOption(let mode):
                currentMode = mode
                cameraManager.reconfigureCaptureSession(mode: currentMode)
            case .showTimerOptions:
                withAnimation {
                    showTimerOptions.toggle()
                }
            case .changeTimerOption(let timer):
                print("BOUNGA: \(timer)")
                currentTimer = timer
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
