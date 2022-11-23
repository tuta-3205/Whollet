import ICONKit

protocol WalletRepository {
    func createWallet() -> Wallet
    
    func getWalletFromPrivateKey(privateKey: String) -> Wallet
    
    func getIcxBalance(address: String) -> String

    func sendICX(to: String, amount: Double, wallet: Wallet) -> String
    
    func getTransaction(txHash: String) -> Response.TransactionByHashResult?
}
