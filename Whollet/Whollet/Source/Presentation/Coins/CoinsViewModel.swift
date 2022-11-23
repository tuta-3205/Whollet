import Foundation

final class CoinsViewModel: NSObject {
    
    private var getCoinsUseCase: GetCoinsUseCase!
    
    private var fullData: [CoinModel] = []
    
    private var isSearch = false
    
    private(set) var bsCoins: BehaviorSubject<[CoinModel]> = BehaviorSubject(nil)
    
    override init() {
        super.init()
        self.getCoinsUseCase = GetCoinsUseCase()
        getCoins()
    }

    func getCoins() {
        let params = CoinsRequestParams(
            vsCurrency: "usd",
            order: "market_cap_desc",
            perPage: 1000,
            page: 1,
            sparkline: false,
            ids: nil)
        
        self.getCoinsUseCase.getCoins(params: params) { [weak self] (data, error) -> Void in
            guard let self = self else { return }
            if error != nil {
                return
            }
            if let data = data {
                self.fullData = data
                let slice = self.fullData[0..<20]
                self.bsCoins.add(Array(slice))
            }
        }
    }
    
    func loadMore() {
        if isSearch {
            return
        }
        let start = (bsCoins.value ?? []).count
        let end = (bsCoins.value ?? []).count + 10 >= fullData.count - 1
            ? fullData.count - 1
            : (bsCoins.value ?? []).count + 10
        let slice = fullData[start..<end]
        bsCoins.add((bsCoins.value ?? []) + Array(slice))
    }
    
    func search(keyword: String) {
        if !keyword.isEmpty {
            isSearch = true
            let dataSearch = fullData.filter({
                ($0.name ?? "").contains(keyword) || ($0.id ?? "").contains(keyword)})
            self.bsCoins.add(dataSearch)
        } else {
            let slice = self.fullData[0..<20]
            self.bsCoins.add(Array(slice))
            isSearch = false
        }
    }
    
}
