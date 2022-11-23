import UIKit

extension UIFont {
    static func titilliumWebRegular(size: CGFloat = 15.0) -> UIFont {
        return UIFont(name: "TitilliumWeb-Regular", size: size) ?? .systemFont(ofSize: size)
    }
    static func titilliumWebBold(size: CGFloat = 15.0) -> UIFont {
        return UIFont(name: "TitilliumWeb-Bold", size: size) ?? .systemFont(ofSize: size)
    }
}
