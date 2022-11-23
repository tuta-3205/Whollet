import UIKit
import Reusable

final class TransactionTableViewCell: UITableViewCell, Reusable, NibLoadable {

    @IBOutlet weak var cellView: UIView!
    
    @IBOutlet weak var statusImage: UIImageView!
    
    @IBOutlet weak var amountUSDText: UILabel!
    
    @IBOutlet weak var amountText: UILabel!
    
    @IBOutlet weak var statusText: UILabel!
    
    @IBOutlet weak var dateText: UILabel!
    
    @IBOutlet var resizeTexts: [UILabel]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configView()
    }

    private func configView() {
        statusImage.clipsToBounds = true
        cellView.layer.cornerRadius = 20 * UIScreen.resizeHeight
        for text in resizeTexts {
            text.resizeWithHeight()
        }
        cellView.backgroundColor = UIColor.MyTheme.primaryBackground
        selectionStyle = .none
    }
    
    func bindData(data: TransactionDetail) {
        if let status = data.status {
            let isSent = status == "sent"
            statusText.text = isSent ? "Sent" : "Rejected"
            statusImage.image = UIImage(named: isSent ? "sent" : "rejected")
        }
        amountText.text = "\(String(text: (data.totalAmount ?? 0).description, size: 8)) ICX"
        amountUSDText.text = "$ \(data.totalAmountUSD?.description ?? "")"
        if let time = data.time {
            self.dateText.text = time.getFormattedDate(format: "MMM d, YYYY")
        }
    }
}
