import UIKit
import ICONKit

final class AmountViewModel: NSObject {
    private var getICXBalanceUseCase: GetICXBalanceUseCase!
    
    private weak var appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    private(set) var bsBalance: BehaviorSubject<String> = BehaviorSubject(nil)
    
    override init() {
        super.init()
        getICXBalanceUseCase = GetICXBalanceUseCase()
        getBalance()
    }
    
    func getBalance() {
        let address = appDelegate?.wallet?.address ?? ""
        let balance = getICXBalanceUseCase.getBalance(address: address)
        bsBalance.add(balance)
    }
    
    func saveICXValue(_ value: Double) {
        appDelegate?.transactions.valueICX = value
    }
}
