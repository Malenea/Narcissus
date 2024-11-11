import SwiftUI
import Shared

public struct CameraFeedView: View {

    public enum Event: Hashable {
        case idle
        case didAppear

        case tappedOnSnapButton(CameraMode)

        case switchFlash
        case showModeOptions
        case switchModeOption(CameraMode)
        case showTimerOptions
        case changeTimerOption(TimerMode)
        case switchCamera

        case openSettings

        case finishCapturingPhoto(UIImage)
        case finishCapturingVideo(URL)

        public func hash(into hasher: inout Hasher) {
            hasher.combine(self)
        }
    }

    public typealias NavigationEvent = CameraFeedView.Event

    @StateObject private var viewModel: ViewModel<CameraManager>
    @State private var currentEvent: Event? = .didAppear

    public init(
        onNavigationEvent: @escaping (NavigationEvent) -> Void
    ) {
        self._viewModel = .init(wrappedValue: ViewModel(
            cameraManager: CameraManager(),
            onNavigationEvents: onNavigationEvent
        ))
    }

    public var body: some View {
        let showOptions = ViewShowOptions(
            showSettingAlert: $viewModel.showSettingAlert,
            showTimerOptions: viewModel.showTimerOptions,
            showModeOptions: viewModel.showModeOptions
        )

        ContentView(
            session: viewModel.cameraManager.session,
            isLoading: viewModel.isLoading,
            currentMode: $viewModel.currentMode,
            currentTimer: $viewModel.currentTimer,
            isRecording: viewModel.isRecording,
            isFlashOn: viewModel.isFlashOn,
            showOptions: showOptions,
            onEvent: { currentEvent = $0 }
        )
        .task(id: currentEvent) {
            guard let currentEvent else { return }
            await viewModel.handle(event: currentEvent)
            self.currentEvent = nil
        }
    }

}
