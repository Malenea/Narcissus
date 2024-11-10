import SwiftUI
import AVKit

public extension VideoPreviewView {

    @MainActor
    class ViewModel: ObservableObject {

        @Published var player: AVPlayer = AVPlayer()
        @Published var url: URL
        private let onNavigationEvents: (NavigationEvent) -> Void

        init(
            url: URL,
            onNavigationEvents: @escaping (NavigationEvent) -> Void
        ) {
            self.url = url
            self.onNavigationEvents = onNavigationEvents
        }

        func handle(event: Event) async {
            switch event {
            case .didAppear:
                await initialLoad()

            default: break
            }
        }

        private func initialLoad() async {
            player = AVPlayer(url: url)
            player.play()
        }

    }

}
