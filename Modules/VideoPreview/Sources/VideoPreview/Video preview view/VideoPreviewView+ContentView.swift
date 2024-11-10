import SwiftUI
import AVKit
import Shared

public extension VideoPreviewView {

    struct ContentView: View {

        let player: Binding<AVPlayer>
        let url: URL
        let onEvent: (Event) -> Void

        private var thumbnailImage: Image {
            guard let uiImageThumbnail = url.getThumbnailImageFromVideoURL() else { return Image(systemName: "questionmark") }
            return Image(uiImage: uiImageThumbnail)
        }

        init(
            player: Binding<AVPlayer>,
            url: URL,
            onEvent: @escaping (Event) -> Void
        ) {
            self.player = player
            self.url = url
            self.onEvent = onEvent
        }

        public var body: some View {
            contentView
                .onAppear {
                    NotificationCenter
                        .default
                        .addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.wrappedValue.currentItem, queue: .main) { _ in
                            player.wrappedValue.seek(to: .zero)
                            player.wrappedValue.play()
                        }
                    onEvent(.didAppear)
                }
        }

        private var contentView: some View {
            GeometryReader { geometry in
                ZStack {
                    Color.black.edgesIgnoringSafeArea(.all)

                    VideoPlayer(player: player.wrappedValue)
                        .scaledToFill()
                        .ignoresSafeArea(.all, edges: .bottom)
                        .frame(width: geometry.size.width, height: geometry.size.height + geometry.safeAreaInsets.bottom)
                        .clipped()
//                    if let filteredImage {
//                        Image(uiImage: filteredImage)
//                            .resizable()
//                            .scaledToFill()
//                            .ignoresSafeArea(.all, edges: .bottom)
//                            .frame(width: geometry.size.width, height: geometry.size.height + geometry.safeAreaInsets.bottom)
//                            .clipped()
//                    }
                    VStack(spacing: .zero) {
                        Spacer()
//                        if showFiltersOptions {
//                            if currentFilter.wrappedValue == .sepia {
//                                slider
//                                    .transition(.slide)
//                            }
//                            ModeSelector(currentMode: currentFilter.wrappedValue.toModeSelectorItem, modes: ImageFilter.allModeSelectorCases, isDisabled: false) {
//                                onEvent(.switchFilterOption(ImageFilter(rawValue: $0.id)))
//                            }
//                            .padding(.vertical, 16)
//                            .transition(.slide)
//                        }
                        HStack {
//                            FilterOptionsButton {
//                                onEvent(.showFiltersOptions)
//                            }
//                            .padding(.leading, 24.0)
//                            .padding(.trailing, 16.0)
//                            .padding(.bottom, geometry.safeAreaInsets.bottom)
                            Spacer()
                            ShareLink(item: url, preview: SharePreview("Narcissus", image: thumbnailImage), label: {
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

//        private var slider: some View {
//            VStack {
//                Text("Intensity")
//                    .font(.caption)
//                Slider(value: filterIntensity, in: 0...1)
//                    .accentColor(.white.opacity(0.6))
//                    .onChange(of: filterIntensity.wrappedValue) {
//                        onEvent(.changedIntensity(filterIntensity.wrappedValue))
//                    }
//            }
//            .padding(8)
//            .background {
//                Color(.systemBackground)
//                    .opacity(0.6)
//                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 18)
//                            .stroke(Color.primary.opacity(0.15), lineWidth: 1.2)
//                    )
//            }
//            .padding(.horizontal, 48)
//            .padding(.bottom, 8)
//        }

    }

}
