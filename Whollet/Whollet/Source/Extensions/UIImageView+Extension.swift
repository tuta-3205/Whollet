import UIKit

extension UIImageView {
    func loadFrom(from url: URL, placeholder: UIImage? = nil) {
        image = placeholder
        ImageManager.shared.fetchImage(url: url) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self.image = image
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func generateQRCode(from string: String) {
        let data = string.data(using: String.Encoding.ascii)

        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)

            if let output = filter.outputImage?.transformed(by: transform) {
                self.image =  UIImage(ciImage: output)
            }
        }
    }
}
