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

class VideoDelegate: NSObject, AVCaptureFileOutputRecordingDelegate {

    private let completion: (URL?, CameraManager.ManagerError?) -> Void

    init(completion: @escaping (URL?, CameraManager.ManagerError?) -> Void) {
        self.completion = completion
    }

    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
    }

    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: (any Error)?) {
        if let error {
            completion(nil, CameraManager.ManagerError.capturingError(error))
            return
        }
        completion(outputFileURL, nil)
    }

}
