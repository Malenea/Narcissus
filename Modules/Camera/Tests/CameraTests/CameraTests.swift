import XCTest
import AVKit
import SnapshotTesting
@testable import Camera

final class CameraTests: XCTestCase {

    @MainActor
    func testCameraFeedViewViewModel() throws {
        let cameraManagerMock = CameraManagerMock()
        let viewModel = CameraFeedView.ViewModel(cameraManager: cameraManagerMock) { event in
            switch event {
            case .changeTimerOption(let timer):
                XCTAssertEqual(timer.value, 5)
            default: break
            }
        }

        viewModel.onNavigationEvents(.changeTimerOption(.five))
    }

    @MainActor
    func testSnapshotCameraFeedViewWithNoOptionsForPhoto() async {
        let view = CameraFeedView.ContentView(session: AVCaptureSession(),
                                              isLoading: false,
                                              currentMode: .constant(.photo),
                                              currentTimer: .constant(.instant),
                                              isRecording: false,
                                              isFlashOn: false,
                                              showOptions: .init(
                                                showSettingAlert: .constant(false),
                                                showTimerOptions: false,
                                                showModeOptions: false
                                              )
        ) { _ in }
        assertSnapshot(of: view, as: .image(precision: 0.98, perceptualPrecision: 0.98, layout: .device(config: .iPhone8Plus)))
    }

    @MainActor
    func testSnapshotCameraFeedViewWithOptionsForVideo() async {
        let view = CameraFeedView.ContentView(session: AVCaptureSession(),
                                              isLoading: false,
                                              currentMode: .constant(.video(true)),
                                              currentTimer: .constant(.five),
                                              isRecording: true,
                                              isFlashOn: true,
                                              showOptions: .init(
                                                showSettingAlert: .constant(false),
                                                showTimerOptions: true,
                                                showModeOptions: true
                                              )
        ) { _ in }
        assertSnapshot(of: view, as: .image(precision: 0.98, perceptualPrecision: 0.98, layout: .device(config: .iPhone8Plus)))
    }

}
