import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins

// MARK: - Extensions to UIImage to apply filters directly
public extension UIImage {

    // MARK: - Builtin filters
    func toSepia(intensity: CGFloat) -> UIImage {
        guard let ciImage = CIImage(image: self) else { return self }

        let filter = CIFilter.sepiaTone()
        filter.inputImage = ciImage
        filter.intensity = Float(intensity)
        return applyFilter(filter, inputImage: self)
    }

    // MARK: - Custom filters
    var toSketch: UIImage {
        self
            .addFilter(filterType: .Posterize)
            .addFilter(filterType: .NoiseReduction)
            .addFilter(filterType: .Sharpen)
            .addFilter(filterType: .MonoChrome)
    }

    func addFilter(filterType : FilterType) -> UIImage {
            let filter = CIFilter(name: filterType.rawValue)
            let ciInput = CIImage(image: self)
            filter?.setValue(ciInput, forKey: "inputImage")
            if filterType == .Sharpen {
                filter?.setValue(0.8, forKey: "inputIntensity")
                filter?.setValue(8, forKey: "inputRadius")
            }
            if filterType == .Posterize {
                filter?.setValue(15, forKey: "inputLevels")
            }
            if filterType == .MonoChrome {
                filter?.setValue(CIColor(red: 0.8, green: 0.8, blue: 0.8), forKey: "inputColor")
                filter?.setValue(1.0, forKey: "inputIntensity")
            }
            if filterType == .NoiseReduction {
                filter?.setValue(2, forKey: "inputSharpness")
            }
            return applyFilter(filter, inputImage: self)
        }

    private func applyFilter(_ filter: CIFilter?, inputImage: UIImage) -> UIImage {
        let context = CIContext()
        guard let filter,
              let outputCIImage = filter.outputImage,
              let cgImage = context.createCGImage(outputCIImage, from: outputCIImage.extent) else {
            return self
        }
        let outputUIImage = UIImage(cgImage: cgImage, scale: inputImage.scale, orientation: inputImage.imageOrientation)
        return outputUIImage
    }

}
