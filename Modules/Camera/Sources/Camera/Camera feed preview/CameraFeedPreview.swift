import SwiftUI
import AVFoundation

public struct CameraFeedPreview: UIViewRepresentable {

    let session: AVCaptureSession

    public func makeUIView(context: Context) -> VideoPreviewView {
        let view = VideoPreviewView()
        view.backgroundColor = .black
        view.videoPreviewLayer.session = session
        view.videoPreviewLayer.videoGravity = .resizeAspectFill
        return view
    }

    public func updateUIView(_ uiView: VideoPreviewView, context: Context) {
    }

}

public extension CameraFeedPreview {

    class VideoPreviewView: UIView {

        public override class var layerClass: AnyClass { AVCaptureVideoPreviewLayer.self }
        var videoPreviewLayer: AVCaptureVideoPreviewLayer { layer as! AVCaptureVideoPreviewLayer }

    }

}
