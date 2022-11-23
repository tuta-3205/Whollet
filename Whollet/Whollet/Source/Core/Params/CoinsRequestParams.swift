import Foundation

struct CoinsRequestParams: BaseRequestParams {
    let vsCurrency: String
    let order: String
    let perPage: Int
    let page: Int
    let sparkline: Bool
    let ids: String?
    
    func toPath() -> String {
        var path = "?vs_currency=\(vsCurrency)&order=\(order)&per_page=\(perPage)&page=\(page)&sparkline=\(sparkline)"
        if let id = ids {
            path = "\(path)&ids=\(id)"
        }
        return path
    }
}
