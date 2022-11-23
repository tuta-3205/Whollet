import Foundation

final class CoinsRepositoryImpl: CoinsRepository {
    private let services = CoinServices.shared
    
    func getCoins(params: CoinsRequestParams, completion: @escaping (CoinsResponseModel?, Error?) -> Void) {
        services.getCoins(request: params) { result in
            switch result {
            case .success(let model):
                completion(model, nil)
                return
            case .failure(let error):
                completion(nil, error)
                return
            }
        }
    }
    
    func getCoinDetail(params: ChartRequestParams, completion: @escaping (ChartResponseModel?, Error?) -> Void) {
        services.getCoinDetail(request: params) { result in
            switch result {
            case .success(let model):
                completion(model, nil)
                return
            case .failure(let error):
                completion(nil, error)
                return
            }
        }
    }
}
