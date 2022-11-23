import UIKit
import Reusable

final class AmountViewController: UIViewController, StoryboardSceneBased {
    static let sceneStoryboard = UIStoryboard(name: "AmountViewController", bundle: nil)
    
    @IBOutlet private weak var icxView: UIView!
    
    @IBOutlet private weak var icxViewText: UILabel!
    
    @IBOutlet private weak var balanceText: UILabel!
    
    @IBOutlet private weak var sentICXText: UILabel!
    
    @IBOutlet private weak var sentUSDText: UILabel!
    
    @IBOutlet private weak var nextButton: UIButton!
    
    private var viewModel: AmountViewModel!
    
    var icxPrice: Double?
    private var balance: Double = 0.0 {
        didSet {
            balanceText.text = "\(String(balance)) ICX Available"
        }
    }
    
    private var number: String = "" {
        didSet {
            if number.isEmpty {
                sentICXText.text = "0.00"
                sentICXText.textColor = .black.withAlphaComponent(0.7)
                sentUSDText.text = "$0.00"
                nextButton.backgroundColor = .none
                nextButton.tintColor = UIColor.MyTheme.primary
            } else {
                sentICXText.text = number
                sentICXText.textColor = UIColor.MyTheme.primary
                sentUSDText.text = "$ " + String(String((Double(number) ?? 0) * (icxPrice ?? 0)))
                if let icx = Double(number), icx > 0, icx < balance {
                    nextButton.backgroundColor = UIColor.MyTheme.primary
                    nextButton.tintColor = .white
                } else {
                    nextButton.backgroundColor = .none
                    nextButton.tintColor = UIColor.MyTheme.primary
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        bindViewModel()
    }
    
    private func bindViewModel() {
        viewModel = AmountViewModel()
        viewModel.bsBalance.bind { [weak self] value in
            if let value = value, let balance = Double(value) {
                self?.balance = balance / 1000000000000000000
            }
        }
    }
    
    private func configView() {
        nextButton.fullCornerRadiusWithHeight()
        icxView.fullCornerRadiusWithHeight()
        nextButton.layer.borderWidth = AppConstants.CGFloats.borderWidthButton.rawValue
        nextButton.layer.borderColor = UIColor.MyTheme.borderColor.cgColor
        nextButton.backgroundColor = .none
        nextButton.tintColor = UIColor.MyTheme.primary
        configNavigatorBar()
    }
    
    private func configNavigatorBar() {
        navigationItem.title = AppConstants.Strings.send.rawValue
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 26.0 * UIScreen.resizeHeight)]
        navigationController?.navigationBar.backgroundColor = UIColor.MyTheme.primaryBackground
    }
    
    @IBAction func zeroButtonOnClick(_ sender: UIButton) {
        number += "0"
    }
    
    @IBAction func oneButtonOnCLick(_ sender: UIButton) {
        number += "1"
    }
    
    @IBAction func towButtonOnClick(_ sender: UIButton) {
        number += "2"
    }
    
    @IBAction func threeButtonOnClick(_ sender: UIButton) {
        number += "3"
    }
    
    @IBAction func fourButtonOnClick(_ sender: Any) {
        number += "4"
    }
    
    @IBAction func fiveButtonOnClick(_ sender: Any) {
        number += "5"
    }
    
    @IBAction func sixButtonOnClick(_ sender: Any) {
        number += "6"
    }
    
    @IBAction func sevenButtonOnClick(_ sender: Any) {
        number += "7"
    }
    
    @IBAction func eightButtonOnClick(_ sender: Any) {
        number += "8"
    }
    
    @IBAction func nineButtonOnClick(_ sender: Any) {
        number += "9"
    }
    
    @IBAction func backButtonOnClick(_ sender: Any) {
        number = ""
    }
    
    @IBAction func pointButtonOnClick(_ sender: Any) {
        number += "."
    }
    
    @IBAction func nextButtonOnClick(_ sender: UIButton) {
        if let icx = Double(number), icx > 0, icx < balance {
            self.viewModel.saveICXValue(icx)
            self.navigationController?.pushViewController(AddressViewController.instantiate(), animated: true)
        }
        
    }
}
