import Foundation
import ICONKit

final class GetTransactionUseCase {
    private let walletRepository = WalletRepositoryImpl()
    
    func getTransaction(txHash: String) -> Response.TransactionByHashResult? {
        return walletRepository.getTransaction(txHash: txHash)
    }
}
