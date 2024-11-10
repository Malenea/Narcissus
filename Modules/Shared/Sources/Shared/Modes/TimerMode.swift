import SwiftUI

public enum TimerMode: Identifiable, Equatable, CaseIterable {

    case instant
    case five
    case ten

    public var id: Self { self }

    public var value: Int {
        switch self {
        case .instant:
            return 0
        case .five:
            return 5
        case .ten:
            return 10
        }
    }

    public init(rawValue: String) {
        switch rawValue {
        case "Instant": self = .instant
        case "5 sec": self = .five
        case "10 sec": self = .ten
        default: self = .instant
        }
    }

    public var toModeSelectorItem: ModeSelectorItem {
        .init(id: title, title: title, imageName: imageName, index: index)
    }

    public static var allModeSelectorCases: [ModeSelectorItem] {
        [
            .init(id: "Instant", title: "Instant", imageName: "timer", index: 0),
            .init(id: "5 sec", title: "5 sec", imageName: "timer", index: 1),
            .init(id: "10 sec", title: "10 sec", imageName: "timer", index: 2)
        ]
    }

    public var index: Int {
        switch self {
        case .instant: return 0
        case .five: return 1
        case .ten: return 2
        }
    }

    public static var allCases: [TimerMode] {
        [.instant, .five, .ten]
    }

    public var title: String {
        switch self {
        case .instant:
            return "Instant"
        case .five:
            return "5 sec"
        case .ten:
            return "10 sec"
        }
    }

    public var imageName: String {
        "timer"
    }

}
