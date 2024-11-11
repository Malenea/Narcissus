import Foundation

public enum CameraMode: Identifiable, Equatable, CaseIterable {
    case photo
    case video(_ isRecording: Bool)

    public var id: String { UUID().uuidString }

    public var toModeSelectorItem: ModeSelectorItem {
        .init(id: title, title: title, imageName: imageName, index: index)
    }

    public static var allModeSelectorCases: [ModeSelectorItem] {
        [
            .init(id: "Photo", title: "Photo", imageName: "camera", index: 0),
            .init(id: "Video", title: "Video", imageName: "video", index: 1)
        ]
    }

    public var index: Int {
        switch self {
        case .photo: return 0
        case .video: return 1
        }
    }

    public static var allCases: [CameraMode] {
        [.photo, .video(false)]
    }

    public var isPhoto: Bool {
        return self == .photo
    }

    public var imageName: String {
        switch self {
        case .photo:
            return "camera"
        case .video:
            return "video"
        }
    }

    public var title: String {
        switch self {
        case .photo:
            return "Photo"
        case .video:
            return "Video"
        }
    }

    public static func ==(lhs: CameraMode, rhs: CameraMode) -> Bool {
        switch (lhs, rhs) {
        case (.photo, .photo):
                return true
        case (.video, .video):
                return true
        default:
            return false
        }
    }

}
