import Foundation

protocol BaseRequestParams: Codable {
    func toPath() -> String
}
