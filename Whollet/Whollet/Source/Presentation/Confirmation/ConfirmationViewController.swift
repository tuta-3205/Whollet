import UIKit
import Reusable

extension ConfirmationViewController: StoryboardSceneBased {
    static let sceneStoryboard = UIStoryboard(name: "ConfirmationViewController", bundle: nil)
}

final class ConfirmationViewController: UIViewController {
    
    @IBOutlet private var resizeText: [UILabel]!
    @IBOutlet private var heightConstants: [NSLayoutConstraint]!
    @IBOutlet private weak var confimButton: UIButton!
    @IBOutlet private weak var bottomView: UIView!
    @IBOutlet private weak var addressText: UILabel!
    @IBOutlet private weak var amountText: UILabel!
    @IBOutlet private weak var amountUSDText: UILabel!
    @IBOutlet private weak var feeText: UILabel!
    @IBOutlet private weak var totalAmountText: UILabel!
    @IBOutlet private weak var totalAmountUSDText: UILabel!
    private var viewModel: ConfirmationViewModel!
    private weak var appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    private var totalAmount = 0.0
    private var totalAmountUSD = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        bindViewModel()
    }
    
    private func bindViewModel() {
        viewModel = ConfirmationViewModel()
        viewModel.bsICXCoins.bind { [weak self] value in
            guard let self = self else { return }
            
            if let icxPrice = value?.currentPrice {
                DispatchQueue.main.async {
                    self.addressText.text = self.appDelegate?.transactions.address
                    let amount = self.appDelegate?.transactions.valueICX ?? 0
                    self.amountText.text = "\(amount.description) ICX"
                    let amountUSD = amount * icxPrice
                    self.amountUSDText.text = "$ \(amountUSD.description)"
                    let totalAmount = amount + 0.0015
                    self.totalAmount = totalAmount
                    self.totalAmountText.text = "\(totalAmount.description) ICX"
                    let totalAmountUSD = totalAmount * icxPrice
                    self.totalAmountUSD = totalAmountUSD
                    self.totalAmountUSDText.text = "$ \(totalAmountUSD.description)"
                }
            }
        }
    }
    
    private func configView() {
        for txt in resizeText {
            txt.resizeWithHeight()
        }
        for height in heightConstants {
            height.constant *= UIScreen.resizeHeight
        }
        confimButton.fullCornerRadiusWithHeight()
        confimButton.resizeTextWithHeight()
        configNavigatorBar()
        bottomView.topRadius()
    }
    
    private func configNavigatorBar() {
        navigationItem.title = AppConstants.Strings.send.rawValue
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 26.0)]
        navigationController?.navigationBar.backgroundColor = UIColor.MyTheme.primaryBackground
    }
    
    
    @IBAction func confirmOnClick(_ sender: UIButton) {
        appDelegate?.transactions.time = Date.now
        appDelegate?.transactions.totalAmount = self.totalAmount
        appDelegate?.transactions.totalAmountUSD = self.totalAmountUSD
        let page = TransactionDetailViewController.instantiate()
        page.type = .send
        self.navigationController?.pushViewController(page, animated: true)
    }
}
