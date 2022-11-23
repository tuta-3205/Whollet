import Foundation
import UIKit
import ICONKit

final class ConfirmationViewModel: NSObject {

    private var getCoinsUseCase: GetCoinsUseCase!
    
    private(set) var bsICXCoins: BehaviorSubject<CoinModel> = BehaviorSubject(nil)
    
    override init() {
        super.init()
        self.getCoinsUseCase = GetCoinsUseCase()
        self.getICXPrice()
    }
    
    private func getICXPrice() {
        let params = CoinsRequestParams(
            vsCurrency: "usd",
            order: "market_cap_desc",
            perPage: 1,
            page: 1,
            sparkline: false,
            ids: "icon")
        
        self.getCoinsUseCase.getCoins(params: params) { [weak self] (data, error) -> Void in
            guard let self = self else { return }
            if error != nil {
                return
            }
            if let data = data, data.count == 1 {
                self.bsICXCoins.add(data.last)
            }
        }
    }
}
