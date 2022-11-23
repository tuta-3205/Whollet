import UIKit
import Reusable

final class DepositViewController: UIViewController, StoryboardSceneBased {
    static let sceneStoryboard = UIStoryboard(name: "DepositViewController", bundle: nil)

    @IBOutlet private weak var depositCoinsText: UILabel!
    
    @IBOutlet private weak var depositView: UIView!
    
    @IBOutlet private weak var backButton: UIButton!
    
    @IBOutlet private weak var icxView: UIView!
    
    @IBOutlet private weak var QRView: UIView!
    
    @IBOutlet private weak var QRImage: UIImageView!
    
    @IBOutlet private weak var walletAddress: UIView!
    
    @IBOutlet weak var walletAddressText: UILabel!
    
    @IBOutlet var heightConstants: [NSLayoutConstraint]!
    
    private weak var appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    private func configView() {
        for height in heightConstants {
            height.constant *= UIScreen.resizeHeight
        }
        depositCoinsText.resizeWithHeight()
        walletAddressText.resizeWithHeight()
        view.backgroundColor = UIColor(argb: 0x11000000)
        depositView.layer.cornerRadius = AppConstants.CGFloats.defaultRadius.rawValue
        depositView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        backButton.fullCornerRadiusWithHeight()
        backButton.layer.borderWidth = AppConstants.CGFloats.depositButtonBorder.rawValue
        backButton.layer.borderColor = UIColor.MyTheme.primaryBackground.cgColor
        icxView.fullCornerRadiusWithHeight()
        QRView.layer.cornerRadius = 10
        if let address = appDelegate?.wallet?.address {
            walletAddressText.text = address
            QRImage.generateQRCode(from: address)
        }
    }
    
    @IBAction func copyOnClick(_ sender: UIButton) {
        UIPasteboard.general.string = appDelegate?.wallet?.address
    }
    
    @IBAction func shareOnClick(_ sender: UIButton) {
        UIApplication.share(appDelegate?.wallet?.address ?? "")
    }
}
