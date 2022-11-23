import Foundation
import Charts

enum TimeChart {
    case day
    case week
    case month
    case year
}

final class DetailViewModel: NSObject {
    private var getCoinsUseCase: GetCoinsUseCase!
    private var getChartUseCase: GetChartlUseCase!
    
    private(set) var bsCoin: BehaviorSubject<CoinModel> = BehaviorSubject(nil)
    private(set) var bsChart: BehaviorSubject<[ChartDataEntry]> = BehaviorSubject(nil)
    
    override init() {
        super.init()
        self.getCoinsUseCase = GetCoinsUseCase()
        self.getChartUseCase = GetChartlUseCase()
    }
    
    func getDetail(id: String) {

        let param = CoinsRequestParams(
            vsCurrency: "usd",
            order: "market_cap_desc",
            perPage: 1,
            page: 1,
            sparkline: false,
            ids: id)
        
        self.getCoinsUseCase.getCoins(params: param) { [weak self] (data, error) -> Void in
            guard let self = self else { return }
            if error != nil {
                return
            }
            if let data = data, data.count == 1 {
                self.bsCoin.add(data.last)
            }
        }
    }
    
    func getChart(timeType: TimeChart, id: String) {
        var days = 1
        var interval: String?
        switch timeType {
        case .week:
            days = 7
        case .month:
            days = 30
            interval = "daily"
        case .year:
            days = 365
            interval = "weekly"
        default:
            break
        }
        let param = ChartRequestParams(
            id: id,
            vsCurrency: "usd",
            day: days,
            interval: interval)
        
        self.getChartUseCase.getDetailChart(params: param) { [weak self] (data, error) -> Void in
            guard let self = self else { return }
            if error != nil {
                return
            }
            if let data = data {
                var dataChart = [ChartDataEntry]()
                for index in 0..<data.prices.count {
                    dataChart.append(ChartDataEntry(x: Double(index), y: data.prices[index][1]))
                }
                self.bsChart.add(dataChart)
            }
        }
    }
}
