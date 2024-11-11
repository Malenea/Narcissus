import Foundation
import AVKit
import Shared

public protocol CameraManagerProtocol: ObservableObject {

    var session: AVCaptureSession { get }

    func reconfigureCaptureSession(mode: CameraMode)
    func configureCaptureSession(mode: CameraMode)

    func startRecording(completion: @escaping (URL?, Error?) -> Void)
    func stopRecording()

    func switchCamera()
    func toggleTorch(torchIsOn: Bool)

    func captureImage(completion: @escaping (UIImage?) -> Void)

}
