import XCTest
@testable import Camera

final class CameraTests: XCTestCase {

    @MainActor
    func testCameraFeedViewViewModel() throws {
        let cameraManagerMock = CameraManagerMock()
        var viewModel = CameraFeedView.ViewModel(cameraManager: cameraManagerMock) { event in
            switch event {
            case .changeTimerOption(let timer):
                XCTAssertEqual(timer.value, 5)
            default: break
            }
        }

        viewModel.onNavigationEvents(.changeTimerOption(.five))
    }

}
