import UIKit
import Charts
import Reusable

final class DetailViewController: UIViewController, StoryboardSceneBased {
    static let sceneStoryboard = UIStoryboard(name: "DetailViewController", bundle: nil)
    
    @IBOutlet private weak var coinImage: UIImageView!
    
    @IBOutlet private weak var coinNaneAndId: UILabel!
    
    @IBOutlet private weak var coinPrice: UILabel!
    
    @IBOutlet private weak var coinRank: UILabel!
    
    @IBOutlet private weak var coinPriceChange24h: UILabel!
    
    @IBOutlet private weak var chartContainer: UIView!
    
    @IBOutlet private var chartTimeTypeButton: [UIButton]!
    
    @IBOutlet private weak var coinChartView: LineChartView!
    
    @IBOutlet private weak var marketText: UILabel!
    
    @IBOutlet private weak var priceChangeText: UILabel!
    
    @IBOutlet private var heightConstants: [NSLayoutConstraint]!
    
    private var viewModel = DetailViewModel()
    
    var id: String?
    
    private var timeChar: TimeChart = .day

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        configView()
    }
    
    private func bindViewModel() {
        if let id = id {
            viewModel.getDetail(id: id)
            viewModel.getChart(timeType: timeChar, id: id)
        }
        
        viewModel.bsCoin.bind { [weak self] value in
            if let detail = value {
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.loadCoinDetail(data: detail)
                }
            }
        }
        
        viewModel.bsChart.bind { [weak self] value in
            if let chartEntry = value {
                guard let self = self else { return }
                
                let set = LineChartDataSet(entries: chartEntry, label: "Line chart")
                set.drawCirclesEnabled = false
                set.mode = .linear
                set.lineWidth = 1
                if chartEntry.first?.y ?? 10 < chartEntry.last?.y ?? 10 {
                    set.setColor(.green)
                } else {
                    set.setColor(.red)
                }
                let data = LineChartData(dataSet: set)
                data.setDrawValues(false)
                
                DispatchQueue.main.async {
                    self.coinChartView.data = data
                    self.coinChartView.animate(xAxisDuration: 2)
                }
            }
        }
    }
    
    private func loadCoinDetail(data: CoinModel) {
        if let imageURL = data.image {
            if let url = URL(string: imageURL) {
                coinImage.loadFrom(from: url)
            }
        }
        coinNaneAndId.text = "\(data.name ?? "") - \(data.id ?? "")"
        coinPrice.text = "$\(data.currentPrice?.description ?? "")"
        coinRank.text = data.marketCapRank?.description
        if let priceChange = data.priceChange24H {
            coinPriceChange24h.text = String(text: priceChange.description, size: 8)
            coinPriceChange24h.textColor = priceChange > 0
                ? UIColor.MyTheme.priceUp
                : UIColor.MyTheme.priceDown
        }
    }
    
    private func configNavigatorBar() {
        navigationItem.title = AppConstants.Strings.detailCoin.rawValue
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont.boldSystemFont(
                ofSize: 26.0 * UIScreen.resizeHeight)]
        navigationController?.navigationBar.backgroundColor = UIColor.MyTheme.primaryBackground
    }
    
    private func configView() {
        for height in heightConstants {
            height.constant *= UIScreen.resizeHeight
        }
        for button in chartTimeTypeButton {
            button.resizeTextWithHeight()
        }
        coinNaneAndId.resizeWithHeight()
        coinPrice.resizeWithHeight()
        coinRank.resizeWithHeight()
        coinPriceChange24h.resizeWithHeight()
        marketText.resizeWithHeight()
        priceChangeText.resizeWithHeight()
        reloadButton()
        configNavigatorBar()
        chartContainer.layer.cornerRadius = 20
        chartContainer.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        configureChart()
    }
    
    private func configureChart() {
        coinChartView.rightAxis.enabled = false
        coinChartView.xAxis.labelPosition = .bottom
        coinChartView.xAxis.axisLineColor = .white
        coinChartView.xAxis.setLabelCount(6, force: false)
        coinChartView.animate(xAxisDuration: 2)
    }
    
    private func reloadButton() {
        var indexButton = 0
        switch timeChar {
        case .week:
            indexButton = 1
        case .month:
            indexButton = 2
        case .year:
            indexButton = 3
        default:
            break
        }
        
        for index in 0..<4 {
            chartTimeTypeButton[index].backgroundColor = .none
        }
        chartTimeTypeButton[indexButton].backgroundColor = UIColor.white.withAlphaComponent(0.1)
        if let id = id {
            viewModel.getChart(timeType: timeChar, id: id)
        }
    }
    
    @IBAction func dayClick(_ sender: UIButton) {
        timeChar = .day
        
        DispatchQueue.main.async {
            self.reloadButton()
        }
    }
    
    @IBAction func weekClick(_ sender: UIButton) {
        timeChar = .week
        DispatchQueue.main.async {
            self.reloadButton()
        }
    }
    
    @IBAction func monthClick(_ sender: UIButton) {
        timeChar = .month
        DispatchQueue.main.async {
            self.reloadButton()
        }
    }
    
    @IBAction func yearClick(_ sender: UIButton) {
        timeChar = .year
        DispatchQueue.main.async {
            self.reloadButton()
        }
    }
}

