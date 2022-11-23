import Foundation
import UIKit
import ICONKit

final class HomeViewModel: NSObject {

    private var getCoinsUseCase: GetCoinsUseCase!
    
    private(set) var bsDataCoins: BehaviorSubject<[CoinModel]> = BehaviorSubject(nil)
    
    private(set) var bsICXCoins: BehaviorSubject<CoinModel> = BehaviorSubject(nil)
    
    override init() {
        super.init()
        self.getCoinsUseCase = GetCoinsUseCase()
        self.getCoins()
        self.getICXPrice()
    }
    
    private func getCoins() {
        let params = CoinsRequestParams(
            vsCurrency: "usd",
            order: "market_cap_desc",
            perPage: 10,
            page: 1,
            sparkline: false,
            ids: nil)
        
        self.getCoinsUseCase.getCoins(params: params) { [weak self] (data, error) -> Void in
            guard let self = self else { return }
            if error != nil {
                return
            }
            if let data = data {
                self.bsDataCoins.add(data)
                return
            }
        }
        
        return
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
