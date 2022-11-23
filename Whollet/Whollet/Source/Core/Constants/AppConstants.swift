import Foundation

struct AppConstants {
    enum Strings: String {
        case nextStep = "Next Step"
        case getStarted = "Let's Get Started"
        case iconPriceUp = "price_up"
        case iconPriceDown = "price_down"
        case icx = "ICX"
        case allTopCoins = "All Top Coins"
        case detailCoin = "Detail Coin"
        case createWallet = "Create Wallet"
        case createICX = "Create a ICX Wallet"
        case loadWallet = "Load Wallet"
        case copyPrimaryKey = "Copy privateKey to Clipboard and Paste"
        case pasteKey = "Paste Key"
        case loading = "Loading"
        case loadingWallet = "Loading a ICX Wallet"
        case createWalletSuccessfully = "Your wallet has been created successfully, private key save on clipboard"
        case goHome = "Go Home"
        case loadWalletSuccessfully = "Your wallet has been loaded successfully"
        case send = "Send"
        case transactionDetail = "Transaction Detail"
        case allTransaction = "All Transaction"
    }
    
    enum CGFloats: CGFloat {
        case defaultRadius = 20.0
        case borderWidthButton = 1.0
        case appBarTitleSize = 26.0
        case depositButtonBorder = 3.0
        case qrRadius = 10.0
    }
    
    enum Ints: Int {
        case priceStringSize = 8
    }
    
    static let onboardings: [OnboardingModel] = [
        OnboardingModel(
            image: "splash_0",
            title: "Welcome to Whollet",
            description: "Manage all your crypto assets! It’s simple and easy! "
        ),
        OnboardingModel(
            image: "splash_1",
            title: "Nice and Tidy Crypto Portfolio!",
            description: "Keep ICX based tokens."
        ),
        OnboardingModel(
            image: "splash_2",
            title: "Receive and Send Money to Friends!",
            description: "Send crypto to your friends. "
        ),
        OnboardingModel(
            image: "splash_3",
            title: "Your Safety is Our Top Priority",
            description: "Our top-notch security features will keep you completely safe."
        )
    ]
}
