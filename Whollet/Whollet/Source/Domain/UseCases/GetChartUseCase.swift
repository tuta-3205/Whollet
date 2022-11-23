import Foundation

final class GetChartlUseCase {
    private let coinRepository = CoinsRepositoryImpl()
    
    func getDetailChart(params: ChartRequestParams, completion: @escaping (ChartResponseModel?, Error?) -> Void) {
        coinRepository.getCoinDetail(params: params, completion: completion)
    }
}
