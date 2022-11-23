import ICONKit
import BigInt

final class WalletRepositoryImpl: WalletRepository {
    
    struct Constants {
        static let providerURL = "https://sejong.net.solidwallet.io/api/v3"
        static let nid = "0x53"
    }
    
    let iconService = ICONService(provider: Constants.providerURL, nid: Constants.nid)
    
    func createWallet() -> Wallet {
        let wallet = Wallet(privateKey: nil)
        return wallet
    }
    
    func getWalletFromPrivateKey(privateKey: String) -> Wallet {
        let privateKey = PrivateKey(hex: Data(hex: privateKey))
        return Wallet(privateKey: privateKey)
    }
    
    func getIcxBalance(address: String) -> String {
        let result: Result<BigUInt, any Error> = iconService.getBalance(address: address).execute()
        switch result {
        case .success(let balance):
            return "\(balance)"
        case .failure(_):
            return "0"
        }
    }
    
    func sendICX(to: String, amount: Double, wallet: Wallet) -> String {
        print("start send icx")
        let coinTransfer = Transaction()
            .from(wallet.address)
            .to(to)
            .value(BigUInt(amount * 1000000000000000000))
            .stepLimit(BigUInt(1000000))
            .nid(iconService.nid)
            .nonce("0x1")

        do {
            let signed = try SignedTransaction(transaction: coinTransfer, privateKey: wallet.key.privateKey)
            let request = iconService.sendTransaction(signedTransaction: signed)
            let response = request.execute()

            switch response {
            case .success(let result):
                print(result)
                return result
            case .failure(_):
                return ""
            }
        } catch {
            return ""
        }
    }
    
    func getTransaction(txHash: String) -> Response.TransactionByHashResult? {
        var transactionResult: Response.TransactionByHashResult?
        while transactionResult == nil {
            let request: Request<Response.TransactionByHashResult> = iconService.getTransaction(hash: txHash)
            let response = request.execute()
            switch response {
            case .success(let transaction):
                transactionResult = transaction
            case .failure (_):
                transactionResult = nil
            }
        }
        return transactionResult
    }
}
