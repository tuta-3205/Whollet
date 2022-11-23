import ICONKit

protocol TransactionRepository {
    func saveTransaction(detail: TransactionDetail)
    
    func getAllTransaction(completion: @escaping ([TransactionDetail], Error?) -> (Void))
}
