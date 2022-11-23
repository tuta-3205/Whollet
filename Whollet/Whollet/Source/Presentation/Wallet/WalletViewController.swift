import UIKit
import Reusable

enum WalletInitialState {
    case load
    case create
}

final class WalletViewController: UIViewController, StoryboardSceneBased {
    static let sceneStoryboard = UIStoryboard(name: "WalletViewController", bundle: nil)
    
    @IBOutlet weak var descriptionText: UILabel!
    
    @IBOutlet weak var nextButton: UIButton!
    
    var initialState: WalletInitialState?
    
    private var viewModel: WalletViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        bindViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.backgroundColor = UIColor.MyTheme.primaryBackground
    }
    
    private func bindViewModel() {
        viewModel = WalletViewModel()
        viewModel.bsWalletState.bind { [weak self] value in
            guard let self = self else { return }
            if let state = value {
                switch state {
                case .inProgress:
                    if self.initialState == .create {
                        DispatchQueue.main.async {
                            self.descriptionText.text = AppConstants.Strings.createICX.rawValue
                            self.nextButton.setTitle(AppConstants.Strings.loading.rawValue, for: .normal)
                            self.nextButton.backgroundColor = UIColor.MyTheme.primary.withAlphaComponent(0.5)
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.descriptionText.text = AppConstants.Strings.loadWallet.rawValue
                            self.nextButton.setTitle(AppConstants.Strings.loading.rawValue, for: .normal)
                            self.nextButton.backgroundColor = UIColor.MyTheme.primary.withAlphaComponent(0.5)
                        }
                    }
                case .loadSuccess:
                    if self.initialState == .create {
                        DispatchQueue.main.async {
                            self.descriptionText.text = AppConstants.Strings.createWalletSuccessfully.rawValue
                            self.nextButton.setTitle(AppConstants.Strings.goHome.rawValue, for: .normal)
                            self.nextButton.backgroundColor = UIColor.MyTheme.primary
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.descriptionText.text = AppConstants.Strings.loadWalletSuccessfully.rawValue
                            self.nextButton.setTitle(AppConstants.Strings.goHome.rawValue, for: .normal)
                            self.nextButton.backgroundColor = UIColor.MyTheme.primary
                        }
                    }
                default:
                    break
                }
            }
        }
    }
    
    private func configView() {
        nextButton.fullCornerRadiusWithHeight()
        nextButton.resizeTextWithHeight()
        guard let initialState = initialState else {
            return
        }
        switch initialState {
        case .create:
            DispatchQueue.main.async {
                self.navigationItem.title = AppConstants.Strings.createWallet.rawValue
                DispatchQueue.main.async {
                    self.descriptionText.text = AppConstants.Strings.createICX.rawValue
                    self.nextButton.setTitle(AppConstants.Strings.createWallet.rawValue, for: .normal)
                    self.nextButton.backgroundColor = UIColor.MyTheme.primary
                }
            }
        case .load:
            DispatchQueue.main.async {
                self.navigationItem.title = AppConstants.Strings.loadWallet.rawValue
                DispatchQueue.main.async {
                    self.descriptionText.text = AppConstants.Strings.copyPrimaryKey.rawValue
                    self.nextButton.setTitle(AppConstants.Strings.pasteKey.rawValue, for: .normal)
                    self.nextButton.backgroundColor = UIColor.MyTheme.primary
                }
            }
        }
    }
    
    @IBAction func nextButtonOnClick(_ sender: UIButton) {
        guard let initialState = initialState else {
            return
        }
        
        switch viewModel.bsWalletState.value {
        case .initial:
            if initialState == .create {
                viewModel.createWallet()
            } else {
                viewModel.loadWallet(UIPasteboard.general.string ?? "")
            }
            return
        case .loadSuccess:
            let homePageController = HomeViewController.instantiate()
            self.navigationController?.pushViewController(homePageController, animated: true)
        default:
            return
        }
        
    }
}
