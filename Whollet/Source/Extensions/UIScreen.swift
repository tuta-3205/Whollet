import UIKit

extension UIScreen {
    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height
    static let screenSize = UIScreen.main.bounds.size
    
    static let resizeWidth = screenWidth / 375
    static let resizeHeight = screenHeight / 812
}
