import ICONKit

final class TransactionRepositoryImpl: TransactionRepository {
    
    private let manager = LocalDataManager.shared
    
    func saveTransaction(detail: TransactionDetail) {
        manager.saveTransaction(detail)
    }
    
    func getAllTransaction(completion: @escaping ([TransactionDetail], Error?) -> Void) {
        return manager.getAllTransaction(completion: completion)
    }
}
