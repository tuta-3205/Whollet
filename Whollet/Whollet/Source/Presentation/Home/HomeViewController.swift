import UIKit
import Reusable

final class HomeViewController: UIViewController, StoryboardSceneBased {
    static let sceneStoryboard = UIStoryboard(name: "HomeViewController", bundle: nil)
    @IBOutlet private weak var tabBarBottomView: UIView!
    @IBOutlet private weak var safeAreaView: UIView!
    @IBOutlet private weak var icxPriceView: UIView!
    @IBOutlet private weak var topCoinView: UIView!
    @IBOutlet private weak var icxPriceText: UILabel!
    @IBOutlet private weak var depositButton: UIButton!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var depositViewHeight: NSLayoutConstraint!
    @IBOutlet private weak var depositViewWidth: NSLayoutConstraint!
    @IBOutlet private weak var depositViewTop: NSLayoutConstraint!
    @IBOutlet private weak var depositView: UIView!
    @IBOutlet private weak var topCoinsText: UILabel!
    @IBOutlet private var heightConstants: [NSLayoutConstraint]!
    @IBOutlet private weak var seeAllTopButton: UIButton!
    
    private var coins: [CoinModel] = []
    private var viewModel: HomeViewModel!
    private var isShowSheet = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.viewControllers.removeAll(where: { $0 != self})
        configView()
        configTableView()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configNavigatorBar()
    }
    
    private func bindViewModel() {
        viewModel = HomeViewModel()
        bindCoins()
        bindICXCoins()
    }
        
    private func bindCoins() {
        viewModel.bsDataCoins.bind { [weak self] value in
            guard let self = self else { return }
            if let coins = value {
                self.coins = coins
                DispatchQueue.main.async {
                    self.tableView.tableFooterView = nil
                    self.tableView.reloadData()
                }
            } else {
                DispatchQueue.main.async {
                    self.tableView.tableFooterView = SpinnerFooter.loadFromNib()
                }
            }
        }
    }
    
    private func bindICXCoins() {
        viewModel.bsICXCoins.bind { [weak self] value in
            guard let self = self else { return }
            if let icxCoin = value {
                let price = icxCoin.currentPrice?.description ?? ""
                DispatchQueue.main.async {
                    self.icxPriceText.text = "$ " + String(
                        text: price,
                        size: AppConstants.Ints.priceStringSize.rawValue)
                }
            }
        }
    }
    
    private func configView() {
        for height in heightConstants {
            height.constant *= UIScreen.resizeHeight
        }
        safeAreaView.backgroundColor = UIColor.MyTheme.primary
        icxPriceView.backgroundColor = UIColor.MyTheme.primary
        icxPriceText.resizeWithHeight()
        topCoinsText.resizeWithHeight()
        seeAllTopButton.resizeTextWithHeight()
        
        tabBarBottomView.topRadius()
        
        topCoinView.layer.cornerRadius = AppConstants.CGFloats.defaultRadius.rawValue
        topCoinView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        depositButton.fullCornerRadius()
        depositButton.layer.borderWidth = AppConstants.CGFloats.depositButtonBorder.rawValue
        depositButton.layer.borderColor = UIColor.MyTheme.primaryBackground.cgColor
    }
    
    private func configTableView() {
        tableView.register(cellType: CoinTableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func configNavigatorBar() {
        navigationItem.title = AppConstants.Strings.icx.rawValue
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont.boldSystemFont(
                ofSize: AppConstants.CGFloats.appBarTitleSize.rawValue * UIScreen.resizeHeight)
        ]
        navigationController?.navigationBar.backgroundColor = UIColor.MyTheme.primary
    }
    
    @IBAction func seeAllTopCoinsOnTap(_ sender: UIButton) {
        let coinsPageController = CoinsViewController.instantiate()
        self.navigationController?.pushViewController(coinsPageController, animated: true)
    }
    
    @IBAction func depositOnClick(_ sender: UIButton) {
        let depositPageController = DepositViewController.instantiate()
        
        if let sheet = depositPageController.sheetPresentationController {
            sheet.detents = [.large()]
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = AppConstants.CGFloats.defaultRadius.rawValue
            sheet.largestUndimmedDetentIdentifier = .medium
        }
        self.present(depositPageController, animated: true, completion: nil)
    }
    
    @IBAction func sendOnClick(_ sender: UIButton) {
        let amountPageController = AmountViewController.instantiate()
        amountPageController.icxPrice = viewModel.bsICXCoins.value?.currentPrice
        self.navigationController?.pushViewController(amountPageController, animated: true)
    }
    
    @IBAction func transactionOnClick(_ sender: Any) {
        let allTransactionPageController = AllTransactionViewController.instantiate()
        self.navigationController?.pushViewController(allTransactionPageController, animated: true)
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coins.count
    }
      
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as CoinTableViewCell
        let coin = coins[indexPath.row]
        cell.bindData(data: coin)
        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailPageController = DetailViewController.instantiate()
        if let id = coins[indexPath.row].id {
            detailPageController.id = id
        }
        self.navigationController?.pushViewController(detailPageController, animated: true)
    }
}
