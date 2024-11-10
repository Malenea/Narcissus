import UIKit
import AVFoundation

class CameraDelegate: NSObject, AVCapturePhotoCaptureDelegate {

    private let completion: (UIImage?, CameraManager.ManagerError?) -> Void

    init(completion: @escaping (UIImage?, CameraManager.ManagerError?) -> Void) {
        self.completion = completion
    }

    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error {
            completion(nil, CameraManager.ManagerError.capturingError(error))
            return
        }
        if let imageData = photo.fileDataRepresentation(), let capturedImage = UIImage(data: imageData) {
            completion(capturedImage, nil)
        } else {
            completion(nil, CameraManager.ManagerError.imageFetchingError)
        }
    }

}
