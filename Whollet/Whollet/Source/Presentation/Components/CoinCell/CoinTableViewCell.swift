import UIKit
import Reusable

final class CoinTableViewCell: UITableViewCell, Reusable, NibLoadable {
    @IBOutlet private weak var priceChangeText: UILabel!
    @IBOutlet private weak var priceText: UILabel!
    @IBOutlet private weak var priceChangeImage: UIImageView!
    @IBOutlet private weak var cellUIView: UIView!
    @IBOutlet private weak var logoImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configView()
    }
    
    private func configView() {
        priceChangeImage.clipsToBounds = true
        cellUIView.fullCornerRadius()
        priceText.resizeWithHeight()
        priceChangeText.resizeWithHeight()
        cellUIView.backgroundColor = UIColor.MyTheme.primaryBackground
        selectionStyle = .none
    }
    
    func bindData(data: CoinModel) {
        priceChangeImage.image = (data.priceChange24H ?? 0) >= 0
            ? UIImage(named: AppConstants.Strings.iconPriceUp.rawValue)
            : UIImage(named: AppConstants.Strings.iconPriceDown.rawValue)
        
        if let logoURL = data.image, let url = URL(string: logoURL) {
            logoImage.loadFrom(from: url)
        }
        priceText.text = "$ \(data.currentPrice ?? 0)"
        if let priceChange = data.priceChange24H {
            priceChangeText.text = String(
                text: abs(priceChange).description,
                size: AppConstants.Ints.priceStringSize.rawValue)
            let isPriceUp = priceChange > 0
            priceChangeText.textColor = isPriceUp ? UIColor.MyTheme.priceUp : UIColor.MyTheme.priceDown
        }
    }
}
