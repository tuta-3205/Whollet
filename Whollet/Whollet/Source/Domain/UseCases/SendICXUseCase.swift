import Foundation
import ICONKit

final class SendICXUseCase {
    private let walletRepository = WalletRepositoryImpl()
    
    func sendICX(to: String, amount: Double, wallet: Wallet) -> String {
        return walletRepository.sendICX(to: to, amount: amount, wallet: wallet)
    }
}
