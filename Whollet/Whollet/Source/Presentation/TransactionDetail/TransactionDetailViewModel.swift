import Foundation
import ICONKit
        
final class TransactionDetailViewModel: NSObject {
    private var sendICXUseCase: SendICXUseCase!
    private var getTransactionUseCase: GetTransactionUseCase!
    private var saveTransactionDetailUseCase: SaveTransactionDetailUseCase!
    
    private(set) var bsHash: BehaviorSubject<String> = BehaviorSubject(nil)
    private(set) var bsResult: BehaviorSubject<Response.TransactionByHashResult> = BehaviorSubject(nil)
    
    override init() {
        super.init()
        self.sendICXUseCase = SendICXUseCase()
        self.getTransactionUseCase = GetTransactionUseCase()
        self.saveTransactionDetailUseCase = SaveTransactionDetailUseCase()
    }
    
    func sendICX(to: String, amount: Double, wallet: Wallet) {
        bsHash.add(sendICXUseCase.sendICX(
            to: to,
            amount: amount,
            wallet: wallet))
    }
    
    func getTransaction(txHash: String) {
        bsResult.add(getTransactionUseCase.getTransaction(txHash: txHash))
    }
    
    func saveTransaction(detail: TransactionDetail) {
        saveTransactionDetailUseCase.saveTransaction(detail: detail)
    }
}
