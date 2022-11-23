import Foundation

struct CoinModel: Codable, Equatable {
    let id, symbol, name: String?
    let image: String?
    let marketCapRank: Int?
    let currentPrice: Double?
    let priceChange24H: Double?
    let atlDate: String?
    
    enum CodingKeys: String, CodingKey {
        case id, symbol, name, image
        case marketCapRank = "market_cap_rank"
        case currentPrice = "current_price"
        case priceChange24H = "price_change_24h"
        case atlDate = "atl_date"
    }
}

typealias CoinsResponseModel = [CoinModel]
