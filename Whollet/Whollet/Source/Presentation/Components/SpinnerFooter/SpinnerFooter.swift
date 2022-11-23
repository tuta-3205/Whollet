import UIKit
import Reusable

final class SpinnerFooter: UIView, Reusable, NibLoadable {
    
    @IBOutlet weak var snipper: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configView()
    }
    
    private func configView() {
        snipper.startAnimating()
    }
}
