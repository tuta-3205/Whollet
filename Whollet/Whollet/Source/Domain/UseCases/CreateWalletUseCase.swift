import Foundation
import ICONKit

final class CreateWalletUseCase {
    private let walletRepository = WalletRepositoryImpl()
    
    func call() -> Wallet {
        return walletRepository.createWallet()
    }
}
