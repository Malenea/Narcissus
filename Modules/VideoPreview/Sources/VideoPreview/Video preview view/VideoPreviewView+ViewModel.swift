import SwiftUI
import AVKit

public extension VideoPreviewView {

    @MainActor
    class ViewModel: ObservableObject {

//        @ObservedObject var previewImage: PreviewImage
        @Published var player: AVPlayer = AVPlayer()
        @Published var url: URL
//        @Published var currentFilter: ImageFilter = .none
//        @Published var showFiltersOptions: Bool = false
//        @Published var filterIntensity: CGFloat = 1.0
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

//            case .showFiltersOptions:
//                withAnimation {
//                    showFiltersOptions.toggle()
//                }
//            case .switchFilterOption(let filter):
//                withAnimation {
//                    currentFilter = filter
//                    switch currentFilter {
//                    case .none:
//                        previewImage.filteredImage = nil
//                    case .sepia:
//                        previewImage.filteredImage = previewImage.uiImage.toSepia(intensity: filterIntensity)
//                    case .sketch:
//                        previewImage.filteredImage = previewImage.uiImage.toSketch
//                    }
//                }
//            case .changedIntensity(let intensity):
//                switch currentFilter {
//                case .sepia:
//                    previewImage.filteredImage = previewImage.uiImage.toSepia(intensity: intensity)
//                default: break
//                }

            default: break
            }
        }

        private func initialLoad() async {
            player = AVPlayer(url: url)
            player.play()
        }

    }

}
