import Foundation
import Shared

public enum FilterType : String {
    case Mono = "CIPhotoEffectMono"
    case MonoChrome = "CIColorMonochrome"
    case Noir = "CIPhotoEffectNoir"
    case Tonal = "CIPhotoEffectTonal"
    case Sharpen = "CIUnsharpMask"
    case Blur = "CIGaussianBlur"
    case Pixelate = "CIPixellate"
    case Edges = "CIEdges"
    case Negative = "CIColorInvert"
    case Posterize = "CIColorPosterize"
    case NoiseReduction = "CINoiseReduction"
}

public enum ImageFilter: String {
    case none
    case sepia
    case sketch

    public init(rawValue: String) {
        switch rawValue {
        case "Sepia": self = .sepia
        case "Sketch": self = .sketch
        default: self = .none
        }
    }

    public var toModeSelectorItem: ModeSelectorItem {
        .init(id: title, title: title, imageName: imageName, index: index)
    }

    public static var allModeSelectorCases: [ModeSelectorItem] {
        [
            .init(id: "None", title: "None", imageName: "camera.filters", index: 0),
            .init(id: "Sepia", title: "Sepia", imageName: "camera.filters", index: 1),
            .init(id: "Sketch", title: "Sketch", imageName: "camera.filters", index: 2)
        ]
    }

    public var index: Int {
        switch self {
        case .none: return 0
        case .sepia: return 1
        case .sketch: return 2
        }
    }

    public var imageName: String {
        "camera.filters"
    }

    public var title: String {
        switch self {
        case .none:
            return "None"
        case .sepia:
            return "Sepia"
        case .sketch:
            return "Sketch"
        }
    }
}
