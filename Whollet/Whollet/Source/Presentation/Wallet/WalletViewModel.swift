import Foundation
import ICONKit

enum WalletState {
    case initial
    case inProgress
    case loadSuccess
}

final class WalletViewModel: NSObject {
    private var createWalletUseCase: CreateWalletUseCase!
    private var loadWalletUseCase: LoadWalletUseCase!
    
    private weak var appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    private(set) var bsWalletState: BehaviorSubject<WalletState> = BehaviorSubject(nil)
    
    private var wallet: Wallet!
    
    override init() {
        super.init()
        bsWalletState.add(.initial)
        self.createWalletUseCase = CreateWalletUseCase()
        self.loadWalletUseCase = LoadWalletUseCase()
    }
    
    func createWallet() {
        bsWalletState.add(.inProgress)
        wallet = createWalletUseCase.call()
        UIPasteboard.general.string = wallet.key.privateKey.hexEncoded
        appDelegate?.wallet = wallet
        bsWalletState.add(.loadSuccess)
    }
    
    func loadWallet(_ privateKey: String) {
        bsWalletState.add(.inProgress)
        wallet = loadWalletUseCase.call(key: privateKey)
        appDelegate?.wallet = wallet
        bsWalletState.add(.loadSuccess)
    }
}
