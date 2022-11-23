import UIKit

extension UIView {
    func dropShadow(color: UIColor, opacity: Float = 0.2, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        layer.cornerRadius = 20
        layer.borderColor = UIColor.clear.cgColor
        layer.borderWidth = 1
    }
    
    func fullCornerRadiusWithHeight() {
        layer.cornerRadius = frame.size.height * UIScreen.resizeHeight / 2
        clipsToBounds = true
    }
    
    func fullCornerRadius() {
        layer.cornerRadius = frame.size.height * 0.5
        clipsToBounds = true
    }
    
    func topRadius() {
        layer.cornerRadius = AppConstants.CGFloats.defaultRadius.rawValue
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
}
