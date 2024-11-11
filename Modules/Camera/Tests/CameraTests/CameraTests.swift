import XCTest
import CameraMocks
@testable import Camera

final class CameraTests: XCTestCase {

    @MainActor
    func testCameraFeedViewViewModel() throws {
        let cameraManagerMock = CameraManagerMock()
        let viewModel = CameraFeedView.ViewModel(cameraManager: cameraManagerMock) { event in
        }

        viewModel.onNavigationEvents(.switchModeOption(.video(false)))
        XCTAssertEqual(viewModel.currentMode, .video(false))

        viewModel.onNavigationEvents(.changeTimerOption(.instant))
        XCTAssertEqual(viewModel.currentTimer.value, 0)
        viewModel.onNavigationEvents(.changeTimerOption(.five))
        XCTAssertEqual(viewModel.currentTimer.value, 5)
        viewModel.onNavigationEvents(.changeTimerOption(.ten))
        XCTAssertEqual(viewModel.currentTimer.value, 10)

        viewModel.onNavigationEvents(.showModeOptions)
        XCTAssertEqual(viewModel.showModeOptions, true)
        viewModel.onNavigationEvents(.showTimerOptions)
        XCTAssertEqual(viewModel.showTimerOptions, true)

        viewModel.onNavigationEvents(.switchFlash)
        XCTAssertEqual(viewModel.isFlashOn, true)

        viewModel.onNavigationEvents(.tappedOnSnapButton(.video(false)))
        XCTAssertEqual(viewModel.isRecording, true)
        viewModel.onNavigationEvents(.tappedOnSnapButton(.video(true)))
        XCTAssertEqual(viewModel.isLoading, true)
    }

}
