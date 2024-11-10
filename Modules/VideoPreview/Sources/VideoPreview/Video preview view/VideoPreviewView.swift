import SwiftUI

public struct VideoPreviewView: View {

    public enum Event: Hashable {
        case idle
        case didAppear

        public func hash(into hasher: inout Hasher) {
            hasher.combine(self)
        }
    }

    public typealias NavigationEvent = VideoPreviewView.Event

    @StateObject private var viewModel: ViewModel
    @State private var currentEvent: Event? = .didAppear

    public init(
        url: URL,
        onNavigationEvent: @escaping (NavigationEvent) -> Void
    ) {
        self._viewModel = .init(wrappedValue: ViewModel(url: url, onNavigationEvents: onNavigationEvent))
    }

    public var body: some View {
        ContentView(
            player: $viewModel.player,
            url: viewModel.url,
            onEvent: { currentEvent = $0 }
        )
        .task(id: currentEvent) {
            guard let currentEvent else { return }
            await viewModel.handle(event: currentEvent)
            self.currentEvent = nil
        }
    }

}
