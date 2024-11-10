import SwiftUI

public class PreviewImage: ObservableObject {

    @Published public var filteredImage: UIImage?

    public let uiImage: UIImage
    public let image: Image

    public init(uiImage: UIImage) {
        self.uiImage = uiImage
        self.image = Image(uiImage: uiImage)
    }

}
