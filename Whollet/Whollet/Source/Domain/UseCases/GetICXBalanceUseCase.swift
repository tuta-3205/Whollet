import Foundation
import ICONKit

final class GetICXBalanceUseCase {
    private let walletRepository = WalletRepositoryImpl()
    
    func getBalance(address: String) -> String {
        return walletRepository.getIcxBalance(
            address: address)
    }
}
