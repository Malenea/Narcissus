import UIKit
import AVFoundation
import Shared
import CameraProtocols

public class CameraManager: CameraManagerProtocol {

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
    @Published var capturedVideoURL: URL? = nil
    private var cameraDelegate: CameraDelegate?
    private var videoDelegate: VideoDelegate?

    @Published var status: Status = .unconfigured
    @Published var currentCamera: AVCaptureDevice.Position = .back
    @Published var flashMode: AVCaptureDevice.FlashMode = .off
    @Published var managerError: ManagerError?

    public var session = AVCaptureSession()
    let photoOutput = AVCapturePhotoOutput()
    let videoOutput = AVCaptureMovieFileOutput()
    var videoDeviceInput: AVCaptureDeviceInput?
    private let sessionQueue = DispatchQueue(label: "com.demo.sessionQueue")

    public func reconfigureCaptureSession(mode: CameraMode) {
        sessionQueue.async { [weak self] in
            self?.session.beginConfiguration()
            if mode == .photo {
                self?.session.sessionPreset = .photo
                if let videoOutput = self?.videoOutput {
                    self?.session.removeOutput(videoOutput)
                }
            } else {
                self?.session.sessionPreset = .high
                if let videoOutput = self?.videoOutput {
                    self?.session.addOutput(videoOutput)
                }
            }
            self?.session.commitConfiguration()
        }
    }

    public func configureCaptureSession(mode: CameraMode) {
        sessionQueue.async { [weak self] in
            guard self?.status == .unconfigured else { return }

            self?.session.beginConfiguration()
            if mode == .photo {
                self?.session.sessionPreset = .photo
            } else {
                self?.session.sessionPreset = .high
            }
            self?.setupVideoInput()
            if mode == .photo {
                self?.setupPhotoOutput()
            } else {
                self?.setupVideoOutput()
            }
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

    private func setupVideoOutput() {
        if session.canAddOutput(videoOutput) {
            session.addOutput(videoOutput)
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

    public func toggleTorch(torchIsOn: Bool) {
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        guard device.hasTorch else {
            managerError = .torchUnavailable
            return
        }
        do {
            try device.lockForConfiguration()
            flashMode = torchIsOn ? .on : .off
            if torchIsOn {
                try device.setTorchModeOn(level: 1)
            } else {
                device.torchMode = .off
            }
            device.unlockForConfiguration()
        } catch {
            managerError = .failedTorchMode(error)
        }
    }

    public func switchCamera() {
        currentCamera = currentCamera == .back ? .front : .back
        guard let videoDeviceInput else { return }
        session.removeInput(videoDeviceInput)
        setupVideoInput()
    }

    public func captureImage(completion: @escaping (UIImage?) -> Void) {
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

    public func startRecording(completion: @escaping (URL?, Error?) -> Void) {
        guard !videoOutput.isRecording, let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("video.mp4") else { return }
        videoDelegate = VideoDelegate { [weak self] url, error in
            if let error {
                self?.managerError = error
                completion(nil, error)
            }
            self?.capturedVideoURL = url
            completion(url, nil)
        }
        if !videoOutput.isRecording {
            if FileManager.default.fileExists(atPath: url.path) {
                try? FileManager.default.removeItem(at: url)
            }
            guard let videoDelegate else { return }
            videoOutput.startRecording(to: url, recordingDelegate: videoDelegate)
        }
    }

    public func stopRecording() {
        guard videoOutput.isRecording else { return }
        videoOutput.stopRecording()
    }

}
