import SwiftUI
import Domain
import Filters

public struct ImagePreviewView: View {

    public enum Event: Hashable {
        case idle
        case didAppear

        case showFiltersOptions
        case switchFilterOption(ImageFilter)
        case changedIntensity(CGFloat)

        public func hash(into hasher: inout Hasher) {
            hasher.combine(self)
        }
    }

    public typealias NavigationEvent = ImagePreviewView.Event

    @StateObject private var viewModel: ViewModel
    @State private var currentEvent: Event? = .didAppear

    public init(
        previewImage: PreviewImage,
        onNavigationEvent: @escaping (NavigationEvent) -> Void
    ) {
        self._viewModel = .init(wrappedValue: ViewModel(previewImage: previewImage, onNavigationEvents: onNavigationEvent))
    }

    public var body: some View {
        ContentView(
            image: viewModel.previewImage.image,
            filteredImage: viewModel.previewImage.filteredImage,
            currentFilter: $viewModel.currentFilter,
            showFiltersOptions: viewModel.showFiltersOptions,
            filterIntensity: $viewModel.filterIntensity,
            onEvent: { currentEvent = $0 }
        )
        .task(id: currentEvent) {
            guard let currentEvent else { return }
            await viewModel.handle(event: currentEvent)
            self.currentEvent = nil
        }
    }

}
