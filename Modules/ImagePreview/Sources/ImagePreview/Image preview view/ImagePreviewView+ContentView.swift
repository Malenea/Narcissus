import SwiftUI
import Shared
import Filters

public extension ImagePreviewView {

    struct ContentView: View {

        let image: Image
        let filteredImage: UIImage?
        let currentFilter: Binding<ImageFilter>
        let showFiltersOptions: Bool
        let onEvent: (Event) -> Void

        var sharingImage: Image {
            guard let filteredImage else { return image }
            return Image(uiImage: filteredImage)
        }

        init(
            image: Image,
            filteredImage: UIImage?,
            currentFilter: Binding<ImageFilter>,
            showFiltersOptions: Bool,
            onEvent: @escaping (Event) -> Void
        ) {
            self.image = image
            self.filteredImage = filteredImage
            self.currentFilter = currentFilter
            self.showFiltersOptions = showFiltersOptions
            self.onEvent = onEvent
        }

        public var body: some View {
            contentView
                .onAppear {
                    onEvent(.didAppear)
                }
        }

        private var contentView: some View {
            GeometryReader { geometry in
                ZStack {
                    Color.black.edgesIgnoringSafeArea(.all)

                    image
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea(.all, edges: .bottom)
                        .frame(width: geometry.size.width, height: geometry.size.height + geometry.safeAreaInsets.bottom)
                        .clipped()
                    if let filteredImage {
                        Image(uiImage: filteredImage)
                            .resizable()
                            .scaledToFill()
                            .ignoresSafeArea(.all, edges: .bottom)
                            .frame(width: geometry.size.width, height: geometry.size.height + geometry.safeAreaInsets.bottom)
                            .clipped()
                    }
                    VStack(spacing: .zero) {
                        Spacer()
                        if showFiltersOptions {
                            ModeSelector(currentMode: currentFilter.wrappedValue.toModeSelectorItem, modes: ImageFilter.allModeSelectorCases, isDisabled: false) {
                                onEvent(.switchFilterOption(ImageFilter(rawValue: $0.id)))
                            }
                            .padding(.vertical, 16)
                            .transition(.slide)
                        }
                        HStack {
                            FilterOptionsButton {
                                onEvent(.showFiltersOptions)
                            }
                            .padding(.leading, 24.0)
                            .padding(.trailing, 16.0)
                            .padding(.bottom, geometry.safeAreaInsets.bottom)
                            Spacer()
                            ShareLink(item: sharingImage, preview: SharePreview("Narcissus", image: sharingImage), label: {
                                ShareButton()
                            })
                            .padding(.leading, 16.0)
                            .padding(.trailing, 24.0)
                            .padding(.bottom, geometry.safeAreaInsets.bottom)
                        }
                        .frame(height: 104.0 + geometry.safeAreaInsets.bottom)
                        .frame(maxWidth: .infinity)
                        .background(Color.black.opacity(0.6))
                    }
                }
            }
        }

    }

}
