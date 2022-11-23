import UIKit
import Reusable

final class CoinsViewController: UIViewController, StoryboardSceneBased {
    static let sceneStoryboard = UIStoryboard(name: "CoinsViewController", bundle: nil)
    
    @IBOutlet private weak var safeAndTopView: UIView!
    
    @IBOutlet private weak var tableContainer: UIView!
    
    @IBOutlet private weak var searchTextField: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet private var heightConstants: [NSLayoutConstraint]!
    
    private var viewModel: CoinsViewModel!
    
    var coins: [CoinModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        configTableView()
        bindViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configNavigatorBar()
    }
    
    private func bindViewModel() {
        viewModel = CoinsViewModel()

        viewModel.bsCoins.bind { [weak self] value in
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
    
    private func configNavigatorBar() {
        navigationItem.title = AppConstants.Strings.allTopCoins.rawValue
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 26.0 * UIScreen.resizeHeight)]
        navigationController?.navigationBar.backgroundColor = UIColor.MyTheme.primaryBackground
    }
    
    private func configView() {
        for height in heightConstants {
            height.constant *= UIScreen.resizeHeight
        }
        safeAndTopView.backgroundColor = UIColor.MyTheme.primaryBackground
        tableContainer.layer.cornerRadius = 20
        tableContainer.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        searchTextField.delegate = self
    }
    
    private func configTableView() {
        self.tableView.register(cellType: CoinTableViewCell.self)
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
}

extension CoinsViewController: UITableViewDataSource {
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

extension CoinsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailPageController = DetailViewController.instantiate()
        if let id = coins[indexPath.row].id {
            detailPageController.id = id
        }
        self.navigationController?.pushViewController(detailPageController, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > (tableView.contentSize.height - 600) {
            self.tableView.tableFooterView = SpinnerFooter.loadFromNib()
            DispatchQueue.main.async {
                self.tableView.tableFooterView = nil
                self.viewModel.loadMore()
            }
            
        }
        
        if position < -100 {
            self.tableView.tableHeaderView = SpinnerFooter.loadFromNib()
            self.viewModel.getCoins()
            DispatchQueue.main.async {
                self.tableView.tableHeaderView = nil
            }
        }
    }
}

extension CoinsViewController: UITextFieldDelegate {
    public func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String) -> Bool {
        guard let oldText = textField.text,
                   let range = Range(range, in: oldText) else {
                 return true
             }
        let newText = oldText.replacingCharacters(in: range, with: string)
        
        viewModel.search(keyword: newText)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        return true
    }
}
