import Foundation

extension String {
    init(text: String, size: Int, isPrice: Bool = false) {
        let index = text.index(
            text.startIndex,
            offsetBy: text.count < size ? text.count : size)
        self = "\(isPrice ? "$ " : "")\(text[..<index])"
    }
}
