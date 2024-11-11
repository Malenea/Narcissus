import SwiftUI

public struct ModeSelectorItem: Identifiable, Equatable {

    public let id: String
    public let title: String
    public let imageName: String
    public let index: Int

    public init(id: String, title: String, imageName: String, index: Int) {
        self.id = id
        self.title = title
        self.imageName = imageName
        self.index = index
    }

    public var isPhoto: Bool {
        id == "Photo"
    }

}

public struct ModeSelector: View {

    @Environment(\.colorScheme) var colorScheme

    let currentMode: ModeSelectorItem
    let modes: [ModeSelectorItem]
    let isDisabled: Bool
    let lastIndex: Int
    let color: Color = .indigo
    let action: (ModeSelectorItem) -> Void

    public init(currentMode: ModeSelectorItem, modes: [ModeSelectorItem], isDisabled: Bool, action: @escaping (ModeSelectorItem) -> Void) {
        self.currentMode = currentMode
        self.modes = modes
        self.isDisabled = isDisabled
        self.lastIndex = modes.count - 1
        self.action = action
    }

    public var body: some View {
        VStack {
            innerContent
                .padding(12)
                .background {
                    Color(.black)
                        .opacity(0.6)
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                        .overlay(RoundedRectangle(cornerRadius: 18)
                            .stroke(Color.primary.opacity(colorScheme == .dark ? 0.15 : 0.08), lineWidth: 1.2)
                        )
                }
                .padding(.horizontal, 25)
                .animation(.smooth, value: currentMode)
        }
    }

    private var innerContent: some View {
        HStack(spacing: .zero) {
            ButtonsFactory
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 2)
        .background {
            GeometryReader { proxy in
                let caseCount = modes.count
                Color.white.opacity(0.6)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .frame(width: proxy.size.width / CGFloat(caseCount))
                    .offset(x: proxy.size.width / CGFloat(caseCount) * CGFloat(currentMode.index))
            }
        }
    }

    private var ButtonsFactory: some View {
        ForEach(modes, id: \.id) { mode in
            VStack {
                Button {
                    guard currentMode != mode && !isDisabled else {
                        return
                    }
                    action(mode)
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: mode.imageName)
                            .font(.caption)
                        Text("\(mode.title)")
                            .font(.caption)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(8)
                    .contentShape(Rectangle())
                }
                .buttonStyle(BouncyButton())
                .foregroundStyle(mode == currentMode ? .black : .white.opacity(0.4))
            }
        }
    }

}
