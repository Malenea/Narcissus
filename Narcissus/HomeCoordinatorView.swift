import SwiftUI
import Camera
import ImagePreview

enum AppPages: Identifiable, Hashable {
    var id: Self { self }

    case camera
    case imagePreview(UIImage)

    static func == (lhs: AppPages, rhs: AppPages) -> Bool {
        switch (lhs, rhs) {
        case (.camera, .camera):
                return true
        case (.imagePreview, .imagePreview):
            return true
        default:
            return false
        }
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

class HomeCoordinator: ObservableObject {

    @Published var path: NavigationPath = NavigationPath()

    func push(page: AppPages) {
        path.append(page)
    }

    func pop() {
        path.removeLast()
    }

    @ViewBuilder
    func build(page: AppPages) -> some View {
        switch page {
        case .camera:
            CameraFeedView { event in
                switch event {
                case .finishCapturingPhoto(let image):
                    self.push(page: .imagePreview(image))
                default: break
                }
            }
        case .imagePreview(let image):
            ImagePreviewView(previewImage: .init(uiImage: image)) { event in
                switch event {
                default: break
                }
            }
        }
    }

}

struct HomeCoordinatorView: View {

    @StateObject private var coordinator = HomeCoordinator()

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.build(page: .camera)
                .navigationDestination(for: AppPages.self) { page in
                    coordinator.build(page: page)
                }
        }
        .environmentObject(coordinator)
    }

}