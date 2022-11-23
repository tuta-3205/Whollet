import UIKit
import Reusable
import ICONKit

enum TransactionDetailType {
    case send
    case view
}

extension TransactionDetailViewController: StoryboardSceneBased {
    static let sceneStoryboard = UIStoryboard(name: "TransactionDetailViewController", bundle: nil)
}

final class TransactionDetailViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet private weak var scrollContentView: UIView!
    @IBOutlet var resizeTexts: [UILabel]!
    @IBOutlet private weak var backToWalletButton: UIButton!
    @IBOutlet var heightConstants: [NSLayoutConstraint]!
    @IBOutlet private weak var statusImage: UIImageView!
    @IBOutlet private weak var statusHeader: UILabel!
    @IBOutlet private weak var dateText: UILabel!
    @IBOutlet private weak var timeText: UILabel!
    @IBOutlet private weak var totalAmountText: UILabel!
    @IBOutlet private weak var totalAmountUSDText: UILabel!
    @IBOutlet private weak var sendFeeText: UILabel!
    @IBOutlet private weak var statusText: UILabel!
    @IBOutlet private weak var transactionText: UILabel!
    @IBOutlet private weak var toText: UILabel!
    @IBOutlet private weak var fromText: UILabel!
    
    private weak var appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    var type: TransactionDetailType?
    var detail: TransactionDetail?
    private var viewModel: TransactionDetailViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let type = type {
            switch type {
            case .send:
                send()
            case .view:
                if let detail = detail {
                    loadDetailView(detail: detail)
                }
            }
        }
    }

    private func configView() {
        for height in heightConstants {
            height.constant *= UIScreen.resizeHeight
        }
        for text in resizeTexts {
            text.resizeWithHeight()
        }
        scrollContentView.topRadius()
        backToWalletButton.resizeTextWithHeight()
        backToWalletButton.fullCornerRadius()
        configNavigatorBar()
    }

    private func send() {
        loadSendingView()
        viewModel = TransactionDetailViewModel()
        if let to = self.appDelegate?.transactions.address,
            let amount = self.appDelegate?.transactions.totalAmount,
            let wallet = self.appDelegate?.wallet {
            viewModel.sendICX(to: to, amount: amount, wallet: wallet)
        }
        
        viewModel.bsHash.bind { [weak self] value in
            guard let self = self else { return }
            if let txHash = value {
                if txHash.isEmpty {
                    self.loadRejectedView()
                } else {
                    self.viewModel.getTransaction(txHash: txHash)
                }
            }
        }
        
        viewModel.bsResult.bind { [weak self] value in
            guard let self = self else { return }
            if let result = value {
                self.loadConfirmedView(result: result)
            } else {
                self.loadRejectedView()
            }
        }
        
    }
    
    private func loadSendingView() {
        UIView.animate(withDuration: 0.3, animations: {
            self.statusImage.image = UIImage(named: "pending")
            self.statusHeader.text = "Pending send"
            self.fromText.text = self.appDelegate?.wallet?.address
            self.toText.text = self.appDelegate?.transactions.address
            self.transactionText.text = ""
            self.statusText.text = "Pending"
            self.totalAmountText.text = "\(self.appDelegate?.transactions.totalAmount?.description ?? "") ICX"
            self.totalAmountUSDText.text = "$ \(self.appDelegate?.transactions.totalAmountUSD?.description ?? "")"
            if let time = self.appDelegate?.transactions.time {
                self.dateText.text = time.getFormattedDate(format: "MMM d, YYYY")
                self.timeText.text = time.getFormattedDate(format: "h:mm a")
            }
        })
    }
    
    private func loadDetailView(detail: TransactionDetail) {
        UIView.animate(withDuration: 0.3, animations: {
            self.statusImage.image = UIImage(named: detail.status ?? "rejected")
            self.statusHeader.text = detail.status == "sent" ? "Sent" : "Rejected"
            self.fromText.text = detail.from
            self.toText.text = detail.to
            self.transactionText.text = detail.id
            self.statusText.text = detail.status == "sent" ? "Sent" : "Rejected"
            self.totalAmountText.text = "\(detail.totalAmount?.description ?? "") ICX"
            self.totalAmountUSDText.text = "$ \(detail.totalAmountUSD?.description ?? "")"
            if let time = detail.time {
                self.dateText.text = time.getFormattedDate(format: "MMM d, YYYY")
                self.timeText.text = time.getFormattedDate(format: "h:mm a")
            }
        })
    }
    
    private func configNavigatorBar() {
        navigationItem.title = AppConstants.Strings.transactionDetail.rawValue
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 26.0)]
        navigationController?.navigationBar.backgroundColor = UIColor.MyTheme.primaryBackground
    }
    
    private func loadRejectedView() {
        viewModel.saveTransaction(detail: TransactionDetail(
            from: self.appDelegate?.wallet?.address,
            to: self.appDelegate?.transactions.address,
            id: "",
            status: "rejected",
            totalAmount: self.appDelegate?.transactions.totalAmount,
            totalAmountUSD: self.appDelegate?.transactions.totalAmountUSD,
            time: self.appDelegate?.transactions.time))
        UIView.animate(withDuration: 0.3, animations: {
            self.statusImage.image = UIImage(named: "rejected")
            self.statusHeader.text = "Rejected send"
            self.statusText.text = "Rejected"
        })
    }
    
    private func loadConfirmedView(result: Response.TransactionByHashResult) {
        viewModel.saveTransaction(detail: TransactionDetail(
            result: result,
            status: "sent",
            totalAmount: self.appDelegate?.transactions.totalAmount,
            totalAmountUSD: self.appDelegate?.transactions.totalAmountUSD))
        UIView.animate(withDuration: 0.3, animations: {
            self.statusImage.image = UIImage(named: "sent")
            self.statusHeader.text = "Sent"
            self.statusHeader.textColor = UIColor.MyTheme.rejected
            self.statusText.text = "Transaction confirmed"
            self.transactionText.text = result.blockHash
            let time = result.timestamp.hexToDate() ?? Date.now
            self.dateText.text = time.getFormattedDate(format: "MMM d, YYYY")
            self.timeText.text = time.getFormattedDate(format: "h:mm a")
        })
        
    }
    
    @IBAction func backToHomeOnClick(_ sender: UIButton) {
        let vc = self.navigationController?.viewControllers.first
        self.navigationController?.popToViewController(vc!, animated: true)
    }
}
