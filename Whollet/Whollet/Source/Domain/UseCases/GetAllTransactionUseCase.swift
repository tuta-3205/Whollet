import Foundation

final class GetAllTransactionUseCase {
    private let transactionRepository = TransactionRepositoryImpl()
    
    func getAllTransaction(completion: @escaping ([TransactionDetail], Error?) -> Void) {
        return transactionRepository.getAllTransaction(completion: completion)
    }
}
