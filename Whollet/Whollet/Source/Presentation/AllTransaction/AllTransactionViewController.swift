import UIKit
import Reusable

extension AllTransactionViewController: StoryboardSceneBased {
    static let sceneStoryboard = UIStoryboard(name: "AllTransactionViewController", bundle: nil)
}

final class AllTransactionViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    private var transactions = [TransactionDetail]()
    private var viewModel: AllTransactionViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        bindViewModel()
        configTableView()
    }
    
    private func bindViewModel() {
        viewModel = AllTransactionViewModel()
        bindTransactions()
    }
        
    private func bindTransactions() {
        viewModel.bsTransactions.bind { [weak self] value in
            guard let self = self else { return }
            if let transactions = value {
                self.transactions = transactions
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
    
    private func configView() {
        configNavigatorBar()
        containerView.topRadius()
    }
    
    private func configNavigatorBar() {
        navigationItem.title = AppConstants.Strings.allTransaction.rawValue
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 26.0)]
        navigationController?.navigationBar.backgroundColor = UIColor.MyTheme.primaryBackground
    }
    
    private func configTableView() {
        tableView.register(cellType: TransactionTableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension AllTransactionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
      
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as TransactionTableViewCell
        let transaction = transactions[indexPath.row]
        cell.bindData(data: transaction)
        return cell
    }
}

extension AllTransactionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailPageController = TransactionDetailViewController.instantiate()
        detailPageController.type = .view
        detailPageController.detail = transactions[indexPath.row]
        self.navigationController?.pushViewController(detailPageController, animated: true)
    }
}

