import UIKit

extension UIColor {
    convenience init(argb: UInt) {
        self.init(
            red: CGFloat((argb & 0x00FF0000) >> 16) / 255.0,
            green: CGFloat((argb & 0x0000FF00) >> 8) / 255.0,
            blue: CGFloat(argb & 0x000000FF) / 255.0,
            alpha: CGFloat((argb & 0xFF000000) >> 24) / 255.0
        )
    }
    
    struct MyTheme {
        static var primary: UIColor { return UIColor(argb: 0xFF347AF0) }
        static var primaryBackground: UIColor { return UIColor(argb: 0xFFEDF1F9) }
        static var priceUp: UIColor { return UIColor(argb: 0xFF75BF72) }
        static var priceDown: UIColor { return UIColor(argb: 0xFFDF5060) }
        static var borderColor: UIColor { return UIColor(argb: 0xFFB5BBC9) }
        static var pending: UIColor { return UIColor(argb: 0xFFFDB32A) }
        static var rejected: UIColor { return UIColor(argb: 0xFFDF5060) }
    }
}
