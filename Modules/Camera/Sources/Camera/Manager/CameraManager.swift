import UIKit
import AVFoundation

public class CameraManager: ObservableObject {

    public enum Status {
        case configured
        case unconfigured
        case unauthorized
        case failed
    }

    public enum ManagerError: Error {
        case unavailable
        case configuration
        case createInput(Error)
        case addInput
        case addOutput

        case torchUnavailable
        case failedTorchMode(Error)

        case capturingError(Error)
        case imageFetchingError

        public var errorDescription: String? {
            switch self {
            case .unavailable:
                return "Video device is unavailable"
            case .addInput:
                return "Couldn't add video device input to the session"
            case .createInput(let error):
                return "Couldn't create video device input: \(error)"
            case .addOutput:
                return "Could not add photo output to the session"
            case .configuration:
                return "Camera configuration failed, either your device camera is not available or its missing permissions"
            case .torchUnavailable:
                return "Torch not available for this device"
            case .failedTorchMode(let error):
                return "Failed to set torch mode: \(error)"
            case .capturingError(let error):
                return "CameraManager: Error while capturing photo: \(error)"
            case .imageFetchingError:
                return "CameraManager: Image not fetched."
            }
        }
    }

    @Published var capturedImage: UIImage? = nil
    private var cameraDelegate: CameraDelegate?

    @Published var status: Status = .unconfigured
    @Published var currentCamera: AVCaptureDevice.Position = .back
    @Published var flashMode: AVCaptureDevice.FlashMode = .off
    @Published var managerError: ManagerError?

    let session = AVCaptureSession()
    let photoOutput = AVCapturePhotoOutput()
    var videoDeviceInput: AVCaptureDeviceInput?
    private let sessionQueue = DispatchQueue(label: "com.demo.sessionQueue")

    func configureCaptureSession() {
        sessionQueue.async { [weak self] in
            guard self?.status == .unconfigured else { return }

            self?.session.beginConfiguration()
            self?.session.sessionPreset = .photo
            self?.setupVideoInput()
            self?.setupPhotoOutput()
            self?.session.commitConfiguration()
            self?.startCapturing()
        }
    }

    private func setupVideoInput() {
        do {
            guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: currentCamera) else {
                managerError = .unavailable
                status = .unconfigured
                session.commitConfiguration()
                return
            }
            let videoInput = try AVCaptureDeviceInput(device: camera)
            guard session.canAddInput(videoInput) else {
                managerError = .addInput
                status = .unconfigured
                session.commitConfiguration()
                return
            }
            session.addInput(videoInput)
            videoDeviceInput = videoInput
            status = .configured
        } catch {
            managerError = .createInput(error)
            status = .failed
            session.commitConfiguration()
            return
        }
    }

    private func setupPhotoOutput() {
        if session.canAddOutput(photoOutput) {
            session.addOutput(photoOutput)
            photoOutput.maxPhotoDimensions = .init(width: 4032, height: 3024)
            photoOutput.maxPhotoQualityPrioritization = .quality
            status = .configured
        } else {
            managerError = .addOutput
            status = .failed
            session.commitConfiguration()
            return
        }
    }

    private func startCapturing() {
        guard status == .configured else {
            managerError = .configuration
            return
        }
        self.session.startRunning()
    }

    func stopCapturing() {
        sessionQueue.async { [weak self] in
            guard let self, self.session.isRunning else { return }
            self.session.stopRunning()
        }
    }

    func toggleTorch(torchIsOn: Bool) {
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        guard device.hasTorch else {
            managerError = .torchUnavailable
            return
        }
        do {
            try device.lockForConfiguration()
            flashMode = torchIsOn ? .on : .off
            if torchIsOn {
                try device.setTorchModeOn(level: 1.0)
            } else {
                device.torchMode = .off
            }
            device.unlockForConfiguration()
        } catch {
            managerError = .failedTorchMode(error)
        }
    }

    func switchCamera() {
        currentCamera = currentCamera == .back ? .front : .back
        guard let videoDeviceInput else { return }
        session.removeInput(videoDeviceInput)
        setupVideoInput()
    }

    func captureImage(completion: @escaping (UIImage?) -> Void) {
        sessionQueue.async { [weak self] in
            guard let self else { return }
            var photoSettings = AVCapturePhotoSettings()
            if photoOutput.availablePhotoCodecTypes.contains(.hevc) {
                photoSettings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.hevc])
            }
            if let videoDeviceInput = self.videoDeviceInput, videoDeviceInput.device.isFlashAvailable {
                photoSettings.flashMode = self.flashMode
            }
            photoSettings.maxPhotoDimensions = .init(width: 4032, height: 3024)
            if let previewPhotoPixelFormatType = photoSettings.availablePreviewPhotoPixelFormatTypes.first {
                photoSettings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewPhotoPixelFormatType]
            }
            photoSettings.photoQualityPrioritization = .quality
            cameraDelegate = CameraDelegate { [weak self] image, error in
                if let error {
                    self?.managerError = error
                }
                self?.capturedImage = image
                completion(image)
            }
            if let cameraDelegate {
                self.photoOutput.capturePhoto(with: photoSettings, delegate: cameraDelegate)
            }
        }
    }

}
