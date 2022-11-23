import Foundation

final class AllTransactionViewModel: NSObject {
    private var getAllTransactionUseCase: GetAllTransactionUseCase!
    
    private(set) var bsTransactions: BehaviorSubject<[TransactionDetail]> = BehaviorSubject(nil)
    
    override init() {
        super.init()
        getAllTransactionUseCase = GetAllTransactionUseCase()
        getTransactions()
    }
    
    private func getTransactions() {
        getAllTransactionUseCase.getAllTransaction { [weak self] (data, error) -> (Void) in
            guard let self = self else { return }
            guard error == nil else {
                print("Could not fetch. \(String(describing: error))")
                return
            }
            print("data")
            print(data)
            self.bsTransactions.add(data)
            return
        }
    }
}
