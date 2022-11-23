import Foundation

final class SaveTransactionDetailUseCase {
    private let transactionRepository = TransactionRepositoryImpl()
    
    func saveTransaction(detail: TransactionDetail) {
        return transactionRepository.saveTransaction(detail: detail)
    }
}
