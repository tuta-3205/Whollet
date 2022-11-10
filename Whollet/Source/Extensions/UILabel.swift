import UIKit

extension UILabel {
    func resizeWithHeight() {
        self.font = self.font.withSize(self.font.pointSize * UIScreen.resizeHeight)
    }
}
