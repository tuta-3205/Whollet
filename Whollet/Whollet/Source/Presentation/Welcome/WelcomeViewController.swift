import UIKit
import Reusable

final class WelcomeViewController: UIViewController, StoryboardSceneBased {
    static let sceneStoryboard = UIStoryboard(name: "WelcomeViewController", bundle: nil)
    
    @IBOutlet private weak var welcomeImage: UIImageView!
    
    @IBOutlet private weak var welcomeText: UILabel!
    
    @IBOutlet private weak var wholletText: UILabel!
    
    @IBOutlet private weak var loadButton: UIButton!
    
    @IBOutlet private weak var createButton: UIButton!
    
    @IBOutlet var heightConstants: [NSLayoutConstraint]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }

    private func configView() {
        for height in heightConstants {
            height.constant *= UIScreen.resizeHeight
        }
        view.backgroundColor = UIColor.MyTheme.primary
        loadButton.fullCornerRadiusWithHeight()
        loadButton.resizeTextWithHeight()
        createButton.resizeTextWithHeight()
        welcomeText.resizeWithHeight()
        wholletText.resizeWithHeight()
    }
    
    private func toWalletPage(_ initial: WalletInitialState) {
        let walletPageController = WalletViewController.instantiate()
        walletPageController.initialState = initial
        navigationController?.isNavigationBarHidden = false
        self.navigationController?.pushViewController(walletPageController, animated: true)
    }

    @IBAction func loadWalletOnClick(_ sender: UIButton) {
        toWalletPage(.load)
    }

    @IBAction func createWalletOnClick(_ sender: UIButton) {
        toWalletPage(.create)
    }
}
