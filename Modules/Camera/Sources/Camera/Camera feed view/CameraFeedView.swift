import SwiftUI

public struct CameraFeedView: View {

    public enum Event: Hashable {
        case idle
        case didAppear

        case tappedOnSnapButton(CameraMode)

        case switchFlash
        case showModeOptions
        case switchModeOption(CameraMode)
        case switchCamera

        case openSettings

        case finishCapturingPhoto(UIImage)
        case finishCapturingVideo(URL)

        public func hash(into hasher: inout Hasher) {
            hasher.combine(self)
        }
    }

    public typealias NavigationEvent = CameraFeedView.Event

    @StateObject private var viewModel: ViewModel
    @State private var currentEvent: Event? = .didAppear

    public init(
        onNavigationEvent: @escaping (NavigationEvent) -> Void
    ) {
        self._viewModel = .init(wrappedValue: ViewModel(onNavigationEvents: onNavigationEvent))
    }

    public var body: some View {
        ContentView(
            session: viewModel.cameraManager.session,
            isLoading: viewModel.isLoading,
            currentMode: $viewModel.currentMode,
            isRecording: viewModel.isRecording,
            isFlashOn: viewModel.isFlashOn,
            showSettingAlert: $viewModel.showSettingAlert,
            showModeOptions: viewModel.showModeOptions,
            onEvent: { currentEvent = $0 }
        )
        .task(id: currentEvent) {
            guard let currentEvent else { return }
            await viewModel.handle(event: currentEvent)
            self.currentEvent = nil
        }
    }

}
