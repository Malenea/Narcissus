import UIKit
import AVKit
import Shared
import CameraProtocols

public class CameraManagerMock: CameraManagerProtocol {

    public var session: AVCaptureSession = AVCaptureSession()

    public func reconfigureCaptureSession(mode: CameraMode) {
    }
    
    public func configureCaptureSession(mode: CameraMode) {
    }
    
    public func startRecording(completion: @escaping (URL?, (any Error)?) -> Void) {
    }
    
    public func stopRecording() {
    }
    
    public func switchCamera() {
    }
    
    public func toggleTorch(torchIsOn: Bool) {
    }
    
    public func captureImage(completion: @escaping (UIImage?) -> Void) {
    }

    public init() {}

}
