import Foundation

struct ChartModel: Codable {
    let prices: [[Double]]
}

typealias ChartResponseModel = ChartModel
