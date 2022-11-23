import Foundation

final class GetCoinsUseCase {
    private let coinRepository = CoinsRepositoryImpl()
    
    func getCoins(params: CoinsRequestParams, completion: @escaping (CoinsResponseModel?, Error?) -> Void) {
        coinRepository.getCoins(params: params, completion: completion)
    }
}
